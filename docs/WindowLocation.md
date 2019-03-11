```
#!/usr/bin/env python3
import subprocess
import sys

# just a helper function, to reduce the amount of code
get = lambda cmd: subprocess.check_output(cmd).decode("utf-8")

# get the data on all currently connected screens, their x-resolution
screendata = [l.split() for l in get(["xrandr"]).splitlines() if " connected" in l]
screendata = sum([[(w[0], s.split("+")[-2]) for s in w if s.count("+") == 2] for w in screendata], [])

def get_class(classname):
    # function to get all windows that belong to a specific window class (application)
    w_list = [l.split()[0] for l in get(["wmctrl", "-l"]).splitlines()]
    return [w for w in w_list if classname in get(["xprop", "-id", w])]

scr = sys.argv[2]

try:
    # determine the left position of the targeted screen (x)
    pos = [sc for sc in screendata if sc[0] == scr][0]
except IndexError:
    # warning if the screen's name is incorrect (does not exist)
    print(scr, "does not exist. Check the screen name")
else:
    for w in get_class(sys.argv[1]):
        # first move and resize the window, to make sure it fits completely inside the targeted screen
        # else the next command will fail...
        subprocess.Popen(["wmctrl", "-ir", w, "-e", "0,"+str(int(pos[1])+100)+",100,300,300"])
        # maximize the window on its new screen
        subprocess.Popen(["xdotool", "windowsize", "-sync", w, "100%", "100%"])
```

## How to use
    The script needs both wmctrl and xdotool:
    ```sudo apt-get install xdotool wmctrl```

    Run the script by the command:
    ```python3 /path/to/move_wclass.py <WM_CLASS> <targeted_screen>```

    for example:
    ```python3 /path/to/move_wclass.py gnome-terminal VGA-1```

For the WM_CLASS, you may use part of the WM_CLASS, like in the example. The screen's name needs to be the exact and complete name.

## How it is done (the concept)

In the output of xrandr, for every connected screen, there is a string/line, looking like:
VGA-1 connected 1280x1024+1680+0

This line gives us information on the screen's position and its name, as explained here.

The script lists the information for all screens. When the script is run with the screen and the window class as arguments, it looks up the (x-) position of the screen, looks up all windows (-id's) of a certain class (with the help of wmctrl -l and the output of xprop -id <window_id>.

Subsequently, the script moves all windows, one by one, to a position on the targeted screen (using wmctrl -ir <window_id> -e 0,<x>,<y>,<width>,<height>) and maximizes it (with xdotool windowsize 100% 100%).
    
for further info see [xrandr explination](https://askubuntu.com/questions/614145/output-of-xrandr-shows-1024x76813660-what-does-it-mean-and-can-i-change-it/614242#614242) and [script source](https://askubuntu.com/questions/702071/move-windows-to-specific-screens-using-the-command-line)
