const container = $(".hoppe-loot-app");
container.hide();

window.addEventListener("message", event => {
    if (event.data.open) {
        container.show();

        const items = event.data.items
        for ( obj in items ) {
            console.log(obj); // item_name
            console.log(items[obj]); // quantity

            const lootInv = $(".loot-inv");
            lootInv.append(`
                <div class="loot-inv-item" id="${obj}">
                    <div class="img-qtd">
                        <img src="../assets/inventory/${obj}.png" width="auto" height="20px" />
                        <input value="${items[obj]}" class="loot-inv-item-qtd${obj}" style="pointer-events: none;" id="qtd-item" />
                    </div>
                    <input placeholder="Quantidade" class="select-inv-item-qtd${obj}" type="number" />
                    <button onclick="GetItem('${obj}')">Pegar</button>
                </div>
            `)

        }
    } else {    
        container.hide();
        const lootInv = $(".loot-inv");
        lootInv.empty();
    }
})

const closeButton = $(".close-button");
closeButton.click(() => {
    $.post("http://hpp_loot/closeMenu")
})

function GetItem(_ItemName) {
    const LootInvQtdVal = Number($(`.loot-inv-item-qtd${_ItemName}`).val());
    const SelectQtdVal = Number($(`.select-inv-item-qtd${_ItemName}`).val());

    console.log('LootInvQtd', LootInvQtdVal)
    console.log('SelectQtd', SelectQtdVal)

    if ( SelectQtdVal <= LootInvQtdVal ) {
        const NewLootInvQtdVal = LootInvQtdVal - SelectQtdVal;
        if (NewLootInvQtdVal > 0) {
            $(`.loot-inv-item-qtd${_ItemName}`).attr("value", NewLootInvQtdVal)
        } else {
            $(`#${_ItemName}`).empty();
        }

        const data = { quantity: Number(SelectQtdVal), itemname: _ItemName }
        $.post("http://hpp_loot/giveItem", JSON.stringify(data));
    }
}