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
KEYWORDS="~x86 amd64"
RDEPEND=">=dev-python/pyyaml-3.09"

S="${WORKDIR}/datamill-worker-${PV}"

src_install() {
    # TODO: Change these so that they use more official locations

    dodir /update-staging/
    ewarn "copying from ${S} to ${D}"
    cp -R "${S}/"* "${D}/update-staging/" || die "Install failed!"
    
    dodir /eval-lab/
    cp    "${S}/controller/"*.pl          "${D}/eval-lab/"
    cp -R "${S}/controller/EvalLab/"      "${D}/eval-lab/"
    cp    "${S}/controller/run_benchmark" "${D}/eval-lab/"

    local DETECTED_ARCH=$(uname -m)
    if [[ $DETECTED_ARCH = arm* ]]
    then
        cp "${S}/controller/uboot_set_bench_boot.sh"   "${D}/eval-lab/set_bench_boot.sh"
        cp "${S}/controller/uboot_set_control_boot.sh" "${D}/eval-lab/set_control_boot.sh"
    elif [[ $DETECTED_ARCH = ppc* ]]
    then
        cp "${S}/controller/ppc_set_bench_boot.sh"     "${D}/eval-lab/set_bench_boot.sh"
        cp "${S}/controller/ppc_set_control_boot.sh"   "${D}/eval-lab/set_control_boot.sh"
    elif [[ $DETECTED_ARCH = sparc* ]]
    then
        cp "${S}/controller/sparc_set_bench_boot.sh"   "${D}/eval-lab/set_bench_boot.sh"
        cp "${S}/controller/sparc_set_control_boot.sh" "${D}/eval-lab/set_control_boot.sh"
    else # DEFAULT TO GRUB
        cp "${S}/controller/grub_set_bench_boot.sh"    "${D}/eval-lab/set_bench_boot.sh"
        cp "${S}/controller/grub_set_control_boot.sh"  "${D}/eval-lab/set_control_boot.sh"
    fi
    

    cp "${S}/controller/remerge_packages.sh"    "${D}/eval-lab/"
    cp "${S}/controller/worker.py"              "${D}/eval-lab/"
    cp "${S}/controller/handle_ini.py"          "${D}/eval-lab/"
    cp "${S}/controller/controller_environment" "${D}/eval-lab/"
    cp "${S}/controller/"*.ini                  "${D}/eval-lab/"

    dodir /etc/local.d/
    cp "${S}/controller/"*.start "${D}/etc/local.d/"
    dodir /packages/
    
}
