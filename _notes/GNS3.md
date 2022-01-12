# Notes-GNS3  
  
## Install instructions for Ubuntu(-based)  
```bash
sudo add-apt-repository ppa:gns3/ppa
sudo apt update                                
sudo apt install gns3-gui gns3-server
# when prompted whether non-root users should be allowed to use wireshark and ubridge, select ‘Yes’ both times
```
```bash
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install gns3-iou
# To support CISCO router Idle-PC finder
sudo apt install dynamips:i386
```
```bash
# remove old docker
sudo apt remove docker docker-engine docker.io
# install docker ce
sudo apt install apt-transport-https ca-certificates curl  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - # import docker gpg key
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce
# add groups
sudo usermod -aG ubridge <user_name>
sudo usermod -aG libvirt <user_name>
sudo usermod -aG kvm <user_name>
sudo usermod -aG wireshark <user_name>
sudo usermod -aG docker <user_name>
```
## some error
```bash
# If not install dynamips:i386
Error: Could not send Dynamips command 'vm get_status "AUTOIDLEPC"' to x.x.x.x:xxxxx: Connection lost, process running: False
```
