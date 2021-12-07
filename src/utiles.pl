:- module(utiles, [incrementoCircular6/2, decrementoCircular6/2, sumaCircular6/3, pertenece/3, pertenece/2]).

incrementoCircular6(X, Retorno):-
    sumaCircular6(X,1,Retorno).

decrementoCircular6(X, Retorno):-
    Dec is X - 1,
    Dec is 0,
    !,
    Retorno is 6.
decrementoCircular6(X, Retorno):-
    Retorno is X - 1.

sumaCircular6(S1, S2, Retorno):-
    S3 is S1+S2,
    mod7sin0(S3, Retorno).

mod7sin0(X,R):-
    X =< 6,
    R is X,
    !.
mod7sin0(X,R):-
    X1 is X - 6,
    mod7sin0(X1, R).

pertenece(X,Y,[]):-
    fail.
pertenece(X,Y,[X1,Y1|R]):-
    (X is X1 , Y is Y1) ; pertenece(X,Y,R).


pertenece(X,[X1|R]):-
    X = X1 ; pertenece(X,R).
