%%%%%%%%%%%
% Parsing %
%%%%%%%%%%%

	%%%%%%%%%%%%%%%%%%%%%%%%%
	% top down recognition  %
	%%%%%%%%%%%%%%%%%%%%%%%%%

:- consult('Util.pl').     % DCG to ‘rule’ converter: gn --> det, n. becomes rule(gn,[det,n])
:- get_rules('Famille.pl').      % performs the conversion by asserting rule(gn,[det,n])

tdr(Proto, Words) :-     % top-down recognition – Proto = list of non-terminals or words 
	match(Proto, Words, [], []).  % Final success. This means that Proto = Words
tdr([X|Proto], Words) :-      % top-down recognition. 
	rule(X, RHS),    % retrieving a candidate rule that matches X
	append(RHS, Proto, NewProto),  % replacing X by RHS (= right-hand side)
	nl, write(X),write(' --> '), write(RHS),
	match(NewProto, Words, NewProto1, NewWords), % see if beginning of NewProto matches beginning of Words
	tdr(NewProto1, NewWords).  % lateral recursive call
match([X|L1], [X|L2], R1, R2) :- 
	!, 
	write('\t****  reconnu: '), write(X), 
	match(L1, L2, R1, R2).
	match(L1, L2, L1, L2).

go :-
	tdr([s],[la,soeur,parle,de,sa,cousine,a,milou]).

