:- import(utiles_movimiento).
:- import(utiles).
:- import(tablero).


:- [utiles_movimiento, tablero, utiles].

moverEscarabajo(Escarabajo, Ficha, Jugador, Cara):-
    % esta cara es la comparte Ficha con el Escarabajo
    turno(JugadorActual),
    sumaCircular6(Cara,3,Direccion),
    
    (
    (conexion(JugadorActual,Escarabajo,Direccion,Ficha,Jugador,Cara),

    (liberaPiezaDebajo(Escarabajo); true),
    eliminaAristasPermanente_(JugadorActual,Escarabajo), % por si no habia pieza debajo
    eliminaConexionesPermanente(JugadorActual,Escarabajo), 

    findall([C,X,Y],arista(Jugador,Ficha,C,X,Y),Aristas),
    findall([C1,J2,P2,C2], conexion(Jugador,Ficha,C1,J2,P2,C2),Conexiones),
    eliminaAristasPermanente_(Jugador,Ficha),
    eliminaConexionesPermanente(Jugador,Ficha),
    agregaConexionesEscarabajo(JugadorActual,Escarabajo,Conexiones),
    agregaAristasEscarabajo(JugadorActual,Escarabajo,Aristas),
    assert(debajoDeEscarabajos(Jugador,Ficha,JugadorActual,Escarabajo)),
    
    
    )
    
    ;

    )

liberaPiezaDebajo(Escarabajo):-
    turno(JugadorActual),
    retract(debajoDeEscarabajos(Jugador,Ficha,JugadorActual,Escarabajo)),

    findall([C,X,Y],arista(JugadorActual,Escarabajo,C,X,Y),Aristas),
    findall([C1,J2,P2,C2], conexion(JugadorActual,Escarabajo,C1,J2,P2,C2),Conexiones),
    eliminaAristasPermanente_(JugadorActual,Escarabajo),
    eliminaConexionesPermanente(JugadorActual,Escarabajo),

    agregaConexionesEscarabajo(Jugador,Ficha,Conexiones),
    agregaAristasEscarabajo(Jugador,Ficha,Aristas).

apresaPiezaDebajo(Escarabajo, Ficha, Jugador, Cara):-
    turno(JugadorActual),
    findall([C,X,Y],arista(Jugador,Ficha,C,X,Y),Aristas),
    findall([C1,J2,P2,C2], conexion(Jugador,Ficha,C1,J2,P2,C2),Conexiones),
    eliminaAristasPermanente_(Jugador,Ficha),
    eliminaConexionesPermanente(Jugador,Ficha),
    agregaConexionesEscarabajo(JugadorActual,Escarabajo,Conexiones),
    agregaAristasEscarabajo(JugadorActual,Escarabajo,Aristas),
    assert(debajoDeEscarabajos(Jugador,Ficha,JugadorActual,Escarabajo)),
    

agregaAristasEscarabajo(Jugador,Ficha,[]).
agregaAristasEscarabajo(Jugador,Ficha,[[C,X,Y]|R]):-
    assert(arista(Jugador,Ficha,C,X,Y)),
    agregaAristasEscarabajo(Jugador,Ficha,R).
    
agregaConexionesEscarabajo(Jugador,Ficha,[]).
agregaConexionesEscarabajo(Jugador,Ficha,[[C1,J2,P2,C2]|R]):-
    assert(conexion(Jugador,Ficha,C1,J2,P2,C2)),
    assert(conexion(J2,P2,C2,Jugador,Ficha,C1)),
    agregaAristasEscarabajo(Jugador,Ficha,R).