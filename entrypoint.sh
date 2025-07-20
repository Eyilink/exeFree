#!/bin/bash
#!/bin/bash
set -e

echo "Configuring git"
git config --global user.name "exefree"
git config --global user.email "exefree@outlook.com"
# Enable detailed logging
echo "[DEBUG] Script started with arguments: $*"
echo "[DEBUG] Number of arguments: $#"

VPN=""
WORKSPACE="/workspace"

echo "[DEBUG] Initial values - VPN='$VPN', WORKSPACE='$WORKSPACE'"

# Log each argument
for i in "$@"; do
    echo "[DEBUG] Argument: '$i'"
done

echo "[DEBUG] Starting parameter parsing..."
while [[ "$#" -gt 0 ]]; do
    echo "[DEBUG] Processing argument: '$1' (remaining args: $#)"
    case $1 in
        --vpn) 
            echo "[DEBUG] Found --vpn flag"
            if [[ -n "$2" ]]; then
                VPN="$2"
                echo "[DEBUG] Setting VPN to: '$VPN'"
                shift
            else
                echo "[ERROR] --vpn flag provided but no value found"
                exit 1
            fi
            ;;
        --workspace) 
            echo "[DEBUG] Found --workspace flag"
            if [[ -n "$2" ]]; then
                WORKSPACE="$2"
                echo "[DEBUG] Setting WORKSPACE to: '$WORKSPACE'"
                shift
            else
                echo "[ERROR] --workspace flag provided but no value found"
                exit 1
            fi
            ;;
        *)
            echo "[DEBUG] Unknown argument: '$1'"
            ;;
    esac
    shift
    echo "[DEBUG] After shift, remaining args: $#"
done

echo "[DEBUG] Parameter parsing complete"
echo "[DEBUG] Final values - VPN='$VPN', WORKSPACE='$WORKSPACE'"

# Test the VPN variable more explicitly
echo "[DEBUG] Testing VPN variable:"
echo "[DEBUG] VPN length: ${#VPN}"
echo "[DEBUG] VPN is empty: $([ -z "$VPN" ] && echo "true" || echo "false")"
echo "[DEBUG] VPN is not empty: $([ -n "$VPN" ] && echo "true" || echo "false")"

if [[ -n "$VPN" ]]; then
    echo "[*] Starting VPN with $VPN"
    
    # Check if the VPN file exists
    if [[ ! -f "$VPN" ]]; then
        echo "[ERROR] VPN configuration file not found: $VPN"
        echo "[DEBUG] Current working directory: $(pwd)"
        echo "[DEBUG] Contents of current directory:"
        ls -la . 2>/dev/null || echo "Cannot list current directory"
        echo "[DEBUG] Contents of /vpn directory:"
        ls -la /vpn/ 2>/dev/null || echo "No /vpn directory found"
        echo "[DEBUG] Checking if path is absolute or relative:"
        echo "[DEBUG] VPN path starts with /: $([ "${VPN:0:1}" = "/" ] && echo "true (absolute)" || echo "false (relative)")"
        exit 1
    fi
    
    echo "[DEBUG] VPN file found, starting OpenVPN..."
    sudo openvpn "$VPN" &
    
    # Wait a moment for VPN to initialize
    sleep 2
    echo "[*] VPN process started"
else
    echo "[DEBUG] VPN variable is empty, skipping VPN setup"
fi

echo "[DEBUG] Script execution completed"

# if [[ -n "$WORKSPACE" ]]; then
#   echo "[*] Using workspace $WORKSPACE"
#   cd "$WORKSPACE"
# fi
cd "/workspace"
sudo chown -R exefree:exefree /var/log/supervisor
sudo /usr/bin/cat -n

authenticate_user() {
    echo "Enter your system username:"
    read -r USERNAME
    echo "Enter your system password:"
    read -rs PASSWORD

    # Try switching user with the provided credentials (non-interactive)
    if echo "$PASSWORD" | su -c "exit" "$USERNAME" > /dev/null 2>&1; then
        echo "Authentication successful."
    else
        echo "Authentication failed!"
        exit 1
    fi
}
/opt/tools/clipboard-sync.sh &
echo "Encrypted workspace requires authentication"
authenticate_user


# echo "Setting up encrypted workspace with gocryptfs..."

# sudo mkdir -p /workspace_encrypted /workspace

# # Initialize encrypted directory if it doesn't exist
# if [ ! -f "/workspace_encrypted/gocryptfs.conf" ]; then
#     echo "Initializing encrypted directory..."
#     cat /run/secrets/encfs_password | gocryptfs -init /workspace_encrypted
# fi

# # Mount encrypted directory
# cat /run/secrets/encfs_password | gocryptfs /workspace_encrypted /workspace

# cleanup() {
#     echo "Unmounting encrypted filesystem..."
#     fusermount -u /workspace 2>/dev/null || true
#     exit 0
# }

# trap cleanup SIGTERM SIGINT

echo "Encrypted workspace ready!"
exec "$@"
