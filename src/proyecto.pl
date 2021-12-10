:- import(utiles).
:- import(estado).
:- import(tablero).
:- import(movimiento).
:- [utiles, estado, tablero, movimiento].

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

mover(MiFicha,Ficha, Jugador, Cara):-
    mover_(MiFicha,Ficha, Jugador, Cara),
    cambioDeTurno.

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
    conectarNueva(Pieza1, Jugador2, Pieza2, Cara2),
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

factorial(0):-
    trace,
    write('kk').
factorial(X):-
    Y is X - 1,
    write_ln(Y),
    !,
    factorial(Y).

programa:-
    agregarFicha(escarabajo1),
    agregarFicha(hormiga1, blancas, escarabajo1, 2),

    agregarFicha(hormiga2, blancas, escarabajo1, 5),
    agregarFicha(abeja, negras, hormiga1, 3),

    mover(hormiga2, hormiga1, negras, 4),
    agregarFicha(saltamontes1, negras, abeja, 2),

    mover(escarabajo1,hormiga1,negras,5),
    agregarFicha(hormiga2,negras,saltamontes1,3),

    % spy(moverEscarabajo/4),
    
    mover(escarabajo1,abeja, negras,1),
    agregarFicha(hormiga3,negras,hormiga2,3),

    mover(escarabajo1,abeja, negras,1).



