
%%%%%%%%%%%%%%%%%
%%Base de datos%%
%%%%%%%%%%%%%%%%%

herramientasRequeridas(ordenarCuarto, [[aspiradora(100),escoba], trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordeadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

cazaPolvo(egon).
cazaPolvo(peter).
cazaPolvo(winston).
cazaPolvo(ray).

%tareaPedida(tarea, cliente, metrosCuadrados).
tareaPedida(ordenarCuarto, dana, 20).
tareaPedida(cortarPasto, walter, 50).
tareaPedida(limpiarTecho, walter, 70).
tareaPedida(limpiarBanio, louis, 15).

%precio(tarea, precioPorMetroCuadrado).
precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).


%%%%%%%%%%%%%%
%%Resolucion%%
%%%%%%%%%%%%%%

% Punto 1

%tieneHerramientas(Nombre,Herramienta).

tieneHerramientas(egon,aspiradora(200)).
tieneHerramientas(egon,trapeador).
tieneHerramientas(peter,trapeador).
tieneHerramientas(peter,plumero).
tieneHerramientas(peter,escoba).
tieneHerramientas(winston,varitaNeutrones).

% Punto 2

satisfaceNecesidad(CazaPolvo,Herramienta):-
    tieneHerramientas(CazaPolvo,Herramienta).    
satisfaceNecesidad(CazaPolvo,aspiradora(PotenciaRequerida)):-
    tieneHerramientas(CazaPolvo,aspiradora(Potencia)),
    Potencia >= PotenciaRequerida.
satisfaceNecesidad(CazaPolvo, ListaRemplazables):-
	member(Herramienta, ListaRemplazables),
	satisfaceNecesidad(CazaPolvo, Herramienta).

% Punto 3

puedeRealizar(Tarea,CazaPolvo):-
    herramientasRequeridas(Tarea,_),
    tieneHerramientas(CazaPolvo,varitaNeutrones).
puedeRealizar(Tarea,CazaPolvo):-
    cazaPolvo(CazaPolvo),
    herramientasRequeridas(Tarea,HerramientasRequeridas),
    forall(member(Herramienta,HerramientasRequeridas),satisfaceNecesidad(CazaPolvo,Herramienta)).

% Punto 4

% precio y taraPedida agregados a la base de conociminento

cuantoSeLeCobraPor(Tarea,Cliente,Monto):-
    tareaPedida(Tarea,Cliente,MetrosCuad),
    precio(Tarea,PrecioPorMetroCuad),
    Monto is MetrosCuad*PrecioPorMetroCuad.

cobroPorCliente(Cliente,MontoFinal):-
    tareaPedida(_,Cliente,_),
    findall(Monto,cuantoSeLeCobraPor(_,Cliente,Monto),ListaMontos),
    sum_list(ListaMontos, MontoFinal).

% Punto 5
tareaCompleja(Tarea):-
    herramientasRequeridas(Tarea,Herramientas),
    length(Herramientas, Cuantas),
    Cuantas > 2.

condicionCazapolvo(ray,Cliente):-
    tareaPedida(_,Cliente,_),
    forall(tareaPedida(Tarea,Cliente,_),Tarea \= limpiarTecho).
condicionCazapolvo(winston,Cliente):-
    tareaPedida(_,Cliente,_),
    cobroPorCliente(Cliente,Monto),
    Monto > 500.
condicionCazapolvo(egon,Cliente):-
    tareaPedida(_,Cliente,_),
    forall(tareaPedida(Tarea,Cliente,_),not(tareaCompleja(Tarea))).
condicionCazapolvo(peter,Cliente):-
    tareaPedida(_,Cliente,_).

aceptanPedido(Cliente,CazaPolvo):-
    tieneHerramientas(CazaPolvo,_),
    tareaPedida(_,Cliente,_),
    forall(tareaPedida(Tarea,Cliente,_),puedeRealizar(Tarea,CazaPolvo)),
    condicionCazapolvo(CazaPolvo,Cliente).

% Punto 6
% a)

%herramientasRequeridas(ordenarCuarto, [[escoba,aspiradora(100)], trapeador, plumero]).

/*
La alternativa que planteamos en esta solución es agrupar en una lista
las herramientas remplazables, y agregar una nueva definición a 
satisfaceNecesidad, que era el predicado que usabamos para tratar
directamente con las herramientas, que trate polimorficamente tanto
a nuestros hechos sin herramientas remplazables, como a aquellos que 
sí las tienen. También se podría haber planteado con un functor en vez
de lista
*/
    
    


    
    



    
