const container = $(".IronRoute-App");
container.hide();

window.addEventListener("message", event => {
    if (event.data.open) {
        container.show();
    } else {
        container.hide();
    }
})

const IronRouteCloseButton = $(".IronRouteCloseButton")
IronRouteCloseButton.click(() => {
    console.log("Button clicked")
    $.post("http://IronRoute/closeMenu")
})