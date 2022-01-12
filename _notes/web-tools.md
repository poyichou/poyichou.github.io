# Notes-web-tools  
## curl
When encounter such result, `-L` (`wget -H` for such web site)  
```html
<html>
<head><title>301 Moved Permanently</title></head>
<body>
<center><h1>301 Moved Permanently</h1></center>
<hr><center>nginx</center>
</body>
</html>
```
## wget
- `-r`/`--recursive` download specified URLs, parse the markup to find links to other files, and then download those, repeating by default five times.  
- `-A`/`--accept`, `-I`/`--include-directories=`, `-R/--reject` specify patterns to filter the set above.  
- `-np`/`--no-parent` ensures that only URLs starting with the URLs you've given are downloaded.  
