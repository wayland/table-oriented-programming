Moves
=====

Queries
=======

-	XSLT has apply-templates, which essentially triggers a re-walk of the source,
	which is very powerful

XSLT templates vs. Grammar Actions:
-	Grammar actions are how query output gets turned into a Walkable/Streamable
-	XSLT templates can (via a call to apply-templates) kick off another separate walk of the source

Given the above, how should we treat Producers?

Figure out how to integrate:
-	Declarative Raku
-	Constraint Logic Programming
	-	Start with Wikipedia's constraint programming page
		-	Looks like this can be done with where clauses in 
			signatures (though might have to merge the where 
			clauses from the query and law)
	-	Alma-0 also has a paper on constraint programming

Predicates, Laws and Unification
================================

-	Rewrite so the Alma-0 stuff is in appendices and footnotes

AI Stuff
========
Put in material from:
-	GPT Pilot
	-	Make a ticketing system for communication
-	GOAL programming language: 
	-	https://en.wikipedia.org/wiki/GOAL_agent_programming_language
	-	https://en.wikipedia.org/wiki/Agent-oriented_programming
-	https://github.com/pysmt/pysmt
What's already been done in Raku:
-	https://raku.land/tags/ai
-	https://rakuforprediction.wordpress.com/2023/08/06/number-guessing-games-palm-vs-chatgpt/

Other Changes
=============
Go through everything and:
-	Write any remaining pages
	-	Queries needs finishing
	-	Check out the 2.x series
	-	3.0 needs to be written
	-	4.0 needs to be written
-	Transformation Jungles -- this should be something that feeds into the dataflow stuff

Another set of todos (older):
-	Come up with unified database model (tree + table + relations; relations = 
	Prolog facts, not Relational relations), then incorporate SQL ideas 
-	Relations seem like class attributes that connect to other classes (so just 
	a special kind of attribute)
-	Tuples are objects (object data), but all instances of the class are pushed 
	into a table (or referenced as part of a table)
-	Do a comparison of Prolog, Goedel, Declaraku, and the Constraint Programming page
-	As much as possible, make things work with both Walkables and Streamables



Things to learn about
=====================
-	DataQueryWorkflows: https://github.com/antononcube/Raku-DSL-English-DataQueryWorkflows
	-	Translates an SQL-like language into a variety of querying/data manipulation
		languages, mostly the Big Data ones (from SQL up)
-	Data::Reshapers -- https://github.com/antononcube/Raku-Data-Reshapers (closer to ad-hoc data wrangling)
	-	Just for doing a few bits like switching the axes of tables, and outputting it in various
		data formats (AoA, AoH, etc)
-	https://github.com/librasteve/raku-Dan (closer to array-oriented programming)
	-	Backends onto Python Pandas and Rust Polars

