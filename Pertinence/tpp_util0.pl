/*
         @@   @@    @@@@     @@@@     @@@@
         @@@ @@@   @@  @@     @@       @@
         @@@@@@@  @@          @@       @@
         @@ @ @@  @@          @@       @@
         @@   @@  @@    @     @@       @@
         @@   @@   @@  @@     @@       @@
         @@   @@    @@@@     @@@@     @@@@

	jl dessalles - mai 2010

	TP Argumentation


*******************************************************************************
Module utilitaire
*******************************************************************************/ 


%trace_level(5).


authorised(Level) :-
	trace_level(TL),
	Level =< TL.

wait(Level) :-
	authorised(Level),
	!,
	get0(_).
	%get_single_char(_).
wait(_).

tracer(Level, [Msg|R]) :-
	authorised(Level),
	!,
	write(' '),
	write(Msg),
	tracer(Level, R).
tracer(Level, [ ]) :-
	authorised(Level),
	!,
	nl.
tracer(_Level, _).

talk(L) :-
	tracer(1,L).

display_memory.
display_active_sit(_, _).