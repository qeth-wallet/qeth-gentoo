# Copyright 2026 Michael Egorov
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream's Release type turns off nchat's lock-ownership assertions
# (nc_assert in uimodel.h), which abort the app when they fire.
CMAKE_BUILD_TYPE=Release
# Go is only needed for WhatsApp, so the go-module phases are wired up by hand.
GO_OPTIONAL=1

inherit cmake flag-o-matic go-module optfeature

# Module list of lib/wmchat/go/go.sum (the WhatsApp/whatsmeow Go tree).
# Regenerate on a bump:
#   awk '{printf "\t\"%s %s\"\n", $1, $2}' lib/wmchat/go/go.sum
EGO_SUM=(
	"filippo.io/edwards25519 v1.2.0"
	"filippo.io/edwards25519 v1.2.0/go.mod"
	"github.com/DATA-DOG/go-sqlmock v1.5.2"
	"github.com/DATA-DOG/go-sqlmock v1.5.2/go.mod"
	"github.com/agnivade/levenshtein v1.2.1"
	"github.com/agnivade/levenshtein v1.2.1/go.mod"
	"github.com/andreyvit/diff v0.0.0-20170406064948-c7f18ee00883"
	"github.com/andreyvit/diff v0.0.0-20170406064948-c7f18ee00883/go.mod"
	"github.com/beeper/argo-go v1.1.2"
	"github.com/beeper/argo-go v1.1.2/go.mod"
	"github.com/coder/websocket v1.8.15"
	"github.com/coder/websocket v1.8.15/go.mod"
	"github.com/elliotchance/orderedmap/v3 v3.1.0"
	"github.com/elliotchance/orderedmap/v3 v3.1.0/go.mod"
	"github.com/google/go-cmp v0.7.0"
	"github.com/google/go-cmp v0.7.0/go.mod"
	"github.com/google/uuid v1.6.0"
	"github.com/google/uuid v1.6.0/go.mod"
	"github.com/mattn/go-colorable v0.1.14"
	"github.com/mattn/go-colorable v0.1.14/go.mod"
	"github.com/mattn/go-isatty v0.0.20"
	"github.com/mattn/go-isatty v0.0.20/go.mod"
	"github.com/mattn/go-sqlite3 v1.14.52"
	"github.com/mattn/go-sqlite3 v1.14.52/go.mod"
	"github.com/mdp/qrterminal v1.0.1"
	"github.com/mdp/qrterminal v1.0.1/go.mod"
	"github.com/petermattis/goid v0.0.0-20260820044319-269ab09b5261"
	"github.com/petermattis/goid v0.0.0-20260820044319-269ab09b5261/go.mod"
	"github.com/rs/zerolog v1.35.1"
	"github.com/rs/zerolog v1.35.1/go.mod"
	"github.com/sergi/go-diff v1.3.1"
	"github.com/sergi/go-diff v1.3.1/go.mod"
	"github.com/skip2/go-qrcode v0.0.0-20200617195104-da1b6568686e"
	"github.com/skip2/go-qrcode v0.0.0-20200617195104-da1b6568686e/go.mod"
	"github.com/stretchr/testify v1.12.0"
	"github.com/stretchr/testify v1.12.0/go.mod"
	"github.com/vektah/gqlparser/v2 v2.5.27"
	"github.com/vektah/gqlparser/v2 v2.5.27/go.mod"
	"go.mau.fi/libsignal v0.2.2"
	"go.mau.fi/libsignal v0.2.2/go.mod"
	"go.mau.fi/util v0.10.1"
	"go.mau.fi/util v0.10.1/go.mod"
	"golang.org/x/crypto v0.57.0"
	"golang.org/x/crypto v0.57.0/go.mod"
	"golang.org/x/exp v0.0.0-20260908205506-85c1c2202aba"
	"golang.org/x/exp v0.0.0-20260908205506-85c1c2202aba/go.mod"
	"golang.org/x/net v0.59.0"
	"golang.org/x/net v0.59.0/go.mod"
	"golang.org/x/sync v0.23.0"
	"golang.org/x/sync v0.23.0/go.mod"
	"golang.org/x/sys v0.6.0/go.mod"
	"golang.org/x/sys v0.48.0"
	"golang.org/x/sys v0.48.0/go.mod"
	"golang.org/x/text v0.42.0"
	"golang.org/x/text v0.42.0/go.mod"
	"google.golang.org/protobuf v1.36.12"
	"google.golang.org/protobuf v1.36.12/go.mod"
	"gopkg.in/yaml.v3 v3.0.1"
	"gopkg.in/yaml.v3 v3.0.1/go.mod"
	"rsc.io/qr v0.2.0"
	"rsc.io/qr v0.2.0/go.mod"
)
go-module_set_globals

