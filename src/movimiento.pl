:- import(movimiento_abeja).
:- import(movimiento_hormiga).
:- import(movimiento_saltamontes).
:- import(movimiento_aranha).

:- import(movimiento_escarabajo).
:- import(movimiento_mariquita).
:- import(movimiento_mosquito).
:- import(movimiento_pillbug).
:- [movimiento_abeja, movimiento_hormiga, movimiento_saltamontes, movimiento_aranha, movimiento_escarabajo, movimiento_mosquito, movimiento_pillbug, movimiento_mariquita].


intentaDarBola(Pillbug, CaraTomar, CaraDejar):-
    turno(JugadorActual),
    (Pillbug = bola;
        (Pillbug = mosquito,
        conexion(JugadorActual,Pillbug,Cara1,Jugador2,bola,Cara2)
        )
    ),
    !,
    daBola_(Pillbug, CaraTomar, CaraDejar).

intentaSubirEscarabajo(Escarabajo,Ficha,Jugador,Cara):-
    turno(JugadorActual),
    (
        Escarabajo = escarabajo1;
        Escarabajo = escarabajo2;
        (
            Escarabajo = mosquito,
            (
            conexion(JugadorActual, Escarabajo, _, _, escarabajo1, _);
            conexion(JugadorActual, Escarabajo, _, _, escarabajo2, _)
            )
        )
    ),
    subirEscarabajo(Escarabajo, Ficha, Jugador, Cara).

mover_(abeja,Ficha, Jugador, Cara):-
    !,
    moverAbeja(abeja,Ficha, Jugador, Cara).

mover_(mariquita, Ficha, Jugador, Cara):-
    !,
    moverMariquita(mariquita, Ficha, Jugador, Cara).

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
    !,
    moverMosquito(mosquito, Ficha, Jugador, Cara).

mover_(bola, Ficha, Jugador,Cara):-
    !,
    moverAbeja(bola, Ficha, Jugador, Cara).