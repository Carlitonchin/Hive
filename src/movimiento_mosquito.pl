:- import(utiles_movimiento).
:- import(utiles).
:- import(tablero).
:- import(movimiento_abeja).
:- import(movimiento_hormiga).
:- import(movimiento_aranha).
:- import(movimiento_saltamontes).
:- import(movimiento_escarabajo).


:- [utiles_movimiento, tablero, utiles, movimiento_abeja, movimiento_hormiga, movimiento_aranha, movimiento_saltamontes, movimiento_escarabajo].

moverMosquito(mosquito, Pieza, Jugador, Cara):-
    turno(JugadorActual),
    conexion(JugadorActual,mosquito,_,_,PiezaAdyacente,_),
    not(PiezaAdyacente = mosquito),
    moverComoAdyacente(mosquito, PiezaAdyacente,Pieza, Jugador, Cara).

moverComoAdyacente(mosquito, PiezaAdyacente,Ficha, Jugador, Cara):-
    (
        PiezaAdyacente = abeja,!,
        moverAbeja(mosquito,Ficha,Jugador,Cara)
    );
    (
        (PiezaAdyacente = hormiga1;
        PiezaAdyacente = hormiga2;
        PiezaAdyacente = hormiga3),!,
        moverHormiga(mosquito, Ficha, Jugador, Cara)
    );
    (
        (PiezaAdyacente = aranha1;
         PiezaAdyacente = aranha2),!,
        moverAranha(mosquito, Ficha, Jugador, Cara)
    );
    (
        (PiezaAdyacente = escarabajo1;
         PiezaAdyacente = escarabajo2),!,
        moverEscarabajo(mosquito, Ficha, Jugador, Cara)
    );
    (
        (   PiezaAdyacente = saltamontes1;
            PiezaAdyacente = saltamontes1;
            PiezaAdyacente = saltamontes1
            ),!,
            moverSaltamontes(mosquito,Ficha,Jugador,Cara)
    ).