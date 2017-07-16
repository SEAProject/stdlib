package stdlib::string;
use strict;
use warnings;
require Exporter;
use vars qw(@EXPORT @ISA);

@ISA = qw(Exporter);
@EXPORT = qw(isString);

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
            $self->{_value} = "$newValue";
        }
        elsif($ref eq "stdlib::string") {
            $self->{_value} = $newValue->get();
        }
        else {
            warn "Invalid string type!\n";
        }
    };
    warn $@ if $@;
}

sub value {
    my ($self) = @_;
    return $self->{_value};
}

sub isString {
    my ($str) = @_; 
    my $ref = ref($str) || ref(\$str);
    return $ref eq 'stdlib::string' ? 1 : 0;
}

1;