/** First Wollok example */
class Nave{
	var velocidad = 0
	var direccion = 0
	var combustible
	
	method acelerar(cuanto) {100000.min(velocidad += cuanto)}
	method desacelerar(cuanto) {0.max(velocidad -= cuanto)}
	method irHaciaElSol(){ direccion = 10}
	method escaparDelSol() {direccion = -10}
	method ponerseParaleroAlSol(){direccion = 0}
	method acercarseUnPocoAlSol(){direccion = 10.min(direccion+1)}
	method alejarseUnPocoAlSol(){direccion = -10.max(direccion-1)}
	
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}	
	method cargarCombustible(cantidad){combustible+=cantidad}
	method descargarCombustible(cantidad){combustible-=cantidad}
	
	method estaTranquila() = combustible >= 4000 and velocidad>1200 and self.condicionAdicional()
	method condicionAdicional()
	
	method recibirAmenaza()
	
	method estaEnRelajo() = self.estaTranquila()
}

	


class NaveBaliza inherits Nave{
	var baliza
	var cambiosBaliza = 0
	
	method cambiarColorDeBaliza(colorNuevo){
		baliza=colorNuevo
		cambiosBaliza += 1 
	}
	
	override method prepararViaje(){
		super()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleroAlSol()
	}
	
	override method condicionAdicional() = baliza != "rojo"
	
	override method recibirAmenaza(){
		self.irHaciaElSol()
		self.cambiarColorDeBaliza("verde")
	}
	override method estaEnRelajo() = super() and cambiosBaliza == 0
}

class NavePasajeros inherits Nave{
	const cantidadDePasajeros
	var comidas
	var bebidas
	var comidasServidas = 0

	
	method cargarRacionesDeComida(cantidad) { comidas+=cantidad}
	method descargarRacionesDeComida(cantidad) { comidas-=cantidad comidasServidas += cantidad}
	method cargarRacionesDebebida(cantidad) { bebidas+=cantidad}
	method descargarRacionesDeBebiba(cantidad) { bebidas-=cantidad}
	
	override method prepararViaje(){
		super()
		self.cargarRacionesDeComida(4*cantidadDePasajeros)
		self.cargarRacionesDebebida(6*cantidadDePasajeros)
		self.acercarseUnPocoAlSol()
	}
	
	override method condicionAdicional() = true
	
	method duplicarVelocidad(){velocidad = velocidad*2}
	override method recibirAmenaza(){
		self.duplicarVelocidad()
		self.descargarRacionesDeComida(cantidadDePasajeros)
		self.descargarRacionesDeBebiba(cantidadDePasajeros*2)
	}
	
	override method estaEnRelajo() = super() and comidasServidas == 30
}

class NaveDeCombate inherits Nave{
	var estaVisible = true
	var misilesDesplegados = true
	const mensajes = []
	
	
	method ponerseVisible() {estaVisible = true}
	method ponerseInvisible() {estaVisible = false}
	method estaInvisible() = not estaVisible
	
	method desplegarMisiles(){misilesDesplegados = true }
	method replegarMisiles(){misilesDesplegados = false }
	method misilesDesplegados() = misilesDesplegados
	
	method emitirMensaje(mensaje){mensajes.add(mensaje)}
	method mensajesEmitidos() = mensajes
	method primerMensajeEmitido() = mensajes.fist()
	method ultimoMensajeEmitido() = mensajes.last()
	method esEscueta() = mensajes.all({r=>r.size()<= 30})
	method emitioMensaje(mensaje) = mensajes.contains(mensaje)
	
	override method prepararViaje(){
		super()
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en mision ")
	}
	override method condicionAdicional() = not misilesDesplegados
	
	override method recibirAmenaza(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
		self.emitirMensaje("Amenaza recibida")
	}
	
	override method estaEnRelajo() = super() and self.esEscueta()
	
}

class NaveHospital inherits NavePasajeros{
	
	var quirofanosPreparados = true
	
	override method condicionAdicional() = not quirofanosPreparados
	
	method prepararQuirofanos(){quirofanosPreparados=true}
	override method recibirAmenaza(){
		super()
		self.prepararQuirofanos()
		
	}
}

class NaveCombateSigilosa inherits NaveDeCombate{
	
	override method condicionAdicional() = super() and estaVisible
	override method recibirAmenaza(){
		super()
		self.ponerseVisible()
		self.desplegarMisiles()
		}
	
}