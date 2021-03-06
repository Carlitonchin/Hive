
:- module(estado, [turno/1, rival/1, piezasSinJugar/2, piezasJugadas/2, cantPiezasJugadas/2, cantPiezasJugadasMas1/0, debajoDeEscarabajos/4, cantPiezasJugadasMas1/0, ultimaPiezaMovida/2, piezaBloqueada/4, abejaJugada/1, topeDeLaTorre/4,juegoTerminado/1]).

:- dynamic piezasSinJugar/2, turno/1, cantPiezasJugadas/2, piezasJugadas/2, debajoDeEscarabajos/4,ultimaPiezaMovida/2, piezaBloqueada/4, abejaJugada/1, juegoTerminado/1.


turno(blancas).

rival(R):-
    turno(X),
    X = blancas,
    R = negras,
    !.
rival(R):-
    turno(X),
    X = negras,
    R = blancas,
    !.

piezasSinJugar(Jugador, Pieza) :- fail.

piezasSinJugar(blancas, hormiga1).
piezasSinJugar(blancas, hormiga2).
piezasSinJugar(blancas, hormiga3).
piezasSinJugar(blancas, abeja).
piezasSinJugar(blancas, mariquita).
piezasSinJugar(blancas, mosquito).
piezasSinJugar(blancas, saltamontes1).
piezasSinJugar(blancas, saltamontes2).
piezasSinJugar(blancas, saltamontes3).
piezasSinJugar(blancas, aranha1).
piezasSinJugar(blancas, aranha2).
piezasSinJugar(blancas, escarabajo1).
piezasSinJugar(blancas, escarabajo2).
piezasSinJugar(blancas, bola).

piezasSinJugar(negras, hormiga1).
piezasSinJugar(negras, hormiga2).
piezasSinJugar(negras, hormiga3).
piezasSinJugar(negras, abeja).
piezasSinJugar(negras, mariquita).
piezasSinJugar(negras, mosquito).
piezasSinJugar(negras, saltamontes1).
piezasSinJugar(negras, saltamontes2).
piezasSinJugar(negras, saltamontes3).
piezasSinJugar(negras, aranha1).
piezasSinJugar(negras, aranha2).
piezasSinJugar(negras, escarabajo1).
piezasSinJugar(negras, escarabajo2).
piezasSinJugar(negras, bola).

piezasJugadas(Jugador, Pieza) :- fail.

debajoDeEscarabajos(Jugador,Pieza,Jugador2,Escarabajo):- fail.

piezaBloqueada(Jugador,Pieza,NumeroTurno,JugadorDeTurno):- fail.

topeDeLaTorre(Jugador1, Pieza1, JugadorR, PiezaR):-
    (debajoDeEscarabajos(Jugador1, Pieza1, J, P)),
    topeDeLaTorre(J,P,JugadorR,PiezaR);
    (
    JugadorR = Jugador1,
    PiezaR = Pieza1
    ).
    
    

cantPiezasJugadas(blancas, 0).
cantPiezasJugadas(negras, 0).

cantPiezasJugadasMas1 :-
    turno(Jugador),
    cantPiezasJugadas(Jugador, Cant),
    retract(cantPiezasJugadas(Jugador, Cant)),
    NewCant is Cant + 1,
    assert(cantPiezasJugadas(Jugador, NewCant)).


