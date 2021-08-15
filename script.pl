#!/usr/bin/perl

use Net::Telnet::Cisco;
$user="admin";
$pass="admin";

$ip= $2;

#Se establece la conexión con los routers

$session = Net::Telnet::Cisco->new(Host => "$ip");
$session->login("$user", "$pass");


### get-request para sysUpTime ###

use strict;
use warnings;

use Net::SNMP;

my $OID_sysUpTime = '1.3.6.1.2.1.1.3.0';

my ($session, $error) = Net::SNMP->session(
   -hostname  => shift || 'localhost',
   -community => shift || 'public',
);


if (!defined $session) {
   printf "ERROR: %s.\n", $error;
   exit 1;
}

my $result = $session->get_request(-varbindlist => [ $OID_sysUpTime ],);

if (!defined $result) {
   printf "ERROR: %s.\n", $session->error();
   $session->close();
   exit 1;
}

printf "The sysUpTime for host '%s' is %s.\n",

      $session->hostname(), $result->{$OID_sysUpTime};

$session->close();

exit 0;


# ejecutar algún comando desde el router 
my @output = $session->cmd('show ip route');
print @output;


# ingresar a modo privilegiado en el router
if ($session->enable(admin) ) {
    @output = $session->cmd('show privilege');
    print "My privileges: @output\n";
} else {
    warn "Can't enable: " . $session->errmsg;
}

#$session->close;
