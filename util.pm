package stdlib::util;
use strict;
use warnings;
use vars qw(@EXPORT @ISA $AUTOLOAD);
require DynaLoader;
require AutoLoader;
require Exporter;

@ISA = qw(Exporter DynaLoader);
@EXPORT = qw(
    typeOf 
    ifStd
);
no warnings 'recursion';

sub AUTOLOAD {
	no strict 'refs'; 
	my $sub = $AUTOLOAD;
    my $constname;
    ($constname = $sub) =~ s/.*:://;
	$!=0; 
    my ($val,$rc) = constant($constname, @_ ? $_[0] : 0);
    if ($rc != 0) {
		$AutoLoader::AUTOLOAD = $sub;
		goto &AutoLoader::AUTOLOAD;
    }
    *$sub = sub { $val };
    goto &$sub;
}

sub typeOf {
    my $element = shift;
    my $ref = ref($element) || ref(\$element);
    return $ref;
}

sub ifStd {
    my ($element,$stdType) = @_;
    die "undefined stdType" if !defined $stdType;
    my $ref = typeOf($element); 
    if($ref eq $stdType) {
        return $element->valueOf;
    }
    else {
        return $element;
    }
}

1;