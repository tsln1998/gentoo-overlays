# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A build system and monorepo management tool for the web ecosystem, written in Rust."
HOMEPAGE="https://moonrepo.dev/moon https://github.com/moonrepo/moon"

SRC_URI="
	amd64? ( https://github.com/moonrepo/moon/releases/download/v${PV}/moon-x86_64-unknown-linux-gnu -> ${P} )
	arm64? ( https://github.com/moonrepo/moon/releases/download/v${PV}/moon-aarch64-unknown-linux-gnu -> ${P} )
"

S="${DISTDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-util/proto-bin
"

src_install() {
	newbin ${P} moon
}
