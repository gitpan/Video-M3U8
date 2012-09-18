use 5.012004;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Video::M3U8',
    VERSION_FROM      => 'lib/Video/M3U8.pm', # finds $VERSION
    PREREQ_PM         => {
			'WWW::Mechanize'	=> '0',
		}, 
    AUTHOR		=> 'MRSLX (cpanplus-info@lists.sf.net)', 
	);
