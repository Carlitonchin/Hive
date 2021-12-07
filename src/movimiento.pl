:- import(movimiento_abeja).
:- import(movimiento_hormiga).
:- [movimiento_abeja, movimiento_hormiga].

mover(abeja,Ficha, Jugador, Cara):-
    moverAbeja(Ficha, Jugador, Cara).

mover(MiFicha,Ficha, Jugador, Cara):-
    (MiFicha = hormiga1;
    MiFicha = hormiga2;
    MiFicha = hormiga3),
    moverHormiga(MiFicha ,Ficha, Jugador, Cara).