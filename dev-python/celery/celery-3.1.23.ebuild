# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1 bash-completion-r1

DESCRIPTION="Asynchronous task queue/job queue based on distributed message passing"
HOMEPAGE="http://celeryproject.org/ https://pypi.python.org/pypi/celery"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# There are a number of other optional 'extras' which overlap with those of kombu, however
# there has been no apparent expression of interest or demand by users for them. See requires.txt
IUSE="doc examples redis sqs test yaml zeromq"

RDEPEND="
	<dev-python/kombu-3.1[${PYTHON_USEDEP}]
	>=dev-python/kombu-3.0.33[${PYTHON_USEDEP}]
	>=dev-python/anyjson-0.3.3[${PYTHON_USEDEP}]
	>=dev-python/billiard-3.3.0.22[${PYTHON_USEDEP}]
	<dev-python/billiard-3.4[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/gevent[$(python_gen_usedep python2_7)]
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		dev-python/nose-cover3[${PYTHON_USEDEP}]
		>=dev-python/pymongo-2.6.2[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/redis-py[${PYTHON_USEDEP}]
		>=dev-db/redis-2.8.0
		>=dev-python/boto-2.13.3[${PYTHON_USEDEP}]
		>=dev-python/pyzmq-13.1.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		)"

PATCHES=(
	"${FILESDIR}"/celery-docs.patch
	"${FILESDIR}"/${PN}-3.1.19-test.patch
)

# testsuite needs it own source
DISTUTILS_IN_SOURCE_BUILD=1

python_compile_all() {
	if use doc; then
		mkdir docs/.build || die
		emake -C docs html
	fi
}

python_test() {
	nosetests --verbose || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	# Main celeryd init.d and conf.d
	newinitd "${FILESDIR}/celery.initd-r2" celery
	newconfd "${FILESDIR}/celery.confd-r2" celery

	use examples && local EXAMPLES=( examples/. )

	use doc && local HTML_DOCS=( docs/.build/html/. )

	newbashcomp extra/bash-completion/celery.bash ${PN}

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "auth support" dev-python/pyopenssl
	optfeature "beanstalk support" dev-python/beanstalkc
	optfeature "cassandra support" dev-python/cassandra-driver
#	optfeature "consul support" dev-python/python-consul
#	optfeature "couchbase support" dev-python/couchbase
#	optfeature "couchdb support" dev-python/pycouchdb
	optfeature "elasticsearch support" dev-python/elasticsearch-py
	optfeature "eventlet support" dev-python/eventlet
	optfeature "gevent support" dev-python/gevent
#	optfeature "librabbitmq support" '>=dev-python/librabbitmq-1.5.0'
	optfeature "memcache support" dev-python/pylibmc
	optfeature "mongodb support" '>=dev-python/pymongo-2.6.2'
	optfeature "msgpack support" '>=dev-python/msgpack-0.3.0'
	optfeature "pymemcache support" dev-python/python-memcached
	optfeature "pyro support" dev-python/pyro:4
	optfeature "redis support" '>=dev-python/redis-py-2.8.0'
#	optfeature "riak support" '>=dev-python/riak-2.0'
#	optfeature "slmq support" '>=dev-python/softlayer_messaging-1.0.3'
	optfeature "sqlalchemy support" dev-python/sqlalchemy
	optfeature "sqs support" '>=dev-python/boto-2.13.3'
#	optfeature "tblib support" '>=dev-python/tblib-1.3.0'
#	optfeature "threads support" dev-python/threadpool
	optfeature "yaml support" '>=dev-python/pyyaml-3.10'
	optfeature "zeromq support" '>=dev-python/pyzmq-13.1.0'
	optfeature "zookeper support" '>=dev-python/kazoo-1.3.1'
}
