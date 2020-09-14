const container = $(".carhud");
container.hide();


window.addEventListener("message", event => {
    if (event.data.open) {
        $(".material-icons").attr("style", "display: block;")
        container.show();
        $(".velocity-value").empty();
        $(".gas-value").empty();

        const velComponent = $(".velocity-value");
        const vel = parseInt((event.data.vel) * 3.6);

        const gasComponent = $(".gas-value");
        const gas = (event.data.gas).toFixed(2);

        gasComponent.append(gas);
        velComponent.append(`${vel} KM/H`);

    } else {
        $(".material-icons").attr("style", "display: none;")
        $(".velocity-value").empty();
        $(".gas-value").empty();
        container.hide();
    }
})