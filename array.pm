package stdlib::array;
use strict;
use warnings;
use stdlib::util;
use stdlib::integer;
use stdlib::boolean;
use stdlib::string;
require Exporter;
use vars qw(@EXPORT @ISA);

@ISA = qw(Exporter);
@EXPORT = qw(isArray);

my $refName = 'stdlib::array';
our $directUpdate = stdlib::boolean->new(1);

sub new {
    my ($class,@Array) = @_;
    return bless({ 
        freezed => stdlib::boolean->new(0),
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
    $self->{freezed}->updateValue(1);
    return $self;
}

sub size {
    my ($self) = @_;
    return stdlib::integer->new(scalar @{$self->{value}});
}

sub push {
    my ($self, $value) = @_;
    die "Not possible to push new value in a freezed Array" if $self->{freezed}->valueOf() == 1;
    die "Not possible to push undefined value!" if !defined $value;
    my $index = push(@{$self->{value}},$value);
    return stdlib::integer->new($index);
}

sub concat {
    my ($self, @arr) = @_; 
    $self->push($_) for @arr;
    return $self;
}

sub join {
    my ($self, $separator) = @_; 
    if(!defined $separator) {
        $separator = ',';
    }
    $separator = ifStd($separator,'stdlib::string');
    my $ref = ref($separator) || ref(\$separator);
    return if $ref ne "SCALAR";
    my $str = '';
    foreach my $v (@{$self->{value}}) {
        $str.="${v}${separator}";
    }
    chop $str;
    return stdlib::string->new($str);
}

sub get {
    my ($self, $index) = @_;
    die "undefined argument index" if !defined $index;
    $index = ifStd($index,'stdlib::integer');
    return $self->{value}[$index];
}

sub first {
    my ($self) = @_;
    return $self->get(0);
}

sub last {
    my ($self) = @_;
    return $self->get($self->size->valueOf() - 1);
}

sub indexOf {
    my ($self, $value) = @_;
    die "undefined argument value" if !defined $value;
    my $index = stdlib::integer->new(-1);
    my $i = 0;
    foreach(@{$self->{value}}) {
        return $index->updateValue($i) if $_ eq $value;
        $i++;
    }
    return $index;
}

sub lastIndexOf {
    my ($self, $value) = @_;
    die "TypeError: Cannot execute lastIndexOf(\$value) with an UNDEFINED <\$value> argument!" if !defined $value;
    my $index = stdlib::integer->new(-1);
    my $i = 0;
    foreach( @{$self->{value}} ) {
        if($_ eq $value) {
            $index->updateValue($i);
        }
        $i++;
    }
    return $index;
}

sub includes {
    my ($self, $value) = @_;
    die "TypeError: Cannot execute includes(\$value) with an UNDEFINED <\$value> argument!" if !defined $value;
    foreach( @{$self->{value}} ) {
        return stdlib::boolean->new(1) if $_ eq $value;
    }
    return stdlib::boolean->new(0);
}

sub pop {
    my ($self) = @_;
    die "Not possible to pop value from a freezed Array" if $self->{freezed}->valueOf() == 1;
    return pop( @{$self->{value}} );
}

sub shift {
    my ($self) = @_;
    die "Not possible to shift value from a freezed Array" if $self->{freezed}->valueOf() == 1;
    return shift( @{$self->{value}} );
}

sub unshift {
    my ($self,@arr) = @_;
    die "Not possible to unshift value(s) into an freezed Array" if $self->{freezed}->valueOf() == 1;
    unshift(@{$self->{value}},$_) for @arr;
    return $self;
}

sub reverse {
    my ($self) = @_;
    die "Not possible to reverse a freezed Array" if $self->{freezed}->valueOf() == 1;
    my @reversedArray = reverse(@{$self->{value}});
    $self->{value} = \@reversedArray;
    return $self;
}

sub clone {
    my ($self) = @_;
    return $self->slice(0,$self->size->valueOf() - 1);
}

sub slice {
    my ($self, $start, $end) = @_;
    if(!defined $start) {
        $start = 0;
    }
    if(!defined $end) {
        $end = $self->size->valueOf() - 1;
    }
    $start = ifStd($start,'stdlib::integer');
    $end = ifStd($end,'stdlib::integer');
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
    my ($self, $index, $nbElements) = @_;
    die "Not possible to splice value(s) from a freezed Array" if $self->{freezed}->valueOf() == 1; 
    die "TypeError: Cannot execute splice(\$index, \$nbElements) with an UNDEFINED <\$index> argument!" if !defined $index;

    if(!defined $nbElements) {
        $nbElements = 1;
    }
    $index = ifStd($index,'stdlib::integer');
    $nbElements = ifStd($nbElements,'stdlib::integer');
    splice(@{$self->{value}},$index,$nbElements);
    return $self;
}

sub fill {
    my ($self, $value, $start, $end) = @_; 
    die "Undefined value for filling" if !defined $value;
    die "Not possible to fill value(s) for a freezed Array" if $self->{freezed}->valueOf() == 1; 

    if(!defined $start) {
        $start = 0;
    }
    if(!defined $end) {
        $end = $self->size->valueOf() - 1;
    }
    $start = ifStd($start, 'stdlib::integer');
    $end = ifStd($end, 'stdlib::integer');
    my $i = 0;
    foreach( @{$self->{value}} ) {
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
    my ($self, $fn) = @_;
    die "TypeError: Cannot execute find(\$functionHandler) with an UNDEFINED <\$functionHandler> argument!" if !defined $fn;
    die "typeOf(FN) is not equal to <CODE>" if typeOf($fn) ne "CODE";

    return undef if $self->size->valueOf() == 0;
    foreach( @{$self->{value}} ) {
        return $_ if $fn->($_);
    }
    return undef;
}

sub findIndex {
    my ($self, $fn) = @_;
    die "TypeError: Cannot execute findIndex(\$functionHandler) with an UNDEFINED <\$functionHandler> argument!" if !defined $fn;
    die "typeOf(FN) is not equal to code" if typeOf($fn) ne "CODE";

    my $indexArr = stdlib::array->new;
    my $i = stdlib::integer->new(0);
    foreach( @{$self->{value}} ) {
        my $ret = $fn->($_);
        $indexArr->push($i) if $ret;
        $i->add;
    }
    return $indexArr;
}

sub sort {
    my ($self, $fn) = @_;
    die "Not possible to sort value(s) for a freezed Array" if $self->{freezed}->valueOf() == 1; 
    die "TypeError: Cannot execute sort(\$functionHandler) with an UNDEFINED <\$functionHandler> argument!" if !defined $fn;
    die "typeOf(FN) is not equal to code" if typeOf($fn) ne "CODE";

    my @sortedArray = sort $fn @{$self->{value}};
    $self->{value} = \@sortedArray;
    return $self;
}

sub reduce {
    my ($self, $fn, $initialValue) = @_;
    die "TypeError: Cannot execute reduce(\$functionHandler, \$initialValue) with an UNDEFINED <\$functionHandler> argument!" if !defined $fn;
    die "Not possible to reduce value(s) for a freezed Array" if $self->{freezed}->valueOf() == 1; 
    die "typeOf(FN) is not equal to code" if typeOf($fn) ne "CODE";
    die "Not possible to reduce with an empty Array" if $self->size->valueOf() == 0;

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
    my ($self, $fn, $initialValue) = @_;
    die "TypeError: Cannot execute reduceRight(\$functionHandler, \$initialValue) with an UNDEFINED <\$functionHandler> argument!" if !defined $fn;
    die "Not possible to reduceRight value(s) for a freezed Array" if $self->{freezed}->valueOf() == 1; 
    die "typeOf(FN) is not equal to code" if typeOf($fn) ne "CODE";

    my $arrSize = $self->size->valueOf;
    die "Not possible to reduceRight with an empty Array" if $arrSize == 0;
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
    my ($self, $fn) = @_;
    die "TypeError: Cannot execute some(\$functionHandler) with an UNDEFINED <\$functionHandler> argument!" if !defined $fn;
    die "Not possible to return some value(s) for a freezed Array" if $self->{freezed}->valueOf() == 1; 
    die "typeOf(FN) is not equal to code" if typeOf($fn) ne "CODE";

    return stdlib::boolean->new(1) if $self->size->valueOf() == 0;
    foreach( @{$self->{value}} ) {
        return stdlib::boolean->new(1) if $fn->($_);
    }
    return stdlib::boolean->new(0);
}

sub map {
    my ($self, $fn) = @_;
    die "Not possible to map value(s) for a freezed Array" if $self->{freezed}->valueOf() == 1; 
    die "TypeError: Cannot execute map(\$functionHandler) with an UNDEFINED <\$functionHandler> argument!" if !defined $fn;
    die "typeOf(FN) is not equal to code" if typeOf($fn) ne "CODE";

    my $newArray = stdlib::array->new();
    foreach(@{$self->{value}}) {
        my $ret = $fn->($_);
        $newArray->push($_) if $ret;
    }
    return $newArray;
}

sub every {
    my ($self, $fn) = @_;
    die "TypeError: Cannot execute every(\$functionHandler) with an UNDEFINED <\$functionHandler> argument!" if !defined $fn;
    die "typeOf(FN) is not equal to code" if typeOf($fn) ne "CODE";

    my $i = stdlib::integer->new(0);
    foreach(@{$self->{value}}) {
        my $ret = $fn->($_,$i);
        return stdlib::boolean->new(0) if !$ret;
        $i->add;
    }
    return stdlib::boolean->new(1);
}

sub forEach {
    my ($self, $fn) = @_;
    die "TypeError: Cannot execute forEach(\$functionHandler) with an UNDEFINED <\$functionHandler> argument!" if !defined $fn;
    die "typeOf(FN) is not equal to code" if typeOf($fn) ne "CODE";

    my $i = stdlib::integer->new(0);
    foreach(@{$self->{value}}) {
        $fn->($_,$i);
        $i->add;
    }
    return $self;
}

sub toArray {
    my ($self) = @_;
    return @{$self->{value}};
}

sub isArray {
    my ($element) = @_; 
    my $ret = typeOf($element) eq $refName;
    return std::boolean->new($ret);
}

1;