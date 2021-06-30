#!/bin/bash
set -euxo pipefail

export PKG_CONFIG_PATH=$HOME/usr/lib/pkgconfig
export LD_LIBRARY_PATH=$HOME/usr/lib
export LDFLAGS="-Wl,-rpath=$HOME/usr/lib"
export PATH=$HOME/usr/bin:$PATH

# OpenSSL

/bin/curl -Lo openssl.tar.gz https://www.openssl.org/source/openssl-1.1.1k.tar.gz
tar xzf openssl.tar.gz
cd openssl-1.1.1k

./config --prefix=$HOME/usr --openssldir=$HOME/usr shared
make -j$(nproc)
make install_sw

cd $HOME
rm -rf openssl*

# cURL

/bin/curl -Lo curl.tar.gz https://curl.se/download/curl-7.77.0.tar.gz
tar xzf curl.tar.gz
cd curl-7.77.0

PKG_CONFIG_PATH=$HOME/usr/lib/pkgconfig ./configure --prefix=$HOME/usr --with-openssl
make -j$(nproc)
make install

cd $HOME
rm -rf curl*

# Git

/bin/curl -Lo git.tar.gz https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.32.0.tar.gz
tar xzf git.tar.gz
cd git-2.32.0

make configure
./configure --prefix=$HOME/usr --with-openssl=$HOME/usr --with-curl=$HOME/usr
make -j$(nproc)
make install

cd $HOME
rm -rf git*

# Homebrew

export HOMEBREW_CURL_PATH=$HOME/usr/bin/curl
export HOMEBREW_GIT_PATH=$HOME/usr/bin/git
export HOMEBREW_DEVELOPER=1

git clone https://github.com/Homebrew/brew $HOME/.linuxbrew/Homebrew
mkdir $HOME/.linuxbrew/bin
ln -s $HOME/.linuxbrew/Homebrew/bin/brew $HOME/.linuxbrew/bin
eval $(~/.linuxbrew/bin/brew shellenv)

brew update
sed -i 's/sha256               x86_64_linux:/sha256 cellar: :any, x86_64_linux:/' $(brew --repo)/Library/Taps/homebrew/homebrew-core/Formula/gcc@5.rb
brew install gcc@5
brew install curl git

echo 'export HOMEBREW_FORCE_BREWED_CURL=true' >> .bashrc
echo 'export HOMEBREW_FORCE_BREWED_GIT=true' >> .bashrc
echo 'eval $(~/.linuxbrew/bin/brew shellenv)' >> .bashrc

rm -rf usr
