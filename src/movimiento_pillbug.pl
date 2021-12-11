:- import(utiles_movimiento).
:- import(utiles).
:- import(tablero).


:- [utiles_movimiento, tablero, utiles].

daBola(Pillbug, CaraTomar, CaraDejar):-
    turno(Jugador),
    conexion(Jugador, Pillbug, CaraTomar, Jugador2, Pieza2, Cara2),
    rival(JugadorRival),
    not(ultimaPiezaMovida(JugadorRival,Pieza2)),
    not(debajoDeEscarabajos(_,_,Jugador2,Pieza2)),
    cantPiezasJugadas(Jugador,NumeroTurno),
    not(piezaBloqueada(Jugador2,Pieza2,NumeroTurno,Jugador)),
    casillaVacia(Pillbug,Jugador,CaraDejar),

    eliminaAristas_(Jugador2,Pieza2),
    eliminaConexiones(Jugador2,Pieza2),!,

    (
        assert(visitado(Pieza2,Jugador2)),
        (not(grafoDesconectado(Pillbug,Jugador)) ; (restablecerPapeleras,!,fail))
    ),

    arista(Jugador,Pillbug,CaraDejar,X,Y),
    coordenadaCaras(CaraDejar,X,Y,CasillaDejar),

    creaConexiones(Jugador2,Pieza2,CasillaDejar),
    creaAristas(Jugador2,Pieza2,CasillaDejar),!,

    (not(grafoDesconectado(Pillbug,Jugador))
    ;
    (eliminaAristasPermanente_(Jugador2,Pieza2),
    eliminaConexionesPermanente(Jugador2,Pieza2),
    restablecerPapeleras,
    !, fail)),

    vaciarPapeleras,
    
    cantPiezasJugadas(Jugador,TurnoActual1),
    TurnoBloqueado1 is TurnoActual1 + 1,
    rival(JugadorRival),
    cantPiezasJugadas(JugadorRival,TurnoBloqueado2),

    eliminaBloqueosAntiguos(Jugador,TurnoActual1),

    assert(piezaBloqueada(Jugador2,Pieza2,TurnoBloqueado1,Jugador)),
    assert(piezaBloqueada(Jugador2,Pieza2,TurnoBloqueado2,JugadorRival)).


eliminaBloqueosAntiguos(Jugador,NumeroTurnos):-
    NumeroTurnoViejo is NumeroTurnos-3,
    findall([J,P,T,J2], piezaBloqueada(J,P,T,J2), R),
    eliminaBloqueosAntiguos(Jugador,NumeroTurnoViejo,R).
    
eliminaBloqueosAntiguos(_,NumeroTurnoViejo,[]).
eliminaBloqueosAntiguos(_,NumeroTurnoViejo,[[J,P,T,J2]|R]):-
    (T > NumeroTurnoViejo,
    eliminaBloqueosAntiguos(_,NumeroTurnoViejo,R),!);
    (retract(piezaBloqueada(J,P,T,J2)),
    eliminaBloqueosAntiguos(_,NumeroTurnoViejo,R),!).