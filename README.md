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
nix build .#darwinConfigurations.gifaeriyanto-mac.system
```

6. Apply result

```bash
./result/sw/bin/darwin-rebuild switch --flake .#gifaeriyanto-mac
```

## Notes (after installation)

### Default Shell

1. Go to `System References`
2. Select `User & Groups`
3. Unlock access and right click on your user, choose `Advanced Options`
4. Change `Login Shell` to `/run/current-system/sw/bin/fish` (or another shell path source)

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

### Fish Plugin

When you want to install a fish plugin, you need to know the rev and sha256 code. To get those codes, do this:

```bash
nix-prefetch-git repo-url
```

Example:

```bash
❯ nix-prefetch-git https://github.com/jethrokuan/z
...
{
  "url": "https://github.com/jethrokuan/z",
  "rev": "85f863f20f24faf675827fb00f3a4e15c7838d76",
  "date": "2022-04-08T19:43:37+02:00",
  "path": "/nix/store/ngc6gybp6rs08ab2jqa2kdmsr9xzipm1-z",
  "sha256": "1kaa0k9d535jnvy8vnyxd869jgs0ky6yg55ac1mxcxm8n0rh2mgq",
  "fetchLFS": false,
  "fetchSubmodules": false,
  "deepClone": false,
  "leaveDotGit": false
}
```

## References

Inspired by:

- https://github.com/r17x/nixpkgs
- https://github.com/malob/nixpkgs
- https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050
- https://github.com/zainfathoni/nixpkgs
