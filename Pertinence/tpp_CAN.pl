/*
         @@   @@    @@@@     @@@@     @@@@
         @@@ @@@   @@  @@     @@       @@
         @@@@@@@  @@          @@       @@
         @@ @ @@  @@          @@       @@
         @@   @@  @@    @     @@       @@
         @@   @@   @@  @@     @@       @@
         @@   @@    @@@@     @@@@     @@@@

	jl dessalles - juin 2012
        www.dessalles.fr
	TP Argumentation

                            Telecom ParisTech
                            
*******************************************************************************
Module principal
*******************************************************************************/ 


:- dynamic(strength/2).	% stores necessities (for positive terms)

:- consult('tpp_knowl.pl').	% chargement de la connaissance particuliere
:- consult('tpp_world.pl').	% chargement de la simulation
%:- consult('tpp_util0.pl').	% chargement d'utilitaires
:- consult('tpp_util.pl').	% chargement d'utilitaires
%%%  Alternative:   :- consult('tpp_util.pl').	% chargement d'utilitaires si le systeme graphique est present

trace_level(5).	% used in 'tpp_util0', but not in 'tpp_util' where trace level is determined from within a window


% qsave_program('paradise',[goal=go,autoload=true, stand_alone=true]).

	go :-
		w_init_world,	% all predicates prefixed with w_ are in 'tpp_world.pl'
		retractall(strength(_,_)),
		findall((T, N), (preference(T, N), want(T, N)), _),
		w_update,	
		w_propagate,	% draws inferences from preferences
		display_memory,
		start.

	/*------------------------------------------------*/
	/* 'start' looks for waiting wishes, then         */
	/* for problems (contradictory wishes or beliefs) */
	/*------------------------------------------------*/

	start :-
        		tracer(3,['(Re)start...']),
		conflicting(T,N,_Problem),
			positive(T, T1, _),
			tracer(2,['Problem of intensity', N, 'with ', T1]),
		resolve_conflict(T,N),
		!,
		start.
	start :-
        	tracer(4,['No conflict left or no solution']).

	resolve_conflict(T, N) :-
		solve_it(T, N).
	resolve_conflict(T, N) :-
		try_and_negate(T, N, T1, N1),	% negates on backtrack
		propagate(T1, N1).
	resolve_conflict(T, N) :-
		give_up(T, N).
	resolve_conflict(T, N) :-
		revise(T, N).	% allows user to change necessity in case of deadlock
	
		
	solve_it(T, N) :-
		optimistic(T, N, T1, _),	% get version of T with positive necessity
        	tracer(5,['Trying to make', T1, 'real']),
		w_make_it_so(T1).	% maybe T1 can be made true
		
	try_and_negate(T, N, T, N).	% negates only when backtracking
	try_and_negate(T, N, T1, N1) :-
		N1 is -N,
		opposite(T, T1),
        	tracer(3,['Negating',T,', considering', T1]),
			wait(3).

	propagate(T, N) :-
		abduct(T, N, Cause),	% finds a weaker cause 
        	tracer(4,['Propagating conflict onto',Cause]),
			wait(4),
		resolve_conflict(Cause, N).
	
	give_up(T,N) :-
		% failure in trying to solve T with intensity N
		% to memorize failure, T is given necessity -N
		N1 is -N,
        	tracer(3,['Giving up: ',T, 'is stored with necessity', N1]),
		necessity(T, N2),
		N1 \== N2,
		want(T, N1),
			wait(3).

	revise(T, N) :-
		necessity(T, N1),
		N1 * N < 0,
		abs(N1) >= abs(N),	% We are left with an unsolved problem
		talk(['We are about to live with', T, '(', N, ')!']),
		talk(['If you want to change preference for', T, '(', N, '), enter number followed by ''.'' (or else: ''n.'')']),
		read(N2),
		integer(N2),
		retractall(preference(T, _)),
		asserta(preference(T, N2)).
		
	


	/*------------------------------------------------*/
	/* 'abduct' looks for causes                      */
	/*------------------------------------------------*/
	abduct(T, N, Cause) :-
		w_link(Causes, T, _Link),
        		tracer(4,['Looking for a weak cause in',Causes, 'with necessity', N]),
		member(Cause, Causes),
		mutable(Cause,N),	% Cause is mutable
		want(Cause,N).	% stores the necessity
	abduct(T, N, _) :-
        		tracer(5,['Failing to perform further abduction from', T, 'with necessity', N]),
		fail.
		

	/*------------------------------------------------*/
	/* 'mutable' tests whether a proposition is          */
	/* mutable, i.e. does not resist change of        */
	/* intensity N                                    */
	/*------------------------------------------------*/
	mutable(T, N) :-
		actual(T, N1),
		N1 * N > 0, % what is wished is the case
		!,
		fail.
	mutable(T, N) :-
		N > 0,		% T is wanted
		necessity(T, NT),
		NT =< -N,	% but T is marked as strongly unmutable
        		tracer(5,[T,'too strong',NT]),
		!,
		fail.
	mutable(T, N) :-
		N < 0,		% T is refused
		necessity(T, NT),
		NT >= -N,	% but T is marked as strongly wanted
        		tracer(5,[T,'too strong',NT]),
		!,
		fail.
	mutable(_T, _N).
		
			
	/*------------------------------------------------*/
	/* necessity processing       ,                   */
	/*------------------------------------------------*/
	
	necessity(F, N) :-
		% reads necessity of the positive version of F
		positive(F, F1, Switch),
		strength(F1,N1),
		N is N1 * Switch.	

	actual(F, 1) :- 
		w_supposed(F),
		!.
	actual(F, -1) :- 
		opposite(F,F1),
		w_supposed(F1),
		!.

	want(F, N) :-
		% stores F with necessity N
        		tracer(4,[F, 'wanted with intensity', N]),
		positive(F, F1, Switch),		% positive version of F (without heading negation)
		retractall(strength(F1,_)),
		N1 is N * Switch,
		asserta(strength(F1, N1)).
	
	optimistic(F, N, F, N) :-
		% version of F with positive necessity
		N >= 0,
		!.
	optimistic(F, N, F1, N1) :-
		opposite(F,F1),
		N1 is -N.

	/*----------------------------------------------------*/
	/* 'conflicting' is used for detecting contradictions */
	/* for processing and display                         */
	/* A proposition creates a conflict if                */
	/* - it is a desired (unrealized) action              */
	/* - it is a desired and refuted state of affairs     */
	/* - it is an actual and undesired state of affairs   */
	/*----------------------------------------------------*/
	conflicting(T, N, T1) :-
		necessity(T,N),
		contradicted(T,N,T1),
		!.
	conflicting(T, N, T1) :-
		preference(T,N),
		contradicted(T,N,T1).

	contradicted(T, N, T1) :-
		N > 0,
		actual(T, -1),
		opposite(T, T1).
	contradicted(T, N, T) :-
		N < 0,
		actual(T, 1).


	/*----------------------------------------------------*/
	/* useful predicates                                  */
	/*----------------------------------------------------*/
	unrealized(T, N) :-
		necessity(T, N),
		N > 0,
		not(actual(T, _)).

	opposite(-T, T) :-
		!.	% avoids cumulating negative signs
	opposite(T, -T).

	positive(-F, F, -1) :-
		% positive version of F (without heading negation)
		!.
	positive(F, F, 1).
	
