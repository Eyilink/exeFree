ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

eval "$(ssh-agent -s)"

ssh-add /home/exefree/.ssh/id_rsa
