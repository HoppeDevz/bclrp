const container = $(".bills-container-master");
container.hide();

window.addEventListener('message', event => {
    if (event.data.open) {
        container.show();

        const bills = event.data.bills

        
        if (bills[0]) {
            console.log(bills)
            const bills_list = $(".bills-list")
            for ( var k = bills.length; k >= 0; k-- ) {
                if (bills[k]) {
                    bills_list.append(`
                        <div class="bill">
                            <h2>ID:${bills[k].toId}</h2>
                            <h3>Quantidade:${bills[k].payQtd}</h3>
                            <h4>Descrição:${bills[k].description}</h4>
                            <h4>Status: ${bills[k].status}</h4>
                            <button onclick="payBill('${bills[k].id}', '${bills[k].payQtd}', '${bills[k].toId}')">Pagar</button>
                        </div>
                    `)
                }
            }
        }
    } else {
        container.hide();
        const bills_list = $(".bills-list")
        bills_list.empty();
    }
})

function payBill(_id, _payQtd, _toId) {
    const id = Number(_id)
    const payQtd = Number(_payQtd)
    const toId = Number(_toId)

    const data = { id, payQtd, toId }
    $.post("http://hpp_bills/payBill", JSON.stringify(data))
}

function generateBill() {
    const _id = Number($(".Id").val());
    const _payQtd = Number($(".payQtd").val());
    const _desc = $(".desc").val();

    if (_id > 1000000 && _payQtd > 1000000 || _desc == "") {  
        const send_confirm = $(".send-confirm");
        send_confirm.empty();

        const send_error = $(".send-error")
        send_error.append("Informações inválidas!")

        setTimeout(() => {
            send_error.empty();
        },6000)

        return
    }

    const send_error = $(".send-error")
    send_error.empty()

    const send_confirm = $(".send-confirm");
    send_confirm.append("Boleto gerado com sucesso!")

    const data = { _id, _payQtd, _desc }
    $.post("http://hpp_bills/generateBill", JSON.stringify(data))

    setTimeout(() => {
        send_confirm.empty();
    },6000)
}

const closeButton = $(".bills-close-button");
closeButton.click(() => {
    $.post("http://hpp_bills/closeMenu")
})