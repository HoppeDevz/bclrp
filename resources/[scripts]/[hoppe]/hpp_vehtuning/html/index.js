const container = $(".hoppe-vehtuning-app");
container.hide();

window.addEventListener("message", event => {
    if (event.data.open) {
        container.show();
        const engine_level =       event.data.engine_level;
        const brake_level =        event.data.brake_level;
        const transmission_level = event.data.transmission_level;
        const turbo =              event.data.turbo;
        const armour_level =       event.data.armour_level;
        const engine_health =      event.data.engine_health;
        const vehicle_health =     event.data.vehicle_health;
        const fuel =               event.data.fuel;

        $(".engine_level").append(`Motor: ${Number(engine_level) + 2}`);
        $(".brake_level").append(`Freio: ${Number(brake_level) + 2}`);
        $(".transmission_level").append(`Transmissão: ${Number(transmission_level) + 2}`);

        if (turbo == -1) {
            $(".turbo").append(`Turbo: Sem Turbo`);
        } else {
            $(".turbo").append(`Turbo: Turbo Instalado`);
        }
        
        $(".armour_level").append(`Blindagem: ${Number(armour_level) + 2}`);
        $(".engine_health").append(`Motor: ${Number(engine_health).toFixed(2)}`);
        $(".vehicle_health").append(`Chassi: ${vehicle_health}`);
        $(".fuel").append(`Gasolina ${Number(fuel).toFixed(2)}`);


    } else {
        container.hide();

        $(".engine_level").empty();
        $(".brake_level").empty();
        $(".transmission_level").empty();
        $(".turbo").empty();
        $(".armour_level").empty();
        $(".engine_health").empty();
        $(".vehicle_health").empty();
        $(".fuel").empty();
    }
})