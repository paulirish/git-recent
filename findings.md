# Code Review Findings: `git-recent`

## 1. Interrogating the Premise (The "XY Problem")

**Why does this exist?**
The core problem is **context switching**. Developers work on multiple streams of thought (branches) and lose track of state. You are patching the symptom ("I can't find my branch") with a search tool.

**The Critique:**
While `fzf` is a great hammer, this script is trying to be a Swiss Army Knife but is currently a rusty pocket knife. It mixes generic git navigation with hyper-specific Chromium workflow logic (`--cl`). This is a massive violation of separation of concerns. If I'm not a Chromium dev, I'm carrying around dead code that I have to read and maintain.

## 2. Architectural Smells & "Leaky Abstractions"

### The Chromium Infection
The script has hardcoded logic for `git cl status` (Chromium's `depot_tools`).
```bash
[[ "$1" == "--cl" || "$1" == "-cl" ]] && show_cl=true || show_cl=false
```
And then deeper:
```bash
CL_STATUS=$([ "$show_cl" = true ] && git cl status ...
```
**Verdict:** This is technical debt. This logic belongs in a wrapper script or a git alias, not in the core distribution of a generic tool. It complicates the loop and the variable handling.

### The `.git` Directory Assumption
```bash
diff_base=$(cat $(git rev-parse --show-cdup).git/refs/remotes/origin/HEAD | awk '{print $2}')
```
**This is the most dangerous line in the script.**
1.  **Worktrees:** If you are in a git worktree, `.git` is a **file**, not a directory. This line will fail.
2.  **Packed Refs:** Git packs references into `.git/packed-refs` for performance. If `origin/HEAD` is packed, the file `.git/refs/remotes/origin/HEAD` **does not exist**. This script will silently fail or error out depending on `cat`'s behavior.
3.  **Submodules:** Similarly, submodules handle `.git` differently.

**Fix:** Use Git plumbing commands, never touch `.git` files directly.

## 3. Security & Shell Hygiene

### Injection Vulnerabilities
You are constructing shell commands dynamically and passing them to `sh -c` inside `fzf`.
```bash
define_branchname="branchname=\\\$(echo {1} | cut -d' ' -f1)"
uniqcommits_cmd="sh -c \"$define_branchname; git log ...\""
```
If a branch name contains malicious shell characters, `fzf`'s `{1}` substitution could trigger them. While `git` restricts branch names, relying on an external tool's validation for your shell safety is bad practice.
*   What if the output format changes?
*   What if `cut` behaves differently?

### Hardcoded `origin`
The script assumes the remote is named `origin`.
```bash
refs/remotes/origin/HEAD
```
Many advanced workflows (and even standard GitHub flow) might use `upstream` as the primary remote or have multiple remotes.

## 4. Performance

### The `CL_STATUS` Bottleneck
If `show_cl` is true, you run `git cl status` *before* the loop.
```bash
CL_STATUS=$([ "$show_cl" = true ] && git cl status ...)
```
`git cl status` involves network calls. You are blocking the UI startup on network latency. This makes the tool feel sluggish.

## 5. Modernization & Refactor Plan

I recommend a rewrite that focuses on stability and standard Git plumbing.

### Proposed Refactor

1.  **Drop the Chromium logic.** Make it a plugin or a separate script (`git-recent-cl`) if absolutely necessary.
2.  **Use Git Plumbing for `diff_base`**:
    ```bash
    # Try to find the default branch correctly
    diff_base=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/@@')
    # Fallback if symbolic-ref fails (e.g. detached head or no remote)
    : ${diff_base:=origin/main}
    ```
3.  **Support Worktrees**: Use `git rev-parse --git-dir` if you must access the dir, but preferably just don't.
4.  **Safer `fzf` integration**: Pass the branch name as an argument to a function or script, rather than interpolating it into a string.
    *   Better yet, use `fzf`'s `{+}` or `{}` directly in the command if possible without the complex shell gymnastics.

### immediate Fixes for Stability
If we aren't doing a full rewrite, we **must** fix the `diff_base` logic immediately to support packed-refs and worktrees.

```bash
# OLD
diff_base=$(cat $(git rev-parse --show-cdup).git/refs/remotes/origin/HEAD | awk '{print $2}')

# NEW (Robust)
diff_base=$(git rev-parse --abbrev-ref origin/HEAD 2>/dev/null)
if [[ -z "$diff_base" || "$diff_base" == "origin/HEAD" ]]; then
    # Fallback logic or error handling
    diff_base="origin/main" # Reasonable default?
fi
```
