const container = $(".barbershop-container");
container.hide();

window.addEventListener('message', event => {
    if (event.data.open) {
        container.show();

        const custom = event.data.custom

        if (!event.data.firstOpen) {
            for ( obj in custom ) {
                if (obj == 2) {
                    console.log(custom[obj])
                    const hairValue = $(".recent-hair");
                    hairValue.attr("value", custom[obj][0])
            
                    if (event.data.modelhash == 1885233650) {
                        const hairForward = $(".hair-forward");
                        hairForward.click(() => {
                            const recentValue = hairValue.val();
                            if (recentValue == 0) {
                                new_value = 74
                                hairValue.attr("value", new_value);
    
                                // post
                                $.post("http://hpp_barbershop/changeHairModel", JSON.stringify(new_value))
                            } else {
                                new_value = Number(recentValue) - 1;
                                hairValue.attr("value", new_value);
    
                                // post
                                $.post("http://hpp_barbershop/changeHairModel", JSON.stringify(new_value))
                            }
                        })
    
                        const hairNext = $(".hair-next");
                        hairNext.click(() => {
                            const recentValue = hairValue.val();
                            if (recentValue == 74) {
                                const new_value = 0
                                hairValue.attr("value", new_value);
    
                                //post
                                $.post("http://hpp_barbershop/changeHairModel", JSON.stringify(new_value))
                            } else {
                                new_value = Number(recentValue) + 1;
                                hairValue.attr("value", new_value);
    
                                //post
                                $.post("http://hpp_barbershop/changeHairModel", JSON.stringify(new_value))
                            }
    
                        })
    
                        const hairColor = $(".hair-color");
                        hairColor.click(() => {
                            const recentColor = hairColor.val();
                            const new_value = Number(recentColor) + 1;
    
                            hairColor.attr("value", new_value);
    
                            console.log(new_value)
    
                            $.post("http://hpp_barbershop/changeHairColor", JSON.stringify(new_value));
                        })
    
                        const FacialHair = $(".recent-facialhair");
                        FacialHair.attr("value", event.data.facialHair);
                        const facialhairForward = $(".facialhair-forward");
                        facialhairForward.click(() => {
                            const FacialHairValue = FacialHair.val();
                            
                            if (FacialHairValue == 0) {
                                new_value = 28;
                                FacialHair.attr("value", Number(new_value))
                                // post
                                $.post("http://hpp_barbershop/changeFacialHair", JSON.stringify(new_value))
                            } else {
                                new_value = Number(FacialHairValue) - 1;
                                FacialHair.attr("value", Number(new_value))
                                // post
                                $.post("http://hpp_barbershop/changeFacialHair", JSON.stringify(new_value))
                            }
                        })
    
                        const facialhairNext = $(".facialhair-next");
                        facialhairNext.click(() => {
                            const FacialHairValue = FacialHair.val();
    
                            if ( FacialHairValue == 28 ) {
                                new_value = 0;
                                FacialHair.attr("value", Number(new_value))
                                //post
                                $.post("http://hpp_barbershop/changeFacialHair", JSON.stringify(new_value))
                            } else {
                                new_value = Number(FacialHairValue) + 1;
                                FacialHair.attr("value", Number(new_value))
                                //post
                                $.post("http://hpp_barbershop/changeFacialHair", JSON.stringify(new_value))
                            }
                        })
    
                        const facialhairColor = $(".facialhair-color");
                        facialhairColor.attr("value", "0");
                        facialhairColor.click(() => {
                            const new_value = Number(facialhairColor.val()) + 1;
                            facialhairColor.attr("value", new_value);
    
                            //post
                            $.post("http://hpp_barbershop/changeFacialHairColor", JSON.stringify(new_value))
                        })

                        console.log('eyecolor', event.data.eyecolor)
                        const eyeColor = $(".recent-eyecolor");
                        eyeColor.attr("value", 1);

                        const eyeFoward = $(".eyecolor-forward");
                        eyeFoward.click(() => {
                            let val = Number(eyeColor.val());
                            let new_val = val - 1;
                            if (new_val > 0) {
                                eyeColor.attr("value", new_val);

                                const data = { new_val }
                                $.post("http://hpp_barbershop/setPedEyeColor", JSON.stringify(data))
                            }
                        });

                        const eyeNext = $(".eyecolor-next");
                        eyeNext.click(() => {
                            let val = Number(eyeColor.val());
                            let new_val = val + 1;

                            eyeColor.attr("value", new_val);

                            const data = { new_val }
                            $.post("http://hpp_barbershop/setPedEyeColor", JSON.stringify(data))
                        });

                        const eyeBrows = $(".recent-eyebrows");
                        eyeBrows.attr("value", 1);

                        eyeBrowsForWard = $(".eyebrows-forward");
                        eyeBrowsForWard.click(() => {
                            let val = Number(eyeBrows.val());
                            let new_val = val - 1;
                            if (new_val > 0) {

                                eyeBrows.attr("value", new_val);

                                const data = { new_val }
                                $.post("http://hpp_barbershop/setPedEyeBrow", JSON.stringify(data))
                            }
                        });

                        eyeBrowsNext = $(".eyebrows-next");
                        eyeBrowsNext.click(() => {
                            let val = Number(eyeBrows.val());
                            let new_val = val + 1;
                            eyeBrows.attr("value", new_val);

                            const data = { new_val }
                            $.post("http://hpp_barbershop/setPedEyeBrow", JSON.stringify(data))
                        })    
                        
                        const eyebrowsColor = $(".eyebrows-color");
                        eyebrowsColor.attr("value", 1)
                        eyebrowsColor.click(() => {
                            let id = Number(eyebrowsColor.val());
                            if (id == 50) {
                                eyebrowsColor.attr("value", 1)
                                let new_val = 1
                                const data = { new_val }
                                console.log(new_val)
                                eyebrowsColor.attr("value", new_val)
                                $.post("http://hpp_barbershop/setPedEyeBrowColor", JSON.stringify(data))
                            } else {
                                let new_val = id + 1
                                const data = { new_val }
                                console.log(new_val)
                                eyebrowsColor.attr("value", new_val)
                                $.post("http://hpp_barbershop/setPedEyeBrowColor", JSON.stringify(data))
                            }
                        })

                        const recentBlush = $(".recent-blush");
                        recentBlush.attr("value", event.data.blush);
    
                        const blushForward = $(".blush-forward");
                        blushForward.click(() => {
                            const old_value = recentBlush.val();
                            if (old_value == -1) {
                                const new_value = 6;
                                recentBlush.attr("value", new_value);
    
                                //post
                                $.post("http://hpp_barbershop/changeBlushIndex", JSON.stringify(new_value))
                            } else {
                                const new_value = Number(old_value) - 1;
                                recentBlush.attr("value", new_value);
    
                                //post
                                $.post("http://hpp_barbershop/changeBlushIndex", JSON.stringify(new_value))
                            }
                        })
    
                        const blushNext = $(".blush-next")
                        blushNext.click(() => {
                            const old_value = recentBlush.val();
                            if (old_value == 6) {
                                const new_value = -1;
                                recentBlush.attr("value", new_value);
    
                                //post
                                $.post("http://hpp_barbershop/changeBlushIndex", JSON.stringify(new_value))
                            } else {
                                const new_value = Number(old_value) + 1;
                                recentBlush.attr("value", new_value);
    
                                //post
                                $.post("http://hpp_barbershop/changeBlushIndex", JSON.stringify(new_value))
                            }
                        })
    
                        const recentLipstick = $(".recent-lipstick");
                        recentLipstick.attr("value", event.data.lipstick);
    
                        const lipstickForward = $(".lipstick-forward");
                        lipstickForward.click(() => {
                            const old_value = recentLipstick.val();
    
                            if ( old_value == -1 ) {
                                new_value = 9;
                                recentLipstick.attr("value", new_value)
    
                                //post
                                $.post("http://hpp_barbershop/changeLipStickIndex", JSON.stringify(new_value))
                            } else {
                                new_value = Number(old_value) - 1;
                                recentLipstick.attr("value", new_value)
    
                                //post
                                $.post("http://hpp_barbershop/changeLipStickIndex", JSON.stringify(new_value))
                            }
                        })
    
                        const lipstickNext = $(".lipstick-next");
                        lipstickNext.click(() => {
                            const old_value = recentLipstick.val();
    
                            if (old_value == 9) {
                                new_value = -1
                                recentLipstick.attr("value", new_value)
    
                                //post
                                $.post("http://hpp_barbershop/changeLipStickIndex", JSON.stringify(new_value))
                            } else {
                                new_value = Number(old_value) + 1;
                                recentLipstick.attr("value", new_value)
    
                                //posts
                                $.post("http://hpp_barbershop/changeLipStickIndex", JSON.stringify(new_value))
                            }
                        })
    
    
                    } else {
                        if (event.data.modelhash == -1667301416) {
                        const hairForward = $(".hair-forward");
                        hairForward.click(() => {
                            const recentValue = hairForward.val();
                            if (recentValue == 0) {
                                new_value = 78
                                hairValue.attr("value", new_value);
    
                                // post
                                $.post("http://hpp_barbershop/changeHairModel", JSON.stringify(new_value))
                            } else {
                                new_value = Number(recentValue) - 1;
                                hairValue.attr("value", new_value);
    
                                // post
                                $.post("http://hpp_barbershop/changeHairModel", JSON.stringify(new_value))
                            }
                        })
    
                        const hairNext = $(".hair-next");
                        hairNext.click(() => {
                            const recentValue = hairValue.val();
                            if (recentValue == 78 ) {
                                const new_value = 0
                                hairValue.attr("value", new_value);
    
                                //post 
                                $.post("http://hpp_barbershop/changeHairModel", JSON.stringify(new_value))
                            } else {
                                new_value = Number(recentValue) + 1;
                                hairValue.attr("value", new_value);
    
                                //post
                                $.post("http://hpp_barbershop/changeHairModel", JSON.stringify(new_value))
                            }
    
                        })
    
                        const hairColor = $(".hair-color");
                        hairColor.click(() => {
                            const recentColor = hairColor.val();
                            const new_value = Number(recentColor) + 1;
    
                            hairColor.attr("value", new_value);
    
                            console.log(new_value)
    
                            $.post("http://hpp_barbershop/changeHairColor", JSON.stringify(new_value));
                        })
    
                        const recentBlush = $(".recent-blush");
                        recentBlush.attr("value", event.data.blush);
    
                        const blushForward = $(".blush-forward");
                        blushForward.click(() => {
                            const old_value = recentBlush.val();
                            if (old_value == -1) {
                                const new_value = 6;
                                recentBlush.attr("value", new_value);
    
                                //post
                                $.post("http://hpp_barbershop/changeBlushIndex", JSON.stringify(new_value))
                            } else {
                                const new_value = Number(old_value) - 1;
                                recentBlush.attr("value", new_value);
    
                                //post
                                $.post("http://hpp_barbershop/changeBlushIndex", JSON.stringify(new_value))
                            }
                        })
    
                        const blushNext = $(".blush-next")
                        blushNext.click(() => {
                            const old_value = recentBlush.val();
                            if (old_value == 6) {
                                const new_value = 0;
                                recentBlush.attr("value", new_value);
    
                                //post
                                $.post("http://hpp_barbershop/changeBlushIndex", JSON.stringify(new_value))
                            } else {
                                const new_value = Number(old_value) + 1
                                recentBlush.attr("value", new_value);
    
                                //post
                                $.post("http://hpp_barbershop/changeBlushIndex", JSON.stringify(new_value))
                            }
                        })
    
                        const recentLipstick = $(".recent-lipstick");
                        recentLipstick.attr("value", event.data.lipstick);
    
                        const lipstickForward = $(".lipstick-forward");
                        lipstickForward.click(() => {
                            const old_value = recentLipstick.val();
    
                            if ( old_value == -1 ) {
                                new_value = 9;
                                recentLipstick.attr("value", new_value)
    
                                //post
                                $.post("http://hpp_barbershop/changeLipStickIndex", JSON.stringify(new_value))
                            } else {
                                new_value = Number(old_value) - 1;
                                recentLipstick.attr("value", new_value)
    
                                //post
                                $.post("http://hpp_barbershop/changeLipStickIndex", JSON.stringify(new_value))
                            }
                        })
    
                        const lipstickNext = $(".lipstick-next");
                        lipstickNext.click(() => {
                            const old_value = recentLipstick.val();
    
                            if (old_value == 9) {
                                new_value = -1
                                recentLipstick.attr("value", new_value)
    
                                //post
                                $.post("http://hpp_barbershop/changeLipStickIndex", JSON.stringify(new_value))
                            } else {
                                new_value = Number(old_value) + 1;
                                recentLipstick.attr("value", new_value)
    
                                //posts
                                $.post("http://hpp_barbershop/changeLipStickIndex", JSON.stringify(new_value))
                            }
                        })
    
                        }
                    }
                    
                } 
            }
        }

    } else {
        container.hide();

        const FacialHair = $(".recent-facialhair");
        const hairValue = $(".recent-hair");
        const recentLipstick = $(".recent-lipstick");
        const recentBlush = $(".recent-blush");

        FacialHair.attr("value", 0);
        hairValue.attr("value", 0);
        recentLipstick.attr("value", 0);
        recentBlush.attr("value", 0);
    }
})

const closeButton = $(".close-barbershop-button");
closeButton.click(() => {
    $.post("http://hpp_barbershop/closeMenu")
})

