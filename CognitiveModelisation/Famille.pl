
% Grammaire d'un fragment elementaire du Francais

% --- Productions
s --> gn, gv.
gn --> det, n.		% Groupe nominal simple
%gn --> gn, gnp.		% Groupe nominal plus groupe nominal prepositionnel 
gn --> det, n, gnp.     /* Groupe nominal plus groupe nominal prépositionnel */
gv --> v.           	% Groupe verbal, verbe intransitif
gv --> v, gn.		% Groupe verbal, verbe + COD : aimer X 
gv --> v, gnp.		% Groupe verbal, verbe + COI : medire de X 
gv --> v, gn, gnp.	% Groupe verbal, verbe + COD + COI : donner X a Y 
gv --> v, gnp, gnp.	% Groupe verbal, verbe + COD + COI : parler de X a Y
gnp --> pp, gn.		% Groupe nominal prepositionnel 

% -- Production preterminales
gn --> [milou].
det --> [le].
det --> [la].
det --> [ma].
det --> [sa].
det --> [ses].
det --> [une].
n --> [fils].
n --> [fille].
n --> [soeur].
n --> [tante].
n --> [bru].
n --> [belle-doche].
n --> [voisine].
n --> [cousine].
v --> [ronchonne].
v --> [aime].
v --> [parle].
v --> [agace].
v --> [hait].
v --> [pleure].
pp --> [de].
pp --> [a].
