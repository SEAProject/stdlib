package stdlib::boolean;
use strict;
use warnings;
use Scalar::Util qw(looks_like_number);
use stdlib::util;
require Exporter;
use vars qw(@EXPORT @ISA);

@ISA = qw(Exporter);
@EXPORT = qw(isBoolean);

our $refName = "stdlib::boolean";

sub new {
    my ($class,$bool) = @_;
    return bless({},ref($class) || $class)->updateValue($bool);
}

sub updateValue {
    my ($self,$bool) = @_;
    if(!defined $bool || !looks_like_number $bool) {
        $self->{_value} = 0;
    }
    else {
        $self->{_value} = abs($bool) ? 1 : 0;
    }
    return $self;
}

sub valueOf {
    my ($self) = @_;
    return $self->{_value};
}

sub isBoolean {
    my ($str) = @_; 
    my $ret = typeOf($str) eq $refName;
    return stdlib::boolean->new($ret);
}

1;