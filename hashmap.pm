package stdlib::hashmap;
use strict;
use warnings;
use stdlib::array;
use stdlib::util;
use stdlib::boolean;
use stdlib::integer;
require Exporter;
use vars qw(@EXPORT @ISA);

@ISA = qw(Exporter);
@EXPORT = qw(isHashMap);

my $refName = 'stdlib::hashmap';

sub new {
    my ($class,$hashRef) = @_;
    return bless({ 
        freezed => stdlib::boolean->new(0),
        value => $hashRef || {}
    },ref($class) || $class);
}

sub size {
    my ($self) = @_;
    return stdlib::integer->new(scalar($self->keys()));
}

sub freeze {
    my ($self) = @_;
    $self->{freezed}->updateValue(1);
    return $self;
}

sub isFreezed() {
    my ($self) = @_;
    return $self->{freezed}->valueOf;
}

sub clear {
    my ($self) = @_;
    $self->{value} = {};
    return $self;
}

sub has {
    my ($self, $key) = @_; 
    return stdlib::boolean->new(0) if !defined $key;
    return stdlib::boolean->new(defined $self->{value}->{$key});
}

sub get {
    my ($self, $key) = @_; 
    return $self->has($key) ? $self->{value}->{$key} : undef;
}

sub set {
    my ($self, $key, $value) = @_;
    die "Error: Cannot use the <HashMap.set()> method because the Object has been detected as freezed." if $self->isFreezed;

    return if !$self->has($key);
    $self->{value}->{$key} = $value;
    return $self;
}

sub delete {
    my ($self, $key) = @_;
    die "Error: Cannot use the <HashMap.delete()> method because the Object has been detected as freezed." if $self->isFreezed;

    if($self->has($key)) {
        delete $self->{value}->{$key};
    }
    return $self;
}

sub forEach {
    my ($self, $fn) = @_;
    die "TypeError: Cannot execute forEach(\$fn) with an UNDEFINED <\$fn> argument!" if !defined $fn;
    die "TypeError: FN Should be a reference of a Subroutine (EG: Callback)." if typeOf($fn) ne "CODE";

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
    my ($element) = @_; 
    my $ret = typeOf($element) eq $refName;
    return stdlib::boolean->new($ret);
}

1;