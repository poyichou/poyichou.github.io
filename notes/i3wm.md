### Notes-i3wm  

#### To install  
```bash
$ sudo pacman -S i3-wm i3lock feh lxappearance acpilight
# i3status-rust
$ yay -S i3status-rust-git ttf-font-awesome-4
$ sudo pacman -S iw
```
#### Basic set up  
```bash
$ cd ~/.config/i3
$ wget https://poyichou.github.io/config_file/i3_config -O config
$ wget https://poyichou.github.io/config_file/i3_status_rs.toml -O status.toml

$ cd /etc/udev/rules.d/
$ sudo wget https://poyichou.github.io/config_file/backlight.rules
$ sudo usermod -a -G video <username>
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

# set themes
lxappearance
```
