package stdlib::boolean;
use strict;
use warnings;
use Scalar::Util qw(looks_like_number);
require Exporter;
use vars qw(@EXPORT @ISA);

@ISA = qw(Exporter);
@EXPORT = qw(isBoolean);

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
        if($num == abs($bool)) {
            $self->{_value} = 1;
        }
        else {
            $self->{_value}= 0;
        }
    }
    return $self;
}

sub true {
    my ($self) = @_;
    $self->{_value} = 1;
    return $self;
}

sub false {
    my ($self) = @_;
    $self->{_value} = 0;
    return $self;
}

sub valueOf {
    my ($self) = @_;
    return $self->{_value};
}

sub isBoolean {
    my ($str) = @_; 
    my $ref = ref($str) || ref(\$str);
    return $ref eq 'stdlib::boolean' ? 1 : 0;
}

1;