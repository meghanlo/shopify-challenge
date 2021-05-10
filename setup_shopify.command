RUBY_VERSIONS=("2.7.3")
if [[ "$OSTYPE" != "darwin"* ]]; then
echo "==========Error: This script only works on OS X.=========="
exit 1
fi

SHELL_CONFIG_FILE=${SHELL_CONFIG_FILE:=~/.zshrc}

echo "==========Install and update Homebrew=========="
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew update

echo "==========Install git=========="
brew install git

echo "==========Install PostgreSQL and start it on boot=========="
brew install postgres
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist

echo "==========Installing Ruby prerequisites=========="
brew install openssl libyaml libffi cmake
# Create symlinks for OpenSSL to prevent `error: 'openssl/ssl.h' file not found`
brew link --force openssl

echo "==========Install rbenv for Ruby version management=========="
brew install rbenv ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> "$SHELL_CONFIG_FILE"
echo 'eval "$(rbenv init -)"' >> "$SHELL_CONFIG_FILE"

echo "==========Install the Ruby versions we use=========="
eval "$(rbenv init -)"
for ruby_version in "${RUBY_VERSIONS[@]}"; do
rbenv install $ruby_version
rbenv shell $ruby_version
gem install bundler -v '~> 1'
done
rbenv rehash

echo "==========Create postgres superuser=========="
createuser -s postgres


echo "==========reload config============="
source "$SHELL_CONFIG_FILE"

# 3 beep salute
for i in `seq 3`; do
echo -ne '\007'
sleep 0.5
done &
echo "✨ 💥 Done! 💥 ✨"