# Git Tips 

---

## Oh Shit Git

There is a copy of [Julia Evans'](https://jvns.ca/) wonderful 10 page pdf called "Oh Shit Git" pinned to our Slack general.

## Commit messages

A [rant](https://juffalow.com/other/write-good-git-commit-message) on writing commit messages. This never seems to matter until you have a broken build and can't figure out which commit to revert to.

## Submitting a Pull Request

In the ideal case, any changes we make are in a branch separate from master. After verifying your changes on your branch, you can navigate to the repository in your web browser and issue a pull request.
This should trigger a Travis build. If the Travis build fails, you can log in to your Travis account and check the build log. Fix any errors in your local repository and commit them to your branch. Each commit will update the pull request and trigger another build.

---

## Setting Meld as Your Merge Tool

To meld as the diff tool, add the following to your .gitconfig file.

```
[diff]
    tool = meld
[difftool]
    prompt = false
[difftool "meld"]
    cmd = meld "$LOCAL" "$REMOTE"
```

To meld as the merge tool, add the following to your .gitconfig file.

```
[merge]
    tool = meld
[mergetool "meld"]
    cmd = meld "$LOCAL" "$MERGED" "$REMOTE" --output "$MERGED"
```

When using the meld tool to merge, merge as you would normally in git, with `git merge branch_name`, then after git lists the merge info, `git mergetool`. Git will ask you file by file if you want to keep the remote or local version for deleted files. For modified files, meld will be launched. Each meld window is a merge for one file. On the left pane you will see the current local file. On the right pane you will see the remote file. In the middle pane is the merged result. Use meld as normal by transfering everything you want to keep to the middle pane. Save and exit the window.

---

## Setting Vim as Default

You can either set Vim as default for Git, or system-wide.

To set Vim as default for Git only, do *ONE OF* the following:

```bash
git config --global core.editor "vim"
```

or

```bash
echo "export GIT_EDITOR=vim" >> ~/.bashrc
source ~/.bashrc
```

To set Vim as default for Git _and_ other programs, do the following:

```bash
echo "export VISUAL=vim" >> ~/.bashrc
echo "export EDITOR=\"$VISUAL\"" >> ~/.bashrc
source ~/.bashrc
```
