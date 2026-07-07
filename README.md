# openwrt-fleth-keyring

OpenWrt keyring package for the Flet'H package feed at
`https://dl.fleth.link/`.

The same package source builds for both OpenWrt package managers:

- OpenWrt 24.10 / opkg installs the usign public key to
  `/etc/opkg/keys/064499bbef2b4ee5`
- OpenWrt 25.12 / apk installs the APK public key to
  `/etc/apk/keys/fleth.pem`

This is useful for Image Builder profiles and SDK feeds that should trust the
Flet'H package repository without running manual key setup commands on first
boot.

## Package

Add this repository as an OpenWrt package feed and build:

```sh
make package/openwrt-fleth-keyring/compile
```

With an opkg-based SDK this produces an `.ipk`; with an apk-based SDK this
produces an `.apk`.

## Manual feed setup

The keyring package is the preferred path for images. For an already running
router, the feed can still be configured manually.

### apk

```sh
wget -O /etc/apk/keys/fleth.pem https://dl.fleth.link/fleth.pem
echo 'https://dl.fleth.link/apk/all/packages.adb' >> /etc/apk/repositories.d/customfeeds.list
apk update
apk add luci-proto-fleth
```

### opkg

```sh
mkdir -p /etc/opkg/keys
wget -O /etc/opkg/keys/064499bbef2b4ee5 https://dl.fleth.link/opkg/all/064499bbef2b4ee5
echo 'src/gz fleth https://dl.fleth.link/opkg/all' >> /etc/opkg/customfeeds.conf
opkg update
opkg install luci-proto-fleth
```
