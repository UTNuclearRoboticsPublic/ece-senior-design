# Bash Tips 

---

#### Redirects

All those fun redirect operators are outlined pretty well in this [Stack Overflow post](https://unix.stackexchange.com/questions/159513/what-are-the-shells-control-and-redirection-operators).

---

#### Grep, Awk, and Sed

Grep is one of the most flexible and useful Linux utilities, Awk is actually a full blown programming language, and Sed isn't too bad either. This [9 page overview](https://www-users.york.ac.uk/~mijp1/teaching/2nd_year_Comp_Lab/guides/grep_awk_sed.pdf) gives some good tips to get started without being overly long and verbose.

#### Comparison Operators 

The cases of comparing strings versus comparing variables are handled a little differently in bash. [This](https://www.tldp.org/LDP/abs/html/comparison-ops.html) is an excellent guide. Note the whitespace! Bash is particular about whitespace.

---

#### Checking if a Variable is Empty

Example:

```bash
if [ -z "$var" ]
then
    # var is empty
else
    # var is not empty
fi
```

---

#### Checking Exit Codes

The proper way to check out an exit code is C-style, and can be a little confusing. Example stolen from [this](https://stackoverflow.com/questions/26675681/how-to-check-the-exit-status-using-an-if-statement-using-bash) Stack Overflow post.

```bash
if some_command
then
    # command returned true
else
    # command returned some error
fi
```

or inverted:

```bash
if ! some_command
then
    # command returned some error
else
    # command returned true
fi
```
