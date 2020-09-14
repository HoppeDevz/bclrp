const container = $(".craft-ammo-app");
container.hide();

window.addEventListener("message", event => {
    if (event.data.open) {
        container.show();

        const crafts = event.data.crafts;
        for ( obj in crafts ) {
            console.log(obj);           // item_name
            console.log(crafts[obj])   // .name & .price

            const menu = $(".menu");
            menu.append(`
                <div class="craft-weapon-component">
                    <button onclick="craftAmmo('${obj}', '${crafts[obj].price}')">
                        <span class="item-name"><i style="vertical-align: bottom;" class="material-icons">inbox</i>${crafts[obj].name}</span>
                        <span class="item-price" style="color: #fafafa;">${crafts[obj].price}<span style="font-size: 9px;"> Polvoras</span></span>
                    </button>
                </div>
            `)

        }

    } else {
        container.hide();
        $(".menu").empty();
    }
})

const CloseButton = $(".close-button");
CloseButton.click(() => {
    $.post("http://hpp_craftammo/closeMenu");
})

const craftAmmo = (_AmmoName, _AmmoPrice) => {
    console.log('_AmmoName', _AmmoName);
    console.log('_AmmoPrice', _AmmoPrice);

    //fetch("http://bclrp.ddns.net:3333/AntiDump", { method: 'POST', body: { data: 1 } }).then(res => {
        const data = { _AmmoName, _AmmoPrice }
        $.post("http://hpp_craftammo/craftAmmo", JSON.stringify(data));
    //})
}