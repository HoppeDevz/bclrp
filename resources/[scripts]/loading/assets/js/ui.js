$("#bgcolor").fadeOut(1000);
setTimeout(function() {
  $(".logo").fadeIn(1000);
}, 500);

var play = true;
var audio_song = document.getElementById("audio-song");
$(document).ready(function() {
  audio_song.volume = 0.7;
});
document.addEventListener ('keypress', (event) => {
  const keyName = event.key;
  if (keyName == "p") {
    if (!play) {
      $("#text-song span").html("pausar");
      audio_song.play();
    } else {
      $("#text-song span").html("tocar");
      audio_song.pause();
    }

    play = !play;
  } else if (keyName == "w") {
    if (audio_song.volume == 1) {
      return false;
    } else {
      audio_song.volume += 0.04
    }
  } else if (keyName == "s") {
    if (audio_song.volume == 0) {
      return false;
    } else {
      audio_song.volume -= 0.04
    }
  }
});

/*setInterval(changeLogos, 2000);
function changeLogos() {
  var logo = $(".logo");
  logo.fadeOut(500);
  if (logo.data("logo") == "br") {
    setTimeout(function() {
        logo.html("<img src='assets/img/logo.png' style='max-width: 200px'; />").fadeIn(500).data('logo', 'default');
    }, 500);
  } else {
    setTimeout(function() {
        logo.html("<img src='assets/img/logo-br.png' style='max-width: 200px'; />").fadeIn(500).data('logo', 'br');
    }, 500);
  }
}*/

var tips = [
  'Fique atento as safezones.',
  'Lembre-se que você será julgado pelo seu bom senso.',
  'Lembre-se que você será julgado pelo seu bom senso.',
  'Lembre-se que você será julgado pelo seu bom senso.',
  'Chamados fora do padrão serão ignorados.',
  'Não utilize informações obtidas no Discord para se beneficiar na cidade.',
  'Leia as regras em nosso Discord e respeite os outros cidadãos.',
  'Não toleramos qualquer tipo de preconceito!',
  'Não jogue tiltado. Isso pode te trazer mais dores de cabeça.',
  'Não se esqueça que todos estão aqui para se divertir.',
  'Em hipótese alguma saia do seu personagem.',
  'Utilize o /help caso precise de ajuda imediata e aguarde algum staff responder.'
];

document.addEventListener('DOMContentLoaded', function() {
  var typed = new Typed('.tip-text', {
    strings: tips,
    typeSpeed: 20,
    backSpeed: 5,
    cursorChar: '',
    backDelay: 3000,
    startDelay: 3000,
    shuffle: true,
    smartBackspace: true,
    loop: true
  });
});

particlesJS("particles-js", {
  "particles": {
    "number": {
      "value": 60,
      "density": {
        "enable": true,
        "value_area": 1000
      }
    },
    "color": {
      "value": "#ffffff"
    },
    "shape": {
      "type": "circle",
      "stroke": {
        "width": 0,
        "color": "#000000"
      },
      "polygon": {
        "nb_sides": 5
      },
      "image": {
        "src": "img/github.svg",
        "width": 100,
        "height": 100
      }
    },
    "opacity": {
      "value": 0.5,
      "random": false,
      "anim": {
        "enable": false,
        "speed": 1,
        "opacity_min": 0.1,
        "sync": false
      }
    },
    "size": {
      "value": 3,
      "random": true,
      "anim": {
        "enable": false,
        "speed": 40,
        "size_min": 0.1,
        "sync": false
      }
    },
    "line_linked": {
      "enable": true,
      "distance": 150,
      "color": "#ffffff",
      "opacity": 0.4,
      "width": 1
    },
    "move": {
      "enable": true,
      "speed": 10,
      "direction": "none",
      "random": false,
      "straight": false,
      "out_mode": "out",
      "bounce": false,
      "attract": {
          "enable": false,
          "rotateX": 600,
          "rotateY": 1200
      }
    }
  },
  "interactivity": {
    "detect_on": "canvas",
    "events": {
      "onhover": {
        "enable": true,
        "mode": "repulse"
      },
      "onclick": {
        "enable": true,
        "mode": "push"
      },
      "resize": true
    },
    "modes": {
      "grab": {
        "distance": 400,
        "line_linked": {
          "opacity": 1
        }
      },
      "bubble": {
        "distance": 400,
        "size": 40,
        "duration": 2,
        "opacity": 8,
        "speed": 3
      },
      "repulse": {
        "distance": 200,
        "duration": 0.4
      },
      "push": {
        "particles_nb": 4
      },
      "remove": {
        "particles_nb": 2
      }
    }
  },
  "retina_detect": true
});