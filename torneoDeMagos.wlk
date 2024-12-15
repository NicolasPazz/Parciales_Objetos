class Mago {
  const poderInnato = 1 // 1-10
  const objetosMagicos = []
  const nombre = "mago"
  var property resistencia = 0
  var property energia = 0
  var property categoria = apendices

  method poderTotal() = poderInnato * self.sumatoriaPoderObjetos()  // A.1
  method sumatoriaPoderObjetos() = objetosMagicos.sum { objeto => objeto.poderAportado(self) }

  method nombrePar() = self.longitudNombre().even()
  method longitudNombre() = nombre.length()

  method disminuirEnergia(energia_) { energia -= energia_}
  method aumentarEnergia(energia_) { energia += energia_}

  method desafiar(mago) { 
    self.leGanaA(mago)
    mago.desafiado(self)
    self.aumentarEnergia(mago.danio())
  }  // A.2

  method leGanaA(mago) = mago.vencido(self)
  method vencido(mago) = categoria.vencido(self, mago)
  method desafiado(magoOGremio) { categoria.desafiado(self, magoOGremio) }
  method danio() = categoria.danio(self)
}


class Categoria {
  var property porcentajePerdida = 0

  method vencido(receptor, atacante) = receptor.resistencia() < atacante.poderTotal()

  method danio(receptor) = receptor.energia() * self.porcentajePerdida()

  method desafiado(receptor, atacante) {
    receptor.disminuirEnergia(self.danio(receptor))
  }
}

object apendices inherits Categoria{
  override method porcentajePerdida() = 0.5
}

object veterano inherits Categoria{
  override method porcentajePerdida() = 0.25
  
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

class Amuleto {
  method poderAportado(mago) = 200
}

object ojota {
  method poderAportado(mago) = 10 * mago.longitudNombre()
}

// PUNTO B
class Gremio {    // B.1
  var property magosAfiliados // Al menos 2
  
  method poderTotal() = magosAfiliados.sum { mago => mago.poderTotal() }
  method energia() = magosAfiliados.sum { mago => mago.energia() }
  method resistencia() = magosAfiliados.sum { mago => mago.resistencia() }
  method resistenciaTotal() = self.resistencia() + self.lider().resistencia()

  method desafiar(mago) {   // B.2
    self.leGanaA(mago)                    // Le gano al mago?
    mago.desafiado(self)                  // Si le gano, lo desafio
    self.aumentarEnergia(mago.danio())    // Efecto por ganar
  }

  method leGanaA(mago) = mago.vencido(self)
  method vencido(mago) = self.resistenciaTotal() < mago.poderTotal()
  // No aclara en el enunciado que pasa cuando vencen un gremio, asumo que todos sus magos pierden la energia
  method desafiado(magoOGremio) { magosAfiliados.forEach { mago => mago.disminuirEnergia(magoOGremio.danio()) } }
  method danio() = self.poderTotal()

  method lider() = magosAfiliados.max { mago => mago.poderTotal() }
  method aumentarEnergia(energia_) { self.lider().aumentarEnergia(energia_) }

  method initialize(magosAfiliados_) {    // B.1
    self.validarCantidadDeMagos(magosAfiliados_)
    self.magosAfiliados(magosAfiliados_)
  }
  method validarCantidadDeMagos(magos) {
    if (magos.size() < 2) {
      throw new Exception(message = "No puede haber menos de 2 magos afiliados a un gremio")
    }
  }
}

// B.3
// Gracias al composite, podemos tomar al gremio como un mago, ya que sus metodos son polimorficos. No necesitamos definir nada mas.