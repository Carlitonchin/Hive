function Pieza()
{
    this.coordenadas = {};
    this.conexiones = {};
}

    var piezas = {};
    piezas["blancas"] = {};
    piezas["negras"] = {};

    var bordes = {};
    bordes["blancas"] = {};
    bordes["negras"] = {};

function piezaConEstasCoordenadas(piezas, x, y)
{
  let result = false;

  ["blancas", "negras"].forEach(jugador=>
    {
    if(piezas[jugador])
    {
     Object.keys(piezas[jugador]).forEach(p=>
      {
        let array = [];
        if(piezas[jugador][p].length === undefined)
            array = [piezas[jugador][p]]
        else
            array = piezas[jugador][p]

        for(let i = 0; i < array.length; i++)
        {
            let coordendas = array[i].coordenadas
            if(coordendas[1][0] <= x && coordendas[2][0] >= x && coordendas[4][1] >= y && coordendas[1][1] <= y)
              result =  [jugador, p, i]
        }
        
      }
    
      )
    }
    });

    return result;
}

function dibujaBorde([v1X, v1Y], [v2X, v2Y], [v3X, v3Y], [v4X, v4Y], [v5X, v5Y], [v6X, v6Y])
{

    let result = new Pieza();
    result.coordenadas[1] = [v1X, v1Y];
    result.coordenadas[2] = [v2X, v2Y];
    result.coordenadas[3] = [v3X, v3Y];
    result.coordenadas[4] = [v4X, v4Y];
    result.coordenadas[5] = [v5X, v5Y];
    result.coordenadas[6] = [v6X, v6Y];

    let jugadores = ["negras", "blancas"]
    for(let i = 0; i < jugadores.length; i++)
    {
        if(bordes[jugadores[i]])
        {
            let piezas = Object.keys(bordes[jugadores[i]]);
            
            for(let p = 0; p < piezas.length; p++)
            {
                let array = bordes[jugadores[i]][piezas[p]];
                
                for(let b = 0; b < array.length; b++)
                {
                    let borde = array[b];
                    if(borde.coordenadas[1][0] == v1X && borde.coordenadas[1][1] == v1Y)
                        return null;
                }
                
            }
    }
    }

    for(let i = 0; i < jugadores.length; i++)
    {
        let p = Object.keys(piezas[jugadores[i]]);
        for(let j = 0; j < p.length; j++)
        {
            let coordenadas = piezas[jugadores[i]][p[j]].coordenadas;
            if(coordenadas[1][0] == v1X && coordenadas[1][1] == v1Y)
                return null;
        }
    }

    let canvas = document.getElementById("canvas");
    let contexto = canvas.getContext("2d");
    contexto.lineWidth = 2;

    contexto.strokeStyle = "yellow";
    
    contexto.beginPath();
    // Esquina superior izquierda
    contexto.moveTo(v1X, v1Y);
    // Línea recta superior
    contexto.lineTo(v2X, v2Y);
    // Esquina central derecha
    contexto.lineTo(v3X, v3Y);
    // Esquina inferior derecha
    contexto.lineTo(v4X, v4Y);
    // Línea recta inferior
    contexto.lineTo(v5X, v5Y);
    // Esquina central izquierda
    contexto.lineTo(v6X, v6Y);
    // Y dejamos que la última línea la dibuje JS
    contexto.closePath();
    // Hacemos que se dibuje
    contexto.stroke();
    // Lo rellenamos
    contexto.fillStyle = "#00000050";
    contexto.fillRect(v1X, v1Y, 60, 100);
    

    return result;
}

function pintaLugaresVacios(jugador, p)
{   
    pieza = piezas[jugador][p];
    bordes[jugador][p] = [];
    [1,2,3,4,5,6].forEach(i=>
        {
            if(!pieza.conexiones[i])
            {
                cara = i + 3;
                if(cara > 6)
                  cara = cara%7+1;

                mi_cara = i+1;
                if(mi_cara > 6)
                  mi_cara = 1;

                [x,y] = pieza.coordenadas[mi_cara]
                v1X = getV1X(x, cara);
                v1Y = getV1Y(y, cara);

                let v2X = v1X + 60;
                let v2Y = v1Y;
                
                let b = dibujaBorde([v1X, v1Y], [v2X,v2Y], [v2X+30,50+v2Y], [v2X, v2Y+100], [v1X, v1Y+100], [v1X-30, v1Y+50]);
                if(b)
                {
                    b.lado = i;
                    bordes[jugador][p].push(b);
                    
                }
            }
        })

}

function pintaTodosLosLugaresVacios()
{
    
    ["blancas", "negras"].forEach(jugador=>
        {
            Object.keys(piezas[jugador]).forEach(pieza=>
                {
                    pintaLugaresVacios(jugador, pieza);
                });
        });

    let canvas = document.getElementById("canvas");
    canvas.addEventListener("click", clickBorde)
}

function clickBorde(event)
{
    let canvas = document.getElementById("canvas");
    let left = canvas.offsetLeft + canvas.clientLeft;
    let top = canvas.offsetTop;
    let x = event.layerX - left;
    let y = event.layerY - top;
    let result = piezaConEstasCoordenadas(bordes, x, y);
    if(result)
    {
        let [jugador, pieza, index] = result;
        let cara = bordes[jugador][pieza][index].lado;
        return ponerPieza(jugador, pieza, cara);
    }

    return false;
}

function clickCanvas(event)
{
  let canvas = document.getElementById("canvas");
  let left = canvas.offsetLeft + canvas.clientLeft;
  let top = canvas.offsetTop;
  let x = event.layerX - left;
  let y = event.layerY - top;
  
  let result = piezaConEstasCoordenadas(piezas, x, y);
  if(result)
  {
    let [jugador, pieza, _] = result;
    pintaLugaresVacios(jugador, pieza)
  }
 
  
}