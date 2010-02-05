inherit subversion

ESVN_REPO_URI="http://pgrouting.postlbs.org/svn/pgrouting/tools/osm2pgrouting/trunk/"
ESVN_PROJECT="osm2pgrouting-snapshot"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-db/pgrouting-1.0.3"

src_install(){
    dobin osm2pgrouting
    insinto /usr/share/${PN}
    doins mapconfig.xml
    
    ewarn ""
    ewarn "To insert osm data into database:"
    ewarn ""
    ewarn "osm2pgrouting -file your-OSM-XML-File.osm -conf /usr/share/${PN}/mapconfig.xml -dbname routing -user postgres -clean"
    ewarn ""
}