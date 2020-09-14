$(document).ready(function(){
	window.addEventListener("message",function(event){
		if (event.data.celular == true) {
			$("#displayBars").css('display', 'none');
			$("#displayVehicle").addClass("over-telefone");
		} else {
			$("#displayBars").css('display', 'block');
			$("#displayVehicle").removeClass("over-telefone");
		}
		if (event.data.active == true) {
			$("#displayHud").css("display","block");
			$(".healthHover").css("width", parseInt(event.data.health) + "%");

			if (parseInt(event.data.health) == 1) {
				$(".healthHover").css("width","0");
			}

			$("#displayInfos").html("");

			$(".invweight").html(event.data.invweight);
			$(".invcapacity").html(event.data.invcapacity);

			if (event.data.vehicle == true) {
				$(".staminaOrGas").css("background", "url(images/gas.png) center no-repeat");
				$(".staminaOrGasHover").css("width", event.data.fuel + "%");
				$("#displayVehicle").css("display","block");
				if (event.data.seatbelt == true) {
					$("#displayVehicle").addClass("seatbelt").html(event.data.speed+"<s>KMH</s>");
				} else {
					$("#displayVehicle").removeClass("seatbelt").html(event.data.speed+"<b>KMH</b>");
				}
			} else {
				$("#displayVehicle").css("display","none");
				$(".staminaOrGas").css("background", "url(images/stamina.png) center no-repeat");
				//$(".staminaOrGasHover").css("width", event.data.stamina + "%");
			}
		} else {
			$("#displayHud").css("display","none");
			$("#displayVehicle").css("display","none");
		}

		if (event.data.movie == true){
			$("#movieTop").css("display","block");
			$("#movieBottom").css("display","block");
			$("#displayLogo").css("display","none");
		} else {
			$("#movieTop").css("display","none");
			$("#movieBottom").css("display","none");
			$("#displayLogo").css("display","block");
		}
	})
});