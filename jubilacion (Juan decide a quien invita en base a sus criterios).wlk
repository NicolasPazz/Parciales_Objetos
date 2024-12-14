// https://docs.google.com/document/d/11XMvYJKG_k45YB83S9_5jjwa2Zl7XbMAoMmr518ahk4/edit?tab=t.0

object juanPerez{
    var criterioDeInvitacion = desarrollador

    method quiereInvitar(empleado) = empleado.esCopado() || criterioDeInvitacion.quiereInvitarA(empleado)

    method invitar(empleado) {
        criterioDeInvitacion = empleado.area()
        if (self.quiereInvitar(empleado)) {
            invitados.agregarInvitado(empleado)
        }
    }
}

object desarrollador {
    method quiereInvitarA(empleado) = empleado.sabeProgramarEn(wlk) || empleado.sabeLenguajeAntiguo()
}

object infraestructura {
    method quiereInvitarA(empleado) = empleado.sabeAlMenos5Lenguajes()
}

object jefe {
    method quiereInvitarA(empleado) = empleado.sabeLenguajeAntiguo() and empleado.tieneACargoSoloGenteCopada()
}

class Empleado {
    const lenguajes = []

    method esCopado()
    method aprenderLenguaje(lenguaje) { lenguajes.add(lenguaje) }
    method estoyInvitado() = juanPerez.quiereInvitar(self)
}

class Desarrollador inherits Empleado {
    method sabeProgramarEn(lenguaje) = lenguajes.contains(lenguaje)
    method sabeLenguajeAntiguo() = lenguajes.any { lenguaje => lenguaje.esAntiguo() }
    method sabeLenguajeModerno() = lenguajes.any { lenguaje => !lenguaje.esAntiguo() }


    override method esCopado() = self.sabeLenguajeAntiguo() and self.sabeLenguajeModerno()
}

class Infraestructura inherits Empleado {
    const aniosExperiencia
    method cantidadDeLenguajes() = lenguajes.size()
    method sabeAlMenos5Lenguajes() = lenguajes.size() >= 5

    override method esCopado() = aniosExperiencia > 10
}


class Jefe {
    const area = jefe
    const lenguajes = #{}
    const subordinados = #{}

    method tieneACargoSoloGenteCopada() = subordinados.all { subordinado => subordinado.esCopado() }

    method agregarSubordinado(empleado) { subordinados.add(empleado) }
}

class Lenguaje {
    const property esAntiguo
}

const wlk = new Lenguaje (esAntiguo = false)

object invitados {
    const listaDeempleado = #{}
    const invitados = #{}

    method evaluarempleado() = listaDeempleado.forEach { empleado => juanPerez.invitar(empleado) }
    method agregarInvitado(empleado) = invitados.add(empleado)
    method cualesSonLosInvitados() = invitados
}