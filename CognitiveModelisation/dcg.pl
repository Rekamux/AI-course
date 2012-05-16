/*  Grammaire DCG d'un fragment élémentaire du Français */
/* François Yvon - Mars 98 */

s  --> gn, gv.      /* Structure de phrase */
gn --> det, n.      /* Groupe nominal simple */
%gn --> gn, gnp.     /* Groupe nominal plus groupe nominal prépositionnel */
gn --> det, n, gnp.     /* Groupe nominal plus groupe nominal prépositionnel */
gv --> v.           /* Groupe verbal, verbe intransitif */
gv --> v, gn.       /* Groupe verbal, verbe + COD : aimer X */
gv --> v, gnp.      /* Groupe verbal, verbe + COI : medire de X */
gv --> v, gn, gnp.  /* Groupe verbal, verbe + COD + COI : donner X a Y */
gv --> v, gnp, gnp. /* Groupe verbal, verbe + COD + COI : parler de X a Y */
gnp --> pp, gn.     /* Groupe nominal prepositionnel */

/* Terminaux */
det --> [la]; [ma]; [sa]; [une].
n   --> [fille]; [soeur]; [tante]; [bru]; [belle-mere].
n   --> [voisine]; [cousine].
v   --> [aime]; [parle]; [agace]; [hait]; [pleure].
pp  --> [de]; [a].
