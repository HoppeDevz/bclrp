const container = $(".clone-card-app");
container.hide();
var hostadress = ""
var charid = 0

window.addEventListener("message", event => {
    if (event.data.open) {
        container.show();
        hostadress = event.data.hostadress;
        charid = event.data.charid;

        $(".id-input-value").attr("value", event.data.charid)

    } else {    
        container.hide();
    }
})

const closeButton = $(".close-clone-card-app-button")
closeButton.click(() => {
    $.post("http://register_account/closeMenu")
})

$(".register-computer-button").click(() => {
    const username = $(".username-value").val();
    const password = $(".password-value").val();

    console.log("hostadress", hostadress);

    if ( username.replace(/\s/g, '') == "" || password.replace(/\s/g, '') == "" ) {
        $(".alert-error").append(`Campos Vazios!`)
        setTimeout(() => {
            $(".alert-error").empty();
        }, 2000);
        return
    }

    const data = { username, password }
    // console.log("Tachengaodaqui")
    $.post("http://register_account/registerAccount", JSON.stringify(data));

})