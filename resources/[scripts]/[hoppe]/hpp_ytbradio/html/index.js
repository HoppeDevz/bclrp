const container = $(".ytb-radio-app");

window.addEventListener('message', event => {
    if (event.data.musicURL) {
        container.empty();

        if (!event.data.resume) {
            container.append(`
                <iframe class="ytb-player" id="ytplayer" type="text/html" width="640" height="360"
                src="${event.data.musicURL}?autoplay=1&origin=http://example.com"
                frameborder="0"
                />
            `)
        } else {
            console.log(event.data._playtime)
            container.append(`
            <iframe class="ytb-player" id="ytplayer" type="text/html" width="640" height="360"
                src="${event.data.musicURL}?autoplay=1&start=${event.data._playtime}"
                frameborder="0"
            />
            `)
        }
        
    }
})