# Update system
echo "Updating system..."
sudo apt update

# Install autossh
echo "Installing autossh..."
sudo apt install autossh -y

# Add ssh key
echo "Generate ssh-key..."
ssh-keygen -b 2048 -t rsa -f /tmp/sshkey -q -N ""

# Config file
echo "Enter the file name want to tunnel without space (eg : mysql, web).."
read -p "Name of file: " sname 

NAME=$sname-tunnel.service

echo "Enter remote server name (eg: remoteserver.com / ip address - 333.333.333.333 ) "
read -p "Remote server : " server
echo "Enter user of remote server (eg: root, admin)"
read -p "User of remote server : " ruser
echo "Enter ssh port for remote server default 22"
read -p "SSH port remote server : " pssh
echo "Enter remote port want to tunnel (eg: 80,443) "
read -p "Remote port : " rport
echo "The name local user to manage this ssh (eg: root, admin) "
read -p "Local user : " luser
echo "Enter local port want to tunnel (eg: 3306) "
read -p "Local internal port : " lport

# ssh without password
echo "SSH remote server. Enter ssh password for remote server."
ssh-copy-id $ruser@$server -p $pssh -f

# Edit config file
echo "Editing config file..."
sed -i "s/service mysql/service $sname/g" tunnel.service
sed -i "s/User=system/User=$luser/g" tunnel.service
sed -i "s/2000/$rport/g" tunnel.service
sed -i "s/3306/$lport/g" tunnel.service
sed -i "s/admin@remoteserver.com/$ruser@$server/g" tunnel.service
sed -i "s/-p 22/-p $pssh/g" tunnel.service


cp tunnel.service /etc/systemd/system/$NAME
systemctl start $NAME
systemctl enable $NAME
systemctl status $NAME

echo "Done setup ssh tunnel"
echo "Name service that you tunnel : " $sname
echo "Remote server that will received tunnel : " $server
echo "Port will be on remote server : " $rport
echo "Local port that will be tunnel : " $lport




