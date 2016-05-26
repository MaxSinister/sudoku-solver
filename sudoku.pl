#!/usr/bin/perl -w

# Die erste, primitive (aber funktionierende!) Version in einer Dreiviertelstunde geschrieben!
# Zweite Version nach 2 Stunden da!
# Dritte Version, mit großem Ausdruck, nach über 3h - leider schafft sie nicht viel.
# Vierte Version. Schafft genau, was ich kann. 60 Zeilen in einer Stunde, in der zweiten eingebaut, getestet und verbessert.
# Fünfte Version. Wenn alles andere versagt, hilft nur ausprobieren. Das kann ich so aber auch.

sub permutation {
	my $ov = shift;
	my @old_values = @{ $ov };
	if ($#old_values == -1) { return [ [] ]; }
	else {
		my @new_permutations = ();
		for (my $i = 0; $i <= $#old_values; $i++) {
			my @new_values = @old_values;
			my $value = $old_values[$i];
			splice @new_values, $i, 1;
			my $new_permutations_copy = &permutation([ @new_values ]);
			for (my $j = 0; $j <= $#{$new_permutations_copy}; $j++) {
				my $np = $new_permutations_copy->[$j];
				my @new_permutation = @{ $np };
				unshift @new_permutation, $value;
				push @new_permutations, [ @new_permutation ];
			}
		}
		return [ @new_permutations ];
	}
}

sub print_state {
    # kleine Version
    for ($i = 0; $i < 81; $i++) {
        print "\n" if ($i % 9 == 0);
        print $initial[$i], " ";
    }
    print "\n";
    # große Version
if (1) {
    for ($i = 0; $i < 9; $i++) {
        for ($m = 0; $m < 3; $m++) {
            for ($j = 0; $j < 9; $j++) {
                $index1 = $i * 9 + $j;
                for ($n = 0; $n < 3; $n++) {
                    $index2 = $m * 3 + $n;
                    if ($initial[$index1]) {
                        print (($index2 == 4) ? $initial[$index1] : "*");
                    }
                    else {
                        $imp = $impossible[$index1 * 9 + $index2];
                        if ($imp) {
                            print "x";
                        }
                        else {
                            print "o";
                        }
                    }
                }
                print " ";
                print " " if ($j == 2 or $j == 5);
            }
            print "\n";
        }
        print "\n";
        print "\n" if ($i == 2 or $i == 5);
    }
}
    print "-" x 80, "\n";
}

# Sudoku lösen:
sub make_constraints {
    for $i (0 .. 8) {
        # Zeilen
        print "[";
        for $j (0 .. 8) {
            print $i * 9 + $j, ", ";
        }
        print "],\n";
        # Spalten
        print "[";
        for $j (0 .. 8) {
            print $j * 9 + $i, ", ";
        }
        print "],\n";
        # Quadrate. Das j-te Feld im i-ten Quadrat. 012 91011 181920 345 121314 212223
        print "[";
        for $j (0 .. 8) {
            $ii = $i - ($i % 3);
            $ii /= 3;
            $jj = $j - ($j % 3);
            $jj /= 3;
            print ((($ii * 3 + $jj) * 9) + (($i % 3) * 3 + ($j % 3)), ", ");
            #print (($ii * 3 + ($i % 3)) * 9 + $jj * 3 + ($j % 3)), ", ";
        }
        print "],\n";
    }
}

# hier die bekannten Werte einsetzen
@initial = (
0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0
);

# 8, 9 in 27? 8 Widerspruch -> 9!
# 4, 5 in 1? 
@constraints = (
[0, 1, 2, 3, 4, 5, 6, 7, 8],
[0, 9, 18, 27, 36, 45, 54, 63, 72],
[0, 1, 2, 9, 10, 11, 18, 19, 20],
[9, 10, 11, 12, 13, 14, 15, 16, 17],
[1, 10, 19, 28, 37, 46, 55, 64, 73],
[3, 4, 5, 12, 13, 14, 21, 22, 23],
[18, 19, 20, 21, 22, 23, 24, 25, 26],
[2, 11, 20, 29, 38, 47, 56, 65, 74],
[6, 7, 8, 15, 16, 17, 24, 25, 26],
[27, 28, 29, 30, 31, 32, 33, 34, 35],
[3, 12, 21, 30, 39, 48, 57, 66, 75],
[27, 28, 29, 36, 37, 38, 45, 46, 47],
[36, 37, 38, 39, 40, 41, 42, 43, 44],
[4, 13, 22, 31, 40, 49, 58, 67, 76],
[30, 31, 32, 39, 40, 41, 48, 49, 50],
[45, 46, 47, 48, 49, 50, 51, 52, 53],
[5, 14, 23, 32, 41, 50, 59, 68, 77],
[33, 34, 35, 42, 43, 44, 51, 52, 53],
[54, 55, 56, 57, 58, 59, 60, 61, 62],
[6, 15, 24, 33, 42, 51, 60, 69, 78],
[54, 55, 56, 63, 64, 65, 72, 73, 74],
[63, 64, 65, 66, 67, 68, 69, 70, 71],
[7, 16, 25, 34, 43, 52, 61, 70, 79],
[57, 58, 59, 66, 67, 68, 75, 76, 77],
[72, 73, 74, 75, 76, 77, 78, 79, 80],
[8, 17, 26, 35, 44, 53, 62, 71, 80],
[60, 61, 62, 69, 70, 71, 78, 79, 80],
);

@impossible = ();
for ($i = 0; $i < 729; $i++) {
    push @impossible, 0;
}
$given = 0;
for ($i = 0; $i < 81; $i++) {
    $given++ if $initial[$i];
}
print "Tipps: $given\n\n";

$count1 = 0;
$count2 = 0;
$count3 = 0;
$count4 = 0;
$count5 = 0;

sub loop1 {
    my $no_solve = 1;
    for ($i = 0; $i <= $#constraints; $i++) {
        $count = 0;
        for ($j = 0; $j < 9; $j++) {
            if ($initial[ $constraints[$i]->[$j] ]) {
                $count++;
            }
        }
        if ($count == 8) {
            $missing = 0;
            %found = ();
            for ($j = 0; $j < 9; $j++) {
                $value = $initial[ $constraints[$i]->[$j] ];
                if ($value) {
                    $found{$value} = 1;
                }
            }
            for ($j = 1; $j <= 9; $j++) {
                unless ($found{$j}) {
                    $missing = $j;
                    last;
                }
            }
            for ($j = 0; $j < 9; $j++) {
                $value = $initial[ $constraints[$i]->[$j] ];
                unless ($value) {
                    $initial[ $constraints[$i]->[$j] ] = $missing;
                    last;
                }
            }
            $no_solve = 0;
        }
    }
    $count1++;
    #&print_state;
    return $no_solve;
}

sub loop2 {
    my $no_solve = 1;
    for ($i = 0; $i < 81; $i++) {
        $value = $initial[$i]; # 0 wenn leer, sonst 1-9!
        if ($value) {
            # Koordinaten - überflüssig?
            #$x = $i % 9;
            #$y = ($i - $x) / 3;
            # alle passenden besetzen
            for ($j = 0; $j < 9; $j++) {
                $impossible[$i * 9 + $j] = 1 unless ($j + 1 == $value); # schon besetzt!
            }
            for ($j = 0; $j <= $#constraints; $j++) {
                for ($k = 0; $k < 9; $k++) {
                    if ($constraints[$j]->[$k] == $i) {
                        for ($a = 0; $a < 9; $a++) {
                            $impossible[$constraints[$j]->[$a] * 9 + $value - 1] = 1;
                        }
                    }
                }
            }
        }
    }
    # Testen: eindeutige Kästchen?
    for ($i = 0; $i < 81; $i++) {
        unless ($initial[$i]) {
            $count = 0;
            for ($j = 0; $j < 9; $j++) {
                $count++ if ($impossible[$i * 9 + $j]);
            }
            if ($count == 8) {
                $missing = 0;
                for ($j = 0; $j < 9; $j++) {
                    unless ($impossible[$i * 9 + $j]) {
                        $missing = $j + 1;
                        last;
                    }
                }
                $initial[$i] = $missing;
                $no_solve = 0;
            }
        }
    }
    $count2++;
    #&print_state;
    $no_solve &= &loop1;
    return $no_solve;
}

sub loop3 {
    my $no_solve = 1;
    for ($i = 2; $i <= $#constraints; $i += 3) {
        $block = ($i - 2) / 3; # auf diesen Block (0-8) bezieht sich das!
        # eine Ziffer nur in drei nebeneinanderliegenden Feldern möglich?
        for ($j = 1; $j <= 9; $j++) {
            # jede Ziffer: einmal waagerecht, einmal senkrecht schauen:
            $wa = "";
            $se = "";
            for ($m = 0; $m < 3; $m++) {
                $w = 0;
                $s = 0;
                for ($n = 0; $n < 3; $n++) {
                    $cw = $m * 3 + $n; # Koordinaten waagerecht
                    $cs = $n * 3 + $m;
                    unless ($impossible[$constraints[$i]->[$cw] * 9 + $j - 1]) { # könnte da sein
                        $w = 1;
                    }
                    unless ($impossible[$constraints[$i]->[$cs] * 9 + $j - 1]) { # könnte da sein
                        $s = 1;
                    }
                }
                $wa .= $w;
                $se .= $s;
            }
            $w = $wa;
            $w =~ s/0//g;
            # wenn nur in einem Block: Schlussfolgerungen möglich, für sechs Zellen. Welche?
            ## oder passt das nur, wenn in den mittleren Blöcken?!
            if (length($w) == 1) {
                # andere Dreierblöcke in der Zeile können die nicht enthalten!
                $k = 0; # welche Zeile?
                if ($wa eq "010") {
                    $k = 1;
                }
                elsif ($wa eq "001") {
                    $k = 2;
                }
                # block-ter Block, Zeile k. Nur dort darf j stehen. In den Blöcken daneben, wieder in Zeile k, nicht!
                $start = $constraints[$i]->[$k * 3]; # erste Zelle der Zeile im Block
                $start -= ($start % 9); # erste Zelle der Zeile insgesamt.
                for ($m = 0; $m < 3; $m++) {
                    if (($block % 3) != $m) {
                        for ($n = 0; $n < 3; $n++) {
                            $index = ($start + $m * 3 + $n) * 9 + $j - 1;
                            unless ($initial[$start + $m * 3 + $n]) {
                            unless ($impossible[$index]) {
                                $impossible[$index] = 1;
                                $no_solve = 0;
                                print "", ($start + $m * 3 + $n), " kann nicht $j sein\n";
                            }
                            }
                        }
                    }
                }
            }
            # [33, 34, 35, 42, 43, 44, 51, 52, 53]
            # 0: 33, 42, 51 (kann dort sein)
            # 1: 34, 43, 52
            # 2: 35, 44, 53
            # k=0: start = 6, 33,42,51 , 60,69,78
            # k=1: start = 7, ???
            # k=2: start = 8, ???
            $s = $se;
            $s =~ s/0//g;
            if (length($s) == 1) {
                # andere Dreierblöcke in der Spalte können die nicht enthalten!
                $k = 0;
                if ($se eq "010") {
                    $k = 1;
                }
                elsif ($se eq "001") {
                    $k = 2;
                }
                # block-ter Block, Spalte k. Nur dort darf j stehen. In den Blöcken dar(üb|unt)er, in Spalte k, nicht!
                $start = $constraints[$i]->[$k]; # oberste Zelle der Spalte im Block
                $start %= 9; # oberste Zelle der Spalte insgesamt
                for ($m = 0; $m < 3; $m++) { # Block!
                    for ($n = 0; $n < 3; $n++) { # Zeile!
                        if ((($block - ($block % 3)) / 3) != $m) {
                            $index = ($start + ($m * 3 + $n) * 9) * 9 + $j - 1;
                            unless ($initial[$start + ($m * 3 + $n) * 9]) {
                            unless ($impossible[$index]) {
                                $impossible[$index] = 1;
                                $no_solve = 0;
                                print "", ($start + ($m * 3 + $n) * 9), " kann nicht $j sein!\n";# $i $k $m $n $block $index
                            }
                            }
                        }
                    }
                }
            }
        }
    }
    $count3++;
    #&print_state;
    $no_solve &= &loop2;
    return $no_solve;
}

# Kombinationen ausprobieren. Welche passen in freie Zellen von Zeile/Spalte/Block?
sub loop4 {
    my $no_solve = 1;
    for (my $i = 0; $i <= $#constraints; $i++) {
        my @missing = (1 .. 9);
        my @cells = @{ $constraints[$i] }; # einfache Liste der Indizes
        for (my $j = 9-1; $j >= 0; $j--) {
            my $value = $initial[ $cells[$j] ];
            if ($value) {
                for (my $k = $#missing; $k >= 0; $k--) {
                    if ($missing[$k] == $value) {
                        splice @missing, $k, 1;
                        splice @cells, $j, 1;
                        last;
                    }
                }
            }
        }
        if ($#missing >= 0) {
            #print join("", @missing), " $i\n";
            #print join("", @cells), " $i!\n";
            # Kombis erstellen, alle ausprobieren.
	        ## in welche Zellen müssen die eingesetzt werden? Das fehlt noch.
	        my $permutations = &permutation(\@missing);
	        my @permutations = @{ $permutations };
	        # erst prüfen: welche passen überhaupt?
	        my @fitting = ();
	        for my $permutation (@permutations) {
		        my @permutation = @{$permutation};
		        my $fits = 1;
		        for (my $j = 0; $j <= $#permutation; $j++) {
			        my $p = $permutation[$j];
			        if ($impossible[ $cells[$j] * 9 + $p - 1]) {
				        $fits = 0;
				        last;
			        }
		        }
		        push @fitting, $permutation if $fits;
	        }
	        die "Keine Kombination passt!" if ($#fitting == -1);
	        print "Of $#permutations permutations $#fitting fit in $i.\n";
	        # dann schauen: Was haben die, die passen, miteinander gemeinsam?
	        my @common = ();
	        for (my $j = 0; $j <= $#missing; $j++) {
		        #my $number = 0;
		        for (my $k = 0; $k <= $#fitting; $k++) {
#			        if ($number == 0) {
#				        $number = $fitting[$k]->[$j];
#			        }
#			        elsif ($number != $fitting[$k]->[$j]) {
#				        $number = -1;
#				        last;
#			        }
		            $common[$j]->{ $fitting[$k]->[$j] } = 1;
		        }
	        }
	        # wenn es gemeinsame gibt: Einsetzen, auf herkömmliche Weise.
	        for (my $j = 0; $j <= $#common; $j++) {
	            %common = %{ $common[$j] };
	            @comm = sort(keys %common);
		        unless ($#comm == -1 or $initial[ $cells[$j] ]) {
		            if ($#comm == 0) {
			            $initial[ $cells[$j] ] = $comm[0];
			            $no_solve = 0;
			        }
	                # kann man auf mehr erweitern: Wenn zwei möglich, aber impossible 3 sagt, kann man streichen.
			        else {
			            my @possible = ();
			            for (my $k = 0; $k < 9; $k++) {
			                push @possible, ($k+1) unless $impossible[ $cells[$j] * 9 + $k];
			            }
			            if ($#comm < $#possible) {
			                print "Behalte $#comm von $#possible bei Zelle $cells[$j]\n";
			                %comm = ();
			                for my $c (@comm) {
			                    $comm{$c} = 1;
			                }
			                for (my $k = 1; $k <= 9; $k++) {
			                    unless ($impossible[ $cells[$j] * 9 + $k - 1] or $comm{$k}) {
			                        $impossible[ $cells[$j] * 9 + $k - 1] = 1;
			                        print "$k nicht in Zelle $cells[$j]\n";
			                        $no_solve = 0;
			                    }
			                }
			            }
			        }
		        }
	        }
        }
    }
    $count4++;
    &print_state;
    $no_solve &= &loop3;
    return $no_solve;
}

sub loop5 {
    my $no_solve = 1;
    ## Backup machen.
    ## In die Zellen mit den wenigsten Möglichkeiten versuchsweise was einsetzen.
    $count5++;
    &print_state;
    $no_solve &= &loop4;
    return $no_solve;
}

# lösen
while (1) {
    # einfach: schauen, ob acht bekannt sind
    while (1) {
        $no_solve = &loop1;
        last if $no_solve;
    }
    # mittel: Für alle 81 Felder schauen, was überhaupt geht
    while (1) {
        $no_solve = &loop2;
        last if $no_solve;
    }
    # schwer: Die unmöglichen Felder weiter nutzen. Wenn in einer Einheit nur eine 1 möglich, muss sie besetzt werden.
    while (1) {
        $no_solve = &loop3;
        last if $no_solve;
    }
    # verschiedene Kombinationen ausprobieren.
    while (1) {
        $no_solve = &loop4;
        last if $no_solve;
    }
    while (1) {
        $no_solve = &loop5;
        last if $no_solve;
    }
    for ($i = 0; $i < 81; $i++) {
        die "Unlösbar" unless $initial[$i];
    }
    last;
}
#&print_state;

print "$count1-mal Schleife 1\n";
print "$count2-mal Schleife 2\n";
print "$count3-mal Schleife 3\n";
print "$count4-mal Schleife 4\n";
