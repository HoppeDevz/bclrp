

window.addEventListener("message", event => {
    $(".hoppe-calls-app").empty();
    if (event.data.callings !== undefined && event.data.callings !== "undefined") {
        let calls = event.data.callings
        for ( obj in calls ) {
            console.log(obj)
            console.log(calls[obj])

            $(".hoppe-calls-app").append(`
                <div class="alert-call">
                    <span>Chamado</span>
                    <span style="color: white;">[${calls[obj][3]}s]</span>
                    <span style="color: green;" >Y</span>
                    <span style="color: red;">N</span>
                </div>
            `)

        }
    }
})