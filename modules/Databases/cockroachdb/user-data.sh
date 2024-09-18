#!/bin/bash

# 1. update the system.
sudo apt-get update
echo "-------------------------------------------------------OS updated-------------------------------------------------------------"

# 2. download cockroach-db latest binaries
sudo curl https://binaries.cockroachdb.com/cockroach-v23.1.6.linux-amd64.tgz | tar -xz
echo "-------------------------------------------------Cockroach-db binaries downloaded------------------------------------------------"

# 3. Copy the binary into the PATH:
sudo cp -i cockroach-v23.1.6.linux-amd64/cockroach /usr/local/bin/
echo "-----------------------------------------------Copied the binary into the PATH------------------------------------------------------"

# 4. CockroachDB uses custom-built versions of the GEOS libraries. Copy these libraries to the location where CockroachDB expects to find them:
sudo mkdir -p /usr/local/lib/cockroach
sudo cp -i cockroach-v23.1.6.linux-amd64/lib/libgeos.so /usr/local/lib/cockroach/
sudo cp -i cockroach-v23.1.6.linux-amd64/lib/libgeos_c.so /usr/local/lib/cockroach/ 

# 5. Verify that CockroachDB can execute spatial queries.
which cockroach

# 6. Create the CA certificate and key:
sudo mkdir -p /home/ubuntu/certs
sudo mkdir -p /home/ubuntu/my-safe-directory

echo "-------------------------------------------------list of directory-------------------------------------------------"
ls -la /home/ubuntu/
echo "-------------------------------------------------*****************-------------------------------------------------"

private_IP=$(hostname -I)
public_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
hostname=$(hostname)
echo "Private IP: $private_IP"
echo "Public IP: $public_IP"
echo "----------------------------------------------------Got the Private IP--------------------------------------------------------"

sudo cockroach cert create-ca --certs-dir=/home/ubuntu/certs --ca-key=/home/ubuntu/my-safe-directory/ca.key
sudo cockroach cert create-client root --certs-dir=certs --ca-key=my-safe-directory/ca.key
# sudo cockroach cert create-node $private_IP localhost 127.0.0.1 --certs-dir=certs --ca-key=my-safe-directory/ca.key

cockroach cert create-node $private_IP $public_IP $hostname node-$hostname localhost 127.0.0.1 
cockroachdb-alb-f82f5b49b491d316.elb.us-east-1.amazonaws.com \
--certs-dir=certs \
--ca-key=my-safe-directory/ca.key

sudo chown ubuntu:ubuntu certs/*

echo "----------------------------------------------Created CA certificate and key-------------------------------------------------"

# Create a systemd service file for cockroachDB (cockroach.service)
sudo cat <<EOF | sudo tee /etc/systemd/system/cockroach.service 
[Unit]
Description=Cockroach Database cluster node
Requires=network.target
[Service]
Type=notify
WorkingDirectory=/home/ubuntu/
ExecStart=/usr/local/bin/cockroach start --certs-dir=certs --advertise-addr=${private_IP} --join=${private_IP} --cache=.25 --max-sql-memory=.25 
TimeoutStopSec=300
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=cockroach  
User=ubuntu
[Install]
WantedBy=default.target
EOF

echo "--------------------------------------------------Created cockroach.service-------------------------------------------------------"

# 9. Reload systemd to recognize the new service
sudo systemctl daemon-reload

# 10. Enable CockroachDB service to start on boot
sudo systemctl enable cockroach

# 11. Start the CockroachDB service
sudo systemctl start cockroach

# 12. Check the status of the CockroachDB service
sudo systemctl status cockroach

echo "-------------------------------------------------------Installed Cockroachdb-------------------------------------------------------------"