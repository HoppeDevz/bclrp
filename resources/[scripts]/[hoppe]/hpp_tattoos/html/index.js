const container = $(".hoppe-tattoo-app");
container.hide();

window.addEventListener("message", event => {
    if (event.data.open) {
        container.show();

        total_price = 0
        
        const tattoolist = event.data.tattolist

        for ( obj in tattoolist ) {
            const _collection =  obj; // _collection
            const _arr =  tattoolist[obj]; // array => [x].nameHash ...

            for ( data in _arr ) {
                $(".menu").append(`
                    <button
                        onclick="applyTattoo('${_collection}', '${data}')"
                    >
                    Tatto ${data}
                    </button>
                `)
            }
        }

    } else {
        container.hide();
        $(".menu").empty();
        $(".total-price").empty();
        $(".total-price").append('0');
    }
})

const finishButton = $(".finish-button");
finishButton.click(() => {
    $.post("http://hpp_tattoos/closeMenu")
})

const closeButton = $(".close-button");
closeButton.click(() => {
    $.post("http://hpp_tattoos/closeMenu2")
})

var total_price = 0
const applyTattoo = (_collection, _index) => {
    console.log( '_collection', _collection )
    console.log( '_index', _index )

    let old_val = Number($(".total-price").val());
    total_price = total_price + 500

    $(".total-price").empty();
    $(".total-price").html(`${total_price.toLocaleString('pt-br',{style: 'currency', currency: 'BRL'})}`);

    const data = { _collection, _index }
    $.post("http://hpp_tattoos/applytattoo", JSON.stringify(data))
}

$(".rotateperson").click(() => {
    $.post("http://hpp_tattoos/rotateperson")
})

$(".cleantattoos").click(() => {
    total_price = 0
    $(".total-price").empty();
    $(".total-price").html(`${"0".toLocaleString('pt-br',{style: 'currency', currency: 'BRL'})}`);

    $.post("http://hpp_tattoos/cleantattoos")
})