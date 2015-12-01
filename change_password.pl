#!/usr/bin/perl -w -I/usr/share/eprints3/perl_lib

use strict;
use warnings;

use EPrints;

my $repoid = shift @ARGV;
my $username = shift @ARGV;
my $newpassword = shift @ARGV;

unless ($newpassword)
{
        print STDERR "change_password *repositorid* *username* *newpassword*\n";
        exit (1);
}

my $session = new EPrints::Session( 1, $repoid );
if( !defined $session )
{
        print STDERR "Could not connect to $repoid\n";
        exit 1;
}

my $user = EPrints::DataObj::User::user_with_username( $session, $username );
if( !defined $user )
{
        print STDERR "Unknown username: $username\n";
        $session->terminate;
        exit 1;
}

my $encrypted_password = EPrints::Utils::crypt_password($newpassword, $session);

$user->set_value('password', $encrypted_password);
$user->commit;

$session->terminate();
exit;
