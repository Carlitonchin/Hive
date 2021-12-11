:- import(utiles_movimiento).
:- import(utiles).
:- import(tablero).


:- [utiles_movimiento, tablero, utiles].

daBola(Pillbug, CaraTomar, CaraDejar):-
    turno(Jugador),
    conexion(Jugador, Pillbug, CaraTomar, Jugador2, Pieza2, Cara2),
    casillaVacia(Pillbug,Jugador,CaraDejar),

    eliminaAristas_(Jugador2,Pieza2),
    eliminaConexiones(Jugador2,Pieza2),

    arista(Jugador,Pillbug,CaraDejar,X,Y),
    coordenadaCaras(CaraDejar,X,Y,CasillaDejar),

    creaConexiones(Jugador2,Pieza2,CasillaDejar),
    creaAristas(Jugador2,Pieza2,CasillaDejar),

    (not(grafoDesconectado(Pillbug,Jugador))
    ;
    (eliminaAristasPermanente_(Jugador2,Pieza2),
    eliminaConexionesPermanente(Jugador2,Pieza2),
    restablecerPapeleras,
    !, fail)),

    vaciarPapeleras.

