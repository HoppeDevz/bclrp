const container = $(".garbageman-app");
container.hide();

window.addEventListener('message', event => {
    if (event.data.open) {
        container.show();

        if (event.data.service) {
            $(".service-state-green").append("Você está em serviço!")
        } else {
            $(".service-state-red").append("Você não está em serviço!")
        }
    } else {
        container.hide();
        $(".service-state-green").empty();
        $(".service-state-red").empty();
    }
})

$(".garbageman-closebutton").click(() => {
    $.post("http://garbageman/closeMenu")
})

$(".start-work-button").click(() => {
    $.post("http://garbageman/startWork")
    $(".service-state-red").empty();
    $(".service-state-green").empty();
    $(".service-state-green").append("Você está em serviço!")
})

$(".stop-work-button").click(() => {
    $.post("http://garbageman/stopWork")
    $(".service-state-green").empty();
    $(".service-state-red").empty();
    $(".service-state-red").append("Você não está em serviço!")
})