#!/usr/bin/perl
# Copyright 2026 Georg Pfuetzenreuter
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

use v5.26; ## no critic (ValuesAndExpressions::ProhibitVersionStrings)
use warnings;

use autodie qw(open close);
use feature qw(say);

use Env qw(IP4_NAMESERVERS IP6_NAMESERVERS);

my $action = $ARGV[1];

my $outfile = '/run/NetworkManager/unbound-forwarders.conf';
my $service = 'unbound';

sub write_unbound_forwarders {
	# TODO: maybe write some fallback if dhcp information is empty
	my @nameservers = split(' ', $IP4_NAMESERVERS . ' ' . $IP6_NAMESERVERS);

	return 0 unless @nameservers;

	open(my $fh, '>', $outfile);

	foreach my $nameserver (@nameservers) {
		$fh->say('forward-addr: ', $nameserver);
	}

	close($fh);

	return 1;
}

if ($action eq 'dhcp4-change' || $action eq 'dhcp6-change' || $action eq 'up') {
	say STDERR "Writing $outfile ...";
	if (write_unbound_forwarders) {
		system("unbound-control reload");
		# should the below be implied by reload?
		system("unbound-control flush_bogus");
		system("unbound-control flush_negative");
	}
}
