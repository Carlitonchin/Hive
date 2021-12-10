:- import(movimiento_abeja).
:- import(movimiento_hormiga).
:- import(movimiento_saltamontes).
:- import(movimiento_aranha).

:- import(movimiento_escarabajo).
:- import(movimiento_mosquito).
:- [movimiento_abeja, movimiento_hormiga, movimiento_saltamontes, movimiento_aranha, movimiento_escarabajo, movimiento_mosquito].


mover_(abeja,Ficha, Jugador, Cara):-
    !,
    moverAbeja(abeja,Ficha, Jugador, Cara).

mover_(MiFicha,Ficha, Jugador, Cara):-
    (MiFicha = hormiga1;
    MiFicha = hormiga2;
    MiFicha = hormiga3),
    !,
    moverHormiga(MiFicha ,Ficha, Jugador, Cara).

mover_(Saltamontes, Ficha,Jugador,Cara):-
    (Saltamontes = saltamontes1;
    Saltamontes = saltamontes2;
    Saltamontes = saltamontes3),
    !,
    moverSaltamontes(Saltamontes, Ficha,Jugador,Cara).

mover_(Aranha, Ficha,Jugador,Cara):-
    (Aranha = aranha1;
    Aranha = aranha2),
    !,
    moverAranha(Aranha, Ficha, Jugador, Cara).

mover_(Escarabajo,Ficha,Jugador,Cara):-
    (Escarabajo = escarabajo1;
    Escarabajo = escarabajo2),
    !,
    moverEscarabajo(Escarabajo, Ficha, Jugador, Cara).
mover_(mosquito, Ficha, Jugador, Cara):-
    moverMosquito(mosquito, Ficha, Jugador, Cara).
