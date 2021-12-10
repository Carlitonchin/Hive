'use strict';
var piezaActual = "";
// Simple client for running a query on the server and displaying the result

var piezaModelo = undefined;

// Called by <body onload="renderPage();">
async function renderPage() {
    document.getElementById('query_form').addEventListener('submit', handleSubmit);
    document.getElementById('jugar_form').addEventListener('submit', jugarSubmit);
    document.getElementById('result').style.display = 'none';
    //document.getElementById('canvas').addEventListener("click", clickBorde)
    let canvas = document.getElementById('canvas')
    canvas.addEventListener("click", clickCanvas)
    updateState();
}

function parsearLista(q)
{
    let result = {};
    q = q.substring(1, q.length - 1);
    q = q.split(']');
    
    for(let i = 0; i < q.length - 1; i++)
    {
        let lado = q[i].substring((i==0)?1:2, q[i].length);
        let array = lado.split(',');
        result[array[0]] = [array[1], array[2]];
    }

    return result
}

async function moverPieza(pieza, jugador2, pieza2, cara2)
{
    let result = '';
    await fetchFromServer('/json', {query: `mover(${pieza}, ${pieza2}, ${jugador2}, ${cara2})`},
                          query_result => result = query_result);

    if(result.success && result.success!="error")
    {
        piezaModelo = 
        {
            jugador:jugador2,
            pieza:pieza2,
            x: piezas[jugador2][pieza2].coordenadas[1][0],
            y: piezas[jugador2][pieza2].coordenadas[1][1]
        }
        await updateState()
       
    }
    else
    {
        refrescarCanvas()
    }
    document.getElementById("true_orFalse").innerHTML = result.success;
    document.getElementById("canvas").removeEventListener("click", clickMoverPieza);

}

async function pintarPieza(pieza, jugador2, pieza2, cara2)
{
    let jugador = "blancas";
    await fetchFromServer('/json', {query: "turno(X)."},
                          query_result => (jugador = query_result.vars[0].value));
    
    jugador = (jugador == "blancas")? "negras": "blancas";
    let q = "";
    await fetchFromServer('/json', {query: `findall([Cara, X, Y], arista(${jugador}, ${pieza}, Cara, X, Y), P).`},
                          query_result => (q = query_result.vars[3].value));
    
    
    let coordenadas = parsearLista(q);
    draw(pieza, jugador, jugador2, cara2, pieza2, 400, 150)
    if(pieza2){

    piezaModelo = {
        jugador:jugador2,
        pieza:pieza2,
        x: piezas[jugador2][pieza2].coordenadas[1][0],
        y: piezas[jugador2][pieza2].coordenadas[1][1]
    }

    }
}

async function ponerPieza(jugador, pieza, cara)
{
    piezaActual = document.getElementById("piezasSinJugar").value;
    let q = `agregarFicha(${piezaActual} , ${jugador} , ${pieza}, ${cara} ).`;
    let result = 0;
    await fetchFromServer('/json', {query: q},
                          query_result => result = query_result)

    if(result.success && result.success!="error")
    {
        pintarPieza(piezaActual, jugador, pieza, cara);
        await updateState()
    }
    else
    {
        refrescarCanvas();
    }
    document.getElementById("true_orFalse").innerHTML = result.success;
    
    document.getElementById("canvas").removeEventListener("click", clickAgregarPieza);
}

async function jugarSubmit(event)
{
    event.preventDefault();
    refrescarCanvas();
    document.getElementById("canvas").addEventListener("click", clickAgregarPieza)
    let select = document.getElementById('piezasSinJugar');
    
   /* let pieza2 = document.getElementById('pieza2');
    let jugador = document.getElementById("jugador");
    let cara = document.getElementById("cara");*/
    let q = "";
    let cantPiezasJugadasBlancas = "";
    await fetchFromServer('/json', {query: "cantPiezasJugadas(blancas,X)."},
                          query_result => cantPiezasJugadasBlancas = query_result.vars[0].value)
    if(cantPiezasJugadasBlancas !== "0")
    {
        piezaActual = select.value;
       pintaTodosLosLugaresVacios();
       
    }
         
    else
    {
        q = `agregarFicha(${select.value}).`;

    let result = 0;
    await fetchFromServer('/json', {query: q},
                          query_result => result = query_result)

    if(result.success && result.success!="error")
    {
        pintarPieza(select.value);
        
        await updateState()
    }
    document.getElementById("true_orFalse").innerHTML = result.success;
}
}

