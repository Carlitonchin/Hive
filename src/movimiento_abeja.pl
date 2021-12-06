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
    intentaMoverHasta(abeja,X,Y,6)).
    
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
