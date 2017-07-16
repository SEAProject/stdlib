package stdlib::integer;
use strict;
use warnings;
use Scalar::Util qw(looks_like_number);
require Exporter;
use vars qw(@EXPORT @ISA);

@ISA = qw(Exporter);
@EXPORT = qw(isInteger);

sub new {
    my ($class,$str) = @_;
    my $blessed = bless({ freezed => 0 },ref($class) || $class);
    eval {
        $blessed->updateValue($str);
    };
    die $@ if $@;
    return $blessed;
}

sub freeze {
    my ($self) = @_;
    $self->{freezed} = 1;
}

sub updateValue {
    my ($self,$newValue) = @_;
    return if $self->{freezed};
    eval {
        my $ref = ref($newValue) || ref(\$newValue);
        if($ref eq "SCALAR") {
            if(looks_like_number($newValue)) {
                $self->{_value} = $newValue;
            }
            else {
                warn "SCALAR Argument is not a integer\n";
            }
        }
        elsif($ref eq "stdlib::int") {
            $self->{_value} = $newValue->valueOf;
        }
        else {
            warn "Invalid integer type!\n";
        }
    };
    warn $@ if $@;
}

sub valueOf {
    my ($self) = @_;
    return $self->{_value};
}

sub sub {
    my ($self,$int) = @_;
    if(looks_like_number $int) {
        $self->{_value} = $self->{_value} - $int;
    }
    return $self;
}

sub add {
    my ($self,$int) = @_;
    if(looks_like_number $int) {
        $self->{_value} = $self->{_value} + $int;
    }
    return $self;
}

sub mul {
    my ($self,$int) = @_;
    if(looks_like_number $int) {
        $self->{_value} = $self->{_value} * $int;
    }
    return $self;
}

sub div {
    my ($self,$int) = @_;
    if(looks_like_number $int) {
        $self->{_value} = $self->{_value} / $int;
    }
    return $self;
}

sub isInteger {
    my ($str) = @_; 
    my $ref = ref($str) || ref(\$str);
    return $ref eq 'stdlib::integer' ? 1 : 0;
}

1;