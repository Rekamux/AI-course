
% example(Correctness, Sentence, Comment...).

example(1, "Pierre ronfle _PP", 'Pendant sa sieste de l\'apr�s-midi, Pierre a ronfl�').
example(1, "Pierre ronfle _PP en une heure", 'Une heure apr�s avoir commenc� � dormir, Pierre a commenc� � ronfler').
example(1, "Pierre ronfle pendant une heure _PP", 'Une heure du sommeil de Pierre a �t� accompagn�e par ses ronflements').
example(0, "Pierre mange du g�teau _PP en une heure", 'Pierre a mis une heure � manger son g�teau').
example(1, "Pierre mange du g�teau pendant une heure _PP", 'Pierre a mang� du g�teau de 14h � 15h, sans n�cessairement le terminer').
example(1, "Pierre mange le g�teau pendant une heure _PP", 'Pierre a mang� -sans n�cessairement le terminer- le g�teau sp�cifique pendant une heure.').
example(1, "Pierre mange le g�teau pendant le spectacle _PP", 'La dur�e du spectacle a �t� suffisante pour Pierre pour manger le g�teau').
example(1, "Pierre mange le g�teau _PP en une heure", 'Pierre a mang� et termin� le g�teau en une heure').
example(1, "Pierre aime le g�teau _PP", 'Pierre a fini de manger le g�teau et il l\'a trouv� bon').
example(1, "Pierre aime le g�teau _IMP", 'Pierre est d�c�d� mais il aimait ce g�teau, ou Pierre a chang� et n\'aime plus ce g�teau, ou La recette du g�teau a chang� et Pierre ne l\'aime pas').
example(1, "Pierre aime le g�teau _IMP en 2010", 'Pierre n\'aime plus le g�teau, sois parce que ses go�ts ont chang�, soit parce que le g�teau a chang�').

