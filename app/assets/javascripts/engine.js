$(document).ready(function() {
	$("#new_operation").bind("keypress", function(e) {
		if (e.keyCode == 45) return false;
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
		      	$('.ui-btn-text',this).text('Enviando...');
		        $("#new_operation").submit();
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
	
	
	
	/*$(".tab-content").hide();
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
	});*/
	
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
				$("#donation_amount").val(10);
				$("#new_operation").submit();
			break;
			case 2:
				$("#donation_amount").val(20);
				$("#new_operation").submit();
			break;
			case 3:
				$("#donation_amount").val(30);
				$("#new_operation").submit();
			break;
			case 4:
				$("#donation_amount").val(50);
				$("#new_operation").submit();
			break;
			default:
				return false;
			break;
		}
	}
}
