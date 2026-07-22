# qeth-gentoo

A Gentoo/Portage overlay for [qeth](https://github.com/qeth-wallet/qeth) — a
Qt (PySide6) Ethereum wallet with Ledger support and a Frame-compatible JSON-RPC
server.

## Packages

- **`net-p2p/qeth`** — the wallet. Generic dependencies (PySide6, aiohttp,
  pydantic, requests, …) come from the system; the Ethereum library stack
  (web3, eth-\*, ledgereth, and its narrowly-pinned compiled deps like ckzg and
  cytoolz) is **vendored from source** into a private `/usr/lib*/qeth/vendor`
  tree and reached through a `/usr/bin/qeth` `PYTHONPATH` wrapper. This mirrors
  the wallet's existing rpm/deb/AppImage/Flatpak packaging, because the eth
  stack is absent from every Gentoo repo and pins its inter-versions too
  narrowly for system site-packages.
- **`net-p2p/helios-bin`** — the a16z Helios light client (upstream prebuilt
  binary), the optional verified-reads sidecar for qeth.

## USE flags (net-p2p/qeth)

| flag | default | effect |
|------|:---:|--------|
| `simulate` | on | transaction preview via a bundled local py-evm fork engine |
| `helios` | on | verified (light-client) reads via `net-p2p/helios-bin` |
| `qr` | on | air-gapped QR signing + camera scanning (pulls Qt Multimedia) |
| `frame` | on | import Frame desktop-wallet accounts (pulls `dev-python/cryptography`) |
| `falkon` | off | install the Falkon browser connector plugin |
| `chromium` | off | install the Chrome extension for manual loading |
| `firefox` | off | install + register the signed Firefox extension |

The three browser-integration flags are off by default so a plain install pulls
no external browser.

## Using the overlay

```sh
# eselect-repository (preferred)
eselect repository add qeth-gentoo git https://github.com/qeth-wallet/qeth-gentoo.git
emaint sync -r qeth-gentoo

# …or a manual repos.conf entry
cat > /etc/portage/repos.conf/qeth-gentoo.conf <<'EOF'
[qeth-gentoo]
location = /var/db/repos/qeth-gentoo
sync-type = git
sync-uri  = https://github.com/qeth-wallet/qeth-gentoo.git
EOF
emaint sync -r qeth-gentoo

emerge -av net-p2p/qeth
```

`~/.qeth` holds config, encrypted keystores and caches (untouched by the
package; only code and the vendored deps are installed system-wide).

## Notes

- **From-source vendoring**: the eth stack is compiled offline at build time
  (`pip --no-index --no-build-isolation --no-deps`); the compiled extensions
  (ckzg, cytoolz, pycryptodomex, plus lru-dict for `simulate` and zxing-cpp for
  `qr`) build against the system Python. A build-time guard fails if PySide6
  ever leaks into the vendored tree.
- **bleak** is vendored as its noarch wheel (it is import-required by
  `ledgerblue.comm`, but its sdist uses the `uv_build` backend, which we avoid).
- **helios** pins the upstream `0.11.1` linux/amd64 release; qeth auto-detects
  `/usr/bin/helios` on PATH and degrades to untrusted RPC when absent.
- amd64 only for now.
