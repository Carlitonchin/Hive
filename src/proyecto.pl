:- import(utiles).
:- import(estado).
:- import(movimiento).
:- [utiles, estado, movimiento].

cambioDeTurno :-
    turno(blancas),
    cantPiezasJugadasMas1,
    retract(turno(blancas)),
    assert(turno(negras)),
    !.
cambioDeTurno :-
    turno(negras),
    cantPiezasJugadasMas1,
    retract(turno(negras)),
    assert(turno(blancas)),
    !.

agregarFicha(Pieza1):- % para la ficha inicial
    cantPiezasJugadas(blancas,0),
    assert(piezasJugadas(blancas,Pieza1)),
    retract(piezasSinJugar(blancas,Pieza1)),
    creaAristas(Pieza1,[0,2,1,1,1,-1,0,-2,-1,-1,-1,1]),
    cambioDeTurno,
    !.
agregarFicha(Pieza1, Jugador2, Pieza2, Cara2):-
    turno(Jugador1),
    not(piezasJugadas(Jugador1, Pieza1)),
    not(faltaAbeja4(Jugador1,Pieza1)),
    conectar(Pieza1, Jugador2, Pieza2, Cara2),
    assert(piezasJugadas(Jugador1,Pieza1)),
    retract(piezasSinJugar(Jugador1,Pieza1)),
    cambioDeTurno,
    !.

faltaAbeja4(Jugador,Pieza):-
    cantPiezasJugadas(Jugador,N),
    N is 3,
    not(piezasJugadas(Jugador,abeja)),
    not(Pieza = abeja),
    !.

