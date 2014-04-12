##############################################################################
TODO/IDEAS/KNOWN PROBLEMS:
- possibility to restore time frames (incl. deleted files)
  realizable by listing each backup and restore from 
  oldest to the newest, problem: not performant
- search file in all backups function and show available
  versions with backups date (list old avail since 0.6.06)
- edit profile opens conf file in vi 
- implement log-fd interpretation
- add a duplicity option check against the options pending 
  deprecation since 0.5.10 namely --time-separator
                             --short-filenames
                            --old-filenames
- add 'exclude_<command>' list usage eg. exclude_verify
- featreq 25: a download/install duplicity option
- hint on install software if a piece is missing
- import/export profile from/to .tgz function !!!


CHANGELOG:
1.7.3 (3.4.2014)
- bugfix: test routines, gpg2 asked for passphrase although GPG_PW was set

1.7.2 (1.4.2014 "April,April")
- bugfix: debian Bug#743190 "duply no longer allows restoration without 
   gpg passphrase in conf file"
   GPG_AGENT_INFO env var is now needed to trigger --use-agent
- bugfix: gpg keyenc test routines didn't work if GPG_PW was not set

1.7.1 (30.3.2014)
- bugfix: purge-* commands renamed to purgeFull, purgeIncr due to 
   incompatibility with new minus batch separator 

1.7.0 (20.3.2014)
- disabled gpg key id plausibility check, too many valid possibilities
- featreq 7 "Halt if precondition fails":
   added and(+), or(-) batch command(separator) support
- featreq 26 "pre/post script with shebang line": 
   if a script is flagged executable it's executed in a subshell 
   now as opposed to sourced to bash, which is the default
- bugfix: do not check if dpbx, swift credentials are set anymore 
- bugfix: properly escape profile name, archdir if used as arguments
- add DUPL_PRECMD conf setting for use with e.g. trickle

1.6.0 (1.1.2014)
- support gs backend
- support dropbox backend
- add gpg-agent support to gpg test routines
- autoenable --use-agent if passwords were not defined in config
- GPG_OPTS are now honored everywhere, keyrings or complete gpg
  homedir can thus be configured to be located anywhere
- always import both secret and public key if avail from config profile
- new explanatory comments in initial exclude file
- bugfix 7: Duply only imports one key at a time 

1.5.11 (19.07.2013)
- purge-incr command for remove-all-inc-of-but-n-full feature added
  patch provided by Moritz Augsburger, thanks!
- documented version command in man page

1.5.10 (26.03.2013)
- minor indent and documentation fixes
- bugfix: exclude filter failed on ubuntu, mawk w/o posix char class support
- bugfix: fix url_decoding generally and for python3
- bugfix 3609075: wrong script results in status line (thx David Epping)

1.5.9 (22.11.2012)
- bugfix 3588926: filter --exclude* params for restore/fetch ate too much
- restore/fetch now also ignores --include* or --exclude='foobar' 

1.5.8 (26.10.2012)
- bugfix 3575487: implement proper cloud files support

1.5.7 (10.06.2012)
- bugfix 3531450: Cannot use space in target URL (file:///) anymore

1.5.6 (24.5.2012)
- commands purge, purge-full have no default value anymore for security 
  reasons; instead max value can be given via cmd line or must be set
  in profile; else an error is shown.
- minor man page modifications

versioning scheme will be simplified to [major].[minor].[patch] version
with the next version raise

1.5.5.5 (4.2.2012)
- bugfix 3479605: SEL context confused profile folder's permission check
- colon ':' in url passphrase got ignored, added python driven url_decoding
  for user & pass to better process special chars

1.5.5.4 (16.10.2011)
- bugfix 3421268: SFTP passwords from conf ignored and always prompted for
- add support for separate sign passphrase (needs duplicity 0.6.14+)

1.5.5.3 (1.10.2011)
- bugfix 3416690: preview threw echo1 error
- fix unknown cmds error usage & friends if more than 2 params were given

1.5.5.2 (23.9.2011)
- bugfix 3409643: ssh key auth did ask for passphrase (--ssh-askpass ?)
- bugfix: mawk does not support \W and did not split multikey definitions
- all parameters should survive  single (') and double (") quotes now

1.5.5.1 (7.6.2011)
- featreq 3311881: add ftps as supported by duplicity 0.6.13 (thx mape2k)
- bugfix 3312208: signing detection broke symmetric gpg test routine

1.5.5 (2.5.2011)
- bugfix: fetch problem with space char in path, escape all params 
  containing non word chars
- list available profiles, if given profile cannot be found
- added --use-agent configuration hint
- bugfix 3174133: --exclude* params in conf DUPL_PARAMS broke 
  fetch/restore
- version command now prints out 'using installed' info
- featreq 3166169: autotrust imported keys, based on code submitted by 
  Martin Ellis - imported keys are now automagically trusted ultimately 
- new txt2man feature to create manpages for package maintainers

1.5.4.2 (6.1.2011)
- new command changelog
- bugfix 3109884: freebsd awk segfaulted on printf '%*', use print again
- bugfix: freebsd awk hangs on 'awk -W version' 
- bugfix 3150244: mawk does not know '--version'
- minor help text improvements
- new env vars CMD_PREV,CMD_NEXT replacing CMD env var for scripts

1.5.4.1 (4.12.2010)
- output awk, python, bash version now in prolog
- shebang uses /usr/bin/env now for freebsd compatibility, 
  bash not in /bin/bash 
- new --disable-encryption parameter, 
  to override profile encr settings for one run
- added exclude-if-present setting to conf template
- bug 3126972: GPG_PW only needed for signing/symmetric encryption 
  (even though duplicity still needs it)

1.5.4 (15.11.2010)
- as of 1.5.3 already, new ARCH_DIR config option
- multiple key support
- ftplicity-Feature Requests-2994929: separate encryption and signing key
- key signing of symmetric encryption possible (duplicity patch committed)
- gpg tests disable switch
- gpg tests now previewable and more intelligent

1.5.3 (1.11.2010)
- bugfix 3056628: improve busybox compatibility, grep did not have -m param
- bugfix 2995408: allow empty password for PGP key
- bugfix 2996459: Duply erroneously escapes '-' symbol in username
- url_encode function is now pythonized
- rsync uses FTP_PASSWORD now if duplicity 0.6.10+ , else issue warning
- feature 3059262: Make pre and post aware of parameters, 
                   internal parameters + CMD of pre or post 

1.5.2.3 (16.4.2010)
- bugfix: date again, should now work virtually anywhere

1.5.2.2 (3.4.2010)
- minor bugfix: duplicity 0.6.8b version string now parsable
- added INSTALL.txt

1.5.2.1 (23.3.2010)
- bugfix: date formatting is awked now and should work on all platforms

1.5.2 (2.3.2010)
- bugfix: errors print to STD_ERR now, failed tasks print an error message
- added --name=duply_<profile> for duplicity 0.6.01+ to name cache folder
- simplified & cleaned profileless commands, removed second instance
- generalized separator time routines
- added support for --no-encryption (GPG_KEY='disabled'), see conf examples
- minor fixes

1.5.1.5 (5.2.2010)
- bugfix: added special handling of credentials for rsync, imap(s)

1.5.1.4 (7.1.2010)
- bugfix: nsecs defaults now to zeroes if date does not deliver [0-9]{9}
- check if ncftp binary is available if url protocol is ftp
- bugfix: duplicity output is now printed to screen directly to resolve
          'mem alloc problem' bug report
- bugfix: passwords will not be in the url anymore to solve the 'duply shows
          sensitive data in process listing' bug report

1.5.1.3 (24.12.2009) 'merry xmas'
- bugfix: gpg pass now apostrophed to allow space and friends
- bugfix: credentials are now url encoded to allow special chars in them
          a note about url encoding has been added to the conf template

1.5.1.2 (1.11.2009)
- bugfix: open parenthesis in password broke duplicity execution
- bugfix: ssh/scp backend does not always need credentials e.g. key auth

1.5.1.1 (21.09.2009)
- bugfix: fixed s3[+http] TARGET_PASS not needed routine
- bugfix: TYPO in duply 1.5.1 prohibited the use of /etc/duply
  see https://sourceforge.net/tracker/index.php?func=detail&
              aid=2864410&group_id=217745&atid=1041147

1.5.1 (21.09.2009) - duply (fka. ftplicity)
- first things first: ftplicity (being able to support all backends since 
  some time) will be called duply (fka. ftplicity) from now on. The addendum
  is for the time being to circumvent confusion.
- bugfix: exit code is 1 (error) not 0 (success), if at least on duplicity 
          command failed
- s3[+http] now supported natively by translating user/pass to access_key/
  secret_key environment variables needed by duplicity s3 boto backend 
- bugfix: additional output lines do not confuse version check anymore
- list command supports now age parameter (patch by stefan on feature 
  request tracker)
- bugfix: option/param pairs are now correctly passed on to duplicity
- bugfix: s3[+http] needs no TARGET_PASS if command is read only

1.5.0.2 (31.07.1009)
- bugfix: insert password in target url didn't work with debian mawk
          related to previous bug report

1.5.0.1 (23.07.2009)
- bugfix: gawk gensub dependency raised an error on debian's default mawk
          replaced with match/substr command combination (bug report)
          https://sf.net/tracker/?func=detail&atid=1041147&aid=2825388&
          group_id=217745

1.5.0 (01.07.2009)
- removed ftp limitation, all duplicity backends should work now
- bugfix: date for separator failed on openwrt busybox date, added a 
  detecting workaround, milliseconds are not available w/ busybox date

1.4.2.1 (14.05.2009)
- bugfix: free temp space detection failed with lvm, fixed awk parse routine

1.4.2 (22.04.2009)
- gpg keys are now exported as gpgkey.[id].asc , the suffix reflects the
  armored ascii nature, the id helps if the key is switched for some reason
  im/export routines are updated accordingly (import is backward compatible 
  to the old profile/gpgkey files)         
- profile argument is treated as path if it contains slashes 
  (for details see usage)
- non-ftplicity options (all but --preview currently) are now passed 
  on to duplicity 
- removed need for stat in secure_conf, it is ls based now
- added profile folder readable check
- added gpg version & home info output
- awk utility availability is now checked, because it was mandatory already
- tmp space is now checked on writability and space requirement
  test fails on less than 25MB or configured $VOLSIZE, 
  test warns if there is less than two times $VOLSIZE because 
  that's required for --asynchronous-upload option  
- gpg functionality is tested now before executing duplicity 
  test drive contains encryption, decryption, comparison, cleanup
  this is meant to detect non trusted or other gpg errors early
- added possibility of doing symmetric encryption with duplicity
  set GPG_KEY="" or simply comment it out
- added hints in config template on the depreciation of 
  --short-filenames, --time-separator duplicity options

new versioning scheme 1.4.2b => 1.4.2, 
beta b's are replaced by a patch count number e.g. 1.4.2.1 will be assigned
to the first bug fixing version and 1.4.2.2 to the second and so on
also the releases will now have a release date formatted (Day.Month.Year)

1.4.1b1 - bugfix: ftplicity changed filesystem permission of a folder
          named exactly as the profile if existing in executing dir
        - improved plausibility checking of config and profile folder
        - secure_conf only acts if needed and prints a warning now

1.4.1b  - introduce status (duplicity collection-status) command
        - pre/post script output printed always now, not only on errors
        - new config parameter GPG_OPTS to pass gpg options
          added examples & comments to profile template conf
        - reworked separator times, added duration display
        - added --preview switch, to preview generated command lines
        - disabled MAX_AGE, MAX_FULL_BACKUPS, VERBOSITY in generated
          profiles because they have reasonable defaults now if not set

1.4.0b1 - bugfix: incr forces incremental backups on duplicity,
          therefore backup translates to pre_bkp_post now
        - bugfix: new command bkp, which represents duplicity's 
          default action (incr or full if full_if_older matches
          or no earlier backup chain is found)

new versioning scheme 1.4 => 1.4.0, added new minor revision number
this is meant to slow down the rapid version growing but still keep 
versions cleanly separated.
only additional features will raise the new minor revision number. 
all releases start as beta, each bugfix release will raise the beta 
count, usually new features arrive before a version 'ripes' to stable
  
1.4.0b
  1.4b  - added startup info on version, time, selected profile
        - added time output to separation lines
        - introduced: command purge-full implements duplicity's 
          remove-all-but-n-full functionality (patch by unknown),
          uses config variable $MAX_FULL_BACKUPS (default = 1)
        - purge config var $MAX_AGE defaults to 1M (month) now 
        - command full does not execute pre/post anymore
          use batch command pre_full_post if needed 
        - introduced batch mode cmd1_cmd2_etc
          (in turn removed the bvp command)
        - unknown/undefined command issues a warning/error now
        - bugfix: version check works with 0.4.2 and older now
  1.3b3 - introduced pre/post commands to execute/debug scripts
        - introduced bvp (backup, verify, purge)
        - bugfix: removed need for awk gensub, now mawk compatible
  1.3b2 - removed pre/post need executable bit set 
        - profiles now under ~/.ftplicity as folders
        - root can keep profiles in /etc/ftplicity, folder must be
          created by hand, existing profiles must be moved there
        - removed ftplicity in path requirement
        - bugfix: bash < v.3 did not know '=~'
        - bugfix: purge works again 
  1.3   - introduces multiple profiles support
        - modified some script errors/docs
        - reordered gpg key check import routine
        - added 'gpg key id not set' check
        - added error_gpg (adds how to setup gpg key howto)
        - bugfix: duplicity 0.4.4RC4+ parameter syntax changed
        - duplicity_version_check routine introduced
        - added time separator, shortnames, volsize, full_if_older 
          duplicity options to config file (inspired by stevie 
          from http://weareroot.de) 
  1.1.1 - bugfix: encryption reactivated
  1.1   - introduced config directory
  1.0   - first release
