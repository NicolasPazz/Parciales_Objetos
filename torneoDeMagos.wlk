class Mago {
  const poderInnato = 1 // 1-10
  const objetosMagicos = []
  const nombre = "mago"
  var property resistencia = 0
  var property energia = 0
  var property categoria = aprendiz

  method poderTotal() = poderInnato * self.sumatoriaPoderObjetos()  // A.1
  method sumatoriaPoderObjetos() = objetosMagicos.sum { objeto => objeto.poderAportado(self) }

  method nombrePar() = self.longitudNombre().even()
  method longitudNombre() = nombre.length()

  method disminuirEnergia(energia_) { energia -= energia_}
  method aumentarEnergia(energia_) { energia += energia_}

  method desafiar(mago) { 
    if (self.leGanaA(mago)) {   // Si le gano, hay transferencia de energia
      mago.disminuirEnergia(mago.danio())
      self.aumentarEnergia(mago.danio())
    }
  } // A.2 / B.2

  method leGanaA(mago) = mago.vencido(self) // El mago es vencido por mi?
  method vencido(mago) = categoria.vencido(self, mago) // El mago me vence?
  method danio() = categoria.danio(self)

  method lider() = self
}


class Categoria {
  var property factorPerdida = 0

  method vencido(receptor, atacante) = receptor.resistencia() < atacante.poderTotal()

  method danio(receptor) = receptor.energia() * self.factorPerdida()
}

object aprendiz inherits Categoria{
  override method factorPerdida() = 0.5
}

object veterano inherits Categoria{
  override method factorPerdida() = 0.25
  
  override method vencido(receptor, atacante) = receptor.resistencia() * 1.5 <= atacante.poderTotal()
}

object inmortal inherits Categoria{
  override method vencido(receptor, atacante) = false
}


class ObjetoMagico {
  const valorBase

  method poderAportado(mago) = valorBase + self.poderExtraEspecifico(mago)
  method poderExtraEspecifico(mago)
}

class Varita inherits ObjetoMagico {
  override method poderExtraEspecifico(mago) = if (mago.nombrePar()) valorBase * 0.5 else valorBase
}

class TunicaComun inherits ObjetoMagico {
  override method poderExtraEspecifico(mago) = 2 * mago.resistencia()
}

class TunicaEpica inherits TunicaComun {
  const puntosFijos = 10
  
  override method poderExtraEspecifico(mago) = super(mago) + puntosFijos
}

class Amuleto { // esto deberia ser un object
  method poderAportado(mago) = 200
}

object ojota {
  method poderAportado(mago) = 10 * mago.longitudNombre()
}


// PUNTO B
class Gremio inherits Mago {    // B.1
  var property magosAfiliados   // Al menos 2
  
  override method poderTotal() = magosAfiliados.sum { mago => mago.poderTotal() }
  override method energia() = magosAfiliados.sum { mago => mago.energia() }
  
  override method resistencia() = magosAfiliados.sum { mago => mago.resistencia() }
  method resistenciaTotal() = self.resistencia() + self.lider().resistencia()

  override method vencido(mago) = self.resistenciaTotal() < mago.poderTotal()
  // No aclara en el enunciado cual es el intercambio de energia cuando pierde un gremio, asumo que es la energia de cada uno de sus magos, que dependen de sus categorias
  override method danio() = magosAfiliados.sum { mago => mago.danio() }

  override method aumentarEnergia(energia_) { self.lider().aumentarEnergia(energia_) }
  // No aclara en el enunciado que pasa cuando vencen a un gremio, asumo que su lider pierde la energia
  override method disminuirEnergia(energia_) { self.lider().disminuirEnergia(energia_) }

  method miembroMasPoderoso() = magosAfiliados.max { mago => mago.poderTotal() }
  override method lider() = self.miembroMasPoderoso().lider()
  
  
  override method initialize() {    // B.1
    super()
    self.validarCantidadDeMagos()
  }
  method validarCantidadDeMagos() {
    if (magosAfiliados.size() < 2) {
      throw new Exception(message = "No puede haber menos de 2 magos afiliados a un gremio")
    }
  }
}


// B.3

// Gracias al composite, podemos tomar al gremio como un mago, ya que comparten la interfaz, son polimorficos.
// Podriamos definir el metodo lider() en la clase Mago, que devuelva a el mismo, y en Gremio, que devuelva al lider del gremio.
// Entonces en el metodo lider() de Gremio, siempre devolveriamos al lider del miembro de mayor poder, en el caso que sea un mago, sera él, y si es un gremio, se buscara recursivamente el lider hasta llegar a un mago.

// EN MAGO:
// method lider() = self

// EN GREMIO:
// method miembroMasPoderoso() = magosAfiliados.max { mago => mago.poderTotal() }
// override method lider() = self.miembroMasPoderoso().lider()