:- import(utiles_movimiento).
:- import(utiles).
:- import(tablero).
:- import(movimiento_abeja).


:- [utiles_movimiento, tablero, utiles, movimiento_abeja].

:-dynamic posicionAranhaPremovimiento/2, caminoAnterior/1.
posicionAranhaPremovimiento(Aristas, Conexiones):- fail.

guardarCamino(Camino):-
    retractall(caminoAnterior(_)),
    assert(caminoAnterior(Camino)).

moverAranha(Aranha, Ficha, Jugador, Cara):-
    % guardarEstadoInicial,
    moverAranhaRecursivo(Aranha, Ficha, Jugador, Cara, 3),
    writeln("Termino de mover la aranha").
    
guardarEstadoInicial:-
    turno(JugadorActual),
    aristasDeLaPieza(JugadorActual, Aranha, Aristas),
    findall([Cara1,Jugador2,Pieza2,Cara2], conexion(JugadorActual,Aranha,Cara1,Jugador2,Pieza2,Cara2), Conexiones),
    assert(posicionAranhaPremovimiento(Aristas,Conexiones)).

moverAranhaRecursivo(Aranha, Ficha, Jugador, Cara, 0):-
    writeln("Caso base del llamado"),
    turno(JugadorActual),!,
    aristasDeLaPieza(JugadorActual, Aranha, Aristas),
    writeln(Aristas),
    writeln("seguro"),
    writeln([Jugador, Ficha, Cara]),
    conexion(JugadorActual,Aranha,_,Jugador,Ficha,Cara),
    writeln("   Dio Tru").

guardarAristasEnPapelera(Jugador, Pieza, [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6]):-
    assert(papeleraAristas(Jugador, Pieza, 1, X1, Y1)),
    assert(papeleraAristas(Jugador, Pieza, 2, X2, Y2)),
    assert(papeleraAristas(Jugador, Pieza, 3, X3, Y3)),
    assert(papeleraAristas(Jugador, Pieza, 4, X4, Y4)),
    assert(papeleraAristas(Jugador, Pieza, 5, X5, Y5)),
    assert(papeleraAristas(Jugador, Pieza, 6, X6, Y6)).

guardarConexionesEnPapelera(Pieza1, Jugador1, []).
guardarConexionesEnPapelera(Pieza1, Jugador1, [[Cara1,Jugador2,Pieza2,Cara2]|R]):-
    assert(papeleraConexiones(Jugador1,Pieza1,Cara1,Jugador2,Pieza2,Cara2)),
    assert(papeleraConexiones(Jugador2,Pieza2,Cara2,Jugador1,Pieza1,Cara1)),
    guardarConexionesEnPapelera(Pieza1, Jugador1, R).

guardarConexionesEnPapelera(Jugador1, Pieza1):-
    findall([Cara1,Jugador2,Pieza2,Cara2], conexion(Jugador1,Pieza1,Cara1,Jugador2,Pieza2,Cara2), X),
    guardarConexionesEnPapelera(Pieza1, Jugador1, X).

moverAranhaRecursivo(Aranha, Ficha, Jugador, Cara, PasosRestantes):-
    turno(JugadorActual),
    aristasDeLaPieza(JugadorActual, Aranha, Aristas),
    posiblePaso(Aranha,JugadorPaso,FichaPaso,CaraPaso),
    write("Pasos restantes "), writeln(PasosRestantes),
    write("Posible paso:"), writeln([JugadorPaso,FichaPaso,CaraPaso]),
    turno(JugadorActual),
    creaConexionesSiNoExisten(JugadorActual, Aranha, Aristas),
    aristasDeLaPieza(JugadorActual,Aranha,ZZ),
    writeln("   movio esta talla"),
    write("         Viejas aristas: "), writeln(Aristas),
    PasosDec is PasosRestantes -1,
    moverAranhaRecursivo(Aranha, Ficha, Jugador, Cara, PasosDec).
    
    %restablecerEstado(Aranha, Aristas)
    
creaConexionesSiNoExisten(Jugador, Pieza, Aristas):-
    (not(aristasDeLaPieza(Jugador, Pieza,A)),
    creaConexiones(Pieza, Aristas),
    creaAristas(Pieza, Aristas));
    !.


posiblePaso(Aranha,Jugador,Ficha,Cara):-
    turno(JugadorActual),
    conexion(JugadorActual,Aranha,Cara1,Jugador,Ficha,Cara2),
    caraAdyacente(Cara2,Cara),
    write("Estoy en "), write([Jugador, Ficha]), write(" en la cara"), writeln(Cara2).
    % findall([J1, P1, C1, J2, P2, C2], conexion(J1, P1, C1, J2, P2, C2), R),
    % writeln(R).

caraAdyacente(Cara, Retorno):-
    incrementoCircular6(Cara,Retorno).
caraAdyacente(Cara,Retorno):-
    decrementoCircular6(Cara,Retorno).

moverComoAbeja(Aranha,Cara, FichaPaso, JugadorPaso, CaraPaso, PasosRestantes, Aristas):-
    turno(JugadorActual),
    moverAbeja(Aranha,FichaPaso,JugadorPaso,CaraPaso),
    aristasDeLaPieza(JugadorActual,Aranha,ZZ),
    writeln("   movio esta talla"),
    write("         Viejas aristas: "), writeln(Aristas),
    PasosDec is PasosRestantes -1,
    (
    moverAranhaRecursivo(Aranha, Ficha, Jugador, Cara, PasosDec);
    (
    writeln("   no movio ni ostias"),
    write("         Viejas aristas: "), writeln(Aristas),
    writeln([JugadorActual, Aranha]),
    aristasDeLaPieza(JugadorActual,Aranha,A),
    write("         Aristas actuales: "),writeln(A),
    eliminaAristasPermanente(Aranha,A),
    eliminaConexionesPermanente(Aranha),
    creaConexiones(Aranha,Aristas),
    creaAristas(Aranha,Aristas),!,
    fail)
    ).

restablecerEstado(Aranha, Aristas):-
    turno(JugadorActual),
    writeln("   no movio ni ostias"),
    write("         Viejas aristas: "), writeln(Aristas),
    writeln([JugadorActual, Aranha]),
    aristasDeLaPieza(JugadorActual,Aranha,A),
    write("         Aristas actuales: "),writeln(A),
    eliminaAristasPermanente(Aranha,A),
    eliminaConexionesPermanente(Aranha),
    creaConexiones(Aranha,Aristas),
    creaAristas(Aranha,Aristas),!,
    fail.