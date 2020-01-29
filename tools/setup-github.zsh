
#!/usr/bin/env zsh

# Basic script to set up the git config variables needed by GitHub.
# After the user enters his user/password, everything should be pre-populated.
# The user can, of course, choose to override the values the script digs up for user.name and user.email

user=`git config --global user.name`
email=`git config --global user.email`

# Setup github username
if [ -z "$user" ]; then
	read -p "GitHub committer name not found, please enter: " user
    `git config --global user.name $user`
fi

# Setup email
if [ -z "$email" ]; then
	read -p "GitHub committer email not found, please enter: " email
    `git config --global user.email $email`
fi

# SSH keys!
if [ ! -f ~/.ssh/github-$user ]; then
	read -p "No github-$user key found, generate one? (y/n) " reply
	echo $reply
	if [ "$reply" != "${reply#[Yy]}" ] ;then
  		echo ""
		echo $fg[red]"****************************************************************************"
		echo $fg[red]"*     GitHub highly recommends you use a strong passphrase on your key     *"
		echo $fg[red]"* Visit http://help.github.com/working-with-key-passphrases/ for more info *"
		echo $fg[red]"* After creating the key we will automatically add it to ssh-add for you   *"
		echo $fg[red]"****************************************************************************"
		echo ""
		ssh-keygen -t rsa -b 4096 -C "$email" -f ~/.ssh/github-$user
		# Make sure we have the proper permissions on the key files
		chmod 600 ~/.ssh/github-$user
		chmod 640 ~/.ssh/github-$user.pub
	fi
fi

# Add the passphrase to ssh-add
if [ -f ~/.ssh/github-$user ]; then
	ssh-add ~/.ssh/github-$user
fi

# Add the key to github manually
if [ -f ~/.ssh/github-$user ]; then
	echo ""
	echo $fg[green] "Add this public key to your github keys":
	echo ""
	cat ~/.ssh/github-$user.pub
	echo ""
fi
