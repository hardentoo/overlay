# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit distutils-r1 git-r3

DESCRIPTION="Command Line Interface Formulation Framework"
HOMEPAGE="https://github.com/dreamhost/cliff"
SRC_URI=''
EGIT_REPO_URI="https://git.openstack.org/openstack/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

CDEPEND=">=dev-python/pbr-1.6[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		>=dev-python/mock-1.2[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/httplib2-0.7.5[${PYTHON_USEDEP}] )
	doc? (
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		!~dev-python/oslo-sphinx-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/httplib2-0.7.5[${PYTHON_USEDEP}] )
	"
# source files stipulate <sphinx-1.3 however build effected perfectly with sphinx-1.3.1
RDEPEND="
	${CDEPEND}
	>=dev-python/cmd2-0.6.7[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7[${PYTHON_USEDEP}]
	<dev-python/prettytable-0.8[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/unicodecsv-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.1.0[${PYTHON_USEDEP}]
	"

python_prepare_all() {
	sed -i '/^argparse/d' requirements.txt || die
	distutils-r1_python_prepare_all
}

python_compile() {
	use doc && esetup.py build_sphinx
}

python_test() {
	nosetests ${PN}/tests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	distutils-r1_python_install_all
}
