:- import(tablero).
:- import(utiles_movimiento).
:- import(movimiento_escarabajo).
:- [tablero, utiles_movimiento, movimiento_escarabajo].

:- dynamic papeleraAristasMariquita/5.

papeleraAristasMariquita(_,_,_,_,_):-fail.

guardarAristasEnPapelera(Pieza, [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6]):-
    turno(Jugador),
    asserta(papeleraAristasMariquita(Jugador, Pieza, 1, X1, Y1)),
    asserta(papeleraAristasMariquita(Jugador, Pieza, 2, X2, Y2)),
    asserta(papeleraAristasMariquita(Jugador, Pieza, 3, X3, Y3)),
    asserta(papeleraAristasMariquita(Jugador, Pieza, 4, X4, Y4)),
    asserta(papeleraAristasMariquita(Jugador, Pieza, 5, X5, Y5)),
    asserta(papeleraAristasMariquita(Jugador, Pieza, 6, X6, Y6)).


/*guardarConexionesEnPapelera(Jugador,Pieza):-
    findall([Cara1,Jugador2,Pieza2,Cara2], conexion(Jugador,Pieza,Cara1,Jugador2,Pieza2,Cara2), X),
    guardarConexionesEnPapelera(Pieza, Jugador, X).

guardarConexionesEnPapelera(Pieza, Jugador, []).

guardarConexionesEnPapelera(Pieza, Jugador, [[Cara1,Jugador2,Pieza2,Cara2]|R]):-
    asserta(papeleraConexiones(Jugador1,Pieza1,Cara1,Jugador2,Pieza2,Cara2)),
    asserta(papeleraConexiones(Jugador2,Pieza2,Cara2,Jugador1,Pieza1,Cara1)),
    guardarConexionesEnPapelera(Pieza1, Jugador1, R).*/

salvarEstado(Mariquita):-
    turno(JugadorActual),
    aristasDeLaPieza(JugadorActual, Mariquita, Aristas),
    guardarAristasEnPapelera(Mariquita, Aristas).
    %guardarConexionesEnPapelera(JugadorActual, Mariquita).

reestablecerEstado(Mariquita, Jugador, Movido):-
    papeleraAristasMariquita(Jugador, Mariquita, 1, X1, Y1),
    papeleraAristasMariquita(Jugador, Mariquita, 2, X2, Y2),
    papeleraAristasMariquita(Jugador, Mariquita, 3, X3, Y3),
    papeleraAristasMariquita(Jugador, Mariquita, 4, X4, Y4),
    papeleraAristasMariquita(Jugador, Mariquita, 5, X5, Y5),
    papeleraAristasMariquita(Jugador, Mariquita, 6, X6, Y6),!,
    retract(papeleraAristasMariquita(Jugador, Mariquita, 1, X1, Y1)),
    retract(papeleraAristasMariquita(Jugador, Mariquita, 2, X2, Y2)),
    retract(papeleraAristasMariquita(Jugador, Mariquita, 3, X3, Y3)),
    retract(papeleraAristasMariquita(Jugador, Mariquita, 4, X4, Y4)),
    retract(papeleraAristasMariquita(Jugador, Mariquita, 5, X5, Y5)),
    retract(papeleraAristasMariquita(Jugador, Mariquita, 6, X6, Y6)),
    !,
    not(Movido=false),!,
    turno(JugadorActual),
    caraAdyacente(Mariquita, [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6], Cara),
    (
    (
        casillaVacia(Mariquita, JugadorActual, Cara),!,
        moverEscarabajo(Mariquita, _, _, Cara)
    )
    ;
    (
        conexion(JugadorActual,Mariquita,Cara,Jugador2,Pieza2,Cara2),!,
        subirEscarabajo(Mariquita,Pieza2,Jugador2,Cara2)
    )
    )
    /*eliminaConexionesPermanente(Mariquita),
    eliminaConexionesPermanente(Mariquita),
    creaConexiones(Marquita, [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6]),
    creaAristas(Mariquita, [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6]),!*/.

caraAdyacente(Mariquita, Aristas, Cara):-
    turno(JugadorActual),
    aristasDeLaPieza(JugadorActual, Mariquita, [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6]),!,
    (
        (coordenadaCaras(Cara, X1,Y1, Aristas),!);
        (coordenadaCaras(Cara, X2,Y2, Aristas),!);
        (coordenadaCaras(Cara, X3,Y3, Aristas),!);
        (coordenadaCaras(Cara, X4,Y4, Aristas),!);
        (coordenadaCaras(Cara, X5,Y5, Aristas),!);
        (coordenadaCaras(Cara, X6,Y6, Aristas),!)
    ).

moverMariquita(Mariquita, Pieza, Jugador, Cara):-
    (
    subirComoEscarabajo(Mariquita, Pieza, Jugador, Cara),
    retractall(papeleraAristasMariquita(_,_,_,_,_)), !);
    (
        retractall(papeleraAristasMariquita(_,_,_,_,_)),!,
        fail
    )
    .

subirComoEscarabajo(Mariquita, Pieza, Jugador, Cara):-
    turno(JugadorActual),
    conexion(JugadorActual,Mariquita,_,Jugador2,Pieza2,Cara2),
    salvarEstado(Mariquita),
    subirEscarabajo(Mariquita,Pieza2,Jugador2,Cara2),
    Movido = true,
    (subirComoEscarabajo2(Mariquita, Pieza, Jugador, Cara);
    (
    reestablecerEstado(Mariquita, JugadorActual, Movido),
    fail
    ))
    .
        
subirComoEscarabajo2(Mariquita, Pieza, Jugador, Cara):-
    turno(JugadorActual),
    conexion(JugadorActual,Mariquita,_,Jugador2,Pieza2,Cara2),
    salvarEstado(Mariquita),
    (subirEscarabajo(Mariquita,Pieza2,Jugador2,Cara2),
    Movido = true,
    (bajarComoEscarabajo(Mariquita, Pieza, Jugador, Cara);
    (
    reestablecerEstado(Mariquita, JugadorActual, Movido),
    fail
    )))
    .

bajarComoEscarabajo(Mariquita, Pieza, Jugador, Cara):-
    turno(JugadorActual),
    (
        debajoDeEscarabajos(Jugador,Pieza,JugadorActual,Mariquita),
        moverEscarabajo(Mariquita, _, _, Cara),!
    )
    ;
    (
        arista(Jugador, Pieza, Cara, X, Y),
        coordenadaCaras(Cara, X, Y, Aristas),
        caraAdyacente(Mariquita, Aristas, CaraMariquita),!,
        moverEscarabajo(Mariquita, _, _, CaraMariquita)
    )
    .
