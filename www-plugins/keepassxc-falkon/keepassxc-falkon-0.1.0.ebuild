# Copyright 2026 Michael Egorov
# Distributed under the terms of the GNU General Public License v3

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit python-single-r1

DESCRIPTION="KeePassXC as the Falkon browser's password manager (fill, save, passkeys)"
HOMEPAGE="https://github.com/michwill/keepassxc-falkon"
SRC_URI="https://github.com/michwill/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# A Python plugin that Falkon loads into its embedded interpreter (PyFalkon),
# so it runs on Falkon's Python and PySide, never from site-packages.
# - PySide >= 6.8 for QWebEngineFrame (filling login forms inside iframes);
#   QtNetwork for the local socket to KeePassXC.
# - libsodium is loaded through ctypes for the browser protocol's crypto_box.
# - KeePassXC >= 2.7 with browser integration built in (USE=browser); the
#   plugin talks to it over that socket, no native-messaging host needed.
RDEPEND="
	${PYTHON_DEPS}
	>=app-admin/keepassxc-2.7.0[browser]
	dev-libs/libsodium
	www-client/falkon[python,${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/pyside-6.8:6[gui,network,webengine,widgets,${PYTHON_USEDEP}]
	')
"

src_install() {
	# Falkon finds system-wide Python plugins in its Qt plugin directory, next
	# to the bundled runaction and middleclickloader. Install the whole
	# package directory: besides the modules, the plugin loads fill.js,
	# passkeys.js, icon.svg and metadata.desktop from it.
	local plugdir=/usr/$(get_libdir)/qt6/plugins/falkon
	insinto "${plugdir}"
	doins -r keepassxc_falkon
	python_optimize "${ED}${plugdir}/keepassxc_falkon"

	einstalldocs
}

pkg_postinst() {
	elog "To use it:"
	elog "  1. In KeePassXC: Settings -> Browser Integration -> Enable browser integration."
	elog "  2. Restart Falkon completely (no falkon process left running)."
	elog "  3. Falkon: Preferences -> Extensions -> tick KeePassXC."
	elog "  4. Falkon: Preferences -> Passwords -> Backend: KeePassXC."
	elog "KeePassXC then asks you to name the new connection (one time)."
}
