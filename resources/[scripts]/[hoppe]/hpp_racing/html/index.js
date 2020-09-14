const container = $(".scoreboard-app");
container.hide();

window.addEventListener("message", event => {
    if ( event.data.open ) {
        container.show();

        const scoreboard = event.data.scoreboard

        for ( obj in scoreboard ) {
            console.log(obj)
            console.log(scoreboard[obj])
            const topRacers = $(".top-racers")

            topRacers.append(`
                <li class="racer" >${scoreboard[obj].name} <span class="time">${scoreboard[obj].time}s </span> </li>
            `)
        }

    } else {
        container.hide();
        const topRacers = $(".top-racers");
        topRacers.empty();
    }
})