:- import(tablero).
:- import(utiles_movimiento).
:- [tablero].
:- [utiles_movimiento].

moverAbeja(Ficha,Jugador,Cara):-
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
    
    aristasDeLaPieza(Jugador1, abeja, R),
    eliminaAristas(abeja,R),
    
    conectarTrasMovimiento(abeja,Jugador,Ficha,Cara),

    !,

    ((not(grafoDesconectado(abeja,Jugador1)) , vaciarPapeleras) ;
    (eliminaConexionesPermanente(abeja),
    aristasDeLaPieza(Jugador1, abeja, R2),
    eliminaAristasPermanente(abeja,R2),
    restablecerPapeleras,
    !,
    fail)).
    
    
    % comprobar que no se desconecte el grafo
    % quitarla y ponerla en la otra casilla


intentaMoverHasta(abeja,X,Y,Direccion):-
    turno(Jugador),

    casillaLibreNoCerrada(abeja,Jugador,Direccion, CasillaDestino),
    pertenece(X,Y,CasillaDestino),
    !.