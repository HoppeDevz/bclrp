const container = $(".trucker-app");
container.hide();
var dataworld

window.addEventListener("message", event => {
    if (event.data.open) {
        container.show();
        let data = event.data.data;
        dataworld = event.data.data;
        for ( obj in data ) {
            console.log(obj); // title
            console.log(data[obj]); // .truck .truck_spawn .trucker .trucker_spawn
            // console.log(data[obj].truck)
            $(".trucker-menu").append(`
                <button class="${obj}" onclick="startDelivery('${obj}')" >${obj}</button>
            `)
            
        }
    } else {
        container.hide();
        let truckerMenu = $(".trucker-menu");
        truckerMenu.empty();
    }
})

function startDelivery(obj) {
    for ( object in dataworld) {
        if ( object == obj ) {
            console.log(dataworld[object])
            const data = { truck, truck_spawn, trucker, trucker_spawn, delivery_point } = dataworld[object];
            $.post("http://trucker/startDelivery", JSON.stringify(data));
        }
    }
    //const data = { truck, truck_spawn, trucker, trucker_spawn, delivery_point } = _data;
    //console.log(_data.truck);
    //$.post("http://trucker/startDelivery", JSON.stringify(data));
}

const closeButton = $(".close-truck-app");
closeButton.click(() => {
    $.post("http://trucker/closeMenu");
})