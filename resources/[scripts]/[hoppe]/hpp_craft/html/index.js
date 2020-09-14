const container = $(".craft-weapon-app")
container.hide();

window.addEventListener('message', event => {
    if (event.data.open) {
        container.show();

        const data = event.data.data

        for ( obj in data ) {
            console.log(obj) // array pos
            console.log(data[obj]) // .name .item and .price

            $(".menu-list").append(`
                <div class="menu-item">
                    <button class="craft-button" onclick="craftWeapon('${data[obj].name}', '${data[obj].item}', '${data[obj].price}')">
                    <img src="../assets/${data[obj].imgUrl}.png" width="25px" />
                    ${data[obj].name} \n 
                    [${data[obj].price} aços]
                    </button>   
                <div>
            `)
        }
    } else {
        container.hide();
    }
})

const closeButton = $(".craft-weapon-close-button");
closeButton.click(() => {
    $.post("http://hpp_craft/closeMenu")
    container.hide();
    $(".menu-list").empty();
})

function craftWeapon(_WeaponName, _WeaponNameItem, _Price) {
    const data = { _WeaponName, _WeaponNameItem,  _Price }
    $.post("http://hpp_craft/craftWeapon", JSON.stringify(data))
}