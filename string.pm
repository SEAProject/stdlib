package stdlib::string;
use strict;
use warnings;
require Exporter;
use stdlib::array;
use stdlib::boolean;
use stdlib::integer;
use stdlib::util;
use vars qw(@EXPORT @ISA);

@ISA = qw(Exporter);
@EXPORT = qw(isString);

our $refName = "stdlib::string";
our $directUpdate = stdlib::boolean->new(1);

sub new {
    my ($class,$str) = @_;
    my $blessed = bless({ 
        freezed => stdlib::boolean->new(0) 
    },ref($class) || $class);
    eval {
        $blessed->updateValue($str);
    };
    die $@ if $@;
    return $blessed;
}

sub freeze {
    my ($self) = @_;
    $self->{freezed}->updateValue(0);
}

sub updateValue {
    my ($self,$newValue) = @_;
    die "Cannot update string value when freezed" if $self->{freezed}->valueOf() == 1;
    eval {
        my $ref = typeOf($newValue);
        if($ref eq "SCALAR") {
            $self->{_value} = "$newValue";
        }
        elsif($ref eq "stdlib::integer") {
            my $nV = $newValue->valueOf;
            $self->{_value} = "$nV";
        }
        elsif($ref eq $refName) {
            $self->{_value} = $newValue->valueOf;
        }
        else {
            warn "Invalid string type!\n";
        }
    };
    die $@ if $@;
    return $self;
}

sub valueOf {
    my ($self) = @_;
    return $self->{_value};
}

sub length {
    my ($self) = @_;
    my $lt = length($self->{_value});
    return stdlib::integer->new($lt);
}

sub isEqual {
    my ($self,$value) = @_;
    return 0 if !defined $value;
    $value = ifStd($value,$refName);
    return $self->{_value} eq $value ? stdlib::boolean->new(1) : stdlib::boolean->new(0);
}

sub substr {
    my ($self,$startPosition,$length) = @_;
    die "Not possible to substring a freezed string" if $self->{freezed}->valueOf() == 1;
    if(!defined $startPosition) {
        $startPosition = 0;
    }
    if(!defined $length) {
        $length = 1;
    }
    my $str = substr( $self->{_value} , ifStd($startPosition,"stdlib::integer") , ifStd($length,"stdlib::integer") );
    return stdlib::string->new($str);
}

sub slice {
    my ($self,$start,$end) = @_;
    die "Not possible to slice a freezed string" if $self->{freezed}->valueOf() == 1;
    return $self->substr( ifStd($start,"stdlib::integer") , ifStd($end,"stdlib::integer") );
}

sub charAt {
    my ($self,$index) = @_;
    return undef if !defined $index; 
    return $self->substr( $index );
}

sub charCodeAt {
    my ($self,$index) = @_;
    return undef if !defined $index;
    my $charCode = ord( $self->charAt( $index )->valueOf() ); 
    return stdlib::integer->new( $charCode );
}

sub match {
    my ($self,$pattern) = @_; 
    return 0 if !defined $pattern;
    my $ret = $self->{_value} =~ m/$pattern/;
    return stdlib::boolean->new($ret);
}

sub concat {
    my $self = shift;
    die "Not possible to concat a freezed string" if $self->{freezed}->valueOf() == 1;
    my $tValue = $self->{_value};
    foreach(@_) {
        if(typeOf($_) eq "SCALAR") {
            $tValue .= "$_";
        }
    }
    if($directUpdate->valueOf() == 1) {
        $self->updateValue($tValue);
        return $self;
    }
    return stdlib::string->new($tValue);
}

sub contains {
    my ($self,$substring) = @_;
    return 0 if !defined $substring;
    my $ret = index($self->{_value}, ifStd($substring,$refName) ) != -1;
    return stdlib::boolean->new($ret);
}

sub containsRight {
    my ($self,$substring) = @_;
    return 0 if !defined $substring;
    my $ret = rindex($self->{_value}, ifStd($substring,$refName) ) != -1;
    return stdlib::boolean->new($ret);
}

sub split {
    my ($self,$splitCaracter) = @_; 
    return if !defined $splitCaracter;
    $splitCaracter = ifStd($splitCaracter,$refName);
    return stdlib::array->new(split($splitCaracter,$self->{_value}));
}

sub repeat {
    my ($self,$repeatCount) = @_;
    die "Not possible to repeat a freezed string" if $self->{freezed}->valueOf() == 1;
    if(!defined $repeatCount) {
        $repeatCount = 1;
    }
    $repeatCount = ifStd($repeatCount,"stdlib::integer");
    my $repeatedValue = $self->{_value};
    my $tValue = $self->{_value};
    while($repeatCount--) {
        $tValue .= $repeatedValue;
    }
    if($directUpdate->valueOf() == 1) {
        $self->updateValue($tValue);
        return $self;
    }
    return stdlib::string->new($tValue);
}

sub replace {
    my ($self,$originChar,$focusChar) = @_;
    die "Not possible to replace carather in a freezed string" if $self->{freezed}->valueOf() == 1;
    return $self if !defined $originChar;
    if(!defined $focusChar) {
        $focusChar = '';
    }
    $originChar = ifStd($originChar,$refName);
    $focusChar = ifStd($focusChar,$refName);
    my $tValue = $self->{_value};
    $tValue =~ s/$originChar/$focusChar/g;
    if($directUpdate->valueOf() == 1) {
        $self->updateValue($tValue);
        return $self;
    }
    return stdlib::string->new($tValue);
}

sub toLowerCase {
    my ($self) = @_;
    die "Not possible to lowerCase a freezed string" if $self->{freezed}->valueOf() == 1;
    my $tValue = $self->{_value};
    $tValue = lc $tValue;
    if($directUpdate->valueOf() == 1) {
        $self->updateValue($tValue);
        return $self;
    }
    return stdlib::string->new($tValue);
}

sub toUpperCase {
    my ($self) = @_;
    die "Not possible to upperCase a freezed string" if $self->{freezed}->valueOf() == 1;
    my $tValue = $self->{_value};
    $tValue = uc $tValue;
    if($directUpdate->valueOf() == 1) {
        $self->updateValue($tValue);
        return $self;
    }
    return stdlib::string->new($tValue);
}

sub trim {
    my ($self) = @_;
    die "Not possible to trim a freezed string" if $self->{freezed}->valueOf() == 1;
    my $tValue = $self->{_value};
    $tValue =~ s/^\s+|\s+$//g;
    if($directUpdate->valueOf() == 1) {
        $self->updateValue($tValue);
        return $self;
    }
    return stdlib::string->new($tValue);
}

sub trimRight {
    my ($self) = @_;
    die "Not possible to trimRight a freezed string" if $self->{freezed}->valueOf() == 1;
    my $tValue = $self->{_value};
    $tValue =~ s/\s+$//;
    if($directUpdate->valueOf() == 1) {
        $self->updateValue($tValue);
        return $self;
    }
    return stdlib::string->new($tValue);
}

sub trimLeft {
    my ($self) = @_;
    die "Not possible to trimLeft a freezed string" if $self->{freezed}->valueOf() == 1;
    my $tValue = $self->{_value};
    $tValue =~ s/^\s+//;
    if($directUpdate->valueOf() == 1) {
        $self->updateValue($tValue);
        return $self;
    }
    return stdlib::string->new($tValue);
}

sub isString {
    my ($str) = @_; 
    my $ret = typeOf($str) eq $refName;
    return stdlib::boolean->new($ret);
}

1;