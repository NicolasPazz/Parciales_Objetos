class Receta {
    const property ingredientes = []
    const property dificultad
    const calidad

    method experiencia() = calidad.experiencia(self)

    method esDificil() = dificultad > 5 or self.cantidadDeIngredientes() > 10
    method cantidadDeIngredientes() = ingredientes.size()

    method tieneSimilar(preparaciones) = preparaciones.any{ preparacion => self.esSimilar(preparacion)}
    method esSimilar(preparacion) = self.ingredientesSimilares(preparacion) or self.dificultadSimilar(preparacion)

    method ingredientesSimilares(preparacion) = preparacion.ingredientes().all{ ingrediente => ingredientes.contains(ingrediente) }
    
    method dificultadSimilar(preparacion) = self.diferenciaDeDificultad(preparacion.dificultad()) <= 1
    method diferenciaDeDificultad(dificultad_) = (dificultad_ - dificultad).abs() 

    //  3
    method menosDeCuatroIngredientes() = self.cantidadDeIngredientes() < 4
    method preparacionesSimilares(preparaciones) = preparaciones.filter{ preparacion => self.esSimilar(preparacion) }
}

class Cocinero {
    const preparaciones = []
    var property nivel = principiante

    //  3
    method preparar(receta) { 
        nivel.validarReceta(receta, self)
        self.agregarPreparacion(receta)
        self.evaluarNivel()
    }
    method agregarPreparacion(receta) { preparaciones.add(receta) }

    method tienePreparacionSimilar(receta) = receta.tieneSimilar(preparaciones)

    method evaluarNivel(){
        if(self.superoNivel(nivel))
            nivel = nivel.siguienteNivel()
    }

    //  1
    method experienciaAdquirida() = preparaciones.sum{ preparacion => preparacion.experiencia() }

    //  2
    method superoNivel(nivel_) = nivel_.superoNivel(self)
    method cantidadPreparacionesDificiles() = preparaciones.count{ preparacion => preparacion.esDificil() }

    //  3
    method perfecciono(receta) = self.experienciaRecetasSimilares(receta) * 3 >= receta.experiencia()
    method preparacionesSimilares(receta) = receta.preparacionesSimilares(preparaciones)
    method experienciaRecetasSimilares(receta) = self.preparacionesSimilares(receta).sum{ preparacion => preparacion.experiencia() }
    method cantidadPreparacionesSimilares(receta) = self.preparacionesSimilares(receta).size()

    //  5
    method prepararRecetaConMasExperiencia() { self.preparar(academia.recetaDeMayorExperiencia(self) ) }
    method puedePreparar(receta) = nivel.puedePreparar(receta, self)
}

object principiante {
    method validarReceta(receta, cocinero){
        if(!self.puedePreparar(receta, cocinero)){
            throw new Exception(message = "Este cocinero no puede preparar esta receta")
        }
    }

    //  2
    method superoNivel(cocinero) = cocinero.experienciaAdquirida() > 100

    //  3
    method siguienteNivel() = experimentado
    method calidadPreparacion(receta) = if(receta.menosDeCuatroIngredientes()) normal else pobre

    //  5
    method puedePreparar(receta, cocinero) = !receta.esDificil()
}

object experimentado {
    method validarReceta(receta, cocinero){
        if(!self.puedePreparar(receta, cocinero)){
            throw new Exception(message = "Este cocinero no puede preparar esta receta")
        }
    }

    //  2
    method superoNivel(cocinero) = cocinero.cantidadPreparacionesDificiles() > 5

    //  3
    method siguienteNivel() = chef
    method calidadPreparacion(receta, cocinero) = if(cocinero.perfecciono(receta)) new Superior (plus = self.calcularPlus(receta, cocinero)) else normal
    method calcularPlus(receta, cocinero) = cocinero.cantidadPreparacionesSimilares(receta) / 10

    //  5
    method puedePreparar(receta, cocinero) = !receta.esDificil() or cocinero.tienePreparacionSimilar(receta)
}

object chef {
    method validarReceta(receta, cocinero){}

    //  2
    method superoNivel(cocinero) = false
    method calidadPreparacion(receta, cocinero) = if(cocinero.perfecciono(receta)) new Superior (plus = self.calcularPlus(receta, cocinero)) else normal
    method calcularPlus(receta, cocinero) = cocinero.cantidadPreparacionesSimilares(receta) / 10

    //  5
    method puedePreparar(receta, cocinero) = true
}

//  1
object normal {
    method experiencia(preparacion) = preparacion.cantidadDeIngredientes() * preparacion.dificultad()
}

object pobre {
    var property experienciaMaxima = 4

    method experiencia(preparacion) = normal.experiencia(preparacion).min(experienciaMaxima)
}

class Superior {
    const plus

    method experiencia(preparacion) = normal.experiencia(preparacion) + plus
}

//  4
class RecetaGourmet inherits Receta {
    override method experiencia() = super() * 2
    override method esDificil() = true
}

//  5
object academia {
    const estudiantes = []
    const property recetario = []

    method entrenarEstudiantes() { estudiantes.forEach{ estudiante => estudiante.prepararRecetaConMasExperiencia() } }
    method recetaDeMayorExperiencia(cocinero) = self.recetasQuePuedePreparar(cocinero).max{ receta => receta.experiencia() }
    method recetasQuePuedePreparar(cocinero) = recetario.filter{ receta => cocinero.puedePreparar(receta) }
}