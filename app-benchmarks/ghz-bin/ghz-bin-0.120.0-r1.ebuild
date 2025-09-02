# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple gRPC benchmarking and load testing tool"
HOMEPAGE="https://ghz.sh/ https://github.com/bojand/ghz"

SRC_URI="
	amd64? ( https://github.com/bojand/ghz/releases/download/v${PV}/ghz-linux-x86_64.tar.gz )
	arm64? ( https://github.com/bojand/ghz/releases/download/v${PV}/ghz-linux-arm64.tar.gz )
"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_install() {
	dobin ghz
}
