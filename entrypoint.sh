#!/bin/bash
set -e

# echo "Setting default creds for Neo4j..."
# sudo sed -i 's/^#\?dbms.default_listen_address=.*/dbms.default_listen_address=0.0.0.0/' /etc/neo4j/neo4j.conf
# echo "dbms.connector.http.listen_address=:7474" | sudo tee -a /etc/neo4j/neo4j.conf > /dev/null
# echo "dbms.connector.bolt.listen_address=:7687" | sudo tee -a /etc/neo4j/neo4j.conf > /dev/null



# Démarre Neo4j
# sudo service neo4j start

cd /workspace

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
