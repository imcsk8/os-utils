#!/usr/bin/perl

use strict;
srand(time ^ ($$+($$<<15)) ^ unpack "%32L*",`ps -a | /usr/bin/gzip -c -f` );
my $MAXTAM = 9;
my @chars = ('a'..'z', 0..9, 'A'..'Z', '@', '!', '#', '$');

if ($ARGV[0] != "") {
    $MAXTAM = $ARGV[0]; 
}

print genpass($MAXTAM);

sub genpass {
	my($tam)=@_;
	my $pass;
	for(my $i=0;$i<=$tam;$i++){
		$pass=$pass.$chars[rand($#chars+1)];
	}
	return($pass);
}
