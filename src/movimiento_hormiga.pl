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
    !,

    % findall([C1,J2,F2,C2], conexion(JugadorActual,Hormiga,C1,J2,F2,C2),K),
    % findall([C,XX,YY],arista(JugadorActual,Hormiga,C,XX,YY),K1),
    % imprimeLista(K1),
    % imprimeLista(K),

    (eliminaAristasPermanente(Hormiga); true),
    (eliminaConexionesPermanente(Hormiga); true),
    coordenadaCaras(Cara, X, Y, R),
    creaConexiones(Hormiga,R),
    creaAristas(Hormiga,R),
    vaciarPapeleras,!);
    
    (restablecerPapeleras,
    fail))
    .

moverPorCara(Hormiga, Direccion, X, Y):-
    turno(Jugador1),
    camino([Casilla|R]),
    casillaLibreNoCerrada(Casilla, Direccion, CasillaDestino),
    not(pertenece(CasillaDestino, [Casilla|R])),
    not(casillaSolitaria(CasillaDestino)),
    retractall(camino(_)),
    assert(camino([CasillaDestino,Casilla|R])),
    % len([CasillaDestino,Casilla|R],Len),
    % findall([J1,F1,C1,J2,F2,C2], conexion(J1,F1,C1,J2,F2,C2),K),
    % findall([J,P,C,XX,YY],arista(J,P,C,XX,YY),K1),
    % writeln(['len: ',Len,' dir: ',Direccion]),
    % imprimeLista(K1),
    % imprimeLista(K),
    (
    (pertenece(X,Y,CasillaDestino), !, 
    % reestablecerPapelerasSinVaciarlas,
    caminoValido(Hormiga, [CasillaDestino, Casilla|R])
    );
    (
    moverPorTodasLasCaras(Hormiga, X, Y)
    )),
    !.

moverPorTodasLasCaras(Hormiga, X, Y):-
    (camino(Camino),
    guardarCamino(Camino),
    moverPorCara(Hormiga, 1, X, Y),
    !
    );

    (
    retractall(camino(_)),
    caminoAnterior(Camino),
    assert(camino(Camino)),
    moverPorCara(Hormiga, 2, X, Y),
    !
    );

    (
    retractall(camino(_)),
    caminoAnterior(Camino),
    assert(camino(Camino)),
    moverPorCara(Hormiga, 3, X, Y),
    !
    );

    (
    retractall(camino(_)),
    caminoAnterior(Camino),
    assert(camino(Camino)),
    moverPorCara(Hormiga, 4, X, Y),
    !
    );

    (
    retractall(camino(_)),
    caminoAnterior(Camino),
    assert(camino(Camino)),
    moverPorCara(Hormiga, 5, X, Y),
    !
    );

    (
    retractall(camino(_)),
    caminoAnterior(Camino),
    assert(camino(Camino)),
    moverPorCara(Hormiga, 6, X, Y),
    !
    );

    caminoAnterior([_|CaminoViejo]),
    retractall(caminoAnterior(_)),
    assert(caminoAnterior(CaminoViejo)),
    fail.


