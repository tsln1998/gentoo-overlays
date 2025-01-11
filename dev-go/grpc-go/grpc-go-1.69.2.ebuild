# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Protoc plugin that generates code for gRPC-Go clients"
HOMEPAGE="https://grpc.io https://github.com/grpc/grpc-go"
SRC_URI="https://github.com/grpc/grpc-go/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/tsln1998/gentoo-deps/releases/download/${P}/${P}-vendor.tar.xz"

S="${WORKDIR}/${P}/cmd/protoc-gen-go-grpc"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"

RDEPEND="dev-go/protobuf-go"
BDEPEND=">=dev-lang/go-1.22"

src_compile() {
	ego build
}

src_install() {
	dobin protoc-gen-go-grpc
}