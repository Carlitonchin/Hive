        
        function Pieza()
        {
          this.coordenadas = {};
          this.conexiones = {};
        }

        var piezas = {};
        piezas["blancas"] = {};
        piezas["negras"] = {};
        function dibujaHex([v1X, v1Y], [v2X, v2Y], [v3X, v3Y], [v4X, v4Y], [v5X, v5Y], [v6X, v6Y], jugador, pieza, coordenadas)
        {
            let canvas = document.getElementById("canvas");
            let contexto = canvas.getContext("2d");
            contexto.lineWidth = 2;

            contexto.strokeStyle = "#212121";
            contexto.fillStyle = (jugador == "blancas")?"gray":"#ff8080";
            
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

            contexto.fillStyle = "yellow";
            contexto.fillRect(v1X, v1Y, 60, 100);
            
            contexto.fillStyle = "red"
            contexto.fillText(pieza, v1X + 15, v1Y + 50)
            contexto.fillText(coordenadas[1], v1X+20, v1Y + 10);
            contexto.fillText(coordenadas[2], v2X, v2Y + 35);
            contexto.fillText(coordenadas[3], v3X-35, v3Y+25);
            contexto.fillText(coordenadas[4], v4X-35, v4Y - 5);
            contexto.fillText(coordenadas[5], v5X - 20, v5Y -35);
            contexto.fillText(coordenadas[6], v6X+20, v6Y-20);

            piezas[jugador][pieza] = new Pieza();
            piezas[jugador][pieza].coordenadas[1] = [v1X, v1Y]
            piezas[jugador][pieza].coordenadas[2] = [v2X, v2Y]
            piezas[jugador][pieza].coordenadas[3] = [v3X, v3Y]
            piezas[jugador][pieza].coordenadas[4] = [v4X, v4Y]
            piezas[jugador][pieza].coordenadas[5] = [v5X, v5Y]
            piezas[jugador][pieza].coordenadas[6] = [v6X, v6Y]
            return piezas[jugador][pieza];
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

      function draw(pieza, jugador, jugador2, cara2, pieza2, coordenadas){
          
          let v1X =0;
          let v1Y = 0;
          if(!pieza2)
            {
                v1X = 400;
                v1Y = 150;
            }
            else{
                cara2 = Number(cara2);
                let ml = cara2 + 3;
                if(ml > 6)
                  ml = ml%7+1;

                cara2++;
                if(cara2 > 6)
                  cara2 = 1;

                [X,Y] = piezas[jugador2][pieza2].coordenadas[cara2]
                console.log(X, Y);
                console.log(ml)
                v1X = getV1X(X, ml);
                v1Y = getV1Y(Y, ml);
            }

          
          let v2X = v1X + 60;
          let v2Y = v1Y;
        let piezaDibujada = dibujaHex([v1X, v1Y], [v2X,v2Y], [v2X+30,50+v2Y], [v2X, v2Y+100], [v1X, v1Y+100], [v1X-30, v1Y+50], jugador, pieza, coordenadas)
        piezaDibujada.conexiones[ml] = piezas[jugador2][pieza2];
        piezas[jugador2][pieza2].conexiones[cara2] = piezaDibujada;
      }