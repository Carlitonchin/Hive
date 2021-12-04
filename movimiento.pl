:- import(estado).
:- [estado].


:- dynamic arista/5, conexion/4.


arista(Jugador, Pieza, Cara, X, Y):-
    fail.
conexion(Jugador1,Pieza1,Jugador2,Pieza2):-
    fail.

conectar(Pieza1, Jugador2, Pieza2, Cara2):-
    arista(Jugador2, Pieza2, Cara2, X, Y),
    coordenadaCaras(Cara2, X, Y, R),
    not(encimaDePieza(R)),
    (not(conexionesConRival(R)) ; cantPiezasJugadas(negras,0)),
    creaConexiones(Pieza1, R),
    creaAristas(Pieza1, R).

creaConexiones(Pieza, []).
creaConexiones(Pieza1, [X,Y|R]):-
    turno(Jugador1),
    (arista(Jugador2,Pieza2,_,X,Y),
    assert(conexion(Jugador1,Pieza1,Jugador2,Pieza2)));
    creaConexiones(Pieza1, R),
    !.
    

conexionesConRival([X,Y|R]):-
    rival(Rival),
    (arista(Rival,A,B,X,Y) ; conexionesConRival(R)).
    
encimaDePieza([X1,Y1,X2,Y2|R]):-
    arista(Jugador, Pieza, 1, X1, Y1),
    arista(Jugador, Pieza, 2, X2, Y2),
    !.
    

coordenadaCaras(CaraAConectar, X, Y, R):-
    CaraAConectar is 1,
    X1 is X,
    Y1 is Y+4,
    X2 is X+1,
    Y2 is Y+3,
    X3 is X+1,
    Y3 is Y+1,
    X4 is X,
    Y4 is Y,
    X5 is X-1,
    Y5 is Y+1,
    X6 is X-1,
    Y6 is Y+3,
    R = [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],
    !.
coordenadaCaras(CaraAConectar, X, Y, R):-
    CaraAConectar is 2,
    X1 is X+1,
    Y1 is Y+3,
    X2 is X+2,
    Y2 is Y+2,
    X3 is X+2,
    Y3 is Y,
    X4 is X+1,
    Y4 is Y-1,
    X5 is X,
    Y5 is Y,
    X6 is X,
    Y6 is Y+2,
    R = [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],
    !.
coordenadaCaras(CaraAConectar, X, Y, R):-
    CaraAConectar is 3,
    X1 is X+1,
    Y1 is Y+1,
    X2 is X+2,
    Y2 is Y,
    X3 is X+2,
    Y3 is Y-2,
    X4 is X+1,
    Y4 is Y-3,
    X5 is X,
    Y5 is Y-2,
    X6 is X,
    Y6 is Y,
    R = [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],
    !.
coordenadaCaras(CaraAConectar, X, Y, R):-
    CaraAConectar is 4,
    X1 is X,
    Y1 is Y,
    X2 is X+1,
    Y2 is Y-1,
    X3 is X+1,
    Y3 is Y-3,
    X4 is X,
    Y4 is Y-4,
    X5 is X-1,
    Y5 is Y-3,
    X6 is X-1,
    Y6 is Y-1,
    R = [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],
    !.
coordenadaCaras(CaraAConectar, X, Y, R):-
    CaraAConectar is 5,
    X1 is X-1,
    Y1 is Y+1,
    X2 is X,
    Y2 is Y,
    X3 is X,
    Y3 is Y-2,
    X4 is X-1,
    Y4 is Y-3,
    X5 is X-2,
    Y5 is Y-2,
    X6 is X-2,
    Y6 is Y,
    R = [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],
    !.
coordenadaCaras(CaraAConectar, X, Y, R):-
    CaraAConectar is 6,
    X1 is X-1,
    Y1 is Y+3,
    X2 is X,
    Y2 is Y+2,
    X3 is X,
    Y3 is Y,
    X4 is X-1,
    Y4 is Y-1,
    X5 is X-2,
    Y5 is Y,
    X6 is X-2,
    Y6 is Y+2,
    R = [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],
    !.

creaAristas(Pieza, [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6]):-
    turno(Jugador),
    assert(arista(Jugador, Pieza, 1, X1, Y1)),
    assert(arista(Jugador, Pieza, 2, X2, Y2)),
    assert(arista(Jugador, Pieza, 3, X3, Y3)),
    assert(arista(Jugador, Pieza, 4, X4, Y4)),
    assert(arista(Jugador, Pieza, 5, X5, Y5)),
    assert(arista(Jugador, Pieza, 6, X6, Y6)).
