:- import(estado).
:- import(utiles).
:- [estado, utiles].


:- dynamic arista/5, conexion/6, visitado/2, papeleraConexiones/6, papeleraAristas/5, camino/1.

camino(L):-
    fail.

arista(Jugador, Pieza, Cara, X, Y):-
    fail.
papeleraAristas(Jugador, Pieza, Cara, X, Y):-
    fail.
conexion(Jugador1,Pieza1,Cara1,Jugador2,Pieza2,Cara2):-
    fail.
papeleraConexiones(Jugador1,Pieza1,Cara1,Jugador2,Pieza2,Cara2):-
    fail.

aristasDeLaPieza(Jugador, Pieza, R):-
    arista(Jugador,Pieza,1,X1,Y1),
    arista(Jugador,Pieza,2,X2,Y2),
    arista(Jugador,Pieza,3,X3,Y3),
    arista(Jugador,Pieza,4,X4,Y4),
    arista(Jugador,Pieza,5,X5,Y5),
    arista(Jugador,Pieza,6,X6,Y6),
    R = [X1, Y1, X2, Y2, X3, Y3, X4, Y4, X5, Y5, X6, Y6].

conectarNueva(Pieza1, Jugador2, Pieza2, Cara2):-
    arista(Jugador2, Pieza2, Cara2, X, Y),
    coordenadaCaras(Cara2, X, Y, R),
    not(encimaDePieza(R)),
    (not(conexionesConRival(R)) ; cantPiezasJugadas(negras,0)),
    creaConexiones(Pieza1, R),
    creaAristas(Pieza1, R).

conectarTrasMovimiento(Pieza1, Jugador2, Pieza2, Cara2):-
    arista(Jugador2, Pieza2, Cara2, X, Y),
    coordenadaCaras(Cara2, X, Y, R),
    creaConexiones(Pieza1, R),
    creaAristas(Pieza1, R).


encimaDePieza([X1,Y1,X2,Y2|R]):-
    arista(Jugador, Pieza, 1, X1, Y1),
    arista(Jugador, Pieza, 2, X2, Y2),
    !.

conexionesConRival([X,Y|R]):-
    rival(Rival),
    (arista(Rival,A,B,X,Y) ; conexionesConRival(R)).

creaConexiones(Pieza,L):-
    turno(Jugador),
    creaConexiones(Jugador,Pieza,L).

creaConexiones(Jugador1,Pieza1, []).
creaConexiones(Jugador1,Pieza1, [X,Y|R]):-
    (arista(Jugador2,Pieza2,Cara2,X,Y),
    sumaCircular6(Cara2,3,Cara1),
    assert(conexion(Jugador1,Pieza1,Cara1,Jugador2,Pieza2,Cara2)),
    assert(conexion(Jugador2,Pieza2,Cara2,Jugador1,Pieza1,Cara1)),
    creaConexiones(Jugador1,Pieza1, R),!);
    creaConexiones(Jugador1,Pieza1, R).

eliminaConexiones(Pieza):-
    turno(Jugador),
    eliminaConexiones(Jugador, Pieza).

eliminaConexiones(Jugador,Pieza):-
    findall([Cara1,Jugador2,Pieza2,Cara2], conexion(Jugador,Pieza,Cara1,Jugador2,Pieza2,Cara2), X),
    eliminaConexiones(Pieza, Jugador, X).

eliminaConexiones(Pieza1, Jugador1, []).
eliminaConexiones(Pieza1, Jugador1, [[Cara1,Jugador2,Pieza2,Cara2]|R]):-
    assert(papeleraConexiones(Jugador1,Pieza1,Cara1,Jugador2,Pieza2,Cara2)),
    retract(conexion(Jugador1,Pieza1,Cara1,Jugador2,Pieza2,Cara2)),
    assert(papeleraConexiones(Jugador2,Pieza2,Cara2,Jugador1,Pieza1,Cara1)),
    retract(conexion(Jugador2,Pieza2,Cara2,Jugador1,Pieza1,Cara1)),
    eliminaConexiones(Pieza1, Jugador1, R).

eliminaConexionesPermanente(Pieza1):-
    turno(Jugador1),
    eliminaConexionesPermanente(Jugador1,Pieza1).

eliminaConexionesPermanente(Jugador,Pieza):-
    findall([Cara1,Jugador2,Pieza2,Cara2], conexion(Jugador,Pieza,Cara1,Jugador2,Pieza2,Cara2), X),
    eliminaConexionesPermanente(Pieza, Jugador, X).

eliminaConexionesPermanente(Pieza1, Jugador1, []).
eliminaConexionesPermanente(Pieza1, Jugador1, [[Cara1,Jugador2,Pieza2,Cara2]|R]):-
    retract(conexion(Jugador1,Pieza1,Cara1,Jugador2,Pieza2,Cara2)),
    retract(conexion(Jugador2,Pieza2,Cara2,Jugador1,Pieza1,Cara1)),
    eliminaConexionesPermanente(Pieza1, Jugador1, R).

