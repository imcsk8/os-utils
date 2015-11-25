#!/usr/bin/perl

use strict;
srand(time ^ ($$+($$<<15)) ^ unpack "%32L*",`ps -a | /usr/bin/gzip -c -f` );
my $MAXTAM=9;
my @chars=('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',0,1,2,3,4,5,6,7,8,9);

print genpass($MAXTAM);

sub genpass {
	my($tam)=@_;
	my $pass;
	for(my $i=0;$i<=$tam;$i++){
		$pass=$pass.$chars[rand($#chars+1)];
	}
	return($pass);
}
