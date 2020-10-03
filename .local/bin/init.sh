#!/usr/bin/env bash

if [[ $UID -ne 0 ]]; then
  sudo -p 'Restarting as root, password:' bash $0 "$@"
  exit $?
fi

dnf install \
  git \
  fzf \
  neovim \
  z \
  ripgrep \
  @LibreOffice \
  "@Container Management" \
  @LibreOffice \
  "@System Tools" \
  "@Sound and Video" \
  chromium \
  nodejs \
  python3 \
  rsync \
  sshfs \
  simple-scan \
  lm_sensors \
  keepassxc


npm install -g neovim
pip3 install pynvim

type yarn || {
  npm install -g yarn
  yarn set version berry
}

[[ -f /usr/lib/chromium/libwidevinecdm.so ]] || {
  printf "installing libvidevine ...\n"
  LATEST=`curl https://dl.google.com/widevine-cdm/current.txt`
  wget https://dl.google.com/widevine-cdm/$LATEST-linux-x64.zip
  unzip $LATEST-linux-x64.zip
  mkdir /usr/lib/chromium
  mv libwidevinecdm.so /usr/lib/chromium
  chmod 644 /usr/lib/chromium/libwidevinecdm.so
}
