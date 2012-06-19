%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% JL Dessalles - février 2012 - www.dessalles.fr                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% implementation minimale du modele temporel


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Syntax
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s(FS) --> dp(CFS), ip(HFS), { wt(1,s), merge(HFS, CFS, FS) }.
ip(FS) --> tp(HFS), pp(CFS), {wt(1,ip), merge(HFS, CFS, FS) }.	% circonstanciel
ip(FS) --> tp(FS).		% pas de circonstanciel
tp(FS) --> vp(CFS), l(t,HFS), {wt(1,tp), merge(HFS, CFS, FS) }.	% temps
vp(FS) --> vp1(HFS), pp(CFS), {wt(1,vp), merge(HFS, CFS, FS) }.	% deuxième complément
vp(FS) --> vp1(FS).	% pas de deuxième complément
vp1(FS) --> l(v,HFS), dp(CFS), { wt(1,vp1), merge(HFS, CFS, FS) }.	% complément direct
vp1(FS) --> l(v,HFS), pp(CFS), { wt(1,vp1), merge(HFS, CFS, FS) }.	% complément indirect
vp1(FS) --> l(v,FS).	% pas de complément
pp(FS) --> l(p,HFS), dp(CFS), { wt(1,pp), merge(HFS, CFS, FS) }.
dp(FS) --> l(dp,FS), {wt(1,dp1)}.	% nom propre
dp(FS) --> l(d,HFS), l(n,CFS), { wt(1,dp2), merge(HFS, CFS, FS) }.	% nom déterminé
l(SyntCat, FS) --> [Word], {lexicon(Word, FS), wt(1,Word), checkF(synt:SyntCat, FS, _) }.

