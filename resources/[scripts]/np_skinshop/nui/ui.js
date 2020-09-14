$(function(){
    
    $("#menu").hide();
    window.model = "m";

    window.addEventListener('message', function(event){
        var item = event.data;

        if(item.showMenu == true){
            showMenu(true);
        } else {
            showMenu(false);
        }

        if (item.masc !== true){
            window.model = "f";
        }

    });

    menu(); 

    // Fechar NUI no Esc
    document.onkeyup = function(data){
        if(data.which == 27){
            $.post('http://np_skinshop/exit');
        }
        if(data.which == 65){ //a
            $.post('http://np_skinshop/rotate', JSON.stringify("left"));
        }
        if(data.which == 68) { //d
            $.post('http://np_skinshop/rotate', JSON.stringify("right"));
        }
        if(data.which == 39) { // right
            //alert("Teste")
            $.post('http://np_skinshop/color', JSON.stringify("right"));
        }
        if(data.which == 37) { // left
            //alert("Teste")
            $.post('http://np_skinshop/color', JSON.stringify("left"));
        }
    }

});

function showMenu(bool){
    if (bool) {
        $("div").each(function(i,obj){
            var element = $(this);

            if (element.attr("data-parent")){
                element.hide();
            } else {
                element.fadeIn(500);
            }
        })
    }
    else {
        $("#menu").fadeOut(500);
    }
}

function menu(){
    $(".classes").each(function(i, ojb){
        var menu = $(this).data("sub");
        var element = $("#"+menu);
        
        $(this).click(function(){       
            if (menu != "mascara" && menu != "mochila"){
                if (typeof model !== 'undefined') {
                    var element = $("#"+menu+model);
                } else {
                    var element = $("#"+menu+"m");
                }
            } else {
                var element = $("#"+menu);                    
            }

            $(".item").each(function(i, ojb){
                $(this).hide()
            });
            
            element.fadeIn(500);
        });
    });


    $(".botao").each(function(i, ojb){
        $(this).click(function(){
            if($(this).parent().attr("id") == "mascara"){
                var dados = 1;
            }
            if($(this).parent().attr("id") == "maosf" || $(this).parent().attr("id") == "maosm"){
                var dados = 3;
            }
            if($(this).parent().attr("id") == "calcaf" || $(this).parent().attr("id") == "calcam"){
                var dados = 4;
            }
            if($(this).parent().attr("id") == "mochila"){
                var dados = 5;
            }
            if($(this).parent().attr("id") == "sapatof" || $(this).parent().attr("id") == "sapatom"){
                var dados = 6;
            }
            if($(this).parent().attr("id") == "gravataf" || $(this).parent().attr("id") == "gravatam"){
                var dados = 7;
            }
            if($(this).parent().attr("id") == "blusaf" || $(this).parent().attr("id") == "blusam"){
                var dados = 8;
            }
            if($(this).parent().attr("id") == "coletef" || $(this).parent().attr("id") == "coletem"){
                var dados = 9;
            }
            if($(this).parent().attr("id") == "jaquetaf" || $(this).parent().attr("id") == "jaquetam"){
                var dados = 11;
            }
            if($(this).parent().attr("id") == "chapeuf" || $(this).parent().attr("id") == "chapeum"){
                var dados = 100;
            }
            if($(this).parent().attr("id") == "oculosf" || $(this).parent().attr("id") == "oculosm"){
                var dados = 101;
            }
            if($(this).parent().attr("id") == "orelhaf" || $(this).parent().attr("id") == "orelham"){
                var dados = 102;
            }


            var tipo = $(this).data("action");
            $.post("http://np_skinshop/update", JSON.stringify([dados, tipo]));
        })
    })
}