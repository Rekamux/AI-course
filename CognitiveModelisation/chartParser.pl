%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Telecom ParisTech - 2012 - JL Dessalles - www.dessalles.fr  %
% Lab Work on NL Parsing in Prolog                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main programme (parser)     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sauve :-
	% This may save the programme as a stand-alone executable file
	qsave_program('gram', [goal=parse, toplevel=help, autoload=true]).

:- consult('Util.pl').	% utilities: get_rules, treeDisplay, writeL
:- dynamic(edge/7).



go :-
	get_rules('Famille.pl'),	% load the file containing the grammar
	%get_rules('French.pl'),	% load the file containing the grammar
	parse.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Chart parser
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parse :-
	prompt1('\nSentence :  '),
	get_line(Sentence),
	Sentence \== [''],
	parse(Sentence),
	parse.
parse.

parse(L) :-
	retractall(edge(_, _, _, _, _, _, _)),	% clean up the chart
	start_chart(L),	% add lexical edges that trigger further analysis
	nl, write('Parsed sentence :'), writeL(L), nl,
	length(L,N),	% number of words in the sentence
	edge(0, N, _, [ ], _, T, _),	% there is an edge from start to end, the sentence is correct
	treeDisplay(T),
	write('The sentence is correct.'), nl,
	fail.
parse(L) :-
	edge(0, N, s, [ ], _, _T, _),
	length(InitialChunk, N),
	append(InitialChunk, _, L),	% part of the sentence that has also been recognized as a sentence
	write('Recognized phrase:'), writeL(InitialChunk), nl,
	%nl, treeDisplay(T),
	fail.
parse(_).


start_chart(Words) :-
	% Adds inactive edges for each word, what triggers further analysis
	nth0(Position, Words, Word),	% Finds Word at position Position in Words
	Position1 is Position + 1,
	rule(Cat, [Word]),
	Cat =.. [C|_],	% extracts the name of the functor (or of the constant if no functor)
	T =.. [C, Word],	% makes  T = C(Word), for tree display
	add_edge(Position, Position1, Cat, [ ], [Word], T, 'input '),
	fail.	% forces backtracking to consider all categories for Word
start_chart(_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
/*	edge(EdgeStart, EdgeEnd, Cat, Rest, Beginning, Tree, Comment)
	EdgeStart:	where the edge starts in the sentence
	EdgeEnd:	where the edge is able to go in the sentence
	Cat:		the head of the rule
	Rest:		what remains to be recognized
	Beginning:	what has already been recognized
	Tree:		functional representation of the rule for tree display
	Comment:	comment
*/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

add_edge(NewEdgeStart, NewEdgeEnd, Cat, Rest, Beginning, _, _) :-
	edge(NewEdgeStart, NewEdgeEnd, Cat, Rest, Beginning, _, _),	% nothing to do if the edge already exists
	!.
add_edge(NewEdgeStart, NewEdgeEnd, Cat, Rest, Beginning, T, Comment) :-
	% Here the edge is really added
	assert(edge(NewEdgeStart, NewEdgeEnd, Cat, Rest, Beginning, T, Comment)),
	writef('New edge (%w) %w -> %w:\t%w --> ', [Comment, NewEdgeStart, NewEdgeEnd, Cat]),
	writeL(Beginning), write('* '), writeL(Rest), 
	write('\t'), write(T), nl,
	fail.	% forces backtracking, work is not finished
add_edge(NewEdgeStart, _, Cat, [ ], _, _, _) :-
	% Adding an inactive edge - Cat has been recognized
	% --- Bottom-up phase ---
	% One generates active edges from rules that start with Cat
		/* TO BE WRITTEN
		Use rule(_,_) to define the appropriate new edge
	Cat1 =.. [C|_],
	T =.. [C],		% for tree display
	add_edge(NewEdgeStart, NewEdgeStart, Cat1, [Cat|Rest], [ ], T, 'rule  '),
		*/
	fail.	% forces backtracking, to add them all
add_edge(NewEdgeStart, NewEdgeEnd, Cat, [ ], _, T, _) :-
	% Adding an inactive edge (again) - Cat has been recognized
	% --- Completion phase ---
	% Active edges that finish at NewEdgeStart are extended
		/* TO BE WRITTEN
		Find an active edge ending at NewEdgeStart
		Don't forget to compute the tree structure T1 of the new edge 
		*/
	fail.	% forces backtracking, to extend them all
add_edge(NewEdgeStart, NewEdgeEnd, Cat, [Cat1|Rest], Beginning, T, _) :-
	% Adding an active edge - Maybe it can already be extended
		/* TO BE WRITTEN
		Find an inactive edge starting at NewEdgeEnd
		Don't forget to compute the tree structure T1 of the new edge 
		*/
	fail.
add_edge(_, _, _, _, _, _, _).	% always succeed

