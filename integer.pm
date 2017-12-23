package stdlib::integer;
use strict;
use warnings;
use Scalar::Util qw(looks_like_number);
use stdlib::util;
use stdlib::boolean;
require Exporter;
use vars qw(@EXPORT @ISA);

@ISA = qw(Exporter);
@EXPORT = qw(isInteger);

our $refName = "stdlib::integer";
our $directUpdate = stdlib::boolean->new(1);

sub new {
    my ($class,$str) = @_;
    return bless({ 
        freezed => stdlib::boolean->new(0)
    },ref($class) || $class)->updateValue($str);
}

sub freeze {
    my ($self) = @_;
    $self->{freezed}->updateValue(1);
}

sub updateValue {
    my ($self,$newValue) = @_;
    die "stdlib::integer cannot be instancied or updated with an <UNDEFINED> value" if defined($newValue) == 0;
    die "Cannot update integer value when freezed" if $self->{freezed}->valueOf() == 1;
    my $ref = typeOf $newValue;
    if($ref eq "SCALAR") {
        if(looks_like_number($newValue)) {
            $self->{_value} = $newValue;
        }
        else {
            die "InvalidType: Scalar value <'$newValue'> cannot be casted as a integer!\n";
        }
    }
    elsif($ref eq "stdlib::string") {
        $newValue = $newValue->valueOf();
        $ref = typeOf $newValue;
        if(looks_like_number($newValue)) {
            $self->{_value} = $newValue;
        }
        else {
            die "InvalidType: stdlib::string value <'$newValue'> cannot be casted as a integer!\n";
        }
    }
    elsif($ref eq $refName || $ref eq "stdlib::boolean") {
        $self->{_value} = $newValue->valueOf;
    }
    else {
        die "InvalidType: Cannot cast typeof <$ref> into an <std::integer> Object\n";
    }
    return $self;
}

sub valueOf {
    my ($self, $castStr) = @_;
    return $castStr == 1 ? "$self->{_value}" : $self->{_value};
}

sub toString {
    my ($self) = @_;
    return stdlib::string->new($self->{_value});
}

sub length {
    my ($self) = @_;
    my $lt = length($self->{_value});
    return stdlib::integer->new($lt);
}

sub sub {
    my ($self,$int) = @_;
    die "Not possible to substract a freezed integer" if $self->{freezed}->valueOf() == 1;
    if(!defined $int) {
        $int = 1;
    }
    $int = ifStd($int,$refName);
    my $tValue = $self->{_value};
    if(looks_like_number $int) {
        $tValue -= $int;
    }
    if($directUpdate->valueOf() == 1) {
        $self->updateValue($tValue);
        return $self;
    }
    return stdlib::integer->new($tValue);
}

sub add {
    my ($self,$int) = @_;
    die "Not possible to add a freezed integer" if $self->{freezed}->valueOf() == 1;
    if(!defined $int) {
        $int = 1;
    }
    $int = ifStd($int,$refName);
    my $tValue = $self->{_value};
    if(looks_like_number $int) {
        $tValue += $int;
    }
    if($directUpdate->valueOf() == 1) {
        $self->updateValue($tValue);
        return $self;
    }
    return stdlib::integer->new($tValue);
}

sub mul {
    my ($self,$int) = @_;
    die "Not possible to multiplicate a freezed integer" if $self->{freezed}->valueOf() == 1;
    if(!defined $int) {
        $int = 1;
    }
    $int = ifStd($int,$refName);
    my $tValue = $self->{_value};
    if(looks_like_number $int) {
        $tValue = $tValue * $int;
    }
    if($directUpdate->valueOf() == 1) {
        $self->updateValue($tValue);
        return $self;
    }
    return stdlib::integer->new($tValue);
}

sub div {
    my ($self,$int) = @_;
    die "Not possible to divide a freezed integer" if $self->{freezed}->valueOf() == 1;
    if(!defined $int) {
        $int = 1;
    }
    $int = ifStd($int,$refName);
    my $tValue = $self->{_value};
    if(looks_like_number $int) {
        $tValue = $tValue / $int;
    }
    if($directUpdate->valueOf() == 1) {
        $self->updateValue($tValue);
        return $self;
    }
    return stdlib::integer->new($tValue);
}

sub isInteger {
    my ($element) = @_; 
    my $ret = typeOf($element) eq $refName;
    return stdlib::boolean->new($ret);
}

1;