/*
         @@   @@    @@@@     @@@@     @@@@
         @@@ @@@   @@  @@     @@       @@
         @@@@@@@  @@          @@       @@
         @@ @ @@  @@          @@       @@
         @@   @@  @@    @     @@       @@
         @@   @@   @@  @@     @@       @@
         @@   @@    @@@@     @@@@     @@@@

	jl dessalles - juin 2012

	TP Argumentation


*******************************************************************************
World processing
*******************************************************************************/ 


	/* 
	This module makes use of the domain knowledge to maintain
	the current state of the local world
	Note: This module doesn't know anything about necessities, preferences or abduction
	*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Propagating world states	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	/* Actual aspects of the world may be
	   - 'imposed' (if they belong to the initial state or result from actions)
	   - 'possible' (if they are actions that can be performed)
	   - 'inferred' (if they are consequences of other actual facts)
	*/
	
	w_init_world :-
		retractall(situation(_,_)),
		findall(T, (initial_situation(T), asserta(situation(T, imposed))), _),
		findall(T, (incompatible([T]), opposite(T,T1), asserta(situation(T1, imposed))), _).
        
	w_propagate :-
		% drawing inferences from known facts
		consequence(_F, _),
		!,	% some new thing has been proven
		w_propagate.
	w_propagate.

	consequence(F,F1) :-
		w_supposed(F),
		% some forward chaining
		w_link(Causes, F1, _),	% considers material consequences of F
		select(F, Causes, Rest),
		w_probablyTrue(Rest),		% all elements in Rest are 'supposed'
		ground(F1), % too dangerous to store facts with variables
		not(situation(F1,_)),	% F1 still unknown after instantiation
		w_memory(F, F1).	% F1 becomes possible, inferred or imposed, depending on the status of F

		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reading the world	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	w_probablyTrue([F|Fl]) :-
		w_supposed(F),
		w_probablyTrue(Fl).
	w_probablyTrue([]).

	w_supposed(F) :-
		% F is supposed if it is known as imposed or inferred or decided
		situation(F,Status),
		member(Status, [imposed, inferred, decided]).	% possible actions are not true
	w_supposed(F) :-
		% F is supposed if -F is unknown and F is logically possible and true by default
		default(F),
		not(incompatible([F])),	% F is not logically impossible
		opposite(F, NotF),
		not(situation(NotF, _)).
	w_supposed(F) :-
		% F is supposed if -F is unknown and F is intially true
		initial_situation(F),
		opposite(F, NotF),
		not(situation(NotF, _)).

		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Storing what happens
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	w_memory(F, F1) :-
		w_clean(F1),
		action(F1),	% an action does not become true, just possible
		!,
		tracer(5,['inferring from', F, 'that',F1,'is possible']),
		asserta(situation(F1,possible)).
	w_memory(F, F1) :-
		action(F),	% the effect of actions are irreversible
		!,
		tracer(5,['inferring from', F, 'that',F1,'is definitely the case']),
		asserta(situation(F1,imposed)).
	w_memory(F, F1) :-
		tracer(5,['inferring from', F, 'that',F1,'is the case']),
		asserta(situation(F1,inferred)).

	w_update :-
		% Revision of known facts
		% all previous deductions are erased (but 'imposed' situations remain)
		retractall(situation(_,inferred)),
		retractall(situation(_,possible)).
		
	% 'w_clean' destroys states that are about F or -F
	w_clean(-F) :-
		!,
		w_clean(F).
	w_clean(F) :-
		retractall(situation(F, _)),
		retractall(situation(-F, _)).
               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% interface with knowledge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	w_link(Causes, Effect, action) :-
		Effect <--- CauseChain,		% causal rules
		w_causal_to_list(CauseChain, Causes).
	w_link(Causes, Effect, causal) :-
		Effect <=== CauseChain,		% causal rules
		w_causal_to_list(CauseChain, Causes).
	w_link(Causes, Effect, logical) :-
		incompatible(IncompatibleSet),	% logical rules
		opposite(Effect, NEffect),
		select(NEffect, IncompatibleSet, Causes).

		
	w_causal_to_list(C1 + C2, CauseList) :-
		!,
		w_causal_to_list(C1, C1L),
		w_causal_to_list(C2, C2L),
		append(C1L, C2L, CauseList).
	w_causal_to_list(C, [C]).
		

%%%%%%%%%%%%%%%%%%%%%%%
% Execute actions
%%%%%%%%%%%%%%%%%%%%%%%
	w_make_it_so(A) :-
		action(A),
		!,
        w_possible(A),
			display_active_sit(A, possible),
        	tracer(4,['Trying to execute', A]),
		w_update,		% forget inferences before rebuilding them
		asserta(situation(A, imposed)),
		talk(['------> Action : ', A]),
		consequence(A, _),	% the action does have consequences
		w_propagate,
		retract(situation(A, imposed)),	% action finished
			display_memory,
        	wait(3).
	w_make_it_so(F) :-
		w_mutable(F),
			tracer(5,['deciding that',F,'is the case']),
		w_update,		% forget inferences before rebuilding them
		w_clean(F),
		asserta(situation(F, decided)),
		talk(['------> Decision : ', F]),
		w_propagate,
			display_memory,
        	wait(3).



    w_possible(A) :-
		situation(A, possible),
		!.
    w_possible(A) :-
		consequence(_,A).

	w_mutable(F) :-
		not(w_supposed(F)),
		opposite(F, F1),		
		not(w_supposed(F1)),
			tracer(5,[F,'is mutable because it is not observed']),
		!.
	w_mutable(F) :-
		situation(F, decided),
			tracer(5,[F,'is mutable because it results from a decition']),
		!.
	w_mutable(F) :-
		opposite(F, F1),
		situation(F1, decided),
			tracer(5,[F,'is mutable because', F1, 'results from a decition']),
		!.
	w_mutable(F) :-
		w_supposed(F),
		default(F),
			tracer(5,[F,'is mutable because it was true by default']),
		!.
	w_mutable(F) :-
		opposite(F, F1),
		w_supposed(F1),
		default(F1),
			tracer(5,[F,'is mutable because', F1, 'was true by default']).

		
