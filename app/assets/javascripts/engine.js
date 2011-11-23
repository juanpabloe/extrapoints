$(document).ready(function() {
	$("#alumnos-multiple li").bind('click', function() {
		$(this).toggleClass('selected');
	};
	$("#new_operation").bind("keypress", function(e) {
		if (e.keyCode == 45) return false;
	});
	$("#notice").live('click', function () {
		$(this).hide();
	});
	//Confirmation box student donation form
	$('#operation_confirm').live('click', function() {
		$(this).simpledialog({
		  'mode' : 'bool',
		  'prompt' : '¿Estás seguro?',
		  'useModal': true,
		  'buttons' : {
		  	'SI': {
		      click: function () {
		      	var textoBtn = $('.ui-btn-text',this);
		      	var prevText = $(textoBtn).text();
		      	$(textoBtn).text('Enviando...');
		      	var monto = validaMonto($('#operation_amount',this));
		      	var descripcion = validaDescripción($('#operation_description',this));
		      	if (monto.passed && descripcion.passed) {
		      		$("#new_operation").submit();	
		      	} else {
		      		$("#notice").hide();
				   	if (!monto.passed) {
				   		$("#title").after("<div id=\"notice\" class=\"warning\"><a class=\"close\" href=\"#\">×</a>"+
							 						"<p>"+monto.message+"</p></div>");
				   	} else if (!descripcion.passed) {
							$("#title").after("<div id=\"notice\" class=\"warning\"><a class=\"close\" href=\"#\">×</a>"+
							 						"<p>"+descripcion.message+"</p></div>");
				   	}
				   	$(textoBtn).text(prevText);
		      	}
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
	
	//Confirmation box student donation form
	$('.present').live('vclick', function() {
		$(this).simpledialog({
		  'mode' : 'bool',
		  'prompt' : '¿Estás seguro?',
		  'buttons' : {
		  	'SI': {
		      click: function () {
		      	mandaRegalo($(this).attr("id"));
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
	
	$(".donate-selection").click(function() {
	   $(this).parent().parent().toggleClass('selected') ;
	   var objWithText = $(this).prev().children(':first-child');
	   var text = $(objWithText).text();
	   $(objWithText).text(text == "Seleccionar" ? "Deseleccionar" : "Seleccionar");
	});
	
	$("#make-multiple-donation").click(function() {
	   var students_to_receive = new Array();
	   $('.selected',"#alumnos-multiple").each(function(index) {
          students_to_receive.push($(this).attr('id'));
      });   
      console.log(students_to_receive);
      $.post("/donations/multiple", { 'students[]': [students_to_receive] }, function(data) {
        console.log(data);
      });
	});
	
});

window.addEventListener('load', function(e) {
    setTimeout(function() { window.scrollTo(0, 1); }, 1);
  }, false);
  

function mandaRegalo(premio) {
	premio = parseInt(premio);
	if (premio > 0 && premio < 5) {
		switch(premio) {
			case 1:
				$("#operation_amount").val(10);
				$("#new_operation").submit();
			break;
			case 2:
				$("#operation_amount").val(20);
				$("#new_operation").submit();
			break;
			case 3:
				$("#operation_amount").val(30);
				$("#new_operation").submit();
			break;
			case 4:
				$("#operation_amount").val(50);
				$("#new_operation").submit();
			break;
			default:
				return false;
			break;
		}
	}
}

function validaMonto(obj) {
	var monto = $(obj.selector).val();
	var foo;
	if (typeof monto !== 'undefined' && monto !== null && monto != "" && monto.length > 0) {
		if (parseFloat(monto) > 100 || parseFloat(monto) < 1 ){
			foo = { passed: false, message: "El monto debe de ser menor a 100 puntos y mayor a 0" };
		} else {
			foo = { passed: true, message: "string" };
		}
		return foo;
	}
	foo = { passed: false, message: "Verifica los valores ingresados" };
	return foo;
}

function validaDescripción(obj) {
	var monto = $(obj.selector).val();
	if (typeof monto !== 'undefined' && monto !== null && monto != "" && monto.length > 0) {
		foo = { passed: true, message: "string" };
		return foo;
	}
	foo = { passed: false, message: "Verifica los valores ingresados" };
	return foo;
}
