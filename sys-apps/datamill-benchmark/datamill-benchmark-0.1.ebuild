# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils

DESCRIPTION="This is the ebuild for the worker side of the eval-lab project."
HOMEPAGE="http://mini.resl.uwaterloo.ca"
SRC_URI="ftp://mini.resl.uwaterloo.ca/datamill-worker-${PV}.tar.gz"
# Add license later
# LICENSE=""
SLOT="0"
KEYWORDS="x86 amd64"
RDEPEND=">=dev-python/pyyaml-3.09
         >=dev-util/perf-3.2
         >=sys-process/time-1.7-r1"

S="${WORKDIR}/datamill-worker-${PV}"

src_install() {
    # TODO: Change these so that they use more official locations

    dodir /update-staging/
    ewarn "copying from ${S} to ${D}"
    cp -R "${S}/"* "${D}/update-staging/" || die "Install failed!"
    
    dodir /etc/local.d/
    cp    "${S}/benchmark/"*.start               "${D}/etc/local.d/"
    cp    "${S}/benchmark/wrap.sh"               "${D}/"
    cp    "${S}/benchmark/handle_config.py"      "${D}/"
    cp    "${S}/benchmark/benchmark_environment" "${D}/"
    cp -R "${S}/benchmark/gcc-wrapper"           "${D}/"
    
    # BOOTLOADER SCRIPTS

    local DETECTED_ARCH=$(uname -m)
    if [[ $DETECTED_ARCH = arm* ]]
    then
        cp "${S}/controller/uboot_set_control_boot.sh" "${D}/set_control_boot.sh"
    elif [[ $DETECTED_ARCH = ppc* ]]
    then
        cp "${S}/controller/ppc_set_control_boot.sh"   "${D}/set_control_boot.sh"
    elif [[ $DETECTED_ARCH = sparc* ]]
    then
        cp "${S}/controller/sparc_set_control_boot.sh" "${D}/set_control_boot.sh"
    else # DEFAULT TO GRUB
        cp "${S}/controller/grub_set_control_boot.sh"  "${D}/set_control_boot.sh"
    fi

}
