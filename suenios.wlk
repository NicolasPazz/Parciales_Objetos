// https://docs.google.com/document/d/1vtru1ysNDA5N3eVt33hD9IexzrL7rnQbEofYYrlp7yE/edit?tab=t.0


// PUNTO 1

class Soniador {
    const carrerasDeseadas = []
    const property sueldoDeseado = 7000
    var hijos = 0
    const carrerasLogradas = []
    var felicidad
    var property personalidad
    const suenios = []
    const lugaresVisitados = []

    method sueniosPendientes() = suenios.filter { suenio => suenio.estaPendiente() }
    method sueniosCumplidos() = suenios.filter { suenio => !suenio.estaPendiente() }

    method cumplirSuenio(suenio){
        self.validarSuenio(suenio) 
        suenio.cumplir(self)
    }
    method validarSuenio(suenio) {
        if (!self.sueniosPendientes().contains(suenio)) {
			throw new Exception (message = "El sueño " + suenio + " no está pendiente")
		}
    }

    method aumentarFelicidad(valor) { felicidad += valor }

    method quiereEstudiar(carrera) = carrerasDeseadas.contains(carrera)
    method seRecibioDe(carrera) = carrerasLogradas.contains(carrera)
    method recibirse(carrera) {
        carrerasDeseadas.remove(carrera)
        carrerasLogradas.add(carrera)
    }

    method viajarA(lugar) { lugaresVisitados.add(lugar) }

    method tieneUnHijo() = !hijos.isEmpty()
    method tenerUnHijo() { hijos += 1 }

    method cumplirSuenioMasPreciado() { self.cumplirSuenio(personalidad.suenioMasPreciado(self)) }
    method suenioMasFeliz() = self.sueniosPendientes().max { suenio => suenio.felicidonios() }
    method suenioRandom() = self.sueniosPendientes().anyOne()
    method primerSuenio() = self.sueniosPendientes().first()

    // PUNTO 4

    method esFeliz() = felicidad > self.felicidadPendiente()
    method felicidadPendiente() = self.sueniosPendientes().sum { suenio => suenio.felicidonios() }

    // PUNTO 5

    method esAmbisiosa() = self.cantidadDeSueniosAmbiciosos() > 3
    method cantidadDeSueniosAmbiciosos() = suenios.count { suenio => suenio.esAmbicioso() }
}

class Suenio {
    const property felicidonios = 0
    var property estaPendiente = true

    method cumplir(soniador) {
        self.validarCondiciones(soniador)
        self.realizar(soniador)
        soniador.aumentarFelicidad(self.felicidonios()) // uso el getter para que funcione bien en suenios multiples
        self.cumplir()
    }
    method validarCondiciones(soniador) {}
    method realizar(soniador) {}
    method cumplir() { estaPendiente = false }

    method esAmbicioso() = self.felicidonios() > 100    // uso el getter para que funcione bien en suenios multiples
}
object suenioUnHijo inherits Suenio {
    override method realizar(soniador) {
        soniador.tenerUnHijo()
    }
}

class SuenioViajar inherits Suenio { 
    const lugar 

    override method realizar(soniador) {
		soniador.viajarA(lugar)
	}
}

class SuenioCarrera inherits Suenio {
    const carrera

    override method validarCondiciones(soniador) {
        if (soniador.seRecibioDe(carrera)) {
            throw new Exception (message = soniador.toString() + " ya se recibio de " + carrera)
        }
        if (!soniador.quiereEstudiar(carrera)) {
            throw new Exception (message = soniador.toString() + " no quiere estudiar " + carrera)
        }
    }
    override method realizar(soniador) {
        soniador.recibirse(carrera)
    }
}

class SuenioAdoptar inherits Suenio {
    override method validarCondiciones(soniador) {
        if (soniador.tieneUnHijo()) {
            throw new Exception (message = "Este soñador no puede adoptar, ya tiene al menos un hijo")
        }
    }
    override method realizar(soniador) {
        soniador.tenerUnHijo()
    }
}

class SuenioTrabajo inherits Suenio {
    const sueldo

    override method validarCondiciones(soniador) {
        if (soniador.sueldoDeseado() < sueldo) {
            throw new Exception (message = "Este soñador desea un sueldo mayor al de este trabajo")
        }
    }
}


// PUNTO 2

const viajeCataratas = new SuenioViajar (lugar = "cataratas")
const trabajoDeseado = new SuenioTrabajo (sueldo = 10000)

object suenioMultiple inherits Suenio {
    const suenios = [viajeCataratas, suenioUnHijo, trabajoDeseado]
    override method felicidonios() = suenios.sum { suenio => suenio.felicidonios() } 

    override method validarCondiciones(soniador) {
        suenios.forEach { suenio => suenio.validarCondiciones(soniador) }
    }

    override method realizar(soniador) {
        suenios.forEach { suenio => suenio.realizar(soniador) }
    }
    
    override method cumplir() { 
        suenios.forEach { suenio => suenio.cumplir() }
    }
}


// PUNTO 3

object realista {
    method suenioMasPreciado(soniador) = soniador.suenioMasFeliz()
}

object alocado {
    method suenioMasPreciado(soniador) = soniador.suenioRandom()
}

object obsesivos {
    method suenioMasPreciado(soniador) = soniador.primerSuenio()
}