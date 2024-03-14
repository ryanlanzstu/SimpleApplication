#!/usr/bin/env bash
sudo apt update && sudo apt install -y nodejs npm

# Install nvm to manage Node.js versions
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Use nvm to install and use the correct version of Node.js
nvm install 18.17.0
nvm use 18.17.0

# Ensure npm is up to date
npm install -g npm@latest

# Prepare the application
if [ -d "SimpleApplication" ]; then
    rm -rf SimpleApplication
fi
git clone https://github.com/ryanlanzstu/SimpleApplication.git
cd SimpleApplication || exit

# Stop any previously running instance of the app
pm2 stop example_app || true

# Install dependencies
npm install

# Handle private key and certificate for HTTPS
echo "$PRIVATE_KEY" > privatekey.pem
echo "$SERVER" > server.crt

# Start the application with PM2
pm2 start ./bin/www --name example_app
