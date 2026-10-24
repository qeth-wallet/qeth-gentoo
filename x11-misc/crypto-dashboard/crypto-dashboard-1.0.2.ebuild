# Copyright 2026 Michael Egorov
# Distributed under the terms of the GNU General Public License v3

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit desktop distutils-r1 xdg

DESCRIPTION="Real-time cryptocurrency dashboard with candlestick charts"
HOMEPAGE="https://github.com/michwill/crypto-dashboard"
SRC_URI="https://github.com/michwill/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

# PyQt6 is intentionally NOT a project dependency (it's expected from the system
# so the app uses the desktop's Qt build); declared here as a Gentoo atom.
# QtGui/QtWidgets are imported directly; the chart uses an OpenGL viewport
# when GL works (QtOpenGLWidgets is imported unconditionally, with a software
# fallback) and a scalable SVG icon is rendered via QIcon, hence the opengl +
# svg flags. pyqtgraph's pyqt6 dep USE-matches pyqt6's opengl/svg, so enable
# them on pyqtgraph too. (pyqtgraph 0.14.0-r1 replaced its qt6 flag with
# per-binding pyqt6/pyside6 flags.)
RDEPEND="
	dev-python/pyqt6[gui,opengl,svg,widgets,${PYTHON_USEDEP}]
	dev-python/pyqtgraph[opengl,pyqt6,svg,${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/websocket-client[${PYTHON_USEDEP}]
	dev-python/platformdirs[${PYTHON_USEDEP}]
"

src_install() {
	distutils-r1_src_install

	# Desktop integration. The .desktop has Exec=crypto-dashboard (the entry
	# point the wheel installs to /usr/bin) and Icon=crypto-dashboard; the SVG
	# is named to match so QIcon.fromTheme("crypto-dashboard") resolves.
	domenu data/crypto-dashboard.desktop
	doicon -s scalable data/icons/hicolor/scalable/apps/crypto-dashboard.svg
}
