# Bash Tips 

---

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
