package stdlib::array;
use strict;
use warnings;
require Exporter;
use vars qw(@EXPORT @ISA);

@ISA = qw(Exporter);
@EXPORT = qw(isArray);

sub new {
    my ($class,@Array) = @_;
    return bless({ 
        freezed => 0,
        value => \@Array
    },ref($class) || $class);
}

sub freeze {
    my ($self) = @_;
    $self->{freezed} = 1;
    return $self;
}

sub size {
    my ($self) = @_;
    return scalar @{$self->{value}};
}

sub push {
    my ($self,$value) = @_;
    return if $self->{freezed};
    return if !defined $value;
    my $index = push(@{$self->{value}},$value);
    return $index;
}

sub concat {
    my ($self,@arr) = @_; 
    $self->push($_) for @arr;
    return $self;
}

sub join {
    my ($self,$separator) = @_; 
    if(!defined $separator) {
        $separator = ',';
    }
    my $ref = ref($separator) || ref(\$separator);
    return if $ref ne "SCALAR";
    my $str = '';
    foreach my $v (@{$self->{value}}) {
        $str.="${v}${separator}";
    }
    chop $str;
    return $str;
}

sub get {
    my ($self,$index) = @_;
    die "undefined argument index" if !defined $index;
    return $self->{value}[$index];
}

sub indexOf {
    my ($self,$value) = @_;
    die "undefined argument value" if !defined $value;
    my $index = -1;
    my $ref = ref($value) || ref(\$value);
    foreach(@{$self->{value}}) {

    }
    return $index;
}

sub pop {
    my ($self) = @_;
    my $value = pop(@{$self->{value}});
    return $value;
}

sub shift {
    my ($self) = @_;
    my $value = shift(@{$self->{value}});
    return $value;
}

sub unshift {
    my ($self,@arr) = @_;
    unshift(@{$self->{value}},$_) for @arr;
    return $self;
}

sub reverse {
    my ($self) = @_;
    my @reversedArray = reverse(@{$self->{value}});
    $self->{value} = \@reversedArray;
    return $self;
}

sub slice {
    my ($self,$offset,$length) = @_;
    if(!defined $length) {
        $length = 1;
    }
    my $newArray = stdlib::array->new(); 
    
    return $newArray;
}

sub sort {
    my ($self,$fn) = @_;
}

sub reduce {
    my ($self,$fn,$initialValue) = @_;
}

sub map {
    my ($self,$fn) = @_;
    die "Undefined callback (fn) for map method!" if !defined $fn;
    my $ref = ref($fn) || ref(\$fn);
    return if $ref ne "CODE";
    my $newArray = stdlib::array->new();
    foreach(@{$self->{value}}) {
        my $ret = $fn->($_);
        $newArray->push($_) if $ret;
    }
    return $newArray;
}

sub every {
    my ($self,$fn) = @_;
    die "Undefined callback (fn) for every method!" if !defined $fn; 
    my $ref = ref($fn) || ref(\$fn);
    return if $ref ne "CODE";
    my $i = 0;
    foreach(@{$self->{value}}) {
        my $ret = $fn->($_,$i);
        return 0 if !$ret;
        $i++;
    }
    return 1;
}

sub forEach {
    my ($self,$fn) = @_;
    die "Undefined callback (fn) for forEach method!" if !defined $fn; 
    my $ref = ref($fn) || ref(\$fn);
    return if $ref ne "CODE";
    my $i = 0;
    foreach(@{$self->{value}}) {
        $fn->($_,$i);
        $i++;
    }
    return $self;
}

sub isArray {
    my ($str) = @_; 
    my $i = 0;
    my $ref = ref($str) || ref(\$str);
    return $ref eq 'stdlib::array' ? 1 : 0;
}

1;