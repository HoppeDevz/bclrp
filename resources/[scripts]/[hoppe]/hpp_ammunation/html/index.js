const container = $(".ammu-nation-app");
container.hide();

window.addEventListener("message", event => {
    if (event.data.open) {
        container.show();
    } else {
        container.hide();
    }
});

function buyItem(_ItemName, _ItemPrice) {
    const ItemPrice = Number(_ItemPrice);
    const ItemName = _ItemName;

    const data = { ItemName, ItemPrice };
    $.post("http://hpp_ammunation/buyItem", JSON.stringify(data));
}

const closeButton = $(".close-ammu-button");
closeButton.click(() => {
    $.post("http://hpp_ammunation/closeMenu")
})