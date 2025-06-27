ssh-keygen -t rsa

exefree@dd623947c834: /workspace/reverse_chal  eval "$(ssh-agent -s)"
Agent pid 2155
exefree@dd623947c834: /workspace/reverse_chal  ssh-add -l
The agent has no identities.
exefree@dd623947c834: /workspace/reverse_chal  ssh-add /home/exefree/.ssh/reverse
Identity added: /home/exefree/.ssh/reverse (exefree@dd623947c834)
exefree@dd623947c834: /workspace/reverse_chal  ssh-add -l
3072 SHA256:4D7G6vIfunqIpScRJzOvj1Ws2TyN3MJ5G2M9icJGFoo exefree@dd623947c834 (RSA)
exefree@dd623947c834: /workspace/reverse_chal  ssh -T git@github.com
Hi Eyilink/Reverse! You've successfully authenticated, but GitHub does not provide shell access.