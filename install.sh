#!/bin/sh

target=${1:-/usr/local/bin/alice}
source='https://download.wsoft.ws/WS00310/alice'
os=$(uname | tr '[:upper:]' '[:lower:]')
arch=$(uname -m | tr '[:upper:]' '[:lower:]')

echo '* Losetta Installer *'

if [ "$os" = 'linux' ]  && [ "$arch" = 'x86_64' ]; then
  source='https://download.wsoft.ws/WS00310/alice'
elif [ "$os" = 'linux' ]  && [ "$arch" = 'arm' ]; then
  source='https://download.wsoft.ws/WS00311/alice'
elif [ "$os" = 'linux' ]  && [ "$arch" = 'arm64' ]; then
  source='https://download.wsoft.ws/WS00312/alice'
elif [ "$os" = 'darwin' ]  && [ "$arch" = 'x86_64' ]; then
  source='https://download.wsoft.ws/WS00320/alice'
elif [ "$os" = 'darwin' ]  && [ "$arch" = 'arm64' ]; then
  source='https://download.wsoft.ws/WS00321/alice'
else
  echo 'This platform is NOT supported.'
  exit
fi

echo 'Losetta for '$os' ('$arch') will install'
echo 'from: '$source
echo 'to: '$target
echo
echo 'Downloading binary...'
curl -L $source -o $target
if [ $? -ne 0 ]; then
    echo "Download failed..." >&2
    exit 1
fi
chmod +x $target

echo 'Downloading script...'
$target install --args https://alice.wsoft.ws/uninstall_unix.ice uninstall
$target install --args https://alice.wsoft.ws/icebuild.ice icebuild

echo 'Install completed. We are installed...'
$target version
