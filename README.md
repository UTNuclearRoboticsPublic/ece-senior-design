
# Overview

<p>
This repository contains code used by the ECE Senior Design team composed of:
<ul>
   <li>Beathen Andersen</li>
   <li>Kate Baumli</li>
   <li>Daniel Diamont</li>
   <li>Bryce Fuller</li>
   <li>Caleb Johnson</li>
   <li>John Sigmon</li>
</ul>
</p>
<p>
The team is advised by Dr. Mitchell Pyror, and the project is being supervised by Dr. Pryor as head of the UT Nuclear Robotics Group.
</p>

# Project Summary

TODO

# Installation

## Installing the repository for the first time
<p>
Clone the repository.
</p>

```bash
$ git clone https://github.com/UTNuclearRoboticsPublic/ece-senior-design.git
```

<p>
Navigate into the cloned repository.
</p>

```bash
$ cd ece-senior-design
```

<p>
Set up a python virtual environment. 
(There are several ways to do this, my favorite is below)
</p>

```bash
$ virtualenv -p python3 .env
```

This sets up the environment under the name `.env` which is not descriptive, but keeps me from having to remember how to activate all my different environments. Feel free to install the environment under whatever name you wish, so long as you add the environment name to the .gitignore file in the appropriate place.

<p>
Next activate the environment, and install all the python dependencies via the requirements file. When the environment is active it will display to the left of the prompt, as shown below.
</p>

```bash
$ source .env/bin/activate
(.env) $ pip install -r requirements
```

<p> 
If you install additional libraries, please update the requirements and add the modified file to your commit.
</p>

```bash
$ cd /<ROOT_PATH>/ece-senior-design
$ pip freeze > requirements
```

<p>
When finished with the repository or environment, you can deactivate it with the simple command deactivate.
</p>

```bash
(.env) $ deactivate
$ 
```

## Installation of subdirectory components
Please see the readme in the appropriate directory for further installation instructions.

## Updating the documentation

To update any README's, just open the .md file in your favorite text editor. You can render markdown files in your local browser to ensure they look the way you want by activating your environment, and running

```bash
$ grip <readme name>
```

This returns a link to a localhost address where you can view the rendered markdown file.

# Contents

The repository is set up as follows:

```
+-- ece-senior-design
    +-- osvr                # Contains setup code for the OSVR headset
```
