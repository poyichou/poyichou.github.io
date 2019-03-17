### Notes-i3wm  

#### To install  
```bash
$ sudo pacman -S i3-wm i3status feh
```
#### Basic set up  
```bash
# add this lines at the end of ~/.config/i3/config
exec_always VBoxClient-all # for i3wm installed in Virtualbox guest OS
exec_always feh --bg-fill ~/wallpaper/livie.jpg # set a static wallpaper
```
#### Basic tips  
```bash
# open a terminal
$mod + <enter>
# change window titling style to split/stack/tab
$mod + [e|s|w]
# change to other screen
$mod + <arrow> or $mod + [j|k|l|;]
# close a window
Ctrl + w or $mod + Shift + q

# change to another workspace
$mod + <num>
# shift a window to another workspace
$mod + Shift + num
```
