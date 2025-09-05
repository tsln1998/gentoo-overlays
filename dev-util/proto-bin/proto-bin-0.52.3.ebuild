# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A pluggable multi-language version manager."
HOMEPAGE="https://moonrepo.dev/proto https://github.com/moonrepo/proto"

SRC_URI="
	amd64? ( https://github.com/moonrepo/proto/releases/download/v${PV}/proto_cli-x86_64-unknown-linux-gnu.tar.xz )
	arm64? ( https://github.com/moonrepo/proto/releases/download/v${PV}/proto_cli-aarch64-unknown-linux-gnu.tar.xz )
"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_install() {
	(use amd64 && mv proto_cli-x86_64-unknown-linux-gnu dist) ||  \
	(use arm64 && mv proto_cli-aarch64-unknown-linux-gnu dist) || \
		die "Unsupported architecture"
	newbin dist/proto proto
}
