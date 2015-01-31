#!/usr/bin/perl
# incorporates code from perl diff: http://www.plover.com/~mjd/perl/diff/


#take two pars raw txt input, normalise them and diff em.

$a = "Information access research and development, and information retrieval especially, is based on quantitative and systematic benchmarking. Benchmarking of a computational mechanism is always based on some set of assumptions on how a system with the mechanism under consideration will provide value for its users in concrete situations -- and those assumptions need to be validated somehow. The valuable effort put into those validation studies is seldom useful for other research or system development projects. This paper argues that use cases for information access can be written to give explicit pointers towards benchmarking mechanisms and that if use cases and hypotheses about user preferences, goals, expectation and satisfaction are made explicit in the design of research systems, they will can more conveniently be validated or disproven --- which in turn makes the results emanating from research efforts more relevant for industrial partners, more sustainable for future research and more portable across projects and studies. ";
$b = "Information access research and development, and information retrieval especially, is based on quantitative and systematic benchmarking. Benchmarking of a computational mechanism is always based on some set of assumptions on how a system with the mechanism under consideration will provide value for its users in concrete situations -- and those assumptions need to be validated somehow. The valuable effort put into those validation studies is seldom useful for other research or system development projects. This paper argues that use cases for information access can be written to give explicit pointers towards benchmarking mechanisms and that if use cases  hypotheses about user preferences, goals, expectation and satisfaction are made explicit in the design of research systems, they can more conveniently be validated or disproven --- which in turn makes the results emanating from research efforts more relevant for industrial partners, more sustainable for future research and more portable across projects and studies.";
@a = split " ",$a;
@b = split " ",$b;
@ops = diff(@a,@b);
print $#ops;
print @$ops;


foreach $op (@ops) {
print "$op\n";
}
exit(0);

#foreach $aw (@a) {}






sub LCS_matrix {
  my @x;
  my $a;				# Sequence #1
  my $b;				# Sequence #2

  $a = shift;
  $b = shift;
  (ref $a eq 'ARRAY');
  (ref $b eq 'ARRAY');
  my $eq = shift;
  
  my ($al, $bl);			# Lengths of sequences
  $al = @$a;
  $bl = @$b;

  my ($i, $j);

  $x[0] = [(0) x ($bl+1)];
  for ($i=1; $i<=$al; $i++) {
    my $r = $x[$i] = [];
    $r->[0] = 0;
    for ($j=1; $j<=$bl; $j++) {
      # If the first two items are the same...
      if (defined $eq 
	  ? $eq->($a->[-$i], $b->[-$j])
	  : $a->[-$i] eq $b->[-$j]
	 ) { 
	$r->[$j] = 1 + $x[$i-1][$j-1];
      } else {
	my $pi = $x[$i][$j-1];
	my $pj = $x[$i-1][$j];
	$r->[$j] = ($pi > $pj ? $pi : $pj);
      }
    }
  }

  \@x;
}

sub traverse_sequences {
  my $dispatcher = shift;
  my $a = shift;
  my $b = shift;
  my $equal = shift;
  my $x = LCS_matrix($a, $b, $equal);

  my ($al, $bl) = (scalar(@$x)-1, scalar(@{$x->[0]})-1);
  my ($ap, $bp) = ($al, $bl);
  my $dispf;
  while (1) {
    $dispf = undef;
    my ($ai, $bi) = ($al-$ap, $bl-$bp);
    if ($ap == 0) {
      return 1 if $bp == 0; 
      $dispf = $dispatcher->{A_FINISHED} || $dispatcher->{DISCARD_B};
      $bp--;			# Where to put this?
    } elsif ($bp == 0) {
      $dispf = $dispatcher->{B_FINISHED} || $dispatcher->{DISCARD_A};
      $ap--;			# Where to put this?
    } elsif (defined($equal) 
	     ? $equal->($a->[$ai], $b->[$bi])
	     : $a->[$ai] eq $b->[$bi]
	    ) {
      $dispf = $dispatcher->{MATCH};
      $ap--; 
      $bp--;
    } else {
      if ($x->[$ap][$bp] == $x->[$ap-1][$bp] + 1) {
	$dispf = $dispatcher->{DISCARD_B};
	$bp--;
      } else {
	$dispf = $dispatcher->{DISCARD_A};
	$ap--;
      }
    }
    $dispf->($ai, $bi, @_) if defined $dispf;
    return 1 if $ap == 0 && $bp == 0;
  }
}

sub LCS {
  my $lcs = [];
  my ($a, $b) = @_;
  my $functions = { MATCH => sub {push @$lcs, $a->[$_[0]]} };
  
  traverse_sequences($functions, @_);
  wantarray ? @$lcs : $lcs;
}

sub diff {
  my ($a, $b) = @_;
  my @cur_diff = ();
  my @diffs = ();

  my $functions =
    { DISCARD_A => sub {push @cur_diff, ['-', $_[0], $a->[$_[0]]]},
      DISCARD_B => sub {push @cur_diff, ['+', $_[1], $b->[$_[1]]]},
      MATCH => sub { push @diffs, [@cur_diff] if @cur_diff; 
		     @cur_diff = ()
		   },
    };

  traverse_sequences($functions, @_);
  push @diffs, \@cur_diff if @cur_diff;
  wantarray ? @diffs : \@diffs;
}

