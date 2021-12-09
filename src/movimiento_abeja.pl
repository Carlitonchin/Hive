:- import(tablero).
:- import(utiles_movimiento).
:- [tablero].
:- [utiles_movimiento].

moverAbeja(MiFicha,Ficha,Jugador,Cara):-
    writeln(["Movimiento abeja: ", MiFicha,Ficha,Jugador,Cara]),
    turno(Jugador1),
    aristasDeLaPieza(Jugador1, MiFicha,A),
    findall([H1,H2,H3,H4], conexion(Jugador1,MiFicha,H1,H2,H3,H4), H5),
    writeln(["Aristas: ",A]),
    writeln(["Conexiones: ",H5]),
    arista(Jugador,Ficha,Cara,X,Y),
    writeln("Aristas superado"),
    (
    intentaMoverHasta(MiFicha,X,Y,1);
    intentaMoverHasta(MiFicha,X,Y,2);
    intentaMoverHasta(MiFicha,X,Y,3);
    intentaMoverHasta(MiFicha,X,Y,4);
    intentaMoverHasta(MiFicha,X,Y,5);
    intentaMoverHasta(MiFicha,X,Y,6)
    ),
    writeln("Intenta mover superado"),
    eliminaConexiones(MiFicha),

    writeln("eliminaconexiones superado"),
    aristasDeLaPieza(Jugador1, MiFicha, R),

    writeln("aristas de la pieza superado"),
    eliminaAristas(MiFicha,R),
    
    writeln("eliminar aristas superado"),
    conectarTrasMovimiento(MiFicha,Jugador,Ficha,Cara),

    writeln("conectar superado"),
    !,

    ((not(grafoDesconectado(MiFicha,Jugador1)) ,
    
    writeln("grafo no desconectado superado"),
     vaciarPapeleras) ;
    (
        writeln("Hola de nuevo ......................."),
        eliminaConexionesPermanente(MiFicha),
    aristasDeLaPieza(Jugador1, MiFicha, R2),
    eliminaAristasPermanente(MiFicha,R2),
    restablecerPapeleras,
    !,
    fail)).
    
    
    % comprobar que no se desconecte el grafo
    % quitarla y ponerla en la otra casilla


intentaMoverHasta(Pieza,X,Y,Direccion):-
    turno(Jugador),

    casillaLibreNoCerrada(Pieza,Jugador,Direccion, CasillaDestino),
    pertenece(X,Y,CasillaDestino),
    !.