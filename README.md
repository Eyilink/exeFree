### Next steps
mettre un alias vnc = Xvfb :1 -screen 0 1280x1024x16 & fluxbox & x11vnc -forever & appli et le nom d'un appli pour la démarrer en vnc et deplus changer le display et forwrad les ports (5900..) ENV DISPLAY :1 
 fix openssl 
 fix md4hash unsupported
 fix gem
 ### Setup

It is important to download the file here : https://drive.google.com/file/d/1rvwmJblSLjkOe3RNJ1ksw9tGO2NHMiQR/view?usp=drive_link

And then unzip it in ./resources/

You can install exefree by running as an admin the `install.ps1` file this file will install an X11 server on your host and set an alias for the exefree PS script.

After you need to build an image by running `exefree build`, a `-Type` arg which only support `internal` build for now.

You can do `exefree start <workspace>` to start a new workspace, to this you can add a `-Vpn` and `-Workspace` args.


Different things to do :
 - one container but different encrypted workspaces
 - optiomize X11
 - see multiple arguments problem in the docker compose override file
