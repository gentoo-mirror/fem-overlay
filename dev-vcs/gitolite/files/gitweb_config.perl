###############################################################################
######################### BEGIN gitolite config ###############################

# --------------------------------------------
# Per-repo authorization based on gitolite ACL
# Include this in gitweb.conf
# See doc/3-faq-tips-etc.mkd for more info

# please note that the author does not have personal experience with gitweb
# and does not use it.  Some testing may be required.  Patches welcome but
# please make sure they are tested against a "github" version of gitolite
# and not an RPM or a DEB, for obvious reasons.

# HOME of the gitolite user
$ENV{HOME} = "/var/lib/gitolite";

# finally the user name
$ENV{GL_USER} = $cgi->remote_user || "gitweb";

# load gitolite
require Gitolite::Easy;  Gitolite::Easy->import;

$projects_list = "$ENV{HOME}/projects.list";
$projectroot = $ENV{GL_REPO_BASE};

$export_auth_hook = sub {
    my $repo = shift;

    # gitweb passes us the full repo path; so we strip the beginning
    # and the end, to get the repo name as it is specified in gitolite conf
    return unless $repo =~ s/^\Q$projectroot\E\/?(.+)\.git$/$1/;

    return can_read($repo);
};

#################### END gitolite config ########################
#################################################################