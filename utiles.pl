:- module(utiles, [incrementoCircular6/2, decrementoCircular6/2]).

incrementoCircular6(X, Retorno):-
    Inc is X + 1,
    Inc is 7,
    !,
    Retorno is 1.
incrementoCircular6(X, Retorno):-
    Retorno is X + 1.

decrementoCircular6(X, Retorno):-
    Dec is X - 1,
    Dec is 0,
    !,
    Retorno is 6.
decrementoCircular6(X, Retorno):-
    Retorno is X - 1.
