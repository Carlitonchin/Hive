:- import(tablero).
:- import(utiles).

:- [tablero, utiles].



casillaLibreNoCerrada(L, Direccion, CasillaDestino):-
    coordenadasDeArista(L,Direccion,X,Y),
    coordenadaCaras(Direccion,X,Y,Casilla),
    
    incrementoCircular6(Direccion,Adyacente1),
    coordenadasDeArista(L,Adyacente1,X1,Y1),
    decrementoCircular6(Direccion,Adyacente2),
    coordenadasDeArista(L,Adyacente2,X2,Y2),

    coordenadaCaras(Adyacente1,X1,Y1,Casilla1),
    coordenadaCaras(Adyacente2,X2,Y2,Casilla2),
    !,
    (casillaVacia(Casilla1) ; casillaVacia(Casilla2)),
    casillaVacia(Casilla),
    CasillaDestino = Casilla.

casillaLibreNoCerrada(Pieza,Jugador,Direccion,CasillaDestino):-
    casillaVacia(Pieza, Jugador, Direccion),
    incrementoCircular6(Direccion, Adyacente1),
    decrementoCircular6(Direccion, Adyacente2),
    (casillaVacia(Pieza,Jugador,Adyacente1) ; casillaVacia(Pieza,Jugador,Adyacente2)),
    
    arista(Jugador,Pieza,Direccion,A,B),
    coordenadaCaras(Direccion,A,B,CasillaDestino).
    

casillaVacia([X1,Y1,X2,Y2|R]):-
    not((arista(J,P,A,X1,Y1), arista(J,P,B,X2,Y2))).
casillaVacia(Pieza,Jugador,Direccion):-
    arista(Jugador,Pieza,Direccion,X,Y), 
    coordenadaCaras(Direccion,X,Y,[X1,Y1,X2,Y2|R]), % dos caras de la casilla q esta en la direccion
    not((arista(J,P,A,X1,Y1), arista(J,P,B,X2,Y2))). % que las 2 aristas no pertenezcan a una misma ficha

restablecerPapeleras:-
    reestablecerPapelerasSinVaciarlas,
    vaciarPapeleras.
    
reestablecerPapelerasSinVaciarlas:-
    write('1'),
    findall([Jugador,Pieza,Cara,X,Y], papeleraAristas(Jugador,Pieza,Cara,X,Y), A),
    write('2'),
    reestableceAristas(A),
    write('3'),
    findall([Jugador1,Pieza1,Cara1,Jugador2,Pieza2,Cara2], papeleraConexiones(Jugador1,Pieza1,Cara1,Jugador2,Pieza2,Cara2), B),
    write('4'),
    reestableceConexiones(B),
    write('5').

reestableceAristas([]).
reestableceAristas([[Jugador,Pieza,Cara,X,Y]|R]):-
    assert(arista(Jugador,Pieza,Cara,X,Y)),
    reestableceAristas(R).

reestableceConexiones([]).
reestableceConexiones([[Jugador1,Pieza1,Cara1,Jugador2,Pieza2,Cara2]|R]):-
    assert(conexion(Jugador1,Pieza1,Cara1,Jugador2,Pieza2,Cara2)),
    reestableceConexiones(R).
    
vaciarPapeleras:-
    retractall(papeleraConexiones(Jugador1,Pieza1,Cara1,Jugador2,Pieza2,Cara2)),
    retractall(papeleraAristas(_,_,_,_,_)).



coordenadasDeArista([X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],Cara,X,Y):-
    Cara is 1,
    X is X1,
    Y is Y1,
    !.
coordenadasDeArista([X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],Cara,X,Y):-
    Cara is 2,
    X is X2,
    Y is Y2,
    !.
coordenadasDeArista([X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],Cara,X,Y):-
    Cara is 3,
    X is X3,
    Y is Y3,
    !.
coordenadasDeArista([X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],Cara,X,Y):-
    Cara is 4,
    X is X4,
    Y is Y4,
    !.
coordenadasDeArista([X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],Cara,X,Y):-
    Cara is 5,
    X is X5,
    Y is Y5,
    !.
coordenadasDeArista([X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],Cara,X,Y):-
    Cara is 6,
    X is X6,
    Y is Y6,
    !.