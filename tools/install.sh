#!/bin/bash
set -e

echo "Starting application..."


    
/opt/tools/install_nvim.sh
/opt/tools/customize_shell.sh
/opt/tools/install_fzf.sh
/opt/tools/install_web.sh
    


exec "$@"