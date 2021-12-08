:- import(tablero).
:- import(utiles_movimiento).
:- [tablero].
:- [utiles_movimiento].

moverSaltamontes(Saltamontes,Ficha,Jugador,Cara):-
    turno(JugadorActual),
    arista(Jugador, Ficha, Cara, X, Y),
    coordenadaCaras(Cara, X, Y, Aristas),
    conexion(JugadorActual, Saltamontes, CaraSaltamontes,_,_,_),
    arista(JugadorActual, Saltamontes, CaraSaltamontes, X0, Y0),
    aristasDeLaCara(CaraSaltamontes, Aristas, Xf, Yf),
    casillasAlineadas([X0, Y0], CaraSaltamontes, [Xf, Yf], Direccion),
    !,
    aristasDeLaPieza(JugadorActual, Saltamontes, AristasSaltamontes),
    eliminaAristas(Saltamontes, AristasSaltamontes),
    eliminaConexiones(Saltamontes),
    conectarNueva(Saltamontes,Jugador, Ficha, Cara),!,

    ((not(grafoDesconectado(Saltamontes,Jugador1)) , vaciarPapeleras) ;
    (eliminaConexionesPermanente(Saltamontes),
    aristasDeLaPieza(Jugador1, Saltamontes, R2),
    eliminaAristasPermanente(Saltamontes,R2),
    restablecerPapeleras,
    !,
    fail)).


aristasDeLaCara(Cara, [X1,Y1 | R], X, Y):-
    (Cara = 1,
    X = X1,
    Y = Y1);
    (CaraMenos is Cara - 1,
    aristasDeLaCara(CaraMenos, R, X,Y)).

casillasAlineadas(Coordenadas, Cara, CoordenadasDestino, Direccion):-
    (
    ((Cara = 1;Cara=4), casillasAlineadas1(Coordenadas, CoordenadasDestino, Direccion));
    ((Cara = 2;Cara=5), casillasAlineadas2(Coordenadas, CoordenadasDestino, Direccion));
    ((Cara = 3;Cara=6), casillasAlineadas3(Coordenadas, CoordenadasDestino, Direccion))
    ).

casillasAlineadas1([X0, Y0], [Xf, Yf], Direccion):-
    X0 is Xf,
    0 is ((Yf - Y0) mod 4),
    A is ((Yf - Y0) div 4),
    ((A > 0 , Direccion is 1) ; (A < 0 , Direccion is 4)).
    
casillasAlineadas2([X0, Y0], [Xf, Yf], Direccion):-
    0 is ((Xf - X0) mod 2),
    A is ((Xf - X0) div 2),
    0 is ((Yf - Y0) mod 2),
    A is ((Yf - Y0) div 2),
    ((A > 0 , Direccion is 2) ; (A < 0 , Direccion is 5)).

casillasAlineadas3([X0, Y0], [Xf, Yf], Direccion):-
    0 is ((Xf - X0) mod 2),
    A is ((Xf - X0) div 2),
    0 is ((Yf - Y0) mod 2),
    A is ((Yf - Y0) div -2),
    ((A > 0 , Direccion is 3) ; (A < 0 , Direccion is 6)).