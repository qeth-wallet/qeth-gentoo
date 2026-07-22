# Copyright 2026 Michael Egorov
# Distributed under the terms of the GNU General Public License v3

EAPI=8

PYTHON_COMPAT=( python3_13 )
inherit desktop python-single-r1 xdg

DESCRIPTION="Qt Ethereum wallet with Ledger support and a Frame-compatible JSON-RPC server"
HOMEPAGE="https://github.com/qeth-wallet/qeth"

# The Ethereum stack (web3, eth-*, ledgereth, ckzg, cytoolz, …) is absent from
# every Gentoo repo and pins its inter-versions too narrowly for system
# site-packages, so it is VENDORED from-source into a private tree. Everything
# generic (PySide6, aiohttp, pydantic, …) comes from the system as RDEPEND.
# setuptools-git-versioning is cytoolz's build backend and the only build tool
# not in ::gentoo, so it is fetched here as a build-time wheel.
SRC_URI="
	https://github.com/qeth-wallet/qeth/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://files.pythonhosted.org/packages/e3/5a/df537a48d60fcb23c2e76bf0192a1d812f6f540e6cae698e402a3bbc27f8/setuptools_git_versioning-3.1.0-py3-none-any.whl
	https://files.pythonhosted.org/packages/26/54/05aceb9cd80073805b3ed8522e3196e8cb22f70e741873fa51406c31f4e7/bleak-3.0.2-py3-none-any.whl
	https://files.pythonhosted.org/packages/2b/88/552337d9fc69dc85fb6102c18b73a9f3f77efb39bb9a0c1a8c61bbdd7274/ckzg-2.1.8.tar.gz
	https://files.pythonhosted.org/packages/bd/d4/16916f3dc20a3f5455b63c35dcb260b3716f59ce27a93586804e70e431d5/cytoolz-1.1.0.tar.gz
	https://files.pythonhosted.org/packages/e0/48/3f8c1a252e3a46fd04e6fabc5e11c933b9c39cf84edd4e7c906e29c23750/ECPy-1.2.5.tar.gz
	https://files.pythonhosted.org/packages/00/71/d9e1380bd77fd22f98b534699af564f189b56d539cc2b9dab908d4e4c242/eth_abi-5.2.0.tar.gz
	https://files.pythonhosted.org/packages/74/cf/20f76a29be97339c969fd765f1237154286a565a1d61be98e76bb7af946a/eth_account-0.13.7.tar.gz
	https://files.pythonhosted.org/packages/3c/f5/c67fc24f2f676aa9b7ab29679d44f113f314c817207cd4319353356f62da/eth_hash-0.8.0.tar.gz
	https://files.pythonhosted.org/packages/35/66/dd823b1537befefbbff602e2ada88f1477c5b40ec3731e3d9bc676c5f716/eth_keyfile-0.8.1.tar.gz
	https://files.pythonhosted.org/packages/58/11/1ed831c50bd74f57829aa06e58bd82a809c37e070ee501c953b9ac1f1552/eth_keys-0.7.0.tar.gz
	https://files.pythonhosted.org/packages/7f/ea/ad39d001fa9fed07fad66edb00af701e29b48be0ed44a3bcf58cb3adf130/eth_rlp-2.2.0.tar.gz
	https://files.pythonhosted.org/packages/37/e7/06c5af99ad40494f6d10126a9030ff4eb14c5b773f2a4076017efb0a163a/eth_typing-6.0.0.tar.gz
	https://files.pythonhosted.org/packages/e6/e1/ee3a8728227c3558853e63ff35bd4c449abdf5022a19601369400deacd39/eth_utils-5.3.1.tar.gz
	https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz
	https://files.pythonhosted.org/packages/7f/87/adf4635b4b8c050283d74e6db9a81496063229c9263e6acc1903ab79fbec/hexbytes-1.3.1.tar.gz
	https://files.pythonhosted.org/packages/c0/bb/b9d96530f4a94bec5d76116b47e9e7c8dcc362a28b22ad6faa1d25c1d9ec/ledgerblue-0.1.48.tar.gz
	https://files.pythonhosted.org/packages/b5/bb/4923dc24cda5ae4b2f21b85d02a57a026a6e8cc5379f40db869653e7b414/ledgereth-0.10.0.tar.gz
	https://files.pythonhosted.org/packages/58/f8/cd11ec90bd6a6bcf35bb80e4e29fdebe8bf2b05e869a93ca1e41d85518d0/ndeflib-0.3.3.tar.gz
	https://files.pythonhosted.org/packages/38/a2/cce3ab796e84bea5098c4231ff56e523cb182c58a21280ccff0d75e693e6/nfcpy-1.0.4.tar.gz
	https://files.pythonhosted.org/packages/7b/91/abdc50c4ef06fdf8d047f60ee777ca9b2a7885e1a9cea81343fbecda52d7/parsimonious-0.10.0.tar.gz
	https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz
	https://files.pythonhosted.org/packages/4d/3d/0997fe8196f5be24b7015708a0744a0ef928c4fb3c8bc820dc3328208ef2/python-u2flib-host-3.0.3.tar.gz
	https://files.pythonhosted.org/packages/25/ab/b912c484cfb96ba4834efe050bbf10c9e157bd8189eb859aefba8712b136/pyunormalize-17.0.0.tar.gz
	https://files.pythonhosted.org/packages/0f/49/bcd4d3f9210ed78749eab04d236eeb98f98fbcc16977f308ee4637c1bad8/rlp-4.0.1.tar.gz
	https://files.pythonhosted.org/packages/f1/d9/bdfa9e715804020c3f3676346065c18adbc207c9343a3458246d7430f45c/web3-7.16.0.tar.gz
	simulate? (
		https://files.pythonhosted.org/packages/76/4b/3d870836119dbe9a5e3c9a61af8cc1a8b69d75aea564572e385882d5aefb/cached_property-2.0.1.tar.gz
		https://files.pythonhosted.org/packages/89/d6/9c345601de27b536dc8b0f4c1d6cb84fe76a47de9ac02753f58deae59c86/eth_bloom-3.1.0.tar.gz
		https://files.pythonhosted.org/packages/06/0a/dec86efe38b350314c49a8d39ef01ba7cf8bbbef1d177646320eedea7159/lru_dict-1.4.1.tar.gz
		https://files.pythonhosted.org/packages/1c/96/e73075d5c885274efada2fbc5db6377022036c2f5b4b470dbcf4106e07d5/py_ecc-8.0.0.tar.gz
		https://files.pythonhosted.org/packages/0a/57/a0a84d991bac43058200245d853de9e7e819d216b56e22f66654fdf596d5/py_evm-0.12.1b1.tar.gz
		https://files.pythonhosted.org/packages/a6/2f/5ec6be52952de47e79b1d250c00a922365a76503e3c75605c1cd890c61aa/trie-3.1.0.tar.gz
	)
	qr? (
		https://files.pythonhosted.org/packages/23/39/6621d964dbf7f31dbaade0981a5df4e9db247457962e6bbb88d1b8d55763/zxing_cpp-3.1.0.tar.gz
	)
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+simulate +helios +qr +frame falkon chromium firefox"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# System (generic) deps — the eth stack is vendored (see SRC_URI / src_install).
RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pyside[gui,network,svg,widgets,${PYTHON_USEDEP}]
		dev-python/aiohappyeyeballs[${PYTHON_USEDEP}]
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/aiosignal[${PYTHON_USEDEP}]
		dev-python/annotated-types[${PYTHON_USEDEP}]
		dev-python/async-timeout[${PYTHON_USEDEP}]
		dev-python/attrs[${PYTHON_USEDEP}]
		dev-python/bitarray[${PYTHON_USEDEP}]
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/charset-normalizer[${PYTHON_USEDEP}]
		dev-python/dbus-fast[${PYTHON_USEDEP}]
		dev-python/frozenlist[${PYTHON_USEDEP}]
		dev-python/hidapi[${PYTHON_USEDEP}]
		dev-python/idna[${PYTHON_USEDEP}]
		dev-python/libusb1[${PYTHON_USEDEP}]
		dev-python/multidict[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/propcache[${PYTHON_USEDEP}]
		dev-python/protobuf[${PYTHON_USEDEP}]
		dev-python/pycryptodome[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
		dev-python/pydes[${PYTHON_USEDEP}]
		dev-python/pyelftools[${PYTHON_USEDEP}]
		dev-python/pyserial[${PYTHON_USEDEP}]
		dev-python/python-gnupg[${PYTHON_USEDEP}]
		dev-python/regex[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/segno[${PYTHON_USEDEP}]
		dev-python/toolz[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/typing-inspection[${PYTHON_USEDEP}]
		dev-python/ujson[${PYTHON_USEDEP}]
		dev-python/urllib3[${PYTHON_USEDEP}]
		dev-python/websocket-client[${PYTHON_USEDEP}]
		dev-python/websockets[${PYTHON_USEDEP}]
		dev-python/yarl[${PYTHON_USEDEP}]
		simulate? ( dev-python/sortedcontainers[${PYTHON_USEDEP}] )
		qr? (
			dev-python/cbor2[${PYTHON_USEDEP}]
			dev-python/pyside[multimedia,${PYTHON_USEDEP}]
		)
		frame? ( dev-python/cryptography[${PYTHON_USEDEP}] )
		falkon? ( dev-python/pyside[webchannel,webengine,${PYTHON_USEDEP}] )
	')
	helios? ( net-p2p/helios-bin )
	falkon? ( www-client/falkon )
"

# Build backends for the offline from-source vendoring (--no-build-isolation).
BDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/setuptools-scm[${PYTHON_USEDEP}]
		qr? (
			dev-python/scikit-build-core[${PYTHON_USEDEP}]
			dev-python/nanobind[${PYTHON_USEDEP}]
		)
	')
	qr? (
		dev-build/cmake
		dev-build/ninja
	)
	chromium? ( app-arch/unzip )
"

# Only the qeth tarball is unpacked; the vendored sdists/wheels stay in
# ${DISTDIR} and are pip-installed offline from there.
src_unpack() {
	unpack "${P}.tar.gz"
}

src_configure() { :; }
src_compile() { :; }

src_install() {
	# The private vendored-dependency tree ($(get_libdir) is only callable in a
	# phase function, not global scope).
	local VENDOR="/usr/$(get_libdir)/${PN}/vendor"

	# cytoolz's build backend is the one tool not in ::gentoo — stage its wheel
	# so --no-build-isolation finds it offline.
	local bt="${T}/buildtools"
	"${EPYTHON}" -m pip install --no-index --no-cache-dir --no-deps \
		--target="${bt}" \
		"${DISTDIR}/setuptools_git_versioning-3.1.0-py3-none-any.whl" \
		|| die "staging build backend failed"

	# The vendored distfiles per USE (basenames live in ${DISTDIR}).
	local vend=(
		bleak-3.0.2-py3-none-any.whl ckzg-2.1.8.tar.gz cytoolz-1.1.0.tar.gz
		ECPy-1.2.5.tar.gz eth_abi-5.2.0.tar.gz eth_account-0.13.7.tar.gz
		eth_hash-0.8.0.tar.gz eth_keyfile-0.8.1.tar.gz eth_keys-0.7.0.tar.gz
		eth_rlp-2.2.0.tar.gz eth_typing-6.0.0.tar.gz eth_utils-5.3.1.tar.gz
		future-1.0.0.tar.gz hexbytes-1.3.1.tar.gz ledgerblue-0.1.48.tar.gz
		ledgereth-0.10.0.tar.gz ndeflib-0.3.3.tar.gz nfcpy-1.0.4.tar.gz
		parsimonious-0.10.0.tar.gz pycryptodomex-3.23.0.tar.gz
		python-u2flib-host-3.0.3.tar.gz pyunormalize-17.0.0.tar.gz
		rlp-4.0.1.tar.gz web3-7.16.0.tar.gz
	)
	use simulate && vend+=(
		cached_property-2.0.1.tar.gz eth_bloom-3.1.0.tar.gz lru_dict-1.4.1.tar.gz
		py_ecc-8.0.0.tar.gz py_evm-0.12.1b1.tar.gz trie-3.1.0.tar.gz
	)
	use qr && vend+=( zxing_cpp-3.1.0.tar.gz )

	# qeth itself + the vendored eth stack, compiled from source, into a private
	# tree off the default sys.path. --no-deps keeps the set to the resolved
	# closure (the RDEPENDs above satisfy the rest at runtime); a guard below
	# fails if PySide6 ever leaks in (it MUST come from the system).
	PYTHONPATH="${bt}${PYTHONPATH:+:${PYTHONPATH}}" \
	"${EPYTHON}" -m pip install --no-index --no-build-isolation --no-deps \
		--no-cache-dir --no-warn-script-location \
		--target="${ED}${VENDOR}" \
		"${S}" "${vend[@]/#/${DISTDIR}/}" \
		|| die "offline from-source vendoring failed"

	if [[ -d ${ED}${VENDOR}/PySide6 ]]; then
		die "PySide6 leaked into the vendored tree — it must come from the system"
	fi
	# The wrapper runs `python -m qeth`; the pip console-script/bin/ is unused.
	rm -rf "${ED}${VENDOR}"/bin || die

	# Launcher: system python + the vendor tree on PYTHONPATH.
	sed -e "s|@EPYTHON@|${EPYTHON}|" -e "s|@VENDOR@|${VENDOR}|" \
		"${FILESDIR}"/qeth.launcher > "${T}"/qeth || die
	dobin "${T}"/qeth

	# Desktop integration (Exec=qeth; StartupWMClass=qeth). App id kept as
	# io.github.michwill.qeth (a stable identity, independent of the repo owner).
	domenu dist/flatpak/io.github.michwill.qeth.desktop
	newicon -s scalable qeth/assets/logos/qeth-icon-rounded.svg \
		io.github.michwill.qeth.svg
	insinto /usr/share/metainfo
	doins dist/flatpak/io.github.michwill.qeth.metainfo.xml

	# Falkon connector plugin (a Python plugin Falkon loads from its plugin dir).
	if use falkon; then
		insinto /usr/$(get_libdir)/qt6/plugins/falkon/qeth_connector
		local fk=extensions/falkon/qeth_connector
		doins "${fk}"/__init__.py "${fk}"/bridge.py "${fk}"/toolbar.py \
			"${fk}"/settings.py "${fk}"/probe.py "${fk}"/provider.js \
			"${fk}"/relay.js "${fk}"/qeth-icon.svg "${fk}"/metadata.desktop
	fi

	# Chrome extension: ship the packaged zip + an unpacked dir to load.
	if use chromium; then
		insinto /usr/share/${PN}/extensions/chrome
		doins extensions/chrome/${PN}-${PV}-chrome.zip
		mkdir -p "${T}"/chrome-unpacked || die
		unzip -q extensions/chrome/${PN}-${PV}-chrome.zip \
			-d "${T}"/chrome-unpacked || die
		insinto /usr/share/${PN}/extensions/chrome/unpacked
		doins -r "${T}"/chrome-unpacked/.
	fi

	# Firefox extension: the signed .xpi, plus an auto-drop so Firefox offers it.
	if use firefox; then
		insinto /usr/share/${PN}/extensions/firefox
		doins extensions/firefox/${PN}-${PV}.xpi
		insinto "/usr/$(get_libdir)/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
		newins extensions/firefox/${PN}-${PV}.xpi wallet@qeth.eth.xpi
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "Config, encrypted keystores and caches live under ~/.qeth."
	if use helios; then
		elog "Verified (light-client) reads use net-p2p/helios-bin, auto-detected on PATH."
		use simulate || elog "  (tx-preview verification also needs USE=simulate.)"
	fi
	if use falkon; then
		elog "Falkon: enable 'qeth connector' in Falkon -> Preferences -> Extensions."
	fi
	if use chromium; then
		elog "Chrome: chrome://extensions -> Developer mode -> Load unpacked ->"
		elog "  /usr/share/${PN}/extensions/chrome/unpacked"
	fi
	if use firefox; then
		elog "Firefox should offer the qeth add-on (wallet@qeth.eth); otherwise"
		elog "  about:addons -> Install Add-on From File -> the .xpi under"
		elog "  /usr/share/${PN}/extensions/firefox/"
	fi
}
