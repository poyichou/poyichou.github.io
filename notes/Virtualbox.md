### Notes-Virtualbox  
#### Problem: freeze in full screen mode  
```bash
Machine->Settings->Display, increase Video Memory  
```
#### Problem: resolution in guest not change with window resizing in host  
```bash
Machine->Settings->Graphics Controller, select VBoxVGA  
```
#### Problem: clipboard of host and guest not shared  
```bash
/usr/bin/VBoxClient-all
```