function separarArray(array)
{
   return array = array.substring(1, array.length - 1).split(',');
}

async function turno()
{
    let turno = document.getElementById('turno');
    await fetchFromServer('/json', {query: "turno(X)."},
                          query_result => turno.innerHTML = query_result.vars[0].value);
}

async function piezasBlancasSinJugar()
{
    let div = document.getElementById("piezasBlancasSinJugar");
    await fetchFromServer('/json', {query: "findall(X, piezasSinJugar(blancas,X), P)."},
                          query_result => div.innerHTML = separarArray(query_result.vars[1].value));

}
async function piezasBlancasJugadas()
{
    let div = document.getElementById("piezasBlancasJugadas");
    await fetchFromServer('/json', {query: "findall(X, piezasJugadas(blancas,X), P)."},
                          query_result => div.innerHTML = separarArray(query_result.vars[1].value));

}
async function piezasSinJugar()
{
    let div = document.getElementById("piezasNegrasSinJugar");
    await turno();
    let t = document.getElementById("turno").innerHTML;
    let select = document.getElementById("piezasSinJugar");
    select.innerHTML = "";
    await fetchFromServer('/json', {query: `findall(X, piezasSinJugar(${t},X), P).`},
                          query_result => 
                          {
                              let r= separarArray(query_result.vars[1].value)
                              r.forEach(pieza=>
                                {
                                    let option = document.createElement("option");
                                    option.innerHTML = pieza;
                                    option.value = pieza;
                                    select.appendChild(option)
                                });
                            
                            });

}
async function piezasNegrasJugadas()
{
    let div = document.getElementById("piezasNegrasJugadas");
    await fetchFromServer('/json', {query: "findall(X, piezasJugadas(negras,X), P)."},
                          query_result => div.innerHTML = separarArray(query_result.vars[1].value));

}

function parsearPizasJugadas(s)
{
    s = s.substring(1, s.length - 1)
    s = s.split(']');
    result = []
    for(let i = 0; i < s.length - 1; i++)
    {
        if(i === 0)
        {
            result.push(s[i].substring(1, s[i].length))
        }
        else
            result.push(s[i].substring(2, s[i].length))
    }

    return result;
}

async function pintarTodo(r, piezaModelo)
{
    if(!r)
    return;
    piezas["blancas"] = {};
    piezas["negras"] = {};
    let pintados = {}
    let [pieza, jugador] = r.split(',');
    let x = 400;
    let y = 150;
    if(piezaModelo)
        {
            x = piezaModelo.x;
            y = piezaModelo.y;
        }
    await draw(pieza, jugador, null, null, null, x, y);
    let grafo = [`${pieza},${jugador}`]
    pintados[`${pieza},${jugador}`] = true;
    while(grafo.length > 0){
    [pieza, jugador] = grafo.shift().split(',');
    await fetchFromServer('/json', {query: `findall([Cara1, Jugador2, Pieza2, Cara2], conexion(${jugador},${pieza}, Cara1, Jugador2, Pieza2, Cara2), P).`},
    async query_result => {
        let l = parsearPizasJugadas(query_result.vars[4].value);
        
        l.forEach(async e=>
            {
                
                const [cara, jugador2, pieza2] = e.split(',');
                if(!pintados[`${pieza2},${jugador2}`])
                {
                    await draw(pieza2, jugador2, jugador, cara, pieza);
                    grafo.push(`${pieza2},${jugador2}`)
                    pintados[`${pieza2},${jugador2}`] = true;
                }
                
            })
    });

}
corrimiento(piezas);
}

async function pintarTodoRequest()
{
    let rival = "";
    await fetchFromServer('/json', {query: "rival(X)."},
    async query_result => {rival = query_result.vars[0].value});
    
    await fetchFromServer('/json', {query: "findall([X, Jugador], piezasJugadas(Jugador,X), P)."},
                          async query_result => {
                            let r= parsearPizasJugadas(query_result.vars[2].value)
                            let pieza = "";
                            if(!piezaModelo)
                            {
                                pieza = r[0]
                            }
                                
                            else
                            {
                                pieza = piezaModelo.pieza + "," + piezaModelo.jugador;
                            }
                            await pintarTodo(pieza, piezaModelo);
                          });

    
}

