:- import(utiles_movimiento).
:- import(utiles).
:- import(tablero).


:- [utiles_movimiento, tablero, utiles].

:-dynamic caminoAnterior/1.

guardarCamino(Camino):-
    retractall(caminoAnterior(_)),
    assert(caminoAnterior(Camino)).

moverHormiga(Hormiga, Ficha, Jugador, Cara):-
    turno(JugadorActual),
    arista(Jugador,Ficha,Cara,X,Y),
    aristasDeLaPieza(JugadorActual, Hormiga, L),
    retractall(camino(_)),
    assert(camino([L])),
    eliminaAristas(Hormiga, L),
    eliminaConexiones(Hormiga),
    ((moverPorTodasLasCaras(Hormiga, X, Y),
    findall([J1,P1,C1,J2,P2,C2], conexion(J1,P1,C1,J2,P2,C2), Bag),
    !,
    coordenadaCaras(Cara, X, Y, R),
    creaConexiones(Hormiga,R),
    creaAristas(Hormiga,R),
    vaciarPapeleras);
    
    (restablecerPapeleras,
    fail))
    .

moverPorCara(Hormiga, Direccion, X, Y):-
    turno(Jugador1),
    camino([Casilla|R]),
    casillaLibreNoCerrada(Casilla, Direccion, CasillaDestino),!,
    not(pertenece(CasillaDestino, [Casilla|R])),!,
    not(casillaSolitaria(CasillaDestino)),!,
    retractall(camino(_)),
    assert(camino([CasillaDestino,Casilla|R])),
    (
    (pertenece(X,Y,CasillaDestino),  
    reestablecerPapelerasSinVaciarlas,
    caminoValido(Hormiga, [Casilla|R]),
    !
    );
    (
    moverPorTodasLasCaras(Hormiga, X, Y)
    )),
    !.

moverPorTodasLasCaras(Hormiga, X, Y):-
    (camino(Camino),
    guardarCamino(Camino),
    len(Camino,L1),
    moverPorCara(Hormiga, 1, X, Y),
    !
    );

    (
    retractall(camino(_)),
    caminoAnterior(Camino),
    assert(camino(Camino)),
    len(Camino,L2),
    moverPorCara(Hormiga, 2, X, Y),
    !
    );

    (
    retractall(camino(_)),
    caminoAnterior(Camino),
    assert(camino(Camino)),
    len(Camino,L3),
    moverPorCara(Hormiga, 3, X, Y),
    !
    );

    (
    retractall(camino(_)),
    caminoAnterior(Camino),
    assert(camino(Camino)),
    len(Camino,L4),
    moverPorCara(Hormiga, 4, X, Y),
    !
    );

    (
    retractall(camino(_)),
    caminoAnterior(Camino),
    assert(camino(Camino)),
    len(Camino,L5),
    moverPorCara(Hormiga, 5, X, Y),
    !
    );

    (
    retractall(camino(_)),
    caminoAnterior(Camino),
    assert(camino(Camino)),
    len(Camino,L6),
    moverPorCara(Hormiga, 6, X, Y),
    !
    ).


