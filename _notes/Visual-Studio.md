# Notes-Visual-Studio  

## Cannot find or open the PDB file in Visual Studio C++ 2010
Error log
```bash
'XXX.exe': Loaded 'C:\WINDOWS\system32\ntdll.dll', Cannot find or open the PDB file
...
```
Solution
```
# Tools->Options->Debugging->Symbols
# check Microsoft Symbol Servers
```
