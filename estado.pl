:- module(estado, [turno/1, rival/1, piezasSinJugar/2, piezasJugadas/2, cantPiezasJugadas/2, cantPiezasJugadasMas1/0]).

:- dynamic piezasSinJugar/2, turno/1, cantPiezasJugadas/2, piezasJugadas/2.

turno(blancas).

rival(R):-
    turno(X),
    X = blancas,
    R = negras,
    !.
rival(R):-
    turno(X),
    X = negras,
    R = blancas,
    !.

piezasSinJugar(Jugador, Pieza) :- fail.

piezasSinJugar(blancas, hormiga1).
piezasSinJugar(blancas, hormiga2).
piezasSinJugar(blancas, abeja).
piezasSinJugar(blancas, escarabajo).
piezasSinJugar(blancas, mariquita).
piezasSinJugar(blancas, mosquito).

piezasSinJugar(negras, hormiga1).
piezasSinJugar(negras, hormiga2).
piezasSinJugar(negras, abeja).
piezasSinJugar(negras, escarabajo).
piezasSinJugar(negras, mariquita).
piezasSinJugar(negras, mosquito).

piezasJugadas(Jugador, Pieza) :- fail.

cantPiezasJugadas(blancas, 0).
cantPiezasJugadas(negras, 0).

cantPiezasJugadasMas1 :-
    turno(Jugador),
    cantPiezasJugadas(Jugador, Cant),
    retract(cantPiezasJugadas(Jugador, Cant)),
    NewCant is Cant + 1,
    assert(cantPiezasJugadas(Jugador, NewCant)).