%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% JL Dessalles - février 2012 - www.dessalles.fr                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% implementation minimale du modele temporel   %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- consult('util.pl').	% contains:  get_line str2wlist setTraceLevel wt
:- consult('time_lexicon.pl').	% lexical feature structures
:- consult('grammar.pl').	% syntactic rules
:- setTraceLevel(0).	% controls the detail of tracing comments

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% various ways of running the programme
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
go :-
	setTraceLevel(2),
	nl, nl, write('donner une phrase --->  '),
	get_line(Sentence),
	process_phrase(s, Sentence, FS),
	nl, write('== Ok. '), writeFS(0,FS).
	go.
go :-
	write('Ok').

test :-	% similar to 'go', with no trace
	setTraceLevel(0),
	nl, nl, write('donner une phrase --->  '),
	get_line(Sentence),
	findall(FS, process_phrase(s, Sentence, FS), FSL),
	member(FSi, FSL),
	nl, write('== Ok. '), writeFS(0,FSi),
	fail.
test.

test(PhraseType) :-		% to test phrases instead of complete sentences
	nl, writef('donner un syntagme de type %q --->  ', [PhraseType]),
	get_line(Phrase),
	process_phrase(PhraseType, Phrase,FS),
	nl, write('== Ok. '), writeFS(0,FS).
	
process_phrase(PhraseType, Ph, FS) :-
	% calls the DCG grammar	(with PhraseType = s for a sentence)
	R =.. [PhraseType, FS, Ph, []],
	R.
process_phrase(s, [_,_|_],_) :-
	nl,write('Réessayer... '), nl, fail.


tests :-
	% runs a series of test on examples taken from a file
	setTraceLevel(0),
	consult('exemples.pl'),
	example(Correct, ExStr, Comment),
	writef('\nCorrect: %d - %s - %q', [Correct, ExStr, Comment]),
	str2wlist(ExStr,Sentence),
	process_phrase(s,Sentence,FS),
	nl, write('== Ok. '), writeFS(0,FS),
	fail.
tests.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% merging of structures 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% When Syntax merges two phrases, it calls 'merge' to merge the corresponding semantic structures
merge(FS1, FS2, FS) :-
		% Here we will add calls to predication
	merge0(FS1, FS2, FS).	% feature structure merge

% feature structure merge
merge0([F|_], FS, FS) :- 
	var(F),
	% No feature left
	!.		
merge0([ N:V1 | R1 ], FS2, [N:V | NFS]) :-
	select(N:V2, FS2, R2),
	!,
	% V1 and V2 have to be merged as N-feature values
	merge1(N, V1, V2, V), % calls specialized Merges
	merge0(R1, R2, NFS).
merge0(FS1, FS2, _) :-
	wt(2,'\nEchec unification: '), writeFS(2,FS1), writeFS(2,FS2), fail.

checkF(N:V, FS1, R) :-
	select(N:V1, FS1, R),
	!, V = V1.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% merging of features. merge1(F, V1, V2) : V1 and V2 are merged as features of type F
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
merge1(_, V, V, V) :- !.		% perfect merge - Nothing more to do
merge1(synt, H, _, H) :- !.	% syntactic merge: head wins 
merge1(im, Im1, Im2, Im) :-	% perceptive merge
	!,
	atom_concat(Im1, '_', Im1_),	% mere concatenation of image identifiers
	atom_concat(Im1_, Im2, Im).
merge1(F, V1, V2, _) :-
	wt(3,('\nProblème unification', F:V1, F:V2)),
	fail.


