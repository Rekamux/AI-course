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
Interface with the domain knowledge
******************************************************************************* 



	- The domain knowledge is imbedded in 'causal clauses':
	Effect <=== Cause1 + Cause2 + ... 
	- The domain knowledge may contain 'negative clauses' (incompatibilities):
	incompatible([T1, T2 ...]). 
	- The domain knowledge also contains explicit preferences:
	preference(Fact, Intensity).
	- The domain knowledge involves initial facts:
	initial_situation(F).
	- The domain knowledge makes the distinction between actions and facts
	action(A).
	- The domain knowledge may contain default predicates
	default(P).

                                                                              */

	/*------------------------------------------------*/
	/* Initialisations                                */
	/*------------------------------------------------*/
	% the following lines make the corresponding predicates optional in the knowledge base
	:- dynamic(situation/2).	% connaissances du moment
	:- dynamic(preference/2).	% preferences du moment
	:- dynamic( <--- /2).	% effect-action links
	:- dynamic( <=== /2).	% effect-causes links
	:- dynamic(incompatible /1).	% logical rules
	:- dynamic(default /1).	% logical rules
	:- dynamic(action /1).	% logical rules

	:- op(950, xfy, <===).	% 'is caused by', physical causes
	:- op(950, xfy, <---).	% 'is caused by', actions  
	:- op(500, xfy, +).	% 'and'
	:- op(400, fy, -).	% 'not'



	/*------------------------------------------------*/
	/* Domain knowledge starts here                   */
	/*------------------------------------------------*/

	:- consult('tpp_doors.pl').
	%:- consult('tpp_projector.pl').

