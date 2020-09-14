iziToast.settings({
    timeout: 10000,
    resetOnHover: true,
    transitionIn: 'fadeInLeft',
	transitionOut: 'fadeOutRight',
	position: "topRight",
	progressBar: false,
	close: false
});

$(document).ready(function() {
	window.addEventListener("message",function(event) {
		if(event.data.css == "sucesso") {
			iziToast.success({
				title: false,
				message: event.data.mensagem,
				icon: 'fas fa-check-circle'
			});
		} else if (event.data.css == "negado") {
			iziToast.error({
				title: false,
				message: event.data.mensagem,
				icon: 'fas fa-ban'
			});
		} else if (event.data.css == "aviso") {
			iziToast.warning({
				title: false,
				message: event.data.mensagem,
				icon: 'fas fa-exclamation-triangle'
			});
		} else {
			iziToast.info({
				title: false,
				message: event.data.mensagem,
				icon: 'fas fa-exclamation-triangle'
			});
		}
	});
});