const container = $(".criminal-record-app");
const closeButton = $(".close-button");
var TargetCharId = 0
var BillAmount = 0
container.hide();
closeButton.hide();

window.addEventListener("message", event => {
    if (event.data.open) {
        container.show();
        closeButton.show();

        const criminal_records = event.data.criminal_records;
        const charinfo = event.data.charinfo;
        TargetCharId = charinfo[0].charid;
        console.log(event.data.billVal);
        $(".bills-pendents").append(`Multas:` + event.data.billVal.toLocaleString('pt-br',{style: 'currency', currency: 'BRL'}) );
        BillAmount = Number(event.data.billVal);

        for ( obj in charinfo ) {
            console.log(obj);
            console.log(charinfo[obj]); // .charid, .user_id, .characterName, .age, .money, 

            $(".charName").append(`Nome: ${charinfo[obj].characterName}`)
            $(".age").append(`Idade: ${charinfo[obj].age}`)
            // $(".money").append(`Dinheiro: ${charinfo[obj].money}`)
        }

        if ( criminal_records.length == 0 ) {
            $(".none-criminal-record").append("FICHA LIMPA!")
        }
        for ( data in criminal_records ) {
            console.log(data);
            console.log(criminal_records[data]); //.ID, .criminal_record

            $(".criminal-record-list").append(`
                <div class="character-criminal-record">
                    <span class="criminal-record-id">Policial: ${criminal_records[data].register_by}</span>
                    <span>Crime: ${criminal_records[data].criminal_record}</span>
                </div>
            `)
        }
    } else {
        $(".bills-pendents").empty();
        $(".criminal-record-list").empty();
        $(".none-criminal-record").empty();
        $(".charName").empty();
        $(".age").empty();
        $(".money").empty();
        container.hide();
        closeButton.hide();
    }
})

const billButton = $(".bill-button");
billButton.click(() => {
    const val = Number($(".bill-value").val());
    if (!isNaN(val)) {
        const old_val = BillAmount
        const new_val = Number(old_val) + val
        $(".bills-pendents").empty();
        $(".bills-pendents").append(`Multas:` + new_val.toLocaleString('pt-br',{style: 'currency', currency: 'BRL'}) );
        console.log('TargetCharId', TargetCharId)
        const data = { val, TargetCharId }
        $.post("http://hpp_criminalrecord/addBill", JSON.stringify(data))
    }
})

closeButton.click(() => {
    $.post("http://hpp_criminalrecord/closeMenu")
})