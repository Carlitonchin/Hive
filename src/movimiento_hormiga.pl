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
    assert(camino([L])),
    eliminaAristas(Hormiga, L),
    eliminaConexiones(Hormiga),
    moverPorTodasLasCaras(Hormiga, X, Y),
    
    writeln('Maria'),
    findall([J1,P1,C1,J2,P2,C2], conexion(J1,P1,C1,J2,P2,C2), Bag),
    writeln(Bag),
    
    !,
    coordenadaCaras(Cara, X, Y, R),
    creaConexiones(Hormiga,R),
    creaAristas(Hormiga,R),
    vaciarPapeleras.

moverPorCara(Hormiga, Direccion, X, Y):-
    turno(Jugador1),
    camino([Casilla|R]),
    casillaLibreNoCerrada(Casilla, Direccion, CasillaDestino),!,
    writeln('       Casilla libre no cerrada'),
    not(pertenece(CasillaDestino, [Casilla|R])),!,
    writeln('       No ha sido visitada antes'),
    not(casillaSolitaria(CasillaDestino)),!,
    writeln('       No esta en el vacio'),
    retractall(camino(_)),
    assert(camino([CasillaDestino,Casilla|R])),
    (
    (pertenece(X,Y,CasillaDestino),
    writeln('       Era la casilla q buscaba'),
    writeln(Hormiga),
    writeln([Casilla|R]),    
    reestablecerPapelerasSinVaciarlas,
    writeln('Checkeando si el camino es valido'),
    caminoValido(Hormiga, [Casilla|R]),
    !,
    writeln('       El camino era valido'));
    (
    writeln('       No es la casilla q buscaba'),
    moverPorTodasLasCaras(Hormiga, X, Y),
    writeln('       ######'))),
    !.

moverPorTodasLasCaras(Hormiga, X, Y):-
    (camino(Camino),
    write('Casilla actual: '), writeln(Camino),
    guardarCamino(Camino),
    len(Camino,L1),
    write('    Intentando por cara1, len(camino)='), writeln(L1),
    moverPorCara(Hormiga, 1, X, Y),
    !
    );

    (
    retractall(camino(_)),
    caminoAnterior(Camino),
    assert(camino(Camino)),
    len(Camino,L2),
    write('    Intentando por cara2, len(camino)='), writeln(L2),
    moverPorCara(Hormiga, 2, X, Y),
    !
    );

    (
    retractall(camino(_)),
    caminoAnterior(Camino),
    assert(camino(Camino)),
    len(Camino,L3),
    write('    Intentando por cara3, len(camino)='), writeln(L3),
    moverPorCara(Hormiga, 3, X, Y),
    !
    );

    (
    retractall(camino(_)),
    caminoAnterior(Camino),
    assert(camino(Camino)),
    len(Camino,L4),
    write('    Intentando por cara4, len(camino)='), writeln(L4),
    moverPorCara(Hormiga, 4, X, Y),
    !
    );

    (
    retractall(camino(_)),
    caminoAnterior(Camino),
    assert(camino(Camino)),
    len(Camino,L5),
    write('    Intentando por cara5, len(camino)='), writeln(L5),
    moverPorCara(Hormiga, 5, X, Y),
    !
    );

    (
    retractall(camino(_)),
    caminoAnterior(Camino),
    assert(camino(Camino)),
    len(Camino,L6),
    write('    Intentando por cara6, len(camino)='), writeln(L6),
    moverPorCara(Hormiga, 6, X, Y),
    !
    ).


