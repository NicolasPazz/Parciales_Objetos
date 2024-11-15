// PUNTO 1
class Lugar{
  const nombre

  method cantidadDeLetras() = nombre.length()
  method nombrePar() = self.cantidadDeLetras().even()

  method esDivertido () = self.nombrePar() && self.condicionParticular()

  method condicionParticular()
  method esTranquilo()
}

class Ciudad inherits Lugar{
  const habitantes
  const atracciones
  const decibelesPromedio

  method cantidadDeAtraccionesMayorA(cantidad) = atracciones > cantidad
  method cantidadDeHabitantesMayorA(cantidad) = habitantes > cantidad

  override method condicionParticular() = self.cantidadDeAtraccionesMayorA(3) && self.cantidadDeHabitantesMayorA(100000)
  override method esTranquilo() = decibelesPromedio < 20
}

class Pueblo inherits Lugar{
  const anioFundacion
  const provincia
  const kilometros2

  method fundadoAntesDe(anio) = anioFundacion < anio
  method esDelLitoral() = provincia == "Entre Rios" || provincia == "Corrientes" || provincia == "Misiones"

  override method condicionParticular() = self.fundadoAntesDe(1800) && self.esDelLitoral()
  override method esTranquilo() = provincia == "La Pampa"
}

class Balneario inherits Lugar{
  const metrosDePlayaPromedio
  const marEsPeligroso
  const tienePeatonal

  method playaMayorA(metros) = metrosDePlayaPromedio > metros

  override method condicionParticular() = self.playaMayorA(300) && marEsPeligroso
  override method esTranquilo() = !tienePeatonal
}


// PUNTO 2
object tranquilo{
  method iriaAEse(lugar) = lugar.esTranquilo()
}
object divertido{
  method iriaAEse(lugar) = !lugar.esTranquilo()
}
object raro{
  method iriaAEse(lugar) = self.esRaro(lugar)
  method esRaro(lugar) = lugar.cantidadDeLetras() > 10
}

class Persona{
  const preferencia // set de preferencias
  const presupuestoVacaciones
  const porCuantaPlataMeBajo

  method iriaAEse(lugar) = preferencia.any({preferencia => preferencia.iriaAEse(lugar)})
  method iriaAEsas(lugares) = lugares.all({lugar => self.iriaAEse(lugar)})
  method precioEsAcorde(precio) = precio <= presupuestoVacaciones
  method lePareceBien(precio, ciudades) = 
    if (!self.precioEsAcorde(precio) || !self.iriaAEsas(ciudades)) {
      throw new Exception(message = "El precio se me va de las manos o no me gusta alguna ciudad, no me sumo, gracias")
    }
  method meQuieroBajar(plata) = plata >= porCuantaPlataMeBajo
}


// PUNTO 3
class Tour{
  const fechaDeSalida
  const personasRequeridas
  const ciudades // lista
  const precioPorPersona
  const personasConfirmadas // set

  method hayLugar(plata) =
    if (personasConfirmadas.size() == personasRequeridas && !self.alguienSeQuiereBajar(plata)) {
      throw new Exception(message = "El bondi esta lleno, no se puede sumar nadie mas")
    }

  method alguienSeQuiereBajar(plata) = personasConfirmadas.any({persona => persona.meQuieroBajar(plata)})

  method validarCompra(persona, _ciudades, plata) {
    persona.lePareceBien(precioPorPersona, ciudades)
    self.hayLugar(plata)
  }

  method agregarPersona(persona, _ciudades, plata) { 
    self.validarCompra(persona, ciudades, plata)
    personasConfirmadas.add(persona) 
  }

  method pendienteDeConfirmacion() = personasConfirmadas.size() < personasRequeridas
  method confirmado() = personasConfirmadas.size() == personasRequeridas
  method saleEsteAnio() = fechaDeSalida.year() == calendario.hoy().year()

  method montoTotal() = precioPorPersona * personasRequeridas.size()
}


// PUNTO 4
object reporte {
  method toursPendientes(tours) = tours.filter({tour => tour.pendienteDeConfirmacion()})

  method toursConfirmadosParaEsteAnio(tours) = tours.filter({tour => tour.saleEsteAnio() && tour.confirmado()})
  method montoTotalToursConfirmadosParaEsteAnio(tours) = self.toursConfirmadosParaEsteAnio(tours).sum({tour => tour.montoTotal()})
}

object calendario {
  method hoy () = new Date()
}