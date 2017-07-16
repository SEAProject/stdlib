package stdlib::int;
use strict;
use warnings;
use Scalar::Util qw(looks_like_number);
require Exporter;
use vars qw(@EXPORT @ISA);

@ISA = qw(Exporter);
@EXPORT = qw(isInt);

sub new {
    my ($class,$str) = @_;
    my $blessed = bless({ freezed => 0 },ref($class) || $class);
    eval {
        $blessed->set($str);
    };
    die $@ if $@;
    return $blessed;
}

sub freeze {
    my ($self) = @_;
    $self->{freezed} = 1;
}

sub set {
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
            $self->{_value} = $newValue->get();
        }
        else {
            warn "Invalid integer type!\n";
        }
    };
    warn $@ if $@;
}

sub value {
    my ($self) = @_;
    return $self->{_value};
}

sub isInt {
    my ($str) = @_; 
    my $ref = ref($str) || ref(\$str);
    return $ref eq 'stdlib::int' ? 1 : 0;
}

1;