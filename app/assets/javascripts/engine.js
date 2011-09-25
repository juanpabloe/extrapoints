$(document).ready(function() {
	$("#new_donation").bind("keypress", function(e) {
		if (e.keyCode == 45) return false;
	});
});
