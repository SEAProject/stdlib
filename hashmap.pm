package stdlib::hashmap;
use strict;
use warnings;
use stdlib::array;
require Exporter;
use vars qw(@EXPORT @ISA);

@ISA = qw(Exporter);
@EXPORT = qw(isHashMap);

sub new {
    my ($class,$hashRef) = @_;
    return bless({ 
        freezed => 0,
        value => $hashRef || {}
    },ref($class) || $class);
}

sub size {
    my ($self) = @_;
    return scalar $self->keys;
}

sub freeze {
    my ($self) = @_;
    $self->{freezed} = 1;
    return $self;
}

sub clear {
    my ($self) = @_;
    $self->{value} = {};
    return $self;
}

sub has {
    my ($self,$key) = @_; 
    return 0 if !defined $key;
    return defined $self->{value}->{$key} ? 1 : 0;
}

sub get {
    my ($self,$key) = @_; 
    return $self->has($key) ? $self->{value}->{$key} : undef;
}

sub set {
    my ($self,$key,$value) = @_;
    return if !$self->has($key) && $self->{freezed};
    $self->{value}->{$key} = $value;
    return $self;
}

sub delete {
    my ($self,$key) = @_;
    if($self->has($key)) {
        delete $self->{value}->{$key};
    }
    return $self;
}

sub forEach {
    my ($self,$fn) = @_;
    die "Undefined callback (fn) for forEach method!" if !defined $fn; 
    my $ref = ref($fn) || ref(\$fn);
    return if $ref ne "CODE";
    while (my ($key, $value) = each %{$self->{value}}) {
        $fn->($key,$value);
    }
    return $self;
}

sub keys {
    my ($self) = @_;
    return stdlib::array->new(keys %{$self->{value}});
}

sub values {
    my ($self) = @_;
    return stdlib::array->new(values %{$self->{value}});
}

sub toHash {
    my ($self) = @_;
    return %{$self->{value}};
}

sub isHashMap {
    my ($str) = @_; 
    my $ref = ref($str) || ref(\$str);
    return $ref eq 'stdlib::hashmap' ? 1 : 0;
}

1;