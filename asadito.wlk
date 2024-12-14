// https://docs.google.com/document/d/1WOK0p1qH-5LQxDQ1Jx3b39gSXpyqy4GuLIax11yjnoc/edit?usp=sharing
// PUNTO 1 - Strategy y Template Method

class Posicion {
    const property x
    const property y
}

class Persona {
    var property posicion = new Posicion(x = 0, y = 0)
    var property criterioDeCambio = normal
    const property elementos = []
    var property criterioDeComida = vegetariano
    const comidas = []
    const posicionesOcupadas = [posicion]

    method agregarElementos(elementosAAgregar) {
        elementos.addAll(elementosAAgregar)
    }
    method quitarElementos(elementosAQuitar) {
        elementos.removeAll(elementosAQuitar)
    }
    method pasar(elemento, quienLoPide) {
        self.validarElemento(elemento)
        criterioDeCambio.aplicar(elemento, quienLoPide, self)
    }
    method validarElemento(elemento) {
        if (!self.tengoElemento(elemento)) {
            throw new DomainException(message = "no tengo el elemento")
        }
    }
    method tengoElemento(elemento) = elementos.contains(elemento)
    method primerElemento() = elementos.first()
    method cambiarPosicion(otraPersona) {
        const aDondeVoy = otraPersona.posicion()
        otraPersona.ocuparPosicion(posicion)
        self.ocuparPosicion(aDondeVoy)
    }
    method ocuparPosicion(nuevaPosicion) {
        posicion = nuevaPosicion
        posicionesOcupadas.add(nuevaPosicion)
    }

    method comer(comida) {
        if (criterioDeComida.quiereComer(comida)) self.registrarComida(comida)   
    }
    method registrarComida(comida) {
        comidas.add(comida)
    }

    // PUNTO 3
    method pipon() = comidas.any{ comida => comida.esPesada() }

    // PUNTO 4
    method laEstaPasandoBien() = self.comioAlgo() && self.condicionPersonalParaPasarlaBien()
    method comioAlgo() = !comidas.isEmpty()
    method condicionPersonalParaPasarlaBien()
}

class CriterioDeCambio {
    method aplicar(elemento, quienLoPide, quienLoDa) {
        const elementosIntercambiados = self.queElementosLePaso(elemento, quienLoDa)

        quienLoPide.agregarElementos(elementosIntercambiados)
        quienLoDa.quitarElementos(elementosIntercambiados)
    }
    method queElementosLePaso(elemento, quienLoDa)
}

object sordo inherits CriterioDeCambio{
    override method queElementosLePaso(elemento, quienLoDa) = [quienLoDa.primerElemento()]
}

object dejameTranquilo inherits CriterioDeCambio{
    override method queElementosLePaso(elemento, quienLoDa) = quienLoDa.elementos()
}

object normal inherits CriterioDeCambio {
    override method queElementosLePaso(elemento, quienLoDa) = [elemento]
}

object cambioDePosicion {
    method aplicar(elemento, quienLoPide, quienLoDa) {
        quienLoPide.cambiarPosicion(quienLoDa)
    }
}


// PUNTO 2 - Composicion y Composite

class Comida {
    const property esCarne
    const property calorias

    method tieneMenosCaloriasQue(caloriasMaximas) = calorias < caloriasMaximas
    method esPesada () = calorias > 500
}

object vegetariano {
    method quiereComer(comida) = !comida.esCarne()
}

object dietetico {
    const caloriasMaximas = 500

    method quiereComer(comida) = comida.tieneMenosCaloriasQue(caloriasMaximas)
}

class Alternado {
    var aceptaLaComida = false
    var property criterios = []

    method quiereComer(comida) {
        aceptaLaComida = !aceptaLaComida
        return aceptaLaComida
    }
}

class Combinacion {
    const criterio = []

    method agregarCriterio(criterioAAgregar) = criterio.add(criterioAAgregar)

    method quiereComer(comida) = criterio.all{ criterio => criterio.quiereComer(comida) }
}


// PUNTO 4 - Template Method

object osky inherits Persona {
    override method condicionPersonalParaPasarlaBien() = true
}

object moni inherits Persona {
    override method condicionPersonalParaPasarlaBien() = posicionesOcupadas.contains(new Posicion(x = 1, y = 1))
}

object facu inherits Persona {
    override method condicionPersonalParaPasarlaBien() = comidas.any{ comida => comida.esCarne() }
}

object vero inherits Persona {
    override method condicionPersonalParaPasarlaBien() = elementos.size() <= 3
}