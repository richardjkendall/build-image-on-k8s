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

echo "DOWNLOAD: img"

curl -fSL "http://webshare-svc.default.svc.cluster.local/img" -o "/usr/local/bin/img"
if [ $? -eq 1 ]
  echo "ERROR: could not download img binary"
  exit 1
then
  echo "OKAY: downloaded img"
fi

check_output=`echo "3df3d9de798919c34bb3285518cf6f19307c9c7a0d697d3ede6a79dc51af2b55 /usr/local/bin/img" | sha256sum --check`
okay_string="img: OK"

if [ "$check_output" == "$okay_string" ]; then
  echo "OKAY: downloaded file matches the expected checksum"
else
  echo "ERROR: checksum does not match"
  exit 1
fi

chmod a+x /usr/local/bin/img
echo "OKAY: img is downloaded and installed."
