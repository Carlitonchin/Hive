
        
        
        function dibujaHex([v1X, v1Y], [v2X, v2Y], [v3X, v3Y], [v4X, v4Y], [v5X, v5Y], [v6X, v6Y], jugador, pieza, coordenadas)
        {

            let canvas = document.getElementById("canvas");
            let contexto = canvas.getContext("2d");
            contexto.lineWidth = 2;

            contexto.strokeStyle = "#212121";
            contexto.fillStyle = (jugador == "blancas")?"#E3E4E5":"#332F2C";
            
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
            contexto.fill();

            contexto.fillStyle = "#FFFF65";
            contexto.fillRect(v1X, v1Y, 60, 100);
            
            contexto.fillStyle = "red"
            contexto.fillText(pieza, v1X + 15, v1Y + 50)
            /*contexto.fillText(coordenadas[1], v1X+20, v1Y + 10);
            contexto.fillText(coordenadas[2], v2X, v2Y + 35);
            contexto.fillText(coordenadas[3], v3X-35, v3Y+25);
            contexto.fillText(coordenadas[4], v4X-35, v4Y - 5);
            contexto.fillText(coordenadas[5], v5X - 20, v5Y -35);
            contexto.fillText(coordenadas[6], v6X+20, v6Y-20);*/

            let p = new Pieza();
            p.coordenadas[1] = [v1X, v1Y]
            p.coordenadas[2] = [v2X, v2Y]
            p.coordenadas[3] = [v3X, v3Y]
            p.coordenadas[4] = [v4X, v4Y]
            p.coordenadas[5] = [v5X, v5Y]
            p.coordenadas[6] = [v6X, v6Y]
            return p;
        }

    function getV1X(X, v)
    {
        if(v == 1 || v == 5)
            return X;

        if(v == 2 || v == 4)
            return X - 60;

        if(v == 3)
            return X - 90;
        
        return X + 30;
    }

    function getV1Y(Y, v)
    {
        if(v == 1 || v == 2)  return Y;
        
        if(v == 3 || v == 6) return Y - 50;
        
        return Y - 100;
    }

      function draw(pieza, jugador, jugador2, cara2, pieza2, x,y){
        refrescarCanvas();
          let v1X =0;
          let v1Y = 0;
          let ml = 0;
          if(!pieza2)
            {
                v1X = x;
                v1Y = y;
            }
            else{
                cara2 = Number(cara2);
                ml = cara2 + 3;
                if(ml > 6)
                  ml = ml%7+1;

                cara2++;
                if(cara2 > 6)
                  cara2 = 1;

                [X,Y] = piezas[jugador2][pieza2].coordenadas[cara2]
                
                v1X = getV1X(X, ml);
                v1Y = getV1Y(Y, ml);
            }

          
          let v2X = v1X + 60;
          let v2Y = v1Y;
        let piezaDibujada = dibujaHex([v1X, v1Y], [v2X,v2Y], [v2X+30,50+v2Y], [v2X, v2Y+100], [v1X, v1Y+100], [v1X-30, v1Y+50], jugador, pieza)
        piezas[jugador][pieza] = piezaDibujada;
        if(ml !== 0 )
        {
        
        cara2--;
        if(cara2 == 0)
          cara2 = 6;
        
          //conectar(piezaDibujada, ml, piezas[jugador2][pieza2], cara2)
        }
      }

      function conectar(pieza1, cara1, pieza2, cara2)
      {
        if(pieza1.conexiones[cara1])
          return;

        pieza1.conexiones[cara1] = pieza2;
        pieza2.conexiones[cara2] = pieza1;
        
        let cara2_1 = cara2 + 1;
        let cara2_2 = cara2 - 1;
        let cara1_1 = cara1 - 1;
        let cara1_2 = cara1 + 1;

        if(cara1_1 < 1)
          cara1_1 = 6;

        if(cara1_2 > 6)
          cara1_2 = 1;
 
        if(cara2_1 > 6)
          cara2_1 = 1;

        if(cara2_2 < 1)
          cara2_2 = 6;

        if(pieza2.conexiones[cara2_1])
          {
            let nuevaCara2 = cara1_1 + 3;
                if(nuevaCara2 > 6)
                  nuevaCara2 = nuevaCara2%7+1;

            return conectar(pieza1, cara1_1, pieza2.conexiones[cara2_1], nuevaCara2)
          }
          if(pieza2.conexiones[cara2_2])
          {
            let nuevaCara2 = cara1_2 + 3;
                if(nuevaCara2 > 6)
                  nuevaCara2 = nuevaCara2%7+1;

            return conectar(pieza1, cara1_2, pieza2.conexiones[cara2_2], nuevaCara2)
          }
      }

function corrimientoY(cant)
{
  ["blancas", "negras"].forEach(jugador => {
    Object.keys(piezas[jugador]).forEach(pieza=>
      {
        let v = piezas[jugador][pieza].coordenadas;
        [1,2,3,4,5,6].forEach(i=>
          {
            piezas[jugador][pieza].coordenadas[i][1] += cant;
          })
      });
  });
}

function corrimientoX(cant)
{
  ["blancas", "negras"].forEach(jugador => {
    Object.keys(piezas[jugador]).forEach(pieza=>
      {
        let v = piezas[jugador][pieza].coordenadas;
        [1,2,3,4,5,6].forEach(i=>
          {
            piezas[jugador][pieza].coordenadas[i][0] += cant;
          })
      });
  });
}

function corrimiento(piezas)
{
  let canvas = document.getElementById("canvas");
  let menorX = 0;
  let mayorX = canvas.width;
  let menorY = 0;
  let mayorY = canvas.height;
  let left = canvas.offsetLeft + canvas.clientLeft;
  let top = canvas.offsetTop;
  ["blancas", "negras"].forEach(jugador => {
    Object.keys(piezas[jugador]).forEach(pieza=>
      {
        let v = piezas[jugador][pieza].coordenadas;
        menorX = Math.min(v[6][0] - left - 60, menorX);
        menorY = Math.min(v[1][1] - 60, menorY);
        mayorX = Math.max(v[3][0] - left + 60, mayorX);
        mayorY = Math.max(v[4][1] + 60, mayorY);
        
          
      });
  });

  if(menorX < 0)
    corrimientoX(-1*menorX);

  if(mayorX > canvas.width)
    corrimientoX(canvas.width - mayorX)

    if(menorY < 0)
    corrimientoY(-1*menorY);

  if(mayorY > canvas.height)
    corrimientoY(canvas.height - mayorY)

  refrescarCanvas();
}

      function refrescarCanvas()
      {
        bordes["blancas"] = {};
        bordes["negras"] = {};
        let canvas = document.getElementById("canvas");
        canvas.width = canvas.width;
        ["blancas", "negras"].forEach(jugador => {
          Object.keys(piezas[jugador]).forEach(pieza=>
            {
              let v = piezas[jugador][pieza].coordenadas;
              dibujaHex([v[1][0], v[1][1]], [v[2][0], v[2][1]], [v[3][0], v[3][1]], [v[4][0], v[4][1]], [v[5][0], v[5][1]], [v[6][0], v[6][1]], jugador, pieza)
            });
        });
      }