# Copyright 2026 Michael Egorov
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="helios"

DESCRIPTION="Trustless, efficient Ethereum light client (upstream prebuilt binary)"
HOMEPAGE="https://github.com/a16z/helios"
SRC_URI="https://github.com/a16z/${MY_PN}/releases/download/${PV}/${MY_PN}_linux_amd64.tar.gz
	-> ${P}-linux-amd64.tar.gz"
S="${WORKDIR}"

# helios is dual-licensed Apache-2.0 / MIT.
LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="-* ~amd64"
# Prebuilt dynamically-linked Rust binary: don't let portage strip it, and mark
# it so the prebuilt-binary QA check stays quiet.
RESTRICT="strip"
QA_PREBUILT="usr/bin/${MY_PN}"

RDEPEND="sys-libs/glibc"

src_install() {
	dobin "${MY_PN}"
}
