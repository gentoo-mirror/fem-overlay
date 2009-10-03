
EAPI=2

inherit eutils java-pkg-2

DESCRIPTION="Nexus Maven Repository Server"

MY_P=${P/nexus/nexus-webapp}
SLOT="1"
SRC_URI="http://nexus.sonatype.org/downloads/${MY_P}-bundle.tar.gz"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

S=${WORKDIR}/${MY_P}

NEXUS_HOME=/usr/share/${PN}

pkg_setup() {
    java-pkg-2_pkg_setup
    enewgroup nexus
    enewuser nexus -1 -1 /bin/sh nexus
}

src_install() {
    cd "${S}/bin/jsw"
    case ${ARCH} in
	x86)   F_ARCH="linux-x86-32" ;;
	amd64) F_ARCH="linux-x86-64" ;;
	*) die "This ebuild doesn't support ${ARCH}." ;;
    esac
    ls | grep -v $F_ARCH | xargs rm -vR || die "remove failed"
    
    dodir ${NEXUS_HOME}
    
    diropts -m775 -o nexus -g nexus
    keepdir /etc/nexus
    keepdir /var/lib/nexus/
    keepdir /var/log/nexus/
    keepdir /var/run/nexus/
    keepdir /var/tmp/nexus/

    dosym /var/log/nexus ${NEXUS_HOME}/logs
    dosym /var/log/nexus /var/lib/nexus/logs
    dosym /etc/nexus ${NEXUS_HOME}/conf
    
    # zunaechst nur an localhost binden
    sed -i -e 's:application-host=0.0.0.0:application-host=127.0.0.1:' "${S}"/conf/plexus.properties
    # working-dir aendern
    sed -i -e 's:nexus-work=\${basedir}/../sonatype-work/nexus:nexus-work=/var/lib/nexus:' "${S}"/conf/plexus.properties
    
    cd "${S}"
    chown -R nexus:nexus bin/* lib/* runtime/*
    cp -pPR bin lib runtime "${D}${NEXUS_HOME}" || die "failed to copy runtime"
    cp -pPR conf/* "${D}/etc/nexus" || die "failed to copy conf"
    
    dosym /var/tmp/nexus /usr/share/nexus/runtime/tmp
    
    newinitd "${FILESDIR}"/1.3.6/nexus.init nexus
    
    elog "Nexus storage is /var/lib/nexus. Ensure that there is enough space."
    
    elog "The default password for user admin is admin123."

    ewarn "For security reasons nexus is bound to localhost."
    ewarn "Before binding to public ip or mapping with mod_jk, please change passwords."
}
