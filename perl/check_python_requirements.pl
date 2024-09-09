#!/bin/perl -W

# Checks for python requirements file packages on the distro RPM repositories
# Iván Chavero <ichavero@chavero.com.mx>

use strict;

# File with identified RPM packages
my $RPM_FILE = "install_python_rpms.sh";

# File with ptyhon packages that are not in the distro
my $REQ_FILE = "requirements_with_no_rpm.txt";

if($#ARGV < 0) {
    print "Usage: $0 <requirements.txt file>\n";
    exit;
}

my $req_file = $ARGV[0];

open my $requirements, '<', $req_file or die "Can't open file: $req_file\n";
open my $rpms, '>', $RPM_FILE or die "Can't open $RPM_FILE file\n";
open my $new_reqs, '>', $RPM_FILE or die "Can't open $REQ_FILE file\n";

print $rpms "dnf install -y ";

while (my $p = <$requirements>) {
    chomp $p;
    my $package = "python3-$p";
    $package =~ s/==.*$//g;
    if (is_rpm_package($package)) {
        print "😃 $package has RPM package\n";
        print $rpms "$package ";
    } else  {
        print "😭 NO RPM for $package\n";
        print $new_reqs "$p\n";
    }
}

close($requirements);
close($rpms);
close($new_reqs);

# Checks if a package exists
sub is_rpm_package {
    my $package = shift;
    my $ret = `LANG=en dnf search $package 2>&1| grep "No matches"`;
    if ($ret =~ /No matches/) {
        return 0;
    }
    return 1;
}
