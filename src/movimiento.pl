:- import(movimiento_abeja).
:- import(movimiento_hormiga).
:- import(movimiento_saltamontes).
:- import(movimiento_aranha).

:- [movimiento_abeja, movimiento_hormiga, movimiento_saltamontes, movimiento_aranha].

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