DESCRIPTION="Terminal-based chat client with support for Telegram and WhatsApp"
HOMEPAGE="https://github.com/d99kris/nchat"
SRC_URI="https://github.com/d99kris/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	whatsapp? ( ${EGO_SUM_SRC_URI} )"

# nchat: MIT. Bundled in lib/ncutil/ext: apathy, clip, QR-Code-generator,
# sqlite_modern_cpp (MIT), cereal (BSD), stb (MIT or Unlicense).
# Telegram: the bundled tdlib (Boost-1.0).
# WhatsApp: whatsmeow and go.mau.fi/util (MPL-2.0), go.mau.fi/libsignal
# (GPL-3, so the WhatsApp-enabled binary as a whole is GPL-3), and the Go
# module tree (BSD, MIT, ISC, Apache-2.0).
LICENSE="MIT BSD || ( MIT Unlicense )
	telegram? ( Boost-1.0 )
	whatsapp? ( Apache-2.0 BSD GPL-3 ISC MIT MPL-2.0 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+telegram test +whatsapp X"
REQUIRED_USE="|| ( telegram whatsapp )"
RESTRICT="!test? ( test )"

# libpng: image copy/paste through the clipboard (X11 and Wayland).
# libxcb: the built-in X11 clipboard; without it, nchat uses wl-clipboard on
# Wayland or the clipboard_*_command settings in app.conf.
RDEPEND="
	dev-db/sqlite:3
	media-libs/libpng:=
	sys-apps/file
	sys-libs/ncurses:=
	telegram? (
		dev-libs/openssl:=
		virtual/zlib:=
	)
	X? ( x11-libs/libxcb:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	telegram? ( dev-util/gperf )
	whatsapp? ( >=dev-lang/go-1.26.0:= )
"

src_unpack() {
	if use whatsapp; then
		# Sets up the local GOPROXY from EGO_SUM. Its trailing 'go mod tidy'
		# check runs in ${S}, which has no go.mod (the module is in
		# lib/wmchat/go), so the "go.mod file not found" it prints is harmless.
		go-module_src_unpack
	else
		default
	fi
}

src_prepare() {
	# Install the license notices into Gentoo's docdir, not share/doc/nchat.
	sed -i "s|doc/nchat|doc/${PF}|" CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	# Upstream's Release flags (-O3 -DNDEBUG) are blanked by cmake.eclass in
	# favour of CFLAGS; keep the NDEBUG half so the bundled tdlib is built
	# without its debug assertions, as upstream ships it.
	append-cppflags -DNDEBUG

	local mycmakeargs=(
		# The protocol libraries (libtgchat, libwmchat, plus their helpers
		# libncutil and libtdclientshared) are unversioned and private to
		# nchat. nchat dlopen()s them from <bindir>/../<libdir>, and that same
		# path becomes the RPATH, so a private libdir keeps them out of
		# /usr/lib64.
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)/${PN}"
		# cmake.eclass defaults this to ON, which turns the bundled clip
		# (declared without STATIC) into an uninstalled libclip.so that
		# libncutil then needs. nchat's own libraries are explicitly SHARED.
		-DBUILD_SHARED_LIBS=OFF
		-DNCHAT_BUILD_ORIGIN=gentoo
		-DHAS_DUMMY=OFF
		-DHAS_SIGNAL=OFF
		-DHAS_TELEGRAM=$(usex telegram)
		-DHAS_WHATSAPP=$(usex whatsapp)
		-DHAS_TESTS=$(usex test)
	)
	# The X11 clipboard is enabled by a check_include_files() probe for
	# xcb/xcb.h; presetting its result skips the probe.
	use X || mycmakeargs+=( -DHAVE_XCB_XLIB_H=OFF )

	if use whatsapp; then
		# Link go-sqlite3 against the system libsqlite3 (libncutil already
		# does, and passes -lsqlite3 on to libwmchat) instead of compiling
		# its bundled amalgamation into libwmchat.
		mycmakeargs+=( -DCMAKE_GO_FLAGS=-tags=libsqlite3 )
	fi

	cmake_src_configure
}

src_compile() {
	# Export CGO_CFLAGS & co. for the go build that CMake runs.
	use whatsapp && go-env_set_compile_environment
	cmake_src_compile
}

src_install() {
	cmake_src_install
	# The license itself is covered by LICENSE= above; keep only the
	# third-party notices.
	rm "${ED}/usr/share/doc/${PF}/LICENSE" || die
}

pkg_postinst() {
	optfeature "opening links and attachments" x11-misc/xdg-utils
	optfeature "desktop notifications" x11-libs/libnotify
	optfeature "the clipboard on Wayland" gui-apps/wl-clipboard

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Set up an account with: nchat --setup"
		elog "WhatsApp and Telegram profiles are stored under ~/.config/nchat."
	fi
}
