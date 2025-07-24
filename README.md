### Next steps
 fix openssl (it is the openssl libs in python that doesnt work for some tools)
 zsh history persistent
 one container but different encrypted workspaces
resize du vnc aussi by adding an env var RESOLUTION and passing it to compose by using the wrapper to retrieve it via [System.Windows.Forms.Screen]::AllScreens | ForEach-Object { $_.Bounds.X }

 
 ### Setup

It is important to download the file here : https://drive.google.com/file/d/1rvwmJblSLjkOe3RNJ1ksw9tGO2NHMiQR/view?usp=drive_link

And then unzip it in ./resources/

You can install exefree by running as an admin the `install.ps1` file this file will install an X11 server on your host and set an alias for the exefree PS script.

After you need to build an image by running `exefree build`, a `-Type` arg which only support `internal` build for now.

You can do `exefree start <workspace>` to start a new workspace, to this you can add a `-Vpn` and `-Workspace` args.

I would advise to use the x11 server for lightweight process like xfreerdp and to use the VNC server for burp, firefox, etc.

### Zshrc special capacities

The default zshrc provides a sync_time function to synchronize time during internal assessment.

And a vnc_start func to start a GUI app through VNC. It is recommended to use Ultra VNC Viewer client.

A kerbconf func to display an example kerberos conf to use during internal assessment.