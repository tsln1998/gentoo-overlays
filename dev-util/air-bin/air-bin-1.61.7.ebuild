# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Air is yet another live-reloading command line utility"
HOMEPAGE="https://github.com/air-verse/air"

SRC_URI="
	amd64? ( https://github.com/air-verse/air/releases/download/v${PV}/air_${PV}_linux_amd64 -> air )
	arm64? ( https://github.com/air-verse/air/releases/download/v${PV}/air_${PV}_linux_arm64 -> air )
"

S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_unpack() {
	cp "${DISTDIR}/air" "${S}/air" || die
}

src_install() {
	dobin air
}
