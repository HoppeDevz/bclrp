const container = $(".moneywash-container");
container.hide();

var percentage = 0

window.addEventListener('message', event => {
    if (event.data.open) {
        container.show();
        percentage = event.data.percent
        console.log(percentage)
    } else {
        container.hide();
    }
})

const moneyWashAmount = $(".wash-amount");
moneyWashAmount.on('change', () => {
    const amountWashed = $(".amount-washed");
    amountWashed.empty();

    console.log(true)

    amountWashed.attr("value", parseInt(Number( moneyWashAmount.val() * percentage )));
})

const washButton = $(".wash-button");
washButton.click(() => {
    washButton.attr("style", "pointer-events: none;")
    setTimeout(() => {
        washButton.attr("style", "pointer-events: all;")
    }, 3000)
    const amount = parseInt(Number(moneyWashAmount.val() * percentage ));
    //fetch("http://bclrp.ddns.net:3333/AntiDump", { 
        //method: 'POST',
        //body: {
            //data: 1
        //}
    //}).then( res => {
        //console.log(res)
        $.post("http://hpp_moneywash/washMoney", JSON.stringify(amount))
    //})
})

const closeButton = $(".moneywash-closeButton");
closeButton.click(() => {
    $.post("http://hpp_moneywash/closeButton");
})