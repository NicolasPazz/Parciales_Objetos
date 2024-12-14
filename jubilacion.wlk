// https:docs.google.com/document/d/11XMvYJKG_k45YB83S9_5jjwa2Zl7XbMAoMmr518ahk4/edit?tab=t.0
// Enfoque correcto: Juan establece las reglas que debe cumplir un empleado para asistir

class Empleado {
    const lenguajes = []
    const valorFijoRegalo = 1000

    method aprenderLenguaje(lenguaje) { lenguajes.add(lenguaje) }

    method estaInvitado() = self.esCopado() or self.condicionParaSerInvitado()
    method esCopado()
    method condicionParaSerInvitado()

    method sabeLenguajeAntiguo() = lenguajes.any { lenguaje => lenguaje.esAntiguo() }

    method sabeLenguajeModerno() = lenguajes.any { lenguaje => !lenguaje.esAntiguo() }
    method cantidadDeLenguajesModernos() = lenguajes.count { lenguaje => !lenguaje.esAntiguo() }
    method regalar() = valorFijoRegalo * self.cantidadDeLenguajesModernos()

    method calcularMesa() = self.cantidadDeLenguajesModernos()
}

class Jefe inherits Empleado{
    const subordinados = []

    method tomar(empleado) { subordinados.add(empleado) }
    method todosSubordinadosCopados() = subordinados.all { subordinado => subordinado.esCopado() }

    override method condicionParaSerInvitado() = self.sabeLenguajeAntiguo() and self.todosSubordinadosCopados()
    override method esCopado() = false

    method cantidadDeSubordinados() = subordinados.size()
    override method regalar() = super() + valorFijoRegalo * self.cantidadDeSubordinados()

    override method calcularMesa() = 99
}

class Desarrollador inherits Empleado{
    method sabeProgramarEn(lenguaje) = lenguajes.contains(lenguaje)

    override method condicionParaSerInvitado() = self.sabeProgramarEn(wlk) or self.sabeLenguajeAntiguo()
    override method esCopado() = self.sabeLenguajeModerno() and self.sabeLenguajeAntiguo()
}

class Infra inherits Empleado{
    const aniosExperiencia

    method sabeAlMenos5Lenguajes() = lenguajes.size() >= 5

    override method condicionParaSerInvitado() = self.sabeAlMenos5Lenguajes()
    override method esCopado() = aniosExperiencia > 10
}

class Lenguaje {
    const anioCreacion

    method esAntiguo() = self.aniosDesdeCreacion() > 30

    method aniosDesdeCreacion() = calendario.hoy().year() - anioCreacion
}

const wlk = new Lenguaje (anioCreacion = 2016)

object acmeSA {
    const property personal = []

    method empleadosInvitados() = personal.filter { empleado => empleado.estaInvitado() }
    method cantidadDeInvitados() = self.empleadosInvitados().size()
}

class Evento {
    const empresa = acmeSA
    const asistencias
    const costoFijoSalon = 200000
    const costoFijoPersona = 5000

    method recibir(empleado) {
        self.validarListaDeInvitados(empleado)
        self.registrarAsistencia(empleado)
    }
    method validarListaDeInvitados(empleado) {
        if (!empleado.estaInvitado()) {
            throw new Exception (message = "Este empleado no esta invitado a la fiesta")
        }
    }
    method registrarAsistencia(asistencia) {
        asistencias.add(new Asistencia(empleado = asistencia, mesa = asistencia.calcularMesa()))
    }

    method montoRegalos() = asistencias.sum { asistencia => asistencia.regaloEnEfectivo() }
    method cantidadDeasistencias() = asistencias.size()
    method montoTotal() = costoFijoSalon + self.cantidadDeasistencias() * costoFijoPersona
    method balance() = self.montoRegalos() - self.montoTotal()

    method todosLosInvitadosAsistieron() = self.cantidadDeasistencias() == empresa.cantidadInvitados()
    method fueUnExito() = self.balance() > 0 and self.todosLosInvitadosAsistieron()

    // Transformo la lista de asistencias a lista de mesas de cada asistencia
    method mesas() = asistencias.map { asistencia => asistencia.mesa() }

    // Se fija dentro de la lista de mesas de cada asistencia, cual es la que aparece mas veces
    method mesaConMasasistencias() = self.mesas().max { mesa => self.mesas().occurrencesOf(mesa) }
    
}

class Asistencia {
    const property mesa
    const empleado

    method regaloEnEfectivo() = empleado.regalar()
    method mesa() = empleado.calcularMesa()
}

object calendario {  // Stub
  method hoy () = new Date()
}