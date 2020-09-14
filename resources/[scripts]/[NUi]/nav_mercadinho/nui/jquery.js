$(document).ready(function(){
	let actionContainer = $("#actionmenu");
	let actionButton = $("#actionbutton");

	window.addEventListener("message",function(event){
		let item = event.data;
		switch(item.action){
			case "showMenu":
				updateEbayList();
				actionButton.fadeIn(500);
				actionContainer.fadeIn(500);
			break;

			case "hideMenu":
				actionButton.fadeOut(500);
				actionContainer.fadeOut(500);
			break;

			case 'updateEbayList':
				updateEbayList();
			break;

			case 'updateinvList':
				updateinvList();
			break;
		}
	});

	$("#inicio").load("./inicio.html");

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://nav_digitalden/ebayClose");
		}
	};
});

$('#actionbutton').click(function(e){
	$.post("http://nav_digitalden/ebayClose");
});

const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}

const carregarMenu = (name) => {
	return new Promise((resolve) => {
		$("#inicio").load(name+".html",function(){
			resolve();
		});
	});
}

const updateEbayList = () => {
	$.post("http://nav_digitalden/requestEbayList",JSON.stringify({}),(data) => {
		let i = 0;
		const nameList = data.ebaylist.sort((a,b) => (a.itemname > b.itemname) ? 1: -1);
		$('#inicio').html(`
			<div class="comprar">COMPRAR</div>
			<div class="retirar">RETIRAR</div>
			<div class="obs">Para efetuar uma <b>compra</b> selecione um item abaixo e clique em <b>comprar</b>, o sistema vai efetuar as checagens necessárias e se você possuir o valor ele compra automaticamente.</div>
			<div class="title">LISTAGEM</div>
			${nameList.map((item) => (`
				<div class="model" data-id-key="${item.id}" data-userid-key="${item.userid}" data-price-key="${item.price}" data-qtd-key="${item.quantidade}" data-itemid-key="${item.itemid}">

					<div class="id">${i = i + 1}</div>
					<div class="name">${item.quantidade}x ${item.itemname}</div>
					<div class="price">$${formatarNumero(item.price)}</div>
					<div class="identity">${item.nome}</div>
				</div>
			`)).join('')}
		`);
	});
}

const updateinvList = () => {
	$.post("http://nav_digitalden/requestinvList",JSON.stringify({}),(data) => {
		let i = 0;
		const nameList = data.invlist.sort((a,b) => (a.name > b.name) ? 1: -1);
		$('#inicio').html(`
			<input id="price" class="pri" maxlength="7" spellcheck="false" value="" placeholder="VALOR..">
			<input id="amount" class="qtd" maxlength="7" spellcheck="false" value="" placeholder="QUANT..">
			<div class="anotext">ANÔNIMO</div>
			<input id="anony" class="anony" type="checkbox">
			<div class="vender">VENDER</div>
			<div class="obs">Para anunciar um <b>item</b> selecione-o abaixo e clique em <b>vender</b>, o sistema vai efetuar as checagens necessárias e colocar seu item na listagem, ao ser vendido você receberá o valor no paypal.</div>
			<div class="title">ANUNCIAR</div>
			${nameList.map((item) => (`
				<div class="model" data-itemid-key="${item.itemid}">
					<div class="id">${i = i + 1}</div>
					<div class="name">${item.amount}x ${item.name}</div>
				</div>
			`)).join('')}
		`);
	});
}

$(document).on("click",".model",function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	$('.model').removeClass('active');
	if(!isActive) $el.addClass('active');
});

$(document).on("click",".comprar",function(){
	let $el = $('.model.active');
	if($el){
		$.post("http://nav_digitalden/ebayBuy",JSON.stringify({
			id: $el.attr('data-id-key'),
			userid: $el.attr('data-userid-key'),
			price: $el.attr('data-price-key'),
			qtd: $el.attr('data-qtd-key'),
			itemid: $el.attr('data-itemid-key')
		}));
	}
});

$(document).on("click",".retirar",function(){
	let $el = $('.model.active');
	if($el){
		$.post("http://nav_digitalden/ebayExtract",JSON.stringify({
			id: $el.attr('data-id-key'),
			userid: $el.attr('data-userid-key'),
			qtd: $el.attr('data-qtd-key'),
			itemid: $el.attr('data-itemid-key')
		}));
	}
});

$(document).on("click",".vender",function(){
	let $el = $('.model.active');
	let price = Number($('#price').val());
	let amount = Number($('#amount').val());
	let anony = document.getElementById("anony");
	if($el && price > 0 && amount > 0){
		$.post("http://nav_digitalden/ebaySell",JSON.stringify({
			itemid: $el.attr('data-itemid-key'),
			amount,
			price,
			anony: anony.checked
		}));
	}
});