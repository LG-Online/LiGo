/* Chevron-Rotation beim Öffnen eines Pop-Over-Fensters */
$(".pop_over_link").click(function(){
    $(this).find(".rotate-up").toggleClass("active"); 
});

/* Chevron-Rotation beim Ausklappen eines Unter-Menüs */
$(".chevron-link").click(function(){
    $(this).find(".rotate").toggleClass("active"); 
});

/* Ausklappen/Einklappen sämtlicher Untermenüs via Button */
$(".expand-collapse-button").click(function(){
    if ($(this).data("closedAll")) {
        $(".list-group").collapse("show");
        $(".rotate").addClass("active");
    }
    else {
        $(".list-group").collapse("hide");
        $(".rotate").removeClass("active");
    }
    $(this).data("closedAll",!$(this).data("closedAll"));
});
$(".expand-collapse-button").data("closedAll",true);