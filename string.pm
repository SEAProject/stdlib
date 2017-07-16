package stdlib::string;
use strict;
use warnings;
require Exporter;
use stdlib::array;
use vars qw(@EXPORT @ISA);

@ISA = qw(Exporter);
@EXPORT = qw(isString);

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
            $self->{_value} = "$newValue";
        }
        elsif($ref eq "stdlib::string") {
            $self->{_value} = $newValue->valueOf;
        }
        else {
            warn "Invalid string type!\n";
        }
    };
    warn $@ if $@;
}

sub valueOf {
    my ($self) = @_;
    return $self->{_value};
}

sub isEqual {
    my ($self,$value) = @_;
    return 0 if !defined $value;
    return 1 if $self->{_value} eq $value;
}

sub slice {
    my ($self,$start,$end) = @_;
    return $self->substr( $start , $end );
}

sub substr {
    my ($self,$startPosition,$length) = @_;
    if(!defined $startPosition) {
        $startPosition = 0;
    }
    if(!defined $length) {
        $length = 1;
    }
    return substr( $self->{_value} , $startPosition, $length );
}

sub charAt {
    my ($self,$index) = @_;
    return undef if !defined $index; 
    return $self->substr( $index );
}

sub charCodeAt {
    my ($self,$index) = @_;
    return undef if !defined $index; 
    return ord( $self->charAt( $index ) );
}

sub match {
    my ($self,$pattern) = @_; 
    return 0 if !defined $pattern;
    my $ret = $self->{_value} =~ m/$pattern/;
    return $ret || 0;
}

sub concat {
    my $self = shift;
    foreach(@_) {
        my $ref = ref($_) || ref(\$_);
        if($ref eq "SCALAR") {
            $self->{_value} .= "$_";
        }
    }
}

sub contains {
    my ($self,$substring) = @_;
    return 0 if !defined $substring;
    return index($self->{_value}, $substring) != -1;
}

sub containsRight {
    my ($self,$substring) = @_;
    return 0 if !defined $substring;
    return rindex($self->{_value}, $substring) != -1;
}

sub split {
    my ($self,$splitCaracter) = @_; 
    return if !defined $splitCaracter;
    return stdlib::array->new(split($splitCaracter,$self->{_value}));
}

sub repeat {
    my ($self,$repeatCount) = @_;
    if(!defined $repeatCount) {
        $repeatCount = 1;
    }
    my $repeatedValue = $self->{_value};
    while($repeatCount--) {
        $self->{_value} .= $repeatedValue;
    }
    return $self;
}

sub replace {
    my ($self,$originChar,$focusChar) = @_;
    return $self if !defined $originChar;
    if(!defined $focusChar) {
        $focusChar = '';
    }
    $self->{_value} =~ s/$originChar/$focusChar/g;
    return $self;
}

sub toLowerCase {
    my ($self) = @_;
    $self->{_value} = lc $self->{_value};
    return $self;
}

sub toUpperCase {
    my ($self) = @_;
    $self->{_value} = uc $self->{_value};
    return $self;
}

sub trim {
    my ($self) = @_;
    $self->{_value} =~ s/^\s+|\s+$//g;
    return $self;
}

sub trimRight {
    my ($self) = @_;
    $self->{_value} =~ s/\s+$//;
    return $self;
}

sub trimLeft {
    my ($self) = @_;
    $self->{_value} =~ s/^\s+//;
    return $self;
}

sub isString {
    my ($str) = @_; 
    my $ref = ref($str) || ref(\$str);
    return $ref eq 'stdlib::string' ? 1 : 0;
}

1;