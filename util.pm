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
    TRUE
    FALSE
);
no warnings 'recursion';

use constant {
    TRUE    => 1,
    FALSE   => 0
};

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
    return ref($element) || ref(\$element);
}

sub ifStd {
    my ($element, $stdType) = @_;
    die "TypeError: Cannot execute ifStd(\$stdType) with an UNDEFINED <\$stdType> argument!" if !defined $stdType;
    return typeOf($element) eq $stdType ? $element->valueOf : $element;
}

1;