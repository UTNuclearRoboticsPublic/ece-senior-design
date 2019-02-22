# Testing the install script

If you have modified the install script, you must do it on a separate branch (i.e. not *master*.) After making your modifications, make sure to push the changes to your branch before running the test.

The install test runs a Docker container with a fresh Ubuntu 16.04 as a base image. The container clones this repository, with the branch specified as a command line argument. The container then checks the log file for system errors and errors reported by our logging mechanism, and the results are displayed to stdout. If there are no errors, the log file is deleted.

Example usage:

```shell
bash install_test.sh --branch my-modifications
```
