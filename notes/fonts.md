# Notes-fonts  
## Install fonts  
- Option1: Install with package manager  
- Option2: manually install  
  - Donwload font files (e.g. ttf), puts them into a directory  
  - Put the directory into `/usr/local/share/fonts/`  
## To load font without reboot  
```
#regenerate fonts cache
$ fc-cache -f -v
#check installed fonts
$ fc-list
#check current fonts in effect
$ fc-match
```
