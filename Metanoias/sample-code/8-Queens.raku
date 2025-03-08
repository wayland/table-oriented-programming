#!/usr/bin/raku

#sub	infix:<≛>($a is rw, $b is rw) {
sub	infix:<≛>($a is rw, $b) {
	if defined($a) {
		if defined($b) {
			return $a == $b;
		} else {
			$b = $a;
		}
	} else {
		if defined($b) {
			$a = $b;
		} else {
			die "Error: both undefined";
		}
	}
}

subset	BoardInt of Int where { $_ >= 0 and $_ <= 7 };

my BoardInt $board_size = 7;


sub	queens(@board) {
	for 0..($board_size) -> BoardInt $column {
		ROW: for 0..($board_size) -> BoardInt $row {
			for 0..($column-1) -> BoardInt $index {
				@board[$index] == $row				and next;
				@board[$index] == $row + $column - $index	and next;
				@board[$index] == $row + $index - $column	and next;
			}
			@board[$column] ≛ $row;
		}
	}
}

my @board is Array[$board_size];

say @board.raku;

queens(@board);

say @board;
