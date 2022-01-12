# Notes-Git  

## Upstream interaction  
```bash
# check all branches including upstream ones
git branch -a
# create new local branch which name is based on <remote branch>
#   set up upstream configuration
git checkout [--track|-t] <remote branch>
```
---
## Gerrit  
Set up commit hook
```bash
# 1. Obtaining hook script inserting Change-ID in each commit
# e.g. curl -L http://gerrit-review.googlesource.com/tools/hooks/commit-msg
curl -L http://<Gerrit Server>/tools/hooks/commit-msg
# 2. Put `commit-msg` into local `.git/hooks/`
# 3. If submodules exist, put `commit-msg` into corresponding `hooks/` in `modules/` in the same `.git/`
```
Commit
```bash
# insert name in commit message
# note that if the script for Change-ID is ready,
# the Change-ID will be inserted after completing commit message
git commit [-s|--signoff]
```
Push
```
# push to a special remote branch for others to review the changes
# e.g. git push origin master:refs/for/master
git push origin <local branch>:refs/for/<remote branch>
```
---
## UTF-16 problem  
Situations on utf-16 encoded file  
```
"git diff" and "git log -p <utf16 file>" shows "Binary files a/xxx and b/xxx differ" instead of text content,  
"git log -p --text <utf16 file>" garbled in content.  
```
Solution  
```
git config --global diff.utf16.textconv "iconv -f utf-16 -t utf-8"
echo "<utf16 file> diff=utf16" >> <repo root>/.gitattributes
```
