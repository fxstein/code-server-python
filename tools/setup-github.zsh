#!/usr/bin/env zsh

# Basic script to set up the git config variables needed by GitHub.
# After the user enters his user/password, everything should be pre-populated.
# The user can, of course, choose to override the values the script digs up for user.name and user.email

user=`git config --global user.name`
email=`git config --global user.email`
host=`hostname`

# Setup github username
if [ -z "$user" ]; then
	vared -p "GitHub committer name not found, please enter: " -c user
	git config --global user.name $user
fi

# Setup email
if [ -z "$email" ]; then
	vared -p "GitHub committer email not found, please enter: " -c email
	git config --global user.email $email
fi

# SSH keys!
if [ ! -f ~/.ssh/id_rsa_github-$host-$user ]; then
	vared -p "No id_rsa_github-$host-$user key found, generate one? (y/n) " -c reply
	if [ "$reply" != "${reply#[Yy]}" ] ;then
  		echo ""
		echo $fg[red]"****************************************************************************"
		echo $fg[red]"*     GitHub highly recommends you use a strong passphrase on your key     *"
		echo $fg[red]"* Visit http://help.github.com/working-with-key-passphrases/ for more info *"
		echo $fg[red]"* After creating the key we will automatically add it to ssh-add for you   *"
		echo $fg[red]"****************************************************************************"
		echo ""
		ssh-keygen -t rsa -b 4096 -C "$email" -f ~/.ssh/id_rsa_github-$host-$user
		# Make sure we have the proper permissions on the key files
		chmod 400 ~/.ssh/id_rsa_github-$host-$user
		chmod 440 ~/.ssh/id_rsa_github-$host-$user.pub
	fi
fi

# Add github key to git configuration
if [ -f ~/.ssh/id_rsa_github-$host-$user ]; then
	if grep -qxF 'host github.com' ~/.ssh/config; then
		# Have to potentially update existing setting
		echo "Existing ssh config settings found..."

		# TODO: Figure out if we should do something in this case...
		# sed -e "/host github.com/,/ User git/{ /host github.com/ HostName github.com/ IdentityFile ~/.ssh/id_rsa_github-$host-$user/ User git/p; d }" ~/.ssh/config
	else
		# Create new ssh config settings
		echo "#### BEGIN Auto Generated Github key for $host-$user ####" >> ~/.ssh/config
		echo "host github.com" >> ~/.ssh/config
		echo " HostName github.com" >> ~/.ssh/config
		echo " IdentityFile ~/.ssh/id_rsa_github-$host-$user" >> ~/.ssh/config
		echo " User git" >> ~/.ssh/config
		echo "#### END Auto Generated Github key for $host-$user ####" >> ~/.ssh/config
		# Make sure we have the right permissions
		chmod 600 ~/.ssh/config
	fi 
fi

# Add the passphrase to ssh-add
#if [ -f ~/.ssh/id_rsa_github-$host-$user ]; then
#	ssh-add ~/.ssh/id_rsa_github-$host-$user
#fi

# Add the key to github manually
if [ -f ~/.ssh/id_rsa_github-$host-$user.pub ]; then
	echo ""
	echo $fg[green] "Add this public key to your github keys":
	echo ""
	echo $fg[green]"Suggested Github keyname: github-$host-$user"
	echo ""
	cat ~/.ssh/id_rsa_github-$host-$user.pub
	echo ""
	echo "Add key here: https://github.com/settings/keys"
fi
