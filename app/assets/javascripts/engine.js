$(document).ready(function() {
	$("#new_donation").bind("keypress", function(e) {
		if (e.keyCode == 45) return false;
	});
});

window.addEventListener("load",function() {
  setTimeout(function(){
    // Esconde la barra de dirección
    window.scrollTo(0, 1);
  }, 0);
});