async function updateState()
{
    refrescarCanvas();
    await turno();
    
     await piezasSinJugar()
    
     await pintarTodoRequest();

}



// Handler for form's "Send query" button
async function handleSubmit(event) {
    event.preventDefault();

    let text = document.getElementById('query');
    await fetchFromServer('/json', {query: text.value},
                          query_result => displayQueryResult(query_result));
    await updateState()
}

// Send a request to the server and schedule a callback.
async function fetchFromServer(path, request, callback) {
    // callback should take a single arg, the response from the server.
    try {
        const response = await fetch(
            path,
            {method: 'POST',
             headers: {'Content-Type': 'application/json'},
             body: JSON.stringify(request),
             mode: 'cors',                  // Don't need?
             cache: 'no-cache',             // Don't need?
             credentials: 'same-origin',    // Don't need?
             redirect: 'follow',            // Don't need?
             referrerPolicy: 'no-referrer', // Don't need?
            });
        callback(await response.json());
    } catch(err) {
        // TODO: the following doesn't capture enough information;
        //       there is interesting information in the console log
        //       such as error code 500 or ERR_CONNECTION_REFUSED
        alert('***fetch ' + JSON.stringify(request) + ': ' + err);
    }
}

// Callback from fetchFromServer for handleSubmit
function displayQueryResult(query_result) {
    document.getElementById('result').style.display = 'block';
    document.getElementById('result:query').innerHTML = '<code>' + sanitizeText(query_result.query) + '</code>';
    document.getElementById('result:success').innerHTML = '<i>' + query_result.success.toString() + '</i>';
    document.getElementById('result:query_after_call').innerHTML = '<code>' + sanitizeText(query_result.query_after_call) + '</code>';
    document.getElementById('result:error').innerHTML = '<i><code>' + sanitizeText(query_result.error) + '</code></i>';
    document.getElementById('result:printed_output').innerHTML = '<div class="printed_output">' + sanitizeText(query_result.printed_output) + '</div>';
    document.getElementById('result:vars').innerHTML = '&nbsp';
    if (query_result.success === true) {
        let table = document.createElement('table');
        table.setAttribute('class', 'vars_table');
        
        for (var one_var of query_result.vars) {
            var row = table.insertRow();
            row.vAlign = 'top';
            var td1 = row.insertCell();
            td1.setAttribute('class', 'vars_table');
            td1.innerHTML = '<b><code>' + sanitizeText(one_var.var) + '</code></b>';
            var td2 = row.insertCell();
            td2.setAttribute('class', 'vars_table');
            td2.innerHTML = '<code>' + sanitizeText(one_var.value) + '</code>';
        }
        let result_vars_elem = document.getElementById('result:vars');
        while (result_vars_elem.firstChild) {
            result_vars_elem.firstChild.remove();
        }
        result_vars_elem.appendChild(table);
        document.getElementById('result:query_after_call').innertHTML = '<code>' + sanitizeText(query_result.query_after_call) + '</code>';
    } else if (query_result.success === false) {
        // do nothing
    } else if (query_result.success === 'error') {
        // do nothing
    } else {
        alert('Impossible code from server: ' + JSON.stringify(query_result));
    }
}

// Sanitize a string, allowing tags to not cause problems
function sanitizeText(raw_str) {
    // There shouldn't be a need for .replace(/ /g, '&nbsp;') if CSS
    // has white-space:pre ... but by experiment, it's needed.
    // TODO: remove the '<br/>' insertion and put it into extract_color.pl.
    return raw_str ? (raw_str
                      .replace(/&/g, '&amp;')
                      .replace(/</g, '&lt;')
                      .replace(/>/g, '&gt;')
                      .replace(/"/g, '&quot;')
                      .replace(/'/g, '&apos;')
                      .replace(/\n/g, '<br/>')  // TODO: remove - not needed?
                      .replace(/\s/g, '&nbsp;'))  // TODO: add test for tabs in source
        : raw_str;
}
