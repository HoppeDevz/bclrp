const container = $(".dumptrash-app");
container.hide();

window.addEventListener('message', event => {
    if ( event.data.open ) {
        container.show();
    } else {
        container.hide();
    }
})

$(".dumtrash-closebutton").click(() => {
    $.post("http://dumptrash/closeMenu")
})

$(".dumpbutton").click(() => {
    let qtd = $(".dumpquantity").val();

    if ( qtd == "" || qtd == " " || qtd == null ) { return }

    $.post("http://dumptrash/dump", JSON.stringify(qtd))
})
