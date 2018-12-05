# Continuous Integration

---

## Introduction

The goal of continuous integration is to merge in small changes to the stable codebase often, with the confidence that they will work. The tool we hawe set up to do this is called [Travis](https://travis-ci.org/). 


---

## Travis CI 

### The Basics
Travis works by running a set of tests automatically every time a commit is pushed. Typically a pull request will be issued, and if it passes the tests it will get merged into master. Any further commits to the PR will update it and trigger a new build.

These tests are set up by editing the `.travis.yml` file inside the repository. The only test currently set up is to run [ShellCheck](https://www.shellcheck.net/) on the repository. More on that in the [ShellCheck](#shellcheck) section.

Setting up tests to run with Travis is as easy as pointing it to a new script. More information can be found in their [documentation](https://docs.travis-ci.com/) page.

### Getting Set Up

Go to their [website](https://travis-ci.org/) and click "Sign Up With GitHub". From there it automatically syncs with your GitHub profile and by navigating to this repository you can see logs from any commit or pull request.

---

## ShellCheck

### Basics
[ShellCheck](https://www.shellcheck.net/) is a popular linter. A linter checks your code for poor style or code that is likely to cause errors.

TODO
