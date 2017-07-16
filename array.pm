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

sub clear {
    my ($self) = @_;
    my @Arr = ();
    $self->{value} = \@Arr;
    return $self;
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
    my $i = 0;
    foreach(@{$self->{value}}) {
        return $i if $_ eq $value;
        $i++;
    }
    return $index;
}

sub lastIndexOf {
    my ($self,$value) = @_;
    die "undefined argument value" if !defined $value;
    my $index = -1;
    my $i = 0;
    foreach(@{$self->{value}}) {
        if($_ eq $value) {
            $index = $i;
        }
        $i++;
    }
    return $index;
}

sub includes {
    my ($self,$value) = @_;
    die "undefined value" if !defined $value;
    foreach(@{$self->{value}}) {
        return 1 if $_ eq $value;
    }
    return 0;
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

sub clone {
    my ($self) = @_;
    return $self->slice(0,$self->size() - 1);
}

sub slice {
    my ($self,$start,$end) = @_;
    if(!defined $start) {
        $start = 0;
    }
    if(!defined $end) {
        $end = $self->size() - 1;
    }
    my $newArray = stdlib::array->new(); 
    my $i = 0;
    foreach(@{$self->{value}}) {
        if($i < $start) {
            $i++;
            next;
        }
        $newArray->push($_);
        last if $i == $end;
        $i++;
    }
    return $newArray;
}

sub splice {
    my ($self,$index,$nbElements) = @_; 
    die "index not defined" if !defined $index; 
    if(!defined $nbElements) {
        $nbElements = 1;
    }
    splice(@{$self->{value}},$index,$nbElements);
    return $self;
}

sub fill {
    my ($self,$value,$start,$end) = @_; 
    die "undefined value" if !defined $value;
    if(!defined $start) {
        $start = 0;
    }
    if(!defined $end) {
        $end = $self->size() - 1;
    }
    my $i = 0;
    foreach(@{$self->{value}}) {
        if($i < $start) {
            $i++;
            next;
        }
        $self->{value}[$i] = $value;
        last if $i == $end;
        $i++;
    }
    return $self;
}

sub find {
    my ($self,$fn) = @_;
    die "Undefined callback (fn) for find method!" if !defined $fn;
    my $ref = ref($fn) || ref(\$fn);
    return if $ref ne "CODE";
    return if $self->size() == 0;
    foreach(@{$self->{value}}) {
        return $_ if $fn->($_);
    }
    return undef;
}

sub findIndex {
    my ($self,$fn) = @_;
    die "Undefined callback (fn) for findIndex method!" if !defined $fn;
    my $ref = ref($fn) || ref(\$fn);
    return if $ref ne "CODE";
    my $indexArr = stdlib::array->new;
    my $i = 0;
    foreach(@{$self->{value}}) {
        my $ret = $fn->($_);
        $indexArr->push($i) if $ret;
        $i++;
    }
    return $indexArr;
}

sub sort {
    my ($self,$fn) = @_;
    die "Undefined callback (fn) for sort method!" if !defined $fn;
    my $ref = ref($fn) || ref(\$fn);
    return if $ref ne "CODE";
    my @sortedArray = sort $fn @{$self->{value}};
    $self->{value} = \@sortedArray;
    return $self;
}

sub reduce {
    my ($self,$fn,$initialValue) = @_;
    die "Undefined callback (fn) for reduce method!" if !defined $fn;
    my $ref = ref($fn) || ref(\$fn);
    return if $ref ne "CODE";
    return if $self->size() == 0;
    if(!defined $initialValue) {
        $initialValue = $self->get(0);
    }
    foreach(@{$self->{value}}) {
        $initialValue = $fn->($initialValue,$_);
        last if !defined $initialValue;
    }
    return $initialValue;
}

sub reduceRight {
    my ($self,$fn,$initialValue) = @_;
    die "Undefined callback (fn) for reduceRight method!" if !defined $fn;
    my $ref = ref($fn) || ref(\$fn);
    return if $ref ne "CODE";
    my $arrSize = $self->size();
    return if $arrSize == 0;
    my $i = $arrSize - 1;
    if(!defined $initialValue) {
        $initialValue = $self->get($i);
    }
    while($i >= 0) {
        $initialValue = $fn->($initialValue,$self->get($i));
        last if !defined $initialValue;
        $i--;
    }
    return $initialValue;
}

sub some {
    my ($self,$fn) = @_;
    die "Undefined callback (fn) for map method!" if !defined $fn;
    my $ref = ref($fn) || ref(\$fn);
    return if $ref ne "CODE";
    return if $self->size() == 0;
    foreach(@{$self->{value}}) {
        return 1 if $fn->($_);
    }
    return 0;
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

sub toArray {
    my ($self) = @_;
    return @{$self->{value}};
}

sub isArray {
    my ($str) = @_; 
    my $i = 0;
    my $ref = ref($str) || ref(\$str);
    return $ref eq 'stdlib::array' ? 1 : 0;
}

1;