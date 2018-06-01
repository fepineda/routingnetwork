%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sistema expertos para el problema del analisis y seleccion de enrutamientos dinamicos en redes de datos
% Ferdinand Pineda
% Cod20116350
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

main :-
  mensaje_inicio,
  reiniciar_respuestas,
  encontrar_lenguaje(Lenguaje),
  describe(Lenguaje), nl.

mensaje_inicio :-
  write('Sistema experto para el problema del analisis y seleccion de enrutamientos dinamicos en  redes de datos'), nl,nl,
  write('Para mi futura red, que tipo de enrutamiento dinamico es el mas adecuado'), nl,nl.

encontrar_lenguaje(Lenguaje) :-
  enrutamiento(Lenguaje), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Almacenar respuestas para hacer seguimiento a las preguntas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- dynamic(progreso/2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Limpiar el progreso realizado en las preguntas
% reiniciar_respuestas debe retornar true must always return true; because retract can return either true
% or false, we fail the first and succeed with the second.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

reiniciar_respuestas :-
  retract(progreso(_, _)),
  fail.
reiniciar_respuestas.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reglas para la base de conocimiento
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

enrutamiento(no_se_puede_usar_enrutamiento) :-
	existe_router(no_tengo_router).

enrutamiento(bgp) :-
	existe_router(si_tengo_router),
	router_conectado(mi_red_se_conecta_con_red_externa).

enrutamiento(estatico) :-
	existe_router(si_tengo_router),
	router_conectado(mi_red_no_se_conecta_con_red_externa),
	tamanio_red(mi_red_menos_5_routers).

enrutamiento(ripv1) :-
	existe_router(si_tengo_router),
	router_conectado(mi_red_no_se_conecta_con_red_externa),
	tamanio_red(mi_red_mas_5_routers),
	congiguracion_simple(deseo_configuracion_simple),
	enrutamiento_rip(no_vlsm).

enrutamiento(ripv2) :-
	existe_router(si_tengo_router),
	router_conectado(mi_red_no_se_conecta_con_red_externa),
	congiguracion_simple(deseo_configuracion_simple),
	enrutamiento_rip(si_vlsm).
	
enrutamiento(ospfv2) :-
	existe_router(si_tengo_router),
	router_conectado(mi_red_no_se_conecta_con_red_externa),
	congiguracion_simple(deseo_configuracion_compleja),
	tipo_estandar(standar_abierto),
	enrutamiento_ospf(no_ipv6_ospf).
		
enrutamiento(ospfv3) :-
	existe_router(si_tengo_router),
	router_conectado(mi_red_no_se_conecta_con_red_externa),
	congiguracion_simple(deseo_configuracion_compleja),
	tipo_estandar(standar_abierto),
	enrutamiento_ospf(si_ipv6_ospf).

enrutamiento(igrp) :-
	existe_router(si_tengo_router),
	router_conectado(mi_red_no_se_conecta_con_red_externa),
	congiguracion_simple(deseo_configuracion_compleja),
	tipo_estandar(standar_cerrado),
	enrutamiento_xgrp(no_ipv6_grp).	

enrutamiento(eigrp) :-
	existe_router(si_tengo_router),
	router_conectado(mi_red_no_se_conecta_con_red_externa),
	congiguracion_simple(deseo_configuracion_compleja),
	tipo_estandar(standar_cerrado),
	enrutamiento_xgrp(si_ipv6_grp).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preguntas para la base de conocimiento
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pregunta(existe_router) :-
  write('¿Usara un router en su red?, lo puede reconocer al tener usualmente el puerto LAN Y WAN entre sus interfaces'), nl.

pregunta(router_conectado) :-
  write('¿Su red tendra conexiones externas o se conectara a redes fuera de su organizacion'), nl.
  
pregunta(tamanio_red) :-
  write('¿Cuantos routers implemetara en su red?'), nl.
  
pregunta(congiguracion_simple) :-
  write('¿La configuracion del router desea que sea simple o compleja?'),nl.

pregunta(enrutamiento_rip) :-
  write('¿En su red utilizara VLSM(subnetting), es decir segmentara su red?'),nl.

pregunta(tipo_estandar) :-
  write('¿En los protocolos de enrutamiento que tipo de estandar deseas usar?'),nl.
  
pregunta(enrutamiento_ospf) :-
  write('¿En su red utilizara soluciones IPv6?'),nl.

pregunta(enrutamiento_xgrp) :-
  write('¿En su red requerira utilizar IPv6?'),nl.
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Respuestas para la base de conocimiento
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

respuesta(no_tengo_router) :-
  write('No usare un Router').

respuesta(si_tengo_router) :-
  write('Si usare un router').

respuesta(mi_red_se_conecta_con_red_externa) :-
  write('Mi red se conectara con redes externas - No se considera conexion a internet').

respuesta(mi_red_no_se_conecta_con_red_externa) :-
  write('Mi red no se conectara con redes externas').
  
respuesta(mi_red_menos_5_routers) :-
  write('Mi red usara 5 o menos routers').
  
respuesta(mi_red_mas_5_routers) :-
  write('Mi red usara mas de 5 routers').
  
respuesta(deseo_configuracion_simple) :-
  write('Deseo realizar una configuracion simple').
  
respuesta(deseo_configuracion_compleja) :-
  write('Deseo realizar una configuracion compleja').
  
respuesta(si_vlsm) :-
  write('Si utilizare VLSM').
  
respuesta(no_vlsm) :-
  write('No utilizare VLSM').
  
respuesta(standar_abierto) :-
  write('Deseo usar un estandar abierto').

respuesta(standar_cerrado) :-
  write('Deseo usar un estandar cerrado').
  
respuesta(si_ipv6_ospf) :-
  write('Si usare IPv6').
  
respuesta(no_ipv6_ospf) :-
  write('No usare IPv6').

respuesta(si_ipv6_grp) :-
  write('Si necesitare IPv6').
  
respuesta(no_ipv6_grp) :-
  write('No necesitare IPv6').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descripcion para la base de conocimiento
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

describe(no_se_puede_usar_enrutamiento) :-
  write('No puede implementar enrutamiento dinamico, se encuentra en un entorno LAN').

describe(bgp) :-
  write('Como desea conectar su red, con una red externa, a traves de un enlace externo utilice el protocolo de enrutamiento BGP - Border Gateway Protocol'). 

describe(estatico) :-
  write('Por el tamanio de su red, es preferible utilizar enrutamiento estatico, tendra un mejor desempeño').

describe(ripv1) :-
write('Si no va a implementar VLSM (Subnetting), puede usar el enrutamiento RIPv1 - Pero ya esta desfasado').

describe(ripv2) :-
write('Como va a implementar VLSM, es rewcoemndable configurar el enrutamiento RIPv2 en su red').

describe(ospfv2) :-
write('Como no va a desplegar IPV6, puede usar el enrutamiento OSPFv2').

describe(ospfv3) :-
write('IPV6 le va a dar muchos benceficios en su red, puede usar el enrutamiento OSPFv3').

describe(igrp) :-
write('Como no va a usar IPV6, puede usar el enrutamiento IGRP - pero se encuentra desfasado').

describe(eigrp) :-
write('Buena eleccion para desplegar IPV6, puede usar el enrutamiento EIGRP').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Asigna una respuesta A las preguntas de la base de conocimiento
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

existe_router(Responde) :-
  progreso(existe_router, Responde).
existe_router(Responde) :-
  \+ progreso(existe_router, _),
  preguntar(existe_router, Responde, [no_tengo_router, si_tengo_router]).

router_conectado(Responde) :-
  progreso(router_conectado, Responde).
router_conectado(Responde) :-
  \+ progreso(router_conectado, _),
  preguntar(router_conectado, Responde, [mi_red_se_conecta_con_red_externa, mi_red_no_se_conecta_con_red_externa]).

tamanio_red(Responde) :-
  progreso(tamanio_red, Responde).
tamanio_red(Responde) :-
  \+ progreso(tamanio_red, _),
  preguntar(tamanio_red, Responde, [mi_red_menos_5_routers,mi_red_mas_5_routers]).  
  
congiguracion_simple(Responde) :-
  progreso(congiguracion_simple, Responde).
congiguracion_simple(Responde) :-
  \+ progreso(congiguracion_simple, _),
  preguntar(congiguracion_simple, Responde, [deseo_configuracion_simple, deseo_configuracion_compleja]). 
  
enrutamiento_rip(Responde) :-
  progreso(enrutamiento_rip, Responde).
enrutamiento_rip(Responde) :-
  \+ progreso(enrutamiento_rip, _),
  preguntar(enrutamiento_rip, Responde, [si_vlsm, no_vlsm]).
  
tipo_estandar(Responde) :-
  progreso(tipo_estandar, Responde).
tipo_estandar(Responde) :-
  \+ progreso(tipo_estandar, _),
  preguntar(tipo_estandar, Responde, [standar_abierto, standar_cerrado]). 

enrutamiento_ospf(Responde) :-
  progreso(enrutamiento_ospf, Responde).
enrutamiento_ospf(Responde) :-
  \+ progreso(enrutamiento_ospf, _),
  preguntar(enrutamiento_ospf, Responde, [si_ipv6_ospf, no_ipv6_ospf]). 
  
enrutamiento_xgrp(Responde) :-
  progreso(enrutamiento_xgrp, Responde).
enrutamiento_xgrp(Responde) :-
  \+ progreso(enrutamiento_xgrp, _),
  preguntar(enrutamiento_xgrp, Responde, [si_ipv6_grp, no_ipv6_grp]). 
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Formato a la lista de respuestas
% [Inicio|Cola] son las alternativas de la lista
% Index es el indice del primero en las alternativas 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

respuestas([], _).
respuestas([Inicio|Cola], Index) :-
  write(Index), write(' '), respuesta(Inicio), nl,
  NextIndex is Index + 1,
  respuestas(Cola, NextIndex).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% "Parse" un  Indice, muestra una respuesta con los elementos de las alternativas
% [Inicio|Cola] 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parse(0, [Inicio|_], Inicio).
parse(Index, [Inicio|Cola], Contesta) :-
  Index > 0,
  NextIndex is Index - 1,
  parse(NextIndex, Cola, Contesta).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pregunta al usuario, guarda la repuesta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

preguntar(Pregunta, Responde, Alternativas) :-
  pregunta(Pregunta),
  respuestas(Alternativas, 0),
  read(Index),
  parse(Index, Alternativas, Contesta),
  asserta(progreso(Pregunta, Contesta)),
  Contesta = Responde.