	%%%%%%%%%%%%%
	% bottom-up recognition  %
	%%%%%%%%%%%%%

:- consult('Util.pl').     % DCG to ‘rule’ converter: gn --> det, n. becomes rule(gn,[det,n])
:- get_rules('Famille.pl').      % performs the conversion by asserting rule(gn,[det,n])


bup([s]).  % success when one gets s after a sequence of transformations
bup(P):-
	append(Pref,Rest,P),   % P is split into three pieces 
	append(RHS,Suff,Rest), % P = Pref + RHS + Suff
	rule(X,RHS),
	append(Pref,[X|Suff], NEWP),  % RHS is replaced by X in P:  NEWP = Pref + X + Suff
	write(NEWP), nl, %get0(_),
	bup(NEWP).  % lateral recursive call

go :-
	bup([la,soeur,parle,de,sa,cousine,a,milou]).

	
