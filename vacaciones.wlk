// PUNTO 1
class Lugar{
  const nombre

  method cantidadDeLetras() = nombre.length()
  method nombrePar() = self.cantidadDeLetras().even()

  method esDivertido () = self.nombrePar() && self.condicionParaSerDivertido()
  method condicionParaSerDivertido()

  method esTranquilo()
  method esRaro() = self.cantidadDeLetras() > 10
}

class Ciudad inherits Lugar{
  const habitantes
  const atracciones
  const decibelesPromedio

  method tieneMuchasAtracciones() = atracciones.size() > 3
  method tieneMuchosHabitantes() = habitantes > 100000

  override method condicionParaSerDivertido() = self.tieneMuchasAtracciones() && self.tieneMuchosHabitantes()
  override method esTranquilo() = decibelesPromedio < 20
}

class Pueblo inherits Lugar{
  const anioFundacion
  const provincia
  const kilometros
  
  method fundadoAntesDel1800() = anioFundacion < 1800
  method esDelLitoral() = (#{"Corrientes", "Entre Rios", "Santa Fe"}).contains(provincia)

  override method condicionParaSerDivertido() = self.esDelLitoral() || self.fundadoAntesDel1800()
  override method esTranquilo() = provincia == "La Pampa"
}

class Balneario inherits Lugar{
  const metrosDePlayaPromedio
  const marEsPeligroso
  const tienePeatonal

  method playaGrande() = metrosDePlayaPromedio > 300

  override method condicionParaSerDivertido() = self.playaGrande() && marEsPeligroso
  override method esTranquilo() = !tienePeatonal
}


// PUNTO 2
object tranquilo{
  method iriaAEseLugar(lugar) = lugar.esTranquilo()
}
object divertido{
  method iriaAEseLugar(lugar) = lugar.esDivertido()
}
object raro{
  method iriaAEseLugar(lugar) = lugar.esRaro(lugar)
}

class Persona {
  const preferencia
  const presuepuestoMaximo

  method iriaALugar(lugar) = preferencia.iriaALugar(lugar)

  method reiniciarPreferencias() = preferencia.reiniciarPreferencias()

  method puedePagar(monto) = monto <= presuepuestoMaximo
}

// Composite
class CombinacionDePreferencias { 
  const preferencias = #{}

  method agregarPreferencia(preferencia) = preferencias.add(preferencia)

  method removerPreferencia(preferencia) = preferencias.remove(preferencia)

  method reiniciarPreferencias() = preferencias.clear()

  method iriaALugar(lugar) = preferencias.any({ preferencia => preferencia.iriaALugar(lugar) })
}


// PUNTO 3
class Tour{
  const fechaDeSalida
  const personasRequeridas
  const ciudades // lista
  const precio
  const personasConfirmadas // set

  method hayLugar() {
    if (self.tourCompleto()) {
      throw new DomainException(message = "Se llego al limite de personas para el tour")
    }
  }
  method alguienSeQuiereBajar(plata) = personasConfirmadas.any({persona => persona.meQuieroBajar(plata)})

  method validarCompra(persona) {
    if (!persona.puedePagar(precio)) {
      throw new DomainException(message = "El monto del tour no es adecuado para la persona")
    }
  }

  method validarPreferencia(persona) {
    if (!self.quiereIrATodosLosLugares(persona)) {
      throw new DomainException(message = "Hay lugares que no son adecuados para la persona")
    }
  }

  method quiereIrATodosLosLugares(persona) = ciudades.all({ ciudad => persona.iriaALugar(ciudad) })

  method agregarPersona(persona) { 
    self.validarCompra(persona)
    self.validarPreferencia(persona)
    self.hayLugar()
    personasConfirmadas.add(persona) 
  }

  method bajarPersona(persona) = personasConfirmadas.remove(persona)
  method pendienteDeConfirmacion() = personasConfirmadas.size() < personasRequeridas
  method saleEsteAnio() = fechaDeSalida.year() == calendario.hoy().year()
  method tourCompleto() = personasConfirmadas.size() == personasRequeridas
  method montoTotal() = precio * personasConfirmadas.size()

  method confirmado() = self.tourCompleto()
}


// PUNTO 4
object reporte {
  const tours = [] // Fuente de verdad de los tours

  method toursPendientesDeConfirmacion() = tours.filter({ tour => !tour.confirmado() })

  method totalDeToursQueSalenEsteAnio() = self.toursQueSalenEsteAnio().sum({
    tour => tour.montoTotal()
  })

  method toursQueSalenEsteAnio() = tours.filter({ tour => tour.saleEsteAnio() })
}

object calendario { // Stub
  method hoy () = new Date()
}