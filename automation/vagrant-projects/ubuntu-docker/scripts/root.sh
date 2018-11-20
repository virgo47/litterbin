# based on: https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository

# suppreses some warnings about stdin/out, see also https://serverfault.com/a/670688/302310
export DEBIAN_FRONTEND=noninteractive
# other warnings are still there though (preconfigure, apt-key...)

sudo apt-get update
sudo apt-get install -y apt-transport-https \
  ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce

# user vagrant can use docker command
sudo usermod -aG docker vagrant