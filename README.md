# Gifa's Home

My Nix configs to setup all of my devices. Usually we take some minutes/hours/days to setup our new laptop to make it ready to use. But now, I solved it with Nix. Just need to run my Nix config, and all done.

## Get Started

1. Install Nix

```bash
curl -L https://nixos.org/nix/install | sh
```

2. Create `nix` folder

```bash
mkdir -p ~/.config/nix
```

3. Enable `nix-command flakes` feature

```bash
cat <<EOF > ~/.config/nix/nix.conf
experimental-features = nix-command flakes
EOF
```

4. Clone this repo

```bash
git clone https://github.com/gifaeriyanto/nixpkgs.git ~/.config/nixpkgs
```

5. Run build in `nixpkgs` folder

```bash
# for Intel Chip
nix build .#darwinConfigurations.gifaeriyanto.intel.system

# for M1 Chip
nix build .#darwinConfigurations.gifaeriyanto.m1.system
```

6. Apply result

```bash
./result/sw/bin/darwin-rebuild switch --flake .#gifaeriyanto.m1
```

## Notes (after installation)

### iTerm2

Import profile, [here](https://gist.github.com/gifaeriyanto/1c2cfea240fdcf9360afe9cb51ae5a4b) is my JSON profile.

### Import GPG Keys

For **Public Key**

```bash
gpg --search-keys your_address@example.net
```

Choose the number, then it will be automatically imported.

For **Private Key**

```bash
# download it from telegram with "gpg secret key" keyword
gpg --import secret.pgp

# verify the key
gpg --edit-key your_address@example.net
# then fill next with "**trust"**
# last, choose ultimate
```

If fail because no pinentry, do these:

```bash
# check pinentry-program
cat ~/.gnupg/gpg-agent.conf
# should be `pinentry-program $(brew --prefix)/bin/pinentry-mac`
# pinentry-mac already installed from nix, just make sure the path is correct

# restart gpg agent if you edit the gpg-agent.conf
gpgconf --kill gpg-agent
```

### Node install

Install node latest lts version and node 14

```bash
n lts
n 14 # need rosetta for M1
```

### Github CLI

Login to github via cli to validate your account

```bash
gh auth login
```

Fill password with your personal access token. See [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) for more information.

## References

Inspired by:

- https://github.com/r17x/nixpkgs
- https://github.com/malob/nixpkgs
- https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050
- https://github.com/zainfathoni/nixpkgs
