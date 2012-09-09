package M3U8;
use warnings;
use strict;
use WWW::Mechanize;
my $VERSION = '0.00';
my $cache = {
	manifest => [], #array of manifest file
	tags	 => [], #array of all tags
	};

sub new {
	my $class = shift;
	my $self = {};
	my ($manifest) = @_;
	if ( !defined $manifest ) { die 'Manifest not provided' };

	#check if m3u8 is a file or uri
	if ($manifest =~ m/http|https/) {
		my $mech = WWW::Mechanize->new( agent => 'Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120716 Firefox/15.0a2' );
		$mech->get( $manifest );
		for my $l ( split( /\n/, $mech->content ) ) {
			&process_line( $l );
		};
	undef $mech;
	undef $manifest;

	} else { 
		open my $FH, "<", $manifest;
		while ( <$FH> ) {
			&process_line( $_ );
			};
		};

	bless $self, $class;

	return $self;
};

sub process_line {
	my $line = shift;
	push @{ @$cache{ manifest } }, $line;
	
	if ( $line =~ m/#EXT/ ) {
		push @{ @$cache{ tags } }, $line;
	};
	if ( $line =~ /EXT-X-TARGETDURATION:(.*?)(\n)/ ) {
		$cache->{ targetduration } = $1;
	};
	if ( $line =~ /EXT-X-ENDLIST/ ) {
		$cache->{ end } = 1;
	};

	return 1;
};

sub get_playlist {
	my $self = shift;

	return @{ @$cache{ manifest } } ;
};

sub get_tags {
	my $self = shift;

	return @{ @$cache{ tags } };
};

sub get_target_duration {
	my $self = shift;

	return $cache->{ targetduration };
};

sub is_last_playlist {

	return $cache->{ end };
};


=head1 Overview
Module for fetching and working with M3U8 manifest files.
This is for individual manifests not multi-variant playlists (I may eventually create a module that builds on this)

=head2 new
	$m = Video::M3U8->new($url_or_filename)

If the string contains 'http', new() will fetch the contains from the web, if it does not, new will read from the file
and process the contents, the contents are read into a hash once. since its possible for playlists to be updated consistently,
the only time it is fetched is on 'new()', all other functions work from cache, each new manifest or seeking updates should 
be called again.

=head2 Get playlist

Function will return the entire manifest/playlist

	$m->get_playlist

=head2 Get tags
If you would just like to use the tags;

	$m->get_tags

=head2 Checking for the last playlist
If its an Ondemand playlist or the last in a Live stream (contains EXT-X-ENDLIST tag) this sub will return '1' (true)

	$m->is_last_playlist

=head2 Checking for target duration
Function will return the target duration

	$m->get_target_duration

=head1 AUTHORS

 Copyright (c) 2012
 cost: tell me about bugs or points to improve - have fun.
 Omar Salix, <osalix@gmail.com>
=cut
