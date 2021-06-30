# Linuxbrew for CentOS 7

Small script that allows to install linuxbrew on the old CentOS 7.

The current CentOS 7 has quite outdated software, so old that homebrew/linuxbrew won't install
anymore. Therefore, it's required to first locally compile the latest versions from source and
instruct it to use these for the initial bootstrap.

## Problems with old software

1. linuxbrew needs a newer `curl` and `git` than available in the default repos of CentOS 7 and need
   to be installed from source.
2. These applications don't work with the system's `openssl` so it needs to be compiled as well.
3. The `gcc@5` formula doesn't compile and must be forced to use the bottle instead. Unfortunately
   the `--force-bottle` flag doesn't work so the formular must be patched manually.

And this is what the script basically does. Compile `openssl`, `curl` and `git`. Then patch the
`gcc@5` formula and install it. After that compile `curl` and `git` **again**, this time through
linuxbrew.
In the end it sets up a few env vars that tell linuxbrew to use its own versions of `curl` and `git`
instead of trying the system versions.

## How to use

1. Download the `setup.sh` script and place it in your home folder.
2. Make it executable with `chmod +x setup.sh` and execute it.
3. It will take a while to compile everything so depending on your machine you might go and do
   something else for a while.
4. Enjoy linuxbrew in your `bash` shell. It adds `eval $(~/.linuxbrew/bin/brew shellenv)` to your
   `.bashrc` so if you use another shell you can just add that line to your init script.
