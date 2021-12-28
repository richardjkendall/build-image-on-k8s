#!/bin/bash

echo "DOWNLOAD: kubectl"

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl.sha256"

check_output=`echo "$(<kubectl.sha256) kubectl" | sha256sum --check`
okay_string="kubectl: OK"

if [ "$check_output" == "$okay_string" ]; then
  echo "OKAY: downloaded file matches the expected checksum"
  mkdir -p ~/.local/bin/kubectl
  mv ./kubectl ~/.local/bin/kubectl
  chmod +x ~/.local/bin/kubectl/kubectl
else
  echo "ERROR: checksum does not match"
  exit 1
fi
echo "OKAY: kubectl is downloaded and installed."


echo "DOWNLOAD: img"
curl -LO "https://github.com/genuinetools/img/releases/download/v0.5.11/img-linux-amd64"
if [ $? -eq 1 ]; then
  echo "ERROR: could not download img binary"
  exit 1
else
  echo "OKAY: downloaded img"
fi

mv img-linux-amd64 img
check_output=`echo "cc9bf08794353ef57b400d32cd1065765253166b0a09fba360d927cfbd158088 img" | sha256sum --check`
okay_string="img: OK"

if [ "$check_output" == "$okay_string" ]; then
  echo "OKAY: downloaded file matches the expected checksum"
  mkdir -p ~/.local/bin/img
  mv ./img ~/.local/bin/kubectl
  chmod +x ~/.local/bin/kubectl/img
else
  echo "ERROR: checksum does not match"
  exit 1
fi
echo "OKAY: img is downloaded and installed."

echo "UPDATING: path to include kubectl and img"
export PATH=$PATH:~/.local/bin/kubectl:~/.local/bin/img
echo "DONE: path updated"

USER=go img build -t $REGISTRY/test-nginx .
USER=go img push $REGISTRY/test-nginx
