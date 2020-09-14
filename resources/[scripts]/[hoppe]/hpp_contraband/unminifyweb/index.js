const container = $(".contraband-app");
container.hide();

window.addEventListener("message", event => {
    if (event.data.open) {
        container.show();
    } else {
        container.hide();
    }
});

$(".contraband-close-button").click(() => { $.post("http://hpp_contraband/closeMenu") });

function buyItem(_ItemName, _Price) {
    const data = { _ItemName, _Price };
    $.post("http://hpp_contraband/buyItem", JSON.stringify(data));
}