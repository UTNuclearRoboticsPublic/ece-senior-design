# Continuous Integration

---

## Introduction

The goal of continuous integration is to merge in small changes to the stable codebase often, with the confidence that they will work. The tool we hawe set up to do this is called [Travis](https://travis-ci.org/). 

For some blogs on CI in theory, see:
* [https://circleci.com/blog/path-to-production-how-and-where-to-segregate-test-environments/](https://circleci.com/blog/path-to-production-how-and-where-to-segregate-test-environments/)
* [https://martinfowler.com/articles/continuousIntegration.html](https://martinfowler.com/articles/continuousIntegration.html)

For an example of it in action, see:
* [https://eng.uber.com/ios-monorepo/](https://eng.uber.com/ios-monorepo/)

---

## Travis CI 

### Introduction
Travis works by running a set of tests automatically every time a commit is pushed. Typically a pull request will be issued, and if it passes the tests it will get merged into master. Any further commits to the PR will update it and trigger a new build.

These tests are set up by editing the `.travis.yml` file inside the repository. The only test currently set up is to run [ShellCheck](https://www.shellcheck.net/) on the repository. More on that in the ShellCheck [section](#shellcheck) .

Setting up tests to run with Travis is as easy as pointing it to a new script. More information can be found in their [documentation](https://docs.travis-ci.com/) page.

### Getting Set Up

Go to their [website](https://travis-ci.org/) and click "Sign Up With GitHub". From there it automatically syncs with your GitHub profile and by navigating to this repository you can see logs from any commit or pull request.

---

## ShellCheck

### Introduction
[ShellCheck](https://www.shellcheck.net/) is a popular linter. A linter checks your code for poor style or code that is likely to cause errors. In general, we want to correct what the linter yells at us for. ShellCheck can be run on its own from your terminal, although it is integrated into Travis and Travis will run it for us whenever we push a commit.

### Configuring Errors
In the cases where we want to willfully ignore a linter error, we can use whats called a *directive* to suppress the error and pass our tests.

Example of suppressing an error:

```bash
# shellcheck disable=SC2044
```

This code is inserted directly into the bash script, ideally as close as possible to the offending code. The `SC2044` should be changed to match the error you are suppressing. The error ID can be obtained by running shellcheck in your terminal or checking the Travis logs. There is scoping for shellcheck directives, see more on these [here](https://github.com/koalaman/shellcheck/wiki/Directive). 

---

## Submitting a Pull Request

### Introduction

In the ideal case, any changes we make are in a branch separate from master. TODO


