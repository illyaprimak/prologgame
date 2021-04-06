change([],_,[]).
change(['_','_'|Tail],[X,Y],[X,Y|NewTail]):-!,change(Tail,_,NewTail).
change(['-'|Tail],XY,['_'|NewTail]):-!,change(Tail,XY,NewTail).
change([H|Tail],XY,[H|NewTail]):-change(Tail,XY,NewTail).
 
step(A,B):-append(Begin,Tail,A),append([X,Y],End,Tail),
    X\='_',Y\='_',append(Begin,['-','-'],Temp),
    append(Temp,End,New),change(New,[X,Y],B).
 
show([]).
show([H|Tail]):-show(Tail),nl,write(H).
 
depth(A,B):-search1(B,[A]).
 
search1(B,[B|Tail]):-!,write('Результат роботи пошуку в глибину'),nl,show([B|Tail]),nl.
search1(B,[A|Tail]):-step(A,C),not(member(C,Tail)),search1(B,[C,A|Tail]).
 
 
width(A,B):-search2(B,[[A]]).
 
search2(B,[[B|Tail]|_]):-!,write('Результат роботи пошуку в ширину'),nl,show([B|Tail]),nl.
search2(B,[[A|T]|Tail]):-findall([C,A|T],(step(A,C),not(member(C,T))),L),
    append(Tail,L,New),search2(B,New).
 
h([],[],0).
h([H|T1],[H|T2],N):-!,h(T1,T2,N).
h([_|T1],[_|T2],N):-h(T1,T2,M),N is M+1.
 
 
searchA(A,B):-search3(B,[0:[A]]).
 
prolong(C:[A|Tail],C1:[B,A|Tail],End):-step(A,B),not(member(B,Tail)),h(B,End,Evr),C1 is C+1+Evr.
 
place([],L,L).
place([H|Tail],L,Ans):-placeone(H,L,Temp),place(Tail,Temp,Ans).
 
placeone(C:P,[C1:P1|Tail],[C:P,C1:P1|Tail]):-C=<C1,!.
placeone(C:P,[C1:P1|Tail],[C1:P1|NewTail]):-placeone(C:P,Tail,NewTail).
placeone(C:P,[],[C:P]).
 
search3(B,[_:[B|Tail]|_]):-!,write('Результат роботи A*-пошуку'),nl,show([B|Tail]),nl.
search3(B,[H|Tail]):-findall(Z,prolong(H,Z,B),L),place(L,Tail,New),search3(B,New).
 
all(A):-B=[b,b,b,b,a,a,a,a,'_','_'],
    depth(A,B),width(A,B),searchA(A,B).
