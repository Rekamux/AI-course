
% example(Correctness, Sentence, Comment...).

example(1, "Pierre ronfle _PP", 'Pendant sa sieste de l\'après-midi, Pierre a ronflé').
example(1, "Pierre ronfle _PP en une heure", 'Une heure après avoir commencé à dormir, Pierre a commencé à ronfler').
example(1, "Pierre ronfle pendant une heure _PP", 'Une heure du sommeil de Pierre a été accompagnée par ses ronflements').
example(0, "Pierre mange du gâteau _PP en une heure", 'Pierre a mis une heure à manger son gâteau').
example(1, "Pierre mange du gâteau pendant une heure _PP", 'Pierre a mangé du gâteau de 14h à 15h, sans nécessairement le terminer').
example(1, "Pierre mange le gâteau pendant une heure _PP", 'Pierre a mangé -sans nécessairement le terminer- le gâteau spécifique pendant une heure.').
example(1, "Pierre mange le gâteau pendant le spectacle _PP", 'La durée du spectacle a été suffisante pour Pierre pour manger le gâteau').
example(1, "Pierre mange le gâteau _PP en une heure", 'Pierre a mangé et terminé le gâteau en une heure').
example(1, "Pierre aime le gâteau _PP", 'Pierre a fini de manger le gâteau et il l\'a trouvé bon').
example(1, "Pierre aime le gâteau _IMP", 'Pierre est décédé mais il aimait ce gâteau, ou Pierre a changé et n\'aime plus ce gâteau, ou La recette du gâteau a changé et Pierre ne l\'aime pas').
example(1, "Pierre aime le gâteau _IMP en 2010", 'Pierre n\'aime plus le gâteau, sois parce que ses goûts ont changé, soit parce que le gâteau a changé').

