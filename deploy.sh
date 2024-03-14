# Referenced: https://stackoverflow.com/questions/61625191/nvm-in-gitlab-ci-script-and-ssh


#!/usr/bin/env bash
sudo apt update

# Install nvm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Source for nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Install node and npm
nvm install 18.17.0
nvm use 18.17.0

# Check npm is compatible
npm install -g npm@latest

# Remove ExampleApplication
if [ -d "SimpleApplication" ]; then
    rm -rf SimpleApplication
fi
#
# Clone the repository
git clone https://github.com/ryanlanzstu/SimpleApplication.git

# Change directory to the cloned repository
cd SimpleApplication || exit

# Stop any previously running instance of the app
pm2 stop example_app || true

# Install dependencies
npm install
echo $PRIVATE_KEY > privatekey.pem
echo $SERVER > server.crt

# Start the app using PM2
pm2 start ./bin/www --name example_app