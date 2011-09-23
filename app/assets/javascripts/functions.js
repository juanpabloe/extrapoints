jQuery.fn.setPlaceholder = function(placeholderText) {
    var o = $(this[0]) // It's your element
    console.log(o);
    console.log(placeholderText);	
    $(this[0]).focus(function(){ 
		 if($(this).val() == $(this).attr('defaultValue'))
		 {
		   $(this).val('');
		 }
	  });
	  
	  $(this[0]).blur(function(){
		 if($(this).val() == '')
		 {
		   $(this).val($(this).attr('defaultValue'));
		 } 
	  });
};
