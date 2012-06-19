%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% JL Dessalles - février 2012 - www.dessalles.fr                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% implementation minimale du modele temporel




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lexicon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lexical entries : lexicon(<word>, <syntactic and semantic feature structure>)
% Feature structures are unterminated lists: [ blah, blah | _ ]

lexicon(en, [synt:p, im:en |_]).
lexicon(pendant, [synt:p, im:pdt |_]).
lexicon('à',[synt:p |_]).

lexicon('Marie', [synt:dp, im:marie|_]).
lexicon('Pierre', [synt:dp, im:pierre|_]).
lexicon('elle', [synt:dp, im:elle|_]).
lexicon('il', [synt:dp, im:il|_]).
lexicon(cantine,[synt:n, im:cantine|_]).
lexicon('gâteau',[synt:n, im:gateau|_]).
lexicon(heure, [synt:n, im:heureDuree |_]).
lexicon(spectacle, [synt:n, im:spectacle |_]).
lexicon(2010, [synt:dp, im:2010 |_]).


lexicon(aime, [synt:v, im:aimer|_]).
lexicon(mange, [synt:v, im:manger|_FS]).
% :-
%	FS = [im:manger|_] ; 
%	FS = [im:manger_repas|_].
lexicon(ronfle, [synt:v, im:ronfler|_]).

lexicon('_PP', [synt:t |_]).
lexicon('_IMP', [synt:t |_]).
lexicon('_PR', [synt:t |_]).
lexicon('_FUT', [synt:t |_]).

lexicon(un, [synt:d|FS]) :-
	FS = [det:d, im:unCertain|_] ;
	FS = [det:u, im:'1'|_].
lexicon(une, FS) :- lexicon(un, FS).
lexicon(le, [synt:d |FS]) :-
	FS = [det:d, im:ce |_] ;
	FS = [det:u, im:ceTypeDe |_].
lexicon(la, FS) :- lexicon(le, FS).
lexicon(du, [synt:d, det:u |_]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display feature structures 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

writeFS(TrLevel, FS) :-
	writeFS1(TrLevel, FS), 
	fail.	% because writeSF1 changes FS
writeFS(_, _).
	
writeFS1(TrLevel,FS) :-
	% Attention: modifie FS
	checkF(synt:S, FS, R1), checkF(vwp:V, R1, R2), checkF(det:A, R2, R3),
	length(FS,FSLength),
	!,
	length(Dummy,FSLength),	% creates a list of variables of same length
	FS = Dummy,	% destroys the undetermined tail
	%sort(FS, FSSorted),	
	wt(TrLevel,(S/V/A, R3)).

