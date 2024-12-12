// PUNTO 1
// ELIJO TEMPLATE METHOD PORQUE NO NECESITO FLEXIBILIDAD Y ME PERMITE REUTILIZAR CODIGO. UNA NOTICIA NO SE CONVERTIRA EN UN ARTICULO Y VICEVERSA.

class Noticia {
    const property fechaPublicacion
    //const autor
    const importancia
    const titulo
    const desarrollo
    const palabrasSensacionalistas = ["espectacular", "increible", "grandioso"]

    method esCopada() = 
        self.esImportante() and 
        self.esReciente() and 
        self.condicionCopada()

    method esImportante() = importancia >= 8
    method esReciente() = self.diasDesdeLaPublicacion() < 3
    method diasDesdeLaPublicacion() = calendario.hoy() - fechaPublicacion
    method condicionCopada()

    method esSensacionalista() = palabrasSensacionalistas.any { palabra => titulo.contains(palabra) }

    method cantidadDePalabras(string) = string.words().size()

    method desarrolloCorto() = self.cantidadDePalabras(desarrollo) < 100

    method tituloComienzaConT() = titulo.startsWith("T")

    // PUNTO 3

    method esDeHoy() = fechaPublicacion == calendario.hoy()

    method tieneDesarrollo() = !desarrollo.isEmpty()
    method tieneBuenTitulo() = self.cantidadDePalabras(titulo) >= 2

    method validarQueEstaBienEscrita() {
        self.validarDesarrollo()
        self.validarTitulo()
    }
    method validarDesarrollo() {
        if (!self.tieneDesarrollo()) {
            throw new Exception (message = "La noticia no tiene desarrollo")
        }
    }
    method validarTitulo() {
        if (!self.tieneBuenTitulo()) {
            throw new Exception (message = "El titulo de la noticia tiene menos de 2 palabras")
        }
    }

    // PUNTO 4

    method esDeEstaSemana() = self.diasDesdeLaPublicacion() <= 7
}

class Articulo inherits Noticia{
    const links = []

    override method condicionCopada() = links.size() >= 2
}

class Chivo inherits Noticia {
    const importe

    override method condicionCopada() = importe > 2000000
}

class Reportaje inherits Noticia {
    const entrevistado

    method cantidadDeLetrasImpar() = entrevistado.size().odd()
    method esAlDibu() = entrevistado == "Dibu Martinez"

    override method condicionCopada() = self.cantidadDeLetrasImpar()
    override method esSensacionalista() = 
        super() and 
        self.esAlDibu()
}

class Cobertura inherits Noticia {
    const noticias = []

    override method condicionCopada() = noticias.all { noticia => noticia.esCopada() }
}

// PUNTO 2 
// ELIJO STRATEGY PORQUE NO SE REPITE COMPORTAMIENTO Y PORQUE UN PERIODISTA PUEDE CAMBIAR DE PREFERENCIA.

class Periodista {
    const fechaDeIngreso = calendario.hoy()
    var property preferencia
    const noticias = []

    method agregarNoticia(noticia) { noticias.add(noticia) }
    method interesadoEnPublicar(noticia) = preferencia.lePareceInteresante(noticia)

    // PUNTO 3

    method publicar(noticia){
        self.validarCupo(noticia)
        noticia.validarQueEstaBienEscrita()
        self.agregarNoticia(noticia)
    }

    method validarCupo(noticia) {
        if (self.noticiasDeHoyQueNoPrefiere() >= 2) {
            throw new Exception (message = "El periodista no puede publicar por dia mas de 2 noticias que no prefiere")
        }
    }
    method noticiasDeHoyQueNoPrefiere() = noticias.count { 
            noticia => 
                self.noLeInteresa(noticia) and 
                noticia.esDeHoy() 
        }
    method noLeInteresa(noticia) = !self.interesadoEnPublicar(noticia)

    // PUNTO 4

    method publicoEnEstaSemana() = noticias.any { noticia => noticia.esDeEstaSemana() }
    method esReciente() = calendario.hoy() - fechaDeIngreso <= 365
}

object noticiasCopadas {
    method lePareceInteresante(noticia) = noticia.esCopada()
}

object noticiasSensacionalistas {
    method lePareceInteresante(noticia) = noticia.esSensacionalista()
}

object vago {
    method lePareceInteresante(noticia) = noticia.desarrolloCorto()
}

object preferenciaJoseDeZer {
    method lePareceInteresante(noticia) = noticia.tituloComienzaConT()
}

const joseDeZer = new Periodista (preferencia = preferenciaJoseDeZer)


// PUNTO 4

object reporte {
    const periodistas = []

    method periodistasRecientesPublicaronEstaSemana() = periodistas.filter { 
            periodista => 
                periodista.esReciente() and 
                periodista.publicoEnEstaSemana() 
        }
}


object calendario { // Stub
  method hoy () = new Date()
}