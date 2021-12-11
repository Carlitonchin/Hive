:- import(utiles).
:- import(estado).
:- import(tablero).
:- import(movimiento).
:- [utiles, estado, tablero, movimiento].

verificarFin(Jugador):-
    (
        empate,
        assert(juegoTerminado(empate))
    );
    (
        victoria(blancas),
        assert(juegoTerminado(blancas))
    );
    (
        victoria(negras),
        assert(juegoTerminado(negras))
    );
    !.

cambioDeTurno :-
    turno(blancas),
    verificarFin(blancas),
    cantPiezasJugadasMas1,
    retract(turno(blancas)),
    assert(turno(negras)),
    !.
cambioDeTurno :-
    turno(negras),
    verificarFin(negras),
    cantPiezasJugadasMas1,
    retract(turno(negras)),
    assert(turno(blancas)),
    !.

pasarTurno:-
    turno(negras),!,
    retract(turno(negras)),
    assert(turno(blancas)).

pasarTurno :-
    turno(blancas),!,
    retract(turno(blancas)),
    assert(turno(negras)).

mover(MiFicha,Ficha, Jugador, Cara):-
    not(juegoTerminado(_)),
    turno(JugadorActual),
    abejaJugada(JugadorActual),
    cantPiezasJugadas(JugadorActual,NumeroTurno),
    not(piezaBloqueada(JugadorActual,MiFicha,NumeroTurno,JugadorActual)),
    mover_(MiFicha,Ficha, Jugador, Cara),
    ultimaPiezaMovida(JugadorActual, Ultima),
    retract(ultimaPiezaMovida(JugadorActual, Ultima)),
    assert(ultimaPiezaMovida(JugadorActual, MiFicha)),
    cambioDeTurno.

daBola(Pillbug, CaraTomar, CaraDejar):-
    not(juegoTerminado(_)),
    turno(JugadorActual),
    abejaJugada(JugadorActual),
    intentaDarBola(Pillbug, CaraTomar, CaraDejar),
    cambioDeTurno.


subirEscarabajo(Escarabajo,Ficha,Jugador,Cara):-
    not(juegoTerminado(_)),
    turno(JugadorActual),
    abejaJugada(JugadorActual),
    intentaSubirEscarabajo(Escarabajo,Ficha,Jugador,Cara),
    cambioDeTurno.

agregarFicha(Pieza1):- % para la ficha inicial
    cantPiezasJugadas(blancas,0),
    assert(piezasJugadas(blancas,Pieza1)),
    retract(piezasSinJugar(blancas,Pieza1)),
    creaAristas(Pieza1,[0,2,1,1,1,-1,0,-2,-1,-1,-1,1]),
    assert(ultimaPiezaMovida(blancas, Pieza1)),
    ((Pieza1 = abeja,
        assert(abejaJugada(blancas)),
        cambioDeTurno
        );
    cambioDeTurno),
    !.
agregarFicha(Pieza1, Jugador2, Pieza2, Cara2):-
    not(juegoTerminado(_)),
    turno(Jugador1),
    not(piezasJugadas(Jugador1, Pieza1)),
    not(faltaAbeja4(Jugador1,Pieza1)),
    conectarNueva(Pieza1, Jugador2, Pieza2, Cara2),
    assert(piezasJugadas(Jugador1,Pieza1)),
    retract(piezasSinJugar(Jugador1,Pieza1)),
    (
        (
        ultimaPiezaMovida(Jugador1, Ultima),
        retract(ultimaPiezaMovida(Jugador1, Ultima)),
        assert(ultimaPiezaMovida(Jugador1, Pieza1))
        );
        assert(ultimaPiezaMovida(Jugador1, Pieza1))
    ),
    ((Pieza1 = abeja,
        assert(abejaJugada(Jugador1)),
        cambioDeTurno
        );
    cambioDeTurno),
    !.

faltaAbeja4(Jugador,Pieza):-
    cantPiezasJugadas(Jugador,N),
    N is 3,
    not(abejaJugada(Jugador)),
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

programa2:-
    agregarFicha(escarabajo1),
    agregarFicha(hormiga1, blancas, escarabajo1, 2),

    agregarFicha(hormiga2, blancas, escarabajo1, 4),
    agregarFicha(abeja, negras, hormiga1, 3),

    spy(restauraEstadoAnterior),
    mover(escarabajo1, hormiga1, negras, 5).
    % mover(hormiga2, hormiga1, negras, 4),
    % agregarFicha(saltamontes1, negras, abeja, 2),

    % mover(escarabajo1,hormiga1,negras,5),
    % agregarFicha(hormiga2,negras,saltamontes1,3),

programa3:-
    agregarFicha(escarabajo1),
    agregarFicha(hormiga1, blancas, escarabajo1, 5),
    agregarFicha(hormiga1, blancas, escarabajo1, 2),
    agregarFicha(hormiga2, negras, hormiga1, 5),
    (subirEscarabajo(escarabajo1,hormiga1,negras,2);
    mover(hormiga1, escarabajo1, blancas, 1)
    ),
    (
    subirEscarabajo(escarabajo1,hormiga1,negras,2);
    agregarFicha(hormiga3, negras, hormiga2, 6)
    ).
%subirEscarabajo(escarabajo1,hormiga1,negras,2)

programa4:-
    agregarFicha(bola),
    agregarFicha(hormiga1,blancas,bola,2),

    agregarFicha(hormiga1,blancas,bola,4),
    agregarFicha(hormiga2,negras,hormiga1,1),

    agregarFicha(hormiga2,blancas,bola,5),
    agregarFicha(escarabajo1,negras,hormiga2,3).

    % trace,
    % daBola(bola,4,1).

    % agregarFicha(hormiga2,blancas,bola,3),
    % agregarFicha(saltamontes1,negras,escarabajo1,6).

    % agregarFicha(escarabajo1,blancas,bola,4),
    % mover(saltamontes1,escarabajo1,negras,3).
