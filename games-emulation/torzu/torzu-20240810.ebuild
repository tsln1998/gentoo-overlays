# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 toolchain-funcs xdg

DESCRIPTION="An emulator for Nintendo Switch"
HOMEPAGE="https://torzu.dev"
EGIT_REPO_URI="https://notabug.org/litucks/torzu"
EGIT_BRANCH="master"
EGIT_COMMIT="0719273fedc38890ace9aa3f9b113ad131818483"
EGIT_SUBMODULES=(
	'-*'
	'xbyak'
	'cpp-httplib'
	'cpp-jwt'
	'tzdb_to_nx'
	'externals/nx_tzdb/tzdb_to_nx/externals/tz/tz'
	'simpleini'
	'oaknut'
	'externals/SPIRV-Headers'
	'externals/SPIRV-Tools'
	'externals/VulkanMemoryAllocator'
)

COMPATIBILITY_LIST_COMMIT_SHA="00709ad0aa83f174a09d567ed5a0b3a24d8a6817"

LICENSE="GPL2+"
SLOT="0"
KEYWORDS="amd64"
IUSE="qt5 qt6 sdl cubeb usb webengine +webservice test"

RDEPEND="
	<net-libs/mbedtls-3.1[cmac]
	>=app-arch/zstd-1.5
	>=dev-libs/inih-52
	>=dev-libs/libfmt-9:=
	>=dev-libs/openssl-1.1:=
	>=media-video/ffmpeg-4.3:=
	>=net-libs/enet-1.3
	app-arch/lz4:=
	dev-libs/boost:=[context]
	media-libs/opus
	media-libs/vulkan-loader
	sys-libs/zlib
	usb? (
		virtual/libusb:1
	)
	cubeb? (
		media-libs/cubeb
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		webengine? ( dev-qt/qtwebengine:5[widgets] )
	)
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
		webengine? ( dev-qt/qtwebengine:6[widgets] )
	)
	sdl? (
		media-libs/libsdl2
	)
"
DEPEND="${RDEPEND}
	>=dev-util/vulkan-headers-1.3.236
	>=dev-util/vulkan-utility-libraries-1.3.236
	test? ( <dev-cpp/catch-3:0 )
"
BDEPEND="
	>=dev-cpp/nlohmann_json-3.8.0
	dev-cpp/robin-map
	dev-util/glslang
"
REQUIRED_USE="|| ( qt6 sdl )"
RESTRICT="!test? ( test )"

pkg_setup() {
	if tc-is-gcc; then
		[[ "$(gcc-major-version)" -lt 11 ]] && \
			die "You need gcc version 11 or clang to compile this package"
	fi
}

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	# Disable errors
	sed -i -e '/Werror/d' src/CMakeLists.txt || die

	# Skip submodule downloading
	rm .gitmodules || die

	# Bypass ebuild version
	sed -i \
		-e "s/@GIT_BRANCH@/${EGIT_BRANCH:-master}/" \
		-e "s/@GIT_REV@/$(git rev-parse --short HEAD)/" \
		-e "s/@GIT_DESC@/$(git describe --always --long)/" \
		src/common/scm_rev.cpp.in || die

	# Unbundle mbedtls
	sed -i -e '/^# mbedtls/,/^endif()/d' externals/CMakeLists.txt || die
	sed -i -e 's/mbedtls/& mbedcrypto mbedx509/' \
		src/dedicated_room/CMakeLists.txt \
		src/core/CMakeLists.txt || die

	# Unbundle cubeb
	use cubeb && \
		sed -i '$afind_package(Threads REQUIRED)' CMakeLists.txt && \
		sed -i '/^if.*cubeb/,/^endif()/d' externals/CMakeLists.txt

	# Unbundle enet
	sed -i -e '/^if.*enet/,/^endif()/d' externals/CMakeLists.txt || die
	sed -i -e '/enet\/enet\.h/{s/"/</;s/"/>/}' src/network/network.cpp || die

	# Fix lz4
	sed -i 's/lz4::lz4/lz4/' src/common/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs=(
		-DENABLE_CUBEB=$(usex cubeb)
		-DENABLE_LIBUSB=$(usex usb)
		-DENABLE_QT=$(usex qt5 ON $(usex qt6))
		-DENABLE_QT_TRANSLATION=$(usex qt5 ON $(usex qt6))
		-DENABLE_QT6=$(usex qt6)
		-DENABLE_SDL2=$(usex sdl)
		-DENABLE_WEB_SERVICE=$(usex webservice)
		-DSPIRV-Headers_SOURCE_DIR="${WORKDIR}/${PF}/externals/SPIRV-Headers"
		-DYUZU_TESTS=$(usex test)
		-DYUZU_CHECK_SUBMODULES=OFF
		-DYUZU_USE_BUNDLED_SDL2=OFF
		-DYUZU_USE_EXTERNAL_SDL2=OFF
		-DYUZU_USE_EXTERNAL_VULKAN_HEADERS=OFF
		-DYUZU_USE_EXTERNAL_VULKAN_UTILITY_LIBRARIES=OFF
		-DYUZU_USE_QT_WEB_ENGINE=$(usex webengine)
	)

	cmake_src_configure
}
