#!/usr/bin/perl

### HOW TO COMPILE TO EXE (FOR M$-WINDOWS USERS WITHOUT PERL INSTALLED (NEARLY ALL)):
###pp --gui -o FauxdaciousLyricsHelper.exe -M utf8_heavy.pl -M lyrichelper_modules -l libeay32_.dll -l zlib1_.dll -l ssleay32_.dll FauxdaciousLyricsHelper.pl

###(lyrichelper_modules.pm contains):
###use Lyrics::Fetcher;
###use Lyrics::Fetcher::ApiLyricsOph;
###use Lyrics::Fetcher::AZLyrics;
###use Lyrics::Fetcher::Genius;
###use Lyrics::Fetcher::Musixmatch;
###1;

#FAUXDACIOUS "HELPER" SCRIPT TO FETCH Lyrics FROM sites supported by David Precious's Lyrics::Fetcher module:

#USAGE:  $0 artist title [configpath]

#NOTE:  SEE ALSO THE CONFIG (.ini) FILE: FauxdaciousLyricsHelper.ini in /contrib/, 
#       MOVE OVER TO ~/.config/fauxdacious[_instancename]/ AND EDIT TO SUIT YOUR NEEDS!

#CONFIGURE:  ~/.config/fauxdacious[_instancename]/config:  [audacious].lyrics_helper=FauxdaciousLyricsHelper.pl

#THIS SCRIPT ATTEMPTS TO FETCH THE LYRICS FOR THE CURRENT SONG PLAYING IN FAUXDACIOUS FOR THE NEW
#"PURE PERL" VERSIONS OF THE LYRICWIKI PLUGINS USING A VERIETY OF LYRICS SITES (SUPPORTD BY PERL'S
#Lyrics::Fetcher::* MODULES).  SITE CHANGES ARE NOW MAINTAINED THERE.  THIS REPLACES THE HARDCODED
#USE OF THE SINGLE SITE: https://lyrics.fandom.com/ (NOW DEFUNCT) FROM AUDACIOUS.
#SUPPORTED LYRICS SITES ARE TRIED IN RANDOM ORDER TO REDUCE EXCESS ACTIVITY ON ANY ONE SITE.
#NEW SITES CAN BE ADDED BY UPDATES TO Lyrics::Fetcher RATHER THAN HAVING TO UPDATE C CODE AND
#REBUILDNG FAUXDACIOUS!

#===================================================================================================

#STRIP OUT INC PATHS USED IN COMPILATION - COMPILER PUTS EVERYTING IN IT'S OWN
#TEMPORARY PATH AND WE DONT WANT THE RUN-TIME PHISHING AROUND THE USER'S LOCAL
#MACHINE FOR (POSSIBLY OLDER) INSTALLED PERL LIBS (IF HE HAS PERL INSTALLED)!
BEGIN
{
	$isExe = 1  if ($0 =~ /exe$/io);
	if ($isExe)
	{
		while (@INC)
		{
			$_ = shift(@INC);
			push (@myNewINC, $_)  if (/(?:cache|CODE)/o);
		}
		@INC = @myNewINC;
	}
	else
	{
		while (@INC)   #REMOVE THE "." DIRECTORY!
		{
			$_ = shift(@INC);
			push (@myNewINC, $_)  unless ($_ eq '.');
		}
		@INC = @myNewINC;
	}
}
use strict;
use warnings;
use Lyrics::Fetcher;

#USER: EDIT ~/.config/fauxdacious[_instancename]/FauxdaciousLyricsHelper.txt TO
#ADD STREAMING STATIONS THAT SWITCH BACK TO THEIR STATION TITLE NEAR END OF SONG BEFORE SWITCHING TO
#NEXT SONG IN ORDER TO AVOID RE-SEARCHING THE LYRICS SITES FOR LIKELY NON-EXISTANT "TITLE" EVERY SONG!
#FORMAT:  artist name|title name (one pair per line).

