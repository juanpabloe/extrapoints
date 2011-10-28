$(document).ready(function() {
	$("#new_donation").bind("keypress", function(e) {
		if (e.keyCode == 45) return false;
	});
	
	//Confirmation box student donation form
	$('#donar_confirm').live('vclick', function() {
		$(this).simpledialog({
		  'mode' : 'bool',
		  'prompt' : '¿Estás seguro?',
		  'buttons' : {
		  	'SI': {
		      click: function () {
		      	$('.ui-btn-text',this).text('Enviando...');
		        $("#new_donation").submit();
		      }
		    },
		    'NO': {
		      click: function () {
		      },
		      icon: "delete",
		      theme: "c"
		    }
		  }
		})
	});
	
	//Confirmation box teacher withdrawal form
	$('#withdrawal_confirm').live('vclick', function() {
		$(this).simpledialog({
		  'mode' : 'bool',
		  'prompt' : '¿Estás seguro?',
		  'buttons' : {
		  	'SI': {
		      click: function () {
		      	$('.ui-btn-text',this).text('Enviando...');
		        $("#new_withdraw").submit();
		      }
		    },
		    'NO': {
		      click: function () {
		      },
		      icon: "delete",
		      theme: "c"
		    }
		  }
		})
	});
	
	$(".tab-content").hide();
	$("#alumnos").show();
	//Change tabs in search view
	$('a',"#groupby-tabs").click(function(e) {
		e.preventDefault();
		$("#groupby-tabs a").removeClass("ui-btn-active");
		$(this).addClass("ui-btn-active");
		$(".tab-content").hide();
		var activeTab = $(this).attr("href");
		$(activeTab).show();
		return false;
	});

});

window.addEventListener("load",function() {
  setTimeout(function(){
    // Esconde la barra de dirección
    window.scrollTo(0, 1);
  }, 0);
 
});
