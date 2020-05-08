#!/usr/bin/perl

use strict;

my $MAX_SIZE = 9;
if($#ARGV >= 0) {
    $MAX_SIZE = int($ARGV[0]);
}

srand(time ^ ($$+($$<<15)) ^ unpack "%32L*",`ps -a | /bin/gzip -c -f` );

# Store the chars in an array to avoid using the char() function
my @chars = ('!', '#', '$', '%', '&', '(', ')', '*', '+', ',', '.', '/', 0..9, ':', ';', '<', '=', '>', '?', '@', 'A'..'Z', '[', ']', '_', 'a'..'z');

print genpass($MAX_SIZE);

sub genpass {
    my($size) = @_;
    my $pass;
    for(my $i = 0; $i <= $size; $i++){
        $pass = $pass.$chars[rand($#chars+1)];
    }
    return($pass);
}

