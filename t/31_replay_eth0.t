#!/usr/bin/perl

use strict;
use Net::Pcap::Easy;
use File::Slurp qw(slurp);

use Test;

plan tests => 5 + 5;

my ($udp, $icmp, $arp, $nss2_sooon, $sooon_nss2);

my $npe = Net::Pcap::Easy->new(
    dev              => "file:eth0.data",
    promiscuous      => 0,
    packets_per_loop => 32,

    icmp_callback => sub {
        my ($npe, $ether, $ip, $icmp_) = @_;

        $icmp ++;
    },

    udp_callback => sub {
        my ($npe, $ether, $ip, $udp_) = @_;

        $udp ++;
        $nss2_sooon ++ if $udp_->{src_port} == 9762 and $udp_->{dest_port} = 60009;
        $sooon_nss2 ++ if $udp_->{src_port} == 60009 and $udp_->{dest_port} = 9762;
    },

    arp_callback => sub {
        my ($npe, $ether, $arp_) = @_;

        $arp ++;
    },
);

ok( $npe->loop, 32 );
ok( $npe->loop, 32 );
ok( $npe->loop, 32 );
ok( $npe->loop, 15 );
ok( $npe->loop,  0 );

ok( $udp,       105 );
ok( $icmp,        4 );
ok( $arp,         2 );
ok( $nss2_sooon, 43 );
ok( $sooon_nss2, 61 );

__END__
bash$ tcpdump -nr ../eth0.data | grpe UDP | wc -l
105

bash$ tcpdump -nr ../eth0.data | grep ICMP        | wc -l
4

bash$ tcpdump -nr ../eth0.data | grep arp         | wc -l
2

bash$ tcpdump -nr ../eth0.data | grep 9762.*60009 | wc -l
43

bash$ tcpdump -nr ../eth0.data | grep 60009.*9762 | wc -l
61

bash$ tcpdump -nr ../eth0.data 
reading from file ../eth0.data, link-type EN10MB (Ethernet)
17:10:35.679796 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 220
17:10:35.683135 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:43.149037 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:43.189217 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 92
17:10:43.237648 IP 10.42.96.198.4905 > 255.255.255.255.4905: UDP, length 5
17:10:43.337564 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:43.337682 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 92
17:10:43.338260 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 396
17:10:43.338281 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 396
17:10:43.338300 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 396
17:10:43.343261 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:43.343341 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 1444
17:10:43.343379 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 1444
17:10:43.344342 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:43.344412 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 1444
17:10:43.344446 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 1324
17:10:43.345812 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:43.352016 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:43.357336 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:43.359934 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:43.361051 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:43.731781 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:43.732116 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:43.735138 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:43.872742 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:43.873062 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:43.876065 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:43.913504 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:43.913743 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:43.954046 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:44.013883 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:44.014207 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:44.017217 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:44.103714 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:44.104020 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:44.107021 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:44.751598 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:44.751966 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:44.754973 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:44.885654 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:44.885975 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:44.888978 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:44.987770 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:44.988065 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:44.991067 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:45.065755 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:45.066083 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:45.069101 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:45.126612 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:45.126864 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:45.129866 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:45.312480 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:45.312782 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:45.315780 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:45.458628 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:45.458881 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:45.461901 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:45.537802 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:45.538123 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:45.541142 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:45.680326 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:45.680685 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:45.683807 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:45.798328 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:45.798616 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:45.801743 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:45.881801 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:45.882164 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:45.885264 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:45.921846 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:45.922058 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 140
17:10:45.925163 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:46.022212 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:46.022552 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 156
17:10:46.024147 IP 10.42.97.1 > 10.42.96.194: ICMP echo request, id 11637, seq 1, length 64
17:10:46.024281 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 188
17:10:46.024619 IP 10.42.96.194 > 10.42.97.1: ICMP echo reply, id 11637, seq 1, length 64
17:10:46.024924 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 220
17:10:46.027451 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:46.028522 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:46.029600 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:47.023160 IP 10.42.97.1 > 10.42.96.194: ICMP echo request, id 11637, seq 2, length 64
17:10:47.023622 IP 10.42.96.194 > 10.42.97.1: ICMP echo reply, id 11637, seq 2, length 64
17:10:47.024109 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 220
17:10:47.027880 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:47.419999 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:47.420373 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 284
17:10:47.423826 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:47.425564 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 188
17:10:47.428536 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:47.701278 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:47.741198 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 92
17:10:47.841168 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:47.841305 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 92
17:10:47.842133 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 396
17:10:47.842172 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 396
17:10:47.842208 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 396
17:10:47.848325 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:47.848416 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 1444
17:10:47.848471 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 1444
17:10:47.849478 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:47.849542 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 668
17:10:47.851362 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:47.855617 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:47.857613 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:47.861832 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 92
17:10:47.897204 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 92
17:10:48.189157 arp who-has 10.42.97.250 tell 10.42.97.1
17:10:48.189362 arp reply 10.42.97.250 is-at 00:13:46:1d:b5:ff
17:10:48.382213 IP 10.42.97.250.60009 > 10.42.97.1.9762: UDP, length 140
17:10:48.382341 IP 10.42.97.1.9762 > 10.42.97.250.60009: UDP, length 92