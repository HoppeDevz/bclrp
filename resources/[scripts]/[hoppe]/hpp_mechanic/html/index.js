const container = $(".mechanic-container");
container.hide();

window.addEventListener('message', event => {
    if (event.data.open) {
        container.show();
        
        const stock = event.data.stock
        for ( obj in stock ) {
            console.log(obj);
            console.log(stock[obj])

            if (obj == "vehtyres") {
                const ValueVehTyres = $(".value-vehtyes");
                ValueVehTyres.append(stock[obj])
            }   
            
            if ( obj == "engine" ) {
                const ValueVehEngine = $(".value-engine");
                ValueVehEngine.append(stock[obj])
            }
            
        }
        
    } else {
        container.hide();

        const ValueVehTyres = $(".value-vehtyes");
        ValueVehTyres.empty();

        const ValueVehEngine = $(".value-engine");
        ValueVehEngine.empty();
    }
})

const closeButton = $(".mechanic-close-button");
closeButton.click(() => {
    $.post("http://hpp_mechanic/closeMenu")
})

const addButtonVehtyres = $(".add-button-vehtyres");
addButtonVehtyres.click(() => {
    const valueAddVehtyres = Number($(".value-add-vehtyres").val());
    $.post("http://hpp_mechanic/addVehTyres", JSON.stringify(valueAddVehtyres));

    const ValueVehTyres = $(".value-vehtyes");
    ValueVehTyres.empty();

    const ValueVehEngine = $(".value-engine");
    ValueVehEngine.empty();
})

const addButtonEngine = $(".add-button-engine");
addButtonEngine.click(() => {
    const valueAddEngine = Number($(".value-add-engine").val());
    $.post("http://hpp_mechanic/addEngine", JSON.stringify(valueAddEngine))

    const ValueVehTyres = $(".value-vehtyes");
    ValueVehTyres.empty();

    const ValueVehEngine = $(".value-engine");
    ValueVehEngine.empty();
})