:- import(tablero).
:- [tablero].

mover(abeja,Ficha,Jugador,Cara):-
    turno(Jugador1),
    not((Ficha = abeja , Jugador = Jugador1)),
    arista(Jugador,Ficha,Cara,X,Y),

    (intentaMoverHasta(abeja,X,Y,1);
    intentaMoverHasta(abeja,X,Y,2);
    intentaMoverHasta(abeja,X,Y,3);
    intentaMoverHasta(abeja,X,Y,4);
    intentaMoverHasta(abeja,X,Y,5);
    intentaMoverHasta(abeja,X,Y,6)),

    eliminaConexiones(abeja),
    
    arista(Jugador1,abeja,1,X1,Y1),
    arista(Jugador1,abeja,2,X2,Y2),
    arista(Jugador1,abeja,3,X3,Y3),
    arista(Jugador1,abeja,4,X4,Y4),
    arista(Jugador1,abeja,5,X5,Y5),
    arista(Jugador1,abeja,6,X6,Y6),
    eliminaAristas(abeja,[X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6]),
    
    conectarTrasMovimiento(abeja,Jugador,Ficha,Cara),

    !,

    ((not(grafoDesconectado(abeja,Jugador1)) , vaciarPapeleras) ;
    (eliminaConexionesPermanente(abeja),
    arista(Jugador1,abeja,1,XX1,YY1),
    arista(Jugador1,abeja,2,XX2,YY2),
    arista(Jugador1,abeja,3,XX3,YY3),
    arista(Jugador1,abeja,4,XX4,YY4),
    arista(Jugador1,abeja,5,XX5,YY5),
    arista(Jugador1,abeja,6,XX6,YY6),
    eliminaAristasPermanente(abeja,[XX1,YY1,XX2,YY2,XX3,YY3,XX4,YY4,XX5,YY5,XX6,YY6]),
    restablecerPapeleras,
    !,
    fail)).
    
    
    % comprobar que no se desconecte el grafo
    % quitarla y ponerla en la otra casilla


intentaMoverHasta(abeja,X,Y,Direccion):-
    turno(Jugador),

    casillaLibreNoCerrada(abeja,Jugador,Direccion),
    arista(Jugador,abeja,Direccion,A,B),
    coordenadaCaras(Direccion,A,B,L),
    pertenece(X,Y,L),
    !.


casillaLibreNoCerrada(Pieza,Jugador,Direccion):-
    casillaVacia(Pieza, Jugador, Direccion),
    incrementoCircular6(Direccion, Adyacente1),
    decrementoCircular6(Direccion, Adyacente2),
    (casillaVacia(Pieza,Jugador,Adyacente1) ; casillaVacia(Pieza,Jugador,Adyacente2)).
    

casillaVacia(Pieza,Jugador,Direccion):-
    arista(Jugador,Pieza,Direccion,X,Y), 
    coordenadaCaras(Direccion,X,Y,[X1,Y1,X2,Y2|R]), % dos caras de la casilla q esta en la direccion
    not((arista(J,P,A,X1,Y1), arista(J,P,B,X2,Y2))). % que las 2 aristas no pertenezcan a una misma ficha

restablecerPapeleras:-
    findall([Jugador,Pieza,Cara,X,Y], papeleraAristas(Jugador,Pieza,Cara,X,Y), A),
    reestableceAristas(A),
    findall([Jugador1,Pieza1,Cara1,Jugador2,Pieza2,Cara2], papeleraConexiones(Jugador1,Pieza1,Cara1,Jugador2,Pieza2,Cara2), B),
    reestableceConexiones(B),
    vaciarPapeleras.
    

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