#!/usr/bin/raku

# Things to check after upgrading from Raku 2022.04
# -	Can I uncomment the stuff in gist without crashing?  
# -	Can I use the pre-initialised $!field-mode variable?  

use v6.c;

use	Hash::Ordered;
use	Hash::Agnostic:ver<0.0.11>:auth<zef:lizmat>;

role	TOP::Core {}

class	Tuple is Hash::Ordered {}

role	Relation is SetHash does TOP::Core does Hash::Agnostic does Positional {...}

class	Field does Positional {
	has	Relation	$!relation	is built is required;	# The relation which contains this field
	has	Str		$!name		is built is required;	# The name of the field

	# Positional interface, used for rows
	#	Must: elems, AT-POS, EXISTS-POS
	#	May: DELETE-POS, ASSIGN-POS, BIND-POS, STORE
	# Just delegate these to @.rows, if possible
	method elems() {
		return $!relation.elems;
	}

	method	AT-POS(\position) is rw {
		Proxy.new(
			FETCH => {
				$!relation.rows[position]{$!name};
			},
			STORE => -> $, \value {
				$!relation.rows[position]{$!name} = value;
			},
		);
	}

	method	EXISTS-POS(\position) {
		$!relation.rows.EXISTS-POS(position) or return False;
		return $!relation.rows[position]{$!name}:exists;
	}
}

##### Relations

role	Relation is SetHash does TOP::Core does Hash::Agnostic does Positional {}

class	Table does Relation is export {
	has		%!field-indices;	# For looking up fields by name
	has	Str	@!field-names;		# For keeping the fields in order
	has	Field	@.fields;		# Store the actual fields

	# Currently public for access by Field object -- make protected/friend if useful
	has	Tuple	@.rows handles <elems AT-POS EXISTS-POS DELETE-POS ASSIGN-POS BIND-POS>;

	# Not implemented yet
	# Could be:
	# -	'pragma' (default): Controlled by the strict pragma, as follows:
	#	-	off: extra fields create new columns
	#	-	on (default): extra fields create an error
	# -	'overflow': extra fields get stuck in a JSON hash/object/assoc field; the name of the field is in $!overflow-field-name
	has	Str	$!field-mode = 'strict';
	has	Str	$!overflow-field-name;

	# Associative interface, used for fields
	# 	Must: AT-KEY, EXISTS-KEY
	#	May: DELETE-KEY, ASSIGN-KEY, BIND-KEY, STORE

	# Field (Associative) key locator
	method AT-KEY(\key) is raw {
		Proxy.new(
			FETCH => {
				with %!field-indices.AT-KEY(key) {
					@!fields.AT-POS($_)
				}
				else { Nil }
			},
			STORE => -> $, \value {
#				say "Storing " ~ join('#', key, value);
				with %!field-indices.AT-KEY(key) {
					@!fields.ASSIGN-POS($_, value)
				}
				else {
					my int $index = @!field-names.elems;
					@!field-names.ASSIGN-POS($index, key);
					%!field-indices.BIND-KEY(key, $index);
					@!fields.ASSIGN-POS($index, value);
				}
			}
		)
	}

	multi	method	makeTuple(%items) {
		
#		die "fm2: {$!field-mode}";
		my $field-mode = $!field-mode ?? $!field-mode !! 'lax'; # This shouldn't be needed, but it is at the moment -- try removing it and seeing if things work
		for %items.kv -> $key, $value {
#			say "Processing $key => $value";
			# Check fields here; use $field-mode, above
#			say "fm: {$field-mode} ## $key";
#			say self.raku;
			given $field-mode {
				when 'strict' {
					%!field-indices{$key}:exists or die "Error: Field '$key' doesn't exist\n";
				}
				when 'lax' {
					%!field-indices{$key}:exists or do {
						self.{$key} = Field.new(relation => self, name => $key);
					};
				}
				default {
					die "Unknown field mode '{$field-mode}'";
				}
			}
		}

		Tuple.new(%items);
	}

	multi	method	STORE(\values, :$INITIALIZE) {
		for values -> $row {
			@!rows.STORE(self.makeTuple($row), :$INITIALIZE);
		}

		return self;
	}

	method	of() { return Mu; }

	method BIND-KEY(\key, \value) is raw {
		with %!field-indices.AT-KEY(key) -> \index {
			@!fields.BIND-POS(index, value)
		}
		else {
			my int $index = @!field-names.elems;
			@!field-names.ASSIGN-POS($index, key);
			%!field-indices.BIND-KEY(key, $index);
			@!fields.BIND-POS($index, value);
		}
	}


	method CLEAR() {
		%!field-indices = @!field-names = @!fields = @!rows = Empty;
	}

	method DELETE-KEY(\key) {
		with %!field-indices.DELETE-KEY(key) -> \index {
			my \value = @!fields[index];

			@!field-names.splice:   index, 1;
			@!fields.splice: index, 1;

			%!field-indices.AT-KEY(@!field-names.AT-POS($_))-- for index .. @!field-names.end;

			value
		}
	}

	method EXISTS-KEY(\key) {
		%!field-indices.EXISTS-KEY(key)
	}

	method gist() {
		'gist-needs-fixing' ~ '{' ~ self.pairs.map( *.gist).join(", ") ~ '}'
	}

	method Str() {
		'Str-needs-fixing' ~ self.pairs.join(" ")
	}

	method raku() {
#		'raku-needs-fixing' ~ self.perlseen(self.^name, {
#			~ self.^name
#			~ '.new('
#			~ self.pairs.map({$_<>.perl}).join(',')
#			~ ')'
#		})
		self.^name ~ " \{...\}";
	}

	# Positional interface, used for rows
	#	Must: elems, AT-POS, EXISTS-POS
	#	May: DELETE-POS, ASSIGN-POS, BIND-POS, STORE
	# Just delegate these to @.rows, if possible

	##### Other methods
	method	ingest(@rows) {
		for @rows -> $row {
			@!rows.push: self.makeTuple($row);
		}
	}
}

class	TOP::TableMaker {
	method	createTable(*%params) {
		my Table $table = Table.new();
#		say $table.raku;
		given %params<type> {
			when 'csv' {
				use CSV::Parser;

				my $file_handle = open %params<filename>, :r;
				my $parser = CSV::Parser.new(
					:$file_handle,
					:contains_header_row,
				);
				my @rows;
				until $file_handle.eof {
					my %data= %( $parser.get_line() );
					@rows.push(%data);
				}

				$table.ingest(@rows);
			}
			die "Unknown type '$_'";
		}

		return $table;
	}
}
