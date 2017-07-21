package stdlib::regexp;
use strict;
use warnings;
use stdlib::boolean;
use stdlib::integer;
use stdlib::util;
require Exporter;
use vars qw(@EXPORT @ISA);

@ISA = qw(Exporter);
@EXPORT = qw(isRegExp);

my $refName = 'stdlib::regexp';

sub new {
    my ($class,$strRegExp) = @_;
    my $ref = ref($strRegExp) || ref(\$strRegExp);
    if($ref eq "stdlib::string") {
        $strRegExp = $strRegExp->valueof;
    }
    return bless({
        str => $strRegExp,
        _value => qr/$strRegExp/
    },ref($class) || $class);
}

sub exec {
    my ($self,$str) = @_;
    return 0 if !defined $str;
    my $ref = ref($strRegExp) || ref(\$strRegExp);
    if($ref eq "stdlib::string") {
        $str = $str->valueof;
    }
}

sub test {
    my ($self,$str) = @_;
    return 0 if !defined $str;
    my $ref = ref($strRegExp) || ref(\$strRegExp);
    if($ref eq "stdlib::string") {
        $str = $str->valueof;
    }
    return $str =~ $self->{_value} ? 1 : 0;
}

sub valueOf {
    my ($self) = @_;
    return stdlib::string->new($self->{str});
}

sub isRegExp {
    my ($element) = @_; 
    my $ref = ref($element) || ref(\$element);
    return $ref eq 'stdlib::regexp' ? 1 : 0;
}

1;