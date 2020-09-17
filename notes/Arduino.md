### Notes-Arduino  

#### Compile error
```bash
# error message: 'Caused by: jssc.SerialPortException: Port name - /dev/ttyACM0; Method name - openPort(); Exception type - Permission denied.'
# solution: add current user into dialout group
sudo usermod -a -G dialout $USER
```
