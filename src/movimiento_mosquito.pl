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
    PiezaAdyacente = abeja,
    not(debajoDeEscarabajos(Jugador,Ficha,JugadorActual,mosquito)),
    !,
    moverAbeja(mosquito,Ficha,Jugador,Cara).

moverComoAdyacente(mosquito, PiezaAdyacente,Ficha, Jugador, Cara):-
    (PiezaAdyacente = hormiga1;
    PiezaAdyacente = hormiga2;
    PiezaAdyacente = hormiga3),
    not(debajoDeEscarabajos(Jugador,Ficha,JugadorActual,mosquito)),
    !,
    moverHormiga(mosquito, Ficha, Jugador, Cara).
    
    
moverComoAdyacente(mosquito, PiezaAdyacente,Ficha, Jugador, Cara):-
    (PiezaAdyacente = aranha1;
    PiezaAdyacente = aranha2),
    not(debajoDeEscarabajos(Jugador,Ficha,JugadorActual,mosquito)),
    !,
    moverAranha(mosquito, Ficha, Jugador, Cara).


moverComoAdyacente(mosquito, PiezaAdyacente,Ficha, Jugador, Cara):-
        turno(JugadorActual),
        (PiezaAdyacente = escarabajo1;
        PiezaAdyacente = escarabajo2;
        debajoDeEscarabajos(Jugador,Ficha,JugadorActual,mosquito)
        ),!,
        moverEscarabajo(mosquito, Ficha, Jugador, Cara).
    

moverComoAdyacente(mosquito, PiezaAdyacente,Ficha, Jugador, Cara):-
        (PiezaAdyacente = saltamontes1;
        PiezaAdyacente = saltamontes2;
        PiezaAdyacente = saltamontes3
        ),
        not(debajoDeEscarabajos(Jugador,Ficha,JugadorActual,mosquito)),
        !,
        moverSaltamontes(mosquito,Ficha,Jugador,Cara).