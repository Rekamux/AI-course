
/*-------------------------------------------------|
|* Domain knowledge for PARADISE                  *|
|* Dialogue: 'doors'                          *|
|*------------------------------------------------/

	Original dialogue:
	==================
A1 - Ben moi, j'en bave actuellement parce qu'il faut que je refasse mes portes,
la peinture. Alors j'ai d�cap� � la chaleur. Ca part bien. Mais pas partout.
C'est un travail dingue, hein? 
B1- heu, tu as essay� de.  Tu as d�cap� tes portes? 
A2- Ouais, �a part tr�s bien � la chaleur, mais dans les coins, tout , les
moulures, c'est infaisable. [plus fort] Les moulures.  
B2- Quelle chaleur? La lampe � souder? 
A3- Ouais, avec un truc sp�cial.  
B3- Faut une brosse, dure, une brosse m�tallique.  
A4- Oui, mais j'attaque le bois.  
B4- T'attaques le bois.  
A5- [pause 5 secondes] Enfin je sais pas. C'est un boulot dingue, hein?
C'est plus de boulot que de racheter une porte, hein? 
B5- Oh, c'est pour �a qu'il vaut mieux laiss... il vaut mieux simplement poncer,
repeindre par dessus 
A6- Ben oui, mais si on est les quinzi�mes � se dire �a 
B6- Ah oui.  
A7- Y a d�j� trois couches de peinture, hein, dessus.  
B7- Remarque, si elle tient bien, la peinture, l� o� elle est �caill�e, on
peut enduire. De l'enduit � l'eau, ou 
A8- Oui, mais l'�tat de surface est pas joli, quoi, �a fait laque, tu sais,
�a fait vieille porte.  


	English translation:
	===================
A1-  I have to repaint my doors. I've burned off the old paint. It worked OK, but not everywhere. It's really tough work! [...] In the corners, all this, the mouldings, it's not feasible !
[...]
B1- You have to use a wire brush   
A2- Yes, but that wrecks the wood   
B2- It wrecks the wood...   
[pause 5 seconds]
A3- It's crazy! It's more trouble than buying a new door.
B3- Oh, that's why you'd do better just sanding and repainting them.   
A4- Yes, but if we are the fifteenth ones to think of that   
B4- Oh, yeah...   
A5- There are already three layers of paint   
B5- If the old remaining paint sticks well, you can fill in the peeled spots with filler compound   
A6- Yeah, but the surface won't look great. It'll look like an old door.

	Content to reconstruct:
	=======================
A1- repaint, burn-off, mouldings, tough work
B1- wire brush
A2- wood wrecked
A3- tough work
B3- sanding
A5- several layers
B5- filler compound
A6- not nice surface
                                                                              */


	/*------------------------------------------------*/
	/* Domain knowledge starts here                   */
	/*------------------------------------------------*/

	/* pay attention to the fact that the following
	   lines are not Prolog clauses, but will be interpreted
	   by the programme. 
	   The only Prolog predicates are:
	   - initial_situation
	   - action
	   - default
	   - preference
	   - incompatible
	   -  <===	(physical effects)
	   -  <---	(results of actions)- 
	 */ 

	% initial facts
	initial_situation(-nice_doors).
	initial_situation(-nice_surface).
	initial_situation(mouldings).
	initial_situation(soft_wood).
	initial_situation(several_layers).


	% actions
/*	action(repaint).
	action(burn_off).
	action(wire_brush).
	action(sanding).
	action(filler_compound).
*/

	% defaults
	default(-soft_wood).
	default(-several_layers).
	default(-wood_wrecked).

	% causal clauses
	nice_surface <=== burn_off.		
	nice_surface <=== sanding + -several_layers + -wood_wrecked.
	nice_surface <=== filler_compound + -wood_wrecked.
	nice_doors <=== repaint + nice_surface.

	
	% physical consequences
	tough_work <=== burn_off + mouldings + -wire_brush.
	wood_wrecked <=== wire_brush + soft_wood.
	-nice_surface <=== wood_wrecked.


	% preferences (termes positifs seulement)
	preference(tough_work, -10).
	preference(nice_doors, 20).