#YOU CAN ALSO ADD A USER-AGENT LINE TO SEND TO THE LYRICS SITES HERE:
#SEE Lyrics::Fetcher DOCS FOR THE DEFAULT USER-AGENT VALUE:
#(CURRENTLY:  "Mozilla/5.0 (X11; Linux x86_64; rv:80.0) Gecko/20100101 Firefox/80.0").
#FORMAT:  agent="user-agent string"
my @SKIPTHESE = ();
my $agent = '';

my $DEBUG = defined($ENV{'FAUXDACIOUS_DEBUG'}) ? $ENV{'FAUXDACIOUS_DEBUG'} : 0;

# To find out which fetchers are available:
my @fetchers = Lyrics::Fetcher->available_fetchers;

die "e:$0: No lyric fetchers found!\n"  unless ($#fetchers >= 0);
my $random_fetcher;

if ($#ARGV >= 1) {
	if ($ARGV[2] && -d $ARGV[2]) {
		## USER-CONFIGURED SITE-SKIP LIST:
		if (open IN, "<$ARGV[2]/FauxdaciousLyricsHelper.ini") {
			while (<IN>) {
				s/\r//go;
				chomp;
				next  if (/^\#/o);
				next  unless (/\S/o);
				s/^\s+//o;
				s/\,$//o;
				if (s/^agent\s*\=\s*[\'\"]?//o) {
					($agent = $_) =~ s/[\'\"]$//;
					next;
				}
				s/^[\'\"]//o;
				s/[\'\"]$//o;
				push @SKIPTHESE, $_;
			}
			close IN;
		}
	}

	for (my $a=0;$a<=$#ARGV;$a++) {  #STRIP QUOTES AROUND ARGUMENTS OFF (M$-Windows EXE)!:
		$ARGV[$a] =~ s/^[\'\"]//;
		$ARGV[$a] =~ s/[\'\"]$//;
	}

	unlink "$ARGV[2]/_tmp_lyrics.txt"  if ($ARGV[2] && -d $ARGV[2] && -f "$ARGV[2]/_tmp_lyrics.txt");
	print STDERR "..LYRICS HELPER:Args=".join('|', @ARGV)."=\n"  if ($DEBUG);
	foreach my $skipit (@SKIPTHESE) {
		print STDERR "-???- AT=$ARGV[0]|$ARGV[1]= SKIPIT=$skipit=\n"  if ($DEBUG > 1);
		if ("$ARGV[0]|$ARGV[1]" =~ /^\Q${skipit}\E$/i) {
			print STDERR "i:LYRICS HELPER: SKIPPING ($skipit) AS CONFIGURED.\n"  if ($DEBUG);
			exit (0);  #QUIT - WE KNOW THERE'S NO LYRICS TO FETCH FOR THE *STATION*!
		}
	}
	my %tried = ();
	my $triedcnt = 0;
	while ($triedcnt <= $#fetchers) {
		$random_fetcher = int(rand(scalar @fetchers));
		unless ($tried{$fetchers[$random_fetcher]}) {
			print STDERR "..LYRICS:TRYING $fetchers[$random_fetcher]...\n"  if ($DEBUG);
			my $lyrics = Lyrics::Fetcher->fetch($ARGV[0], $ARGV[1], $fetchers[$random_fetcher]);
			if ($lyrics) {
				my $doschar = ($^O =~ /Win/) ? "\r" : '';
				$lyrics .= "${doschar}\n(Lyrics courtesy: $fetchers[$random_fetcher])";
				if ($ARGV[2] && -d $ARGV[2] && open OUT, ">$ARGV[2]/_tmp_lyrics.txt") {
					binmode OUT;
					print OUT "${lyrics}\0";
					close OUT;
				} else {
					print STDERR $lyrics;
				}
				exit (0);
			}
			$tried{$fetchers[$random_fetcher]} = 1;
			++$triedcnt;
		}
	}
} else {
	print STDERR "..usage: $0 artist title [output_directory]\n";
}
