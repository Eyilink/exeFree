#!/bin/bash
set -e

echo "Starting application..."

# Only run setup if not already done
if [ ! -f "/opt/.setup_complete" ]; then
    echo "Running first-time setup..."
    
    /opt/tools/install_nvim.sh
    /opt/tools/customize_shell.sh
    /opt/tools/install_fzf.sh
    /opt/tools/install_web.sh
    
    # Mark setup as complete
    touch /opt/.setup_complete
    echo "Setup complete!"
else
    echo "Setup already completed, skipping..."
fi

exec "$@"