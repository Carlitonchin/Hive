:- import(utiles_movimiento).
:- import(utiles).
:- import(tablero).


:- [utiles_movimiento, tablero, utiles].

:- dynamic aristasParaEliminar/5, conexionesParaEliminar/6, debajoDeEscarabajosEliminado/4, debajoDeEscarabajosAgregado/4.


moverEscarabajo(Escarabajo, Ficha, Jugador, Cara):-
    % esta cara es la comparte Ficha con el Escarabajo
    moverEscarabajoInterno(Escarabajo, Ficha, Jugador, Cara),
    !,
    vaciaEstadoAnterior.


moverEscarabajoInterno(Escarabajo, Ficha, Jugador, Cara):-
    turno(JugadorActual),
    sumaCircular6(Cara,3,Direccion),
    conexion(JugadorActual,Escarabajo,Direccion,Jugador,Ficha,Cara),
    !,
    (liberaPiezaDebajo(Escarabajo); true),
    eliminaAristas_(JugadorActual,Escarabajo), % por si no habia pieza debajo
    eliminaConexiones(JugadorActual,Escarabajo), 
    apresaPiezaDebajo(Escarabajo, Ficha, Jugador, Cara),
    (not(grafoDesconectado(Escarabajo, JugadorActual)) ; (restauraEstadoAnterior,fail)).

moverEscarabajoInterno(Escarabajo, Ficha, Jugador, Cara):-
    turno(JugadorActual),
    aristasDeLaPieza(JugadorActual,Escarabajo,Aristas1),
    arista(Jugador,Ficha,Cara,X,Y),
    coordenadaCaras(Cara,X,Y,Aristas2),
    encontrarCaraComun(Escarabajo,Aristas1,Aristas2,Cara1),
    casillaLibreNoCerrada(Aristas1,Cara1,_),

    (liberaPiezaDebajo(Escarabajo); true),
    eliminaAristas_(JugadorActual,Escarabajo), % por si no habia pieza debajo
    eliminaConexiones(JugadorActual,Escarabajo), 

    creaConexiones(Escarabajo, Aristas2),
    creaAristas(Pieza, Aristas2),

    (not(grafoDesconectado(Escarabajo, JugadorActual))
    ; 
    ((eliminaConexionesPermanente(Escarabajo);true),
    (eliminaAristasPermanente(Escarabajo);true),
    restauraEstadoAnterior,
    fail)).

liberaPiezaDebajo(Escarabajo):-
    turno(JugadorActual),
    retract(debajoDeEscarabajos(Jugador,Ficha,JugadorActual,Escarabajo)),
    assert(piezasJugadas(Jugador,Ficha)),
    assert(debajoDeEscarabajosEliminado(Jugador,Ficha,JugadorActual,Escarabajo)),

    findall([C,X,Y],arista(JugadorActual,Escarabajo,C,X,Y),Aristas),
    findall([C1,J2,P2,C2], conexion(JugadorActual,Escarabajo,C1,J2,P2,C2),Conexiones),
    eliminaAristas_(JugadorActual,Escarabajo),
    eliminaConexiones(JugadorActual,Escarabajo),

    agregaConexionesEscarabajo(Jugador,Ficha,Conexiones),
    agregaAristasEscarabajo(Jugador,Ficha,Aristas).

apresaPiezaDebajo(Escarabajo, Ficha, Jugador, Cara):-
    turno(JugadorActual),

    findall([C,X,Y],arista(Jugador,Ficha,C,X,Y),Aristas),
    findall([C1,J2,P2,C2], conexion(Jugador,Ficha,C1,J2,P2,C2),Conexiones),
    eliminaAristas_(Jugador,Ficha),
    eliminaConexiones(Jugador,Ficha),
    
    agregaConexionesEscarabajo(JugadorActual,Escarabajo,Conexiones),
    agregaAristasEscarabajo(JugadorActual,Escarabajo,Aristas),
    assert(debajoDeEscarabajos(Jugador,Ficha,JugadorActual,Escarabajo)),
    retract(piezasJugadas(Jugador,Ficha)),
    assert(debajoDeEscarabajosAgregado(Jugador,Ficha,JugadorActual,Escarabajo)).

agregaAristasEscarabajo(Jugador,Ficha,[]).
agregaAristasEscarabajo(Jugador,Ficha,[[C,X,Y]|R]):-
    assert(arista(Jugador,Ficha,C,X,Y)),
    assert(aristasParaEliminar(Jugador,Ficha,C,X,Y)),
    agregaAristasEscarabajo(Jugador,Ficha,R).
    
agregaConexionesEscarabajo(Jugador,Ficha,[]).
agregaConexionesEscarabajo(Jugador,Ficha,[[C1,J2,P2,C2]|R]):-
    assert(conexion(Jugador,Ficha,C1,J2,P2,C2)),
    assert(conexion(J2,P2,C2,Jugador,Ficha,C1)),
    assert(conexionesParaEliminar(Jugador,Ficha,C1,J2,P2,C2)),
    assert(conexionesParaEliminar(J2,P2,C2,Jugador,Ficha,C1)),
    agregaConexionesEscarabajo(Jugador,Ficha,R).

encontrarCaraComun(Escarabajo,Aristas1,Aristas2, Cara1):-
    turno(Jugador),
    encontrarAristaComun(Aristas1,Aristas2, X,Y),
    arista(Jugador,Escarabajo,Cara1,X,Y).

encontrarAristaComun([],Aristas2, X,Y).
encontrarAristaComun([X1,Y1|R],Aristas2, X,Y):-
    (pertenece(X1,Y1,Aristas2),
    X is X1,
    Y is Y1)
    ;
    encontrarAristaComun(R,Aristas2,X,Y).

restauraEstadoAnterior:-
    findall([J,P,C,X,Y],aristasParaEliminar(J,P,C,X,Y),AristasParaEliminar),
    findall([J1,P1,C1,J2,P2,C2], conexionesParaEliminar(J1,P1,C1,J2,P2,C2),ConexionesParaEliminar),
    eliminaAristasPermanenteEstas(AristasParaEliminar),
    eliminaAristasPermanenteEstas(ConexionesParaEliminar),

    ((debajoDeEscarabajosEliminado(J3,P3,J4,P4),
    assert(debajoDeEscarabajos(J3,P3,J4,P4)),
    retract(piezasJugadas(J3,P3))) ; true),
    ((debajoDeEscarabajosAgregado(J5,P5,J6,P6),
    retract(debajoDeEscarabajos(J5,P5,J6,P6)),
    assert(piezasJugadas(J5,P5))) ; true),
    
    restablecerPapeleras.

vaciaEstadoAnterior:-
    retractall(aristasParaEliminar(_,_,_,_,_)),
    retractall(conexionesParaEliminar(_,_,_,_,_,_)),
    retractall(debajoDeEscarabajosEliminado(_,_,_,_)),
    retractall(debajoDeEscarabajosAgregado(_,_,_,_)),
    vaciarPapeleras.
    