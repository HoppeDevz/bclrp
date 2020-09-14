
const container = $(".clone-card-app");
container.hide();

window.addEventListener("message", event => {
    if (event.data.open) {
        container.show();

        // Math.floor(Math.random() * (max - min) ) + min;
        const binVal = Math.floor(Math.random() * (900000 - 100000) ) + 100000;
        const cvvVal = Math.floor(Math.random() * (999 - 100) ) + 100;
        $(".cvv-value").append(cvvVal)
        $(".cvv-value").attr("value", cvvVal);

        $(".bin-value").append(binVal)
        $(".bin-value").attr("value", binVal);

    } else {
        container.hide();

        $(".cvv-value").empty();
        $(".bin-value").empty();
    }
})

const CloseButton = $(".close-clone-card-app-button");
CloseButton.click(() => {
    $.post("http://hpp_hackerjob/closeMenu");
})

const generateCardButton = $(".generate-card-button")
generateCardButton.click(() => {
    const inputBinValue = Number($(".input-bin-value").val());
    const inputCvvValue = Number($(".input-cvv-value").val());

    const cvvVal = Number($(".cvv-value").val());
    const binVal = Number($(".bin-value").val());

    console.log("cvvVal", cvvVal);
    console.log("binVal", binVal);

    if ( isNaN(inputBinValue) || isNaN(inputCvvValue) ) return console.log("INVALID VALUE NAN");
    if ( inputBinValue !== binVal || inputCvvValue !== cvvVal ) return console.log("INCORRECT VALUES");

    // console.log("CONGRATULATIONS! CARD CLONED!")
    const newbinVal = Math.floor(Math.random() * (900000 - 100000) ) + 100000;
    const newcvvVal = Math.floor(Math.random() * (999 - 100) ) + 100;
    $(".cvv-value").empty();
    $(".cvv-value").append(newcvvVal)
    $(".cvv-value").attr("value", newcvvVal);

    $(".bin-value").empty();
    $(".bin-value").append(newbinVal)
    $(".bin-value").attr("value", newbinVal);

    $.post("http://hpp_hackerjob/CloneCardSucess", JSON.stringify(binVal))

})

const startCardClonedDelivery = $(".start-card-cloned-delivery");
startCardClonedDelivery.click(() => {
    $.post("http://hpp_hackerjob/StartDelivery")
})