%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Telecom ParisTech - 2012 - JL Dessalles - www.dessalles.fr  %
% Lab Work on NL Parsing in Prolog                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Small grammar describing a subset of French     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%  DCG Rules %%%

s(FS) --> dp(CFS), ip(HFS).
ip(FS) --> tp(HFS), pp(CFS).	% circonstanciel
ip(FS) --> tp(FS).		% pas de circonstanciel
tp(FS) --> vp(CFS), l(HFS, t).	% temps
vp(FS) --> vp1(HFS), pp(CFS).	% deuxième complément
vp(FS) --> vp1(FS).	% pas de deuxième complément
vp1(FS) --> l(HFS, v), dp(CFS).	% complément direct
vp1(FS) --> l(HFS, v), pp(CFS).	% complément indirect
vp1(FS) --> l(FS, v).	% pas de complément
pp(FS) --> l(HFS, p), dp(CFS).
dp(FS) --> l(FS, dp).	% nom propre
dp(FS) --> l(HFS, d), l(CFS, n).	% nom déterminé

l(_, p) --> [en].
l(_, p) --> [pendant].
l(_, p) --> [a].
l(_, dp) --> ['Marie'].
l(_, dp) --> ['Pierre'].
l(_, dp) --> [elle].
l(_, dp) --> [il].
l(_, n) --> [cantine].
l(_, n) --> [gateau].
l(_, n) --> [heure].
l(_, n) --> [spectacle].
l(_, v) --> [aime].
l(_, v) --> [mange].
l(_, v) --> [ronfle].
l(_, t) --> ['_PP'].
l(_, t) --> ['_IMP'].
l(_, t) --> ['_PR'].
l(_, t) --> ['_FUT'].
l(_, d) --> [un].
l(_, d) --> [un].
l(_, d) --> [une].
l(_, d) --> [une].
l(_, d) --> [le].
l(_, d) --> [la].
l(_, d) --> [du].

/*
lexicon(en, [synt:p, vwp:f, anch:_, im:en |_]).
lexicon(pendant, [synt:p, vwp:g, im:pdt |_]).
lexicon('à',[synt:p |_]).

lexicon('Marie', [synt:dp, im:marie|_]).
lexicon('Pierre', [synt:dp, im:pierre|_]).
lexicon('elle', [synt:dp, im:elle|_]).
lexicon('il', [synt:dp, im:il|_]).
lexicon(cantine,[synt:n, im:cantine|_]).
lexicon('gâteau',[synt:n, im:gateau|_]).
lexicon(heure, [synt:n, anch:u, im:heureDuree |_]).
lexicon(spectacle, [synt:n, im:spectacle |_]).


lexicon(aime, [synt:v, vwp:g, im:aimer|_]).
lexicon(mange, [synt:v, im:manger|_FS]).
% :-
%	FS = [vwp:g, im:manger|_] ; 
%	FS = [vwp:f, im:manger_repas|_].
lexicon(ronfle, [synt:v, vwp:g, im:ronfler|_]).

lexicon('_PP', [synt:t, vwp:f, anch:_ |_]).
lexicon('_IMP', [synt:t, vwp:g |_]).
lexicon('_PR', [synt:t, vwp:g |_]).
lexicon('_FUT', [synt:t, vwp:f, anch:_ |_]).

lexicon(un, [synt:d|FS]) :-
	FS = [vwp:_, anch:d, im:unCertain|_] ;
	FS = [vwp:_, anch:u, im:'1'|_].
lexicon(une, FS) :- lexicon(un, FS).
lexicon(le, [synt:d |FS]) :-
	FS = [vwp:f, anch:d, im:ce |_] ;
	FS = [vwp:_, anch:u, im:ceTypeDe |_].
lexicon(la, FS) :- lexicon(le, FS).
lexicon(du, [synt:d, vwp:g, anch:u |_]).


goo :-
	lexicon(W, [synt:C |_]),
	writef('l(%w) --> [%w].', [C,W]), nl,
	fail.

*/