eliminaConexionesPermanenteEstas([]).
eliminaConexionesPermanenteEstas([[J1,P1,C1,J2,P2,C2]|R]):-
    retract(conexion(J1,P1,C1,J2,P2,C2)),
    eliminaConexionesPermanenteEstas(R).

    
creaAristas(Pieza, [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6]):-
    turno(Jugador),
    creaAristas(Jugador,Pieza,[X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6]).

creaAristas(Jugador, Pieza, [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6]):-
    assert(arista(Jugador, Pieza, 1, X1, Y1)),
    assert(arista(Jugador, Pieza, 2, X2, Y2)),
    assert(arista(Jugador, Pieza, 3, X3, Y3)),
    assert(arista(Jugador, Pieza, 4, X4, Y4)),
    assert(arista(Jugador, Pieza, 5, X5, Y5)),
    assert(arista(Jugador, Pieza, 6, X6, Y6)).

eliminaAristas_(Jugador,Pieza):-
    findall([C,X,Y],arista(Jugador,Pieza,C,X,Y),R),
    eliminaAristas_(Jugador,Pieza,R).

eliminaAristas_(Jugador,Pieza,[]).
eliminaAristas_(Jugador,Pieza,[[C,X,Y]|R]):-
    retract(arista(Jugador, Pieza, C, X, Y)),
    assert(papeleraAristas(Jugador, Pieza, C, X, Y)),
    eliminaAristas_(Jugador,Pieza,R).

eliminaAristas(Pieza,[X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6]):-
    turno(Jugador),
    retract(arista(Jugador, Pieza, 1, X1, Y1)),
    retract(arista(Jugador, Pieza, 2, X2, Y2)),
    retract(arista(Jugador, Pieza, 3, X3, Y3)),
    retract(arista(Jugador, Pieza, 4, X4, Y4)),
    retract(arista(Jugador, Pieza, 5, X5, Y5)),
    retract(arista(Jugador, Pieza, 6, X6, Y6)),
    assert(papeleraAristas(Jugador, Pieza, 1, X1, Y1)),
    assert(papeleraAristas(Jugador, Pieza, 2, X2, Y2)),
    assert(papeleraAristas(Jugador, Pieza, 3, X3, Y3)),
    assert(papeleraAristas(Jugador, Pieza, 4, X4, Y4)),
    assert(papeleraAristas(Jugador, Pieza, 5, X5, Y5)),
    assert(papeleraAristas(Jugador, Pieza, 6, X6, Y6)).

eliminaAristasPermanente(Pieza):-
    turno(Jugador),
    eliminaAristasPermanente_(Jugador,Pieza).

eliminaAristasPermanente_(Jugador,Pieza):-
    findall([C,X,Y],arista(Jugador,Pieza,C,X,Y),R),
    eliminaAristasPermanente_(Jugador,Pieza,R).

eliminaAristasPermanente_(Jugador,Pieza,[]).
eliminaAristasPermanente_(Jugador,Pieza,[[C,X,Y]|R]):-
    retract(arista(Jugador,Pieza,C,X,Y)),
    eliminaAristasPermanente_(Jugador,Pieza,R).
    
    

eliminaAristasPermanente(Pieza,[X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6]):-
    turno(Jugador),
    retract(arista(Jugador, Pieza, 1, X1, Y1)),
    retract(arista(Jugador, Pieza, 2, X2, Y2)),
    retract(arista(Jugador, Pieza, 3, X3, Y3)),
    retract(arista(Jugador, Pieza, 4, X4, Y4)),
    retract(arista(Jugador, Pieza, 5, X5, Y5)),
    retract(arista(Jugador, Pieza, 6, X6, Y6)).

eliminaAristasPermanenteEstas([]).
eliminaAristasPermanenteEstas([[J,P,C,X,Y]|R]):-
    retract(arista(J,P,C,X,Y)),
    eliminaAristasPermanenteEstas(R).
    

coordenadaCaras(CaraAConectar, X, Y, R):-
    CaraAConectar is 1,
    X1 is X,
    Y1 is Y+4,
    X2 is X+1,
    Y2 is Y+3,
    X3 is X+1,
    Y3 is Y+1,
    X4 is X,
    Y4 is Y,
    X5 is X-1,
    Y5 is Y+1,
    X6 is X-1,
    Y6 is Y+3,
    R = [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],
    !.
coordenadaCaras(CaraAConectar, X, Y, R):-
    CaraAConectar is 2,
    X1 is X+1,
    Y1 is Y+3,
    X2 is X+2,
    Y2 is Y+2,
    X3 is X+2,
    Y3 is Y,
    X4 is X+1,
    Y4 is Y-1,
    X5 is X,
    Y5 is Y,
    X6 is X,
    Y6 is Y+2,
    R = [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],
    !.
