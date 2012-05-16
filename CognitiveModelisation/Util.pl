%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Telecom ParisTech - 2012 - JL Dessalles - www.dessalles.fr  %
% Lab Work on NL Parsing in Prolog                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tools                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	sentence input --> list of words
%	DCG loading and DCG to rule conversion
%	basic syntactic tree display

:- dynamic(rule/2).


/*
help :-
	write('verifier le fichier ''regles.txt''\n'),
	prompt1('>'),
	get0(_).
*/
help0 :-
	write('Bye...\n'),
	%prompt1('>'),
	sleep(1).


entree(L1,[M|L2]) :-
	read(M),
	!,
	entree(L1,L2).
entree(L,L).


get_line(Phrase) :-
        collect_wd(String), 
        str2wlist(Phrase, String).

collect_wd([C|R]) :-
        get0(C), C \== -1, C \== 10, C \== 13, !, 
        collect_wd(R).
collect_wd([]).

str2wlist(Phrase,Str) :-
	str2wlist([],Phrase,[],Str).
	
str2wlist(Phrase,[Mot|Phrase],Motcourant,[]) :-
	reverse(Motcourant,Motcourant1),
        atom_codes(Mot, Motcourant1).
str2wlist(Phrasin,[Mot|Phrasout],Motcourant,[32|Str]) :-
	!,
	reverse(Motcourant,Motcourant1),
        atom_codes(Mot, Motcourant1),
	str2wlist(Phrasin,Phrasout,[],Str).
str2wlist(Phrasin,Phrasout,Motcourant,[C|Str]) :-
	str2wlist(Phrasin,Phrasout,[C|Motcourant],Str).


get_rules(FileName) :-
	write('Retrieving rules from '), write(FileName), nl,
	retractall(rule(_,_)),
	see(FileName),
	collectRule,
	seen.

collectRule :-
	%catch(read_clause(R),_,(write('Erreur dans les regles'),nl)),
	catch(read(R),_,(write('Erreur dans les regles'),nl)),
	R =.. [-->,T|Q],
	write(R), nl,
	!,
	transform(Q,Q1),
	assert(rule(T,Q1)),
	collectRule.
collectRule.

transform([A],L) :-
	!,
	transform(A,L).
transform((A,B),[A|B1]) :-
	!,
	transform(B,B1).
transform(A,[A]).

%%%%%%% predicats utilitaires
writeL([]).
writeL([M|Ml]) :-
	write(M),write(' '),
	writeL(Ml).



% "treeDisplay" realise l'affichage de l'arbre syntaxique
% la variable "Indent" est une chaine de caratere qui,
% treeDisplaye en debut de ligne, reproduit le dessin des
% branches en fonction de la position dans l'arbre.  

treeDisplay(StructPhrase) :-
	write('Syntactic tree for: '), write(StructPhrase), nl,
	nl,
	treeDisplay("         ","         ",StructPhrase),
	nl,nl.

treeDisplay(_,_,StructPhrase) :-
	StructPhrase =.. [LibPhrase],
	/* il s'agit d'un terminal */
	!,
	ecris([": ",LibPhrase]).
treeDisplay(Indent,Prefixe,StructPhrase) :-
	%StructPhrase =.. [LibPhrase,AttrPhrase|SousStruct],
	%nl,ecris([Prefixe,LibPhrase,AttrPhrase]),
	StructPhrase =.. [LibPhrase|SousStruct],
	nl,ecris([Prefixe,LibPhrase]),
	treeDisplayFils(Indent,SousStruct).

treeDisplayFils(_,[]).
treeDisplayFils(Indent,[SP]) :-
	% c'est le dernier fils, on ne dessine plus
	% la branche parente                        
	!,
	append(Indent,"   ",NewIndent),
	append(Indent,"  |__",IndentLoc),
	treeDisplay(NewIndent,IndentLoc,SP).
treeDisplayFils(Indent,[SP|SPL]) :-
	append(Indent,"  |",NewIndent),
	append(Indent,"  |__",IndentLoc),
	treeDisplay(NewIndent,IndentLoc,SP),
	treeDisplayFils(Indent,SPL).

ecris([]).
ecris([S|Sl]) :-
	string_to_list(S1,S),
	write(S1),
	ecris(Sl).

