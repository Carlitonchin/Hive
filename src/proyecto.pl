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
    turno(JugadorActual),
    mover_(MiFicha,Ficha, Jugador, Cara),
    ultimaPiezaMovida(JugadorActual, Ultima),
    retract(ultimaPiezaMovida(JugadorActual, Ultima)),
    assert(ultimaPiezaMovida(JugadorActual, MiFicha)),
    cambioDeTurno.

agregarFicha(Pieza1):- % para la ficha inicial
    cantPiezasJugadas(blancas,0),
    assert(piezasJugadas(blancas,Pieza1)),
    retract(piezasSinJugar(blancas,Pieza1)),
    creaAristas(Pieza1,[0,2,1,1,1,-1,0,-2,-1,-1,-1,1]),
    assert(ultimaPiezaMovida(blancas, Pieza1)),
    cambioDeTurno,
    !.
agregarFicha(Pieza1, Jugador2, Pieza2, Cara2):-
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
    agregarFicha(hormiga1, blancas, escarabajo1, 2),

    agregarFicha(hormiga2, blancas, escarabajo1, 4),
    agregarFicha(abeja, negras, hormiga1, 3).

programa4:-
    agregarFicha(bola),!,
    agregarFicha(hormiga1, blancas, bola, 2),!,

    agregarFicha(hormiga1, blancas, bola, 4),!,
    agregarFicha(abeja, negras, hormiga1, 3),!,

    mover(hormiga1,hormiga1,negras,4),!,
    agregarFicha(saltamontes1, negras, hormiga1, 1),!.

    % spy(daBola/3),
    % daBola(bola,2,5).

    % subirEscarabajo(escarabajo1,hormiga1,negras,5).
    % spy(moverEscarabajo/4),
    % mover(escarabajo1,c1,c2,2).
