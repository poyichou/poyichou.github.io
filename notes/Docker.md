# Notes-Latex  

## tcpdump in docker cannot open 
```
# Error message:
#tcpdump: error while loading shared libraries: libcrypto.so.1.0.0: cannot open shared object file: Permission denied
mv /usr/sbin/tcpdump /usr/bin/tcpdump
```
---
## Python causes IOError: [Errno 28] No space left on device 
```
Python throw exception 'IOError: [Errno 28] No space left on device' while there's still lots of space on disk.  
'joblib' might try to parallelize jobs.  
When environment variable 'JOBLIB_TEMP_FOLDER' is not set, it consume '/dev/shm' to handle inter process communication.  
'/dev/shm' is by default 64MB in docker. 'joblib' might not detect such limitation.  
Any python module depending on 'joblib' such as 'sklearn' might encounter such exception.
```
Solution 1  
```bash
JOBLIB_TEMP_FOLDER=/tmp python [args...]
```
Solution 2  
Add following in python code.  
```python
import os
os.environ['JOBLIB_TEMP_FOLDER'] = '/tmp'
```
Solution 3  
Increase /dev/shm size with such command.  
```
docker run --shm-size=512m <image-name>
```
