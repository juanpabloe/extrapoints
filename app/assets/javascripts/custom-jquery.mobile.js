$(document).bind("mobileinit", function(){
	//Removemos la navegación con AJAX, problemas con ruta
	$.extend(  $.mobile , {
		ajaxEnabled: false
	});
	
	// activamos el boton de back por default
	$.mobile.page.prototype.options.addBackBtn = true;
});
