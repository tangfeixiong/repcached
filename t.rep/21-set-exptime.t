#!/usr/bin/perl

use strict;
use Test::More qw(no_plan);
use FindBin qw($Bin);
use lib ("$Bin/lib", "$Bin/../t/lib");
use RepcachedTest;

my($m1, $m2) = new_repcached();
my($sock_m1, $sock_m2) = ($m1->sock, $m2->sock);

for my $sock ([$sock_m1, $sock_m2], [$sock_m2, $sock_m1]) {
    my($sock_m, $sock_b) = ($sock->[0], $sock->[1]);

    my $uniq = int(rand()*100000);
    my($key, $val) = ('settest'.$uniq, 'setval'.$uniq);
    my $vallen = length $val;

    my $exptime = 3;

    print $sock_m "set $key 0 $exptime $vallen\r\n$val\r\n";
    is(scalar <$sock_m>, "STORED\r\n", "stored");
    sync_get_is($sock_m, $sock_b, $key, $val);
    sleep $exptime+1;
    sync_get_is($sock_m, $sock_b, $key, undef)
}