coordenadaCaras(CaraAConectar, X, Y, R):-
    CaraAConectar is 3,
    X1 is X+1,
    Y1 is Y+1,
    X2 is X+2,
    Y2 is Y,
    X3 is X+2,
    Y3 is Y-2,
    X4 is X+1,
    Y4 is Y-3,
    X5 is X,
    Y5 is Y-2,
    X6 is X,
    Y6 is Y,
    R = [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],
    !.
coordenadaCaras(CaraAConectar, X, Y, R):-
    CaraAConectar is 4,
    X1 is X,
    Y1 is Y,
    X2 is X+1,
    Y2 is Y-1,
    X3 is X+1,
    Y3 is Y-3,
    X4 is X,
    Y4 is Y-4,
    X5 is X-1,
    Y5 is Y-3,
    X6 is X-1,
    Y6 is Y-1,
    R = [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],
    !.
coordenadaCaras(CaraAConectar, X, Y, R):-
    CaraAConectar is 5,
    X1 is X-1,
    Y1 is Y+1,
    X2 is X,
    Y2 is Y,
    X3 is X,
    Y3 is Y-2,
    X4 is X-1,
    Y4 is Y-3,
    X5 is X-2,
    Y5 is Y-2,
    X6 is X-2,
    Y6 is Y,
    R = [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],
    !.
coordenadaCaras(CaraAConectar, X, Y, R):-
    CaraAConectar is 6,
    X1 is X-1,
    Y1 is Y+3,
    X2 is X,
    Y2 is Y+2,
    X3 is X,
    Y3 is Y,
    X4 is X-1,
    Y4 is Y-1,
    X5 is X-2,
    Y5 is Y,
    X6 is X-2,
    Y6 is Y+2,
    R = [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6],
    !.


visitado(Pieza, Jugador) :- fail.

unaSolaPieza(Pieza, Jugador):-
    not((piezasJugadas(Jugador2, Pieza2),
    (not(Jugador = Jugador2);
    not(Pieza = Pieza2)))).

grafoDesconectado(Pieza, Jugador):-
    (
        not(dfs(Pieza, Jugador)),
     !,
    retractall(visitado(_,_)));
    (retractall(visitado(_,_)),!,
    fail)
    .
    
    

dfs(Pieza, Jugador):-
    todosVisitados(Pieza, Jugador);(
    not(visitado(Pieza, Jugador)),
    assert(visitado(Pieza, Jugador)),
    conexion(Jugador,Pieza,Cara1,Jugador2,Pieza2,Cara2),
    dfs(Pieza2, Jugador2)
).
    
todosVisitados(P, J):-
    unaSolaPieza(P,J),!;
    not((piezasJugadas(Jugador, Pieza), not(visitado(Pieza,Jugador)))).

caminoValido(Pieza, []) :-
    turno(Jugador),
    (eliminaConexionesPermanente(Pieza); true),
    (eliminaAristasPermanente(Pieza); true).

caminoValido(Pieza, [Coordenadas | R]):-
    turno(Jugador),
    (eliminaConexionesPermanente(Pieza); true),
    (eliminaAristasPermanente(Pieza); true),
    creaConexiones(Pieza, Coordenadas),
    creaAristas(Pieza, Coordenadas),
    !,
    ((not(grafoDesconectado(Pieza, Jugador)),caminoValido(Pieza, R));
    (
    (eliminaConexionesPermanente(Pieza);true),
    (eliminaAristasPermanente(Pieza);true), 
    fail)).

    % findall([J1,P1,C1,J2,P2,C2], conexion(J1,P1,C1,J2,P2,C2), Bag),
    % writeln(Bag).

casillaSolitaria([]).
casillaSolitaria([X,Y | R]):-
    not(arista(J, F, C, X, Y)),
    casillaSolitaria(R).
    

contrario(blancas, negras).
contrario(negras, blancas).

victoria(Jugador):-
    contrario(Jugador, Rival),
    abejaJugada(Rival),
    abejaRodeada(Rival).

abejaRodeada(Rival):-
    (
        (piezasJugadas(Rival, abeja),
        Pieza = abeja,
        Jugador = Rival
        );
        (
            topeDeLaTorre(Rival, abeja, Jugador, Pieza)
        )
    ),!,
    abejaRodeada(Pieza, Jugador).

abejaRodeada(Pieza,Jugador):-
    conexion(Jugador,Pieza,1,_,_,_),
    conexion(Jugador,Pieza,2,_,_,_),
    conexion(Jugador,Pieza,3,_,_,_),
    conexion(Jugador,Pieza,4,_,_,_),
    conexion(Jugador,Pieza,5,_,_,_),
    conexion(Jugador,Pieza,6,_,_,_).

empate:-
    victoria(blancas),
    victoria(negras).