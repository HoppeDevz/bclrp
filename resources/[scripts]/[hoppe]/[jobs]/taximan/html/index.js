const container = $(".taximan-app");
container.hide();

window.addEventListener('message', event => {
    if (event.data.open) {
        container.show();
        const data = event.data.spots;
        for ( obj in data ) {
            // console.log(obj); // 0 => js | lua => 1
            // console.log(data[obj]);

            let raceId = Number(obj) + 1

            const taximanMenu = $(".taximan-menu");
            if ( raceId < 10 ) {
                taximanMenu.append(`
                    <div class=${raceId} id="menu-item">
                        <button onclick="startRace('${raceId}')">Corrida 0${raceId}</button>
                    </div>
                `)
            } else {
                taximanMenu.append(`
                    <div class=${raceId} id="menu-item">
                        <button onclick="startRace('${raceId}')">Corrida ${raceId}</button>
                    </div>
                `)
            }
            
        }
    } else {
        const taximanMenu = $(".taximan-menu");
        taximanMenu.empty();
        container.hide();
    }
})

function startRace(_id) {
    const id = Number(_id)
    console.log(id)
    $.post("http://taximan/startRace", JSON.stringify(id))
}

const closeButton = $(".taximan-closebutton");
closeButton.click(() => {
    $.post("http://taximan/closeMenu")
});