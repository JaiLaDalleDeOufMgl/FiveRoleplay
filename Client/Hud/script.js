Events.Subscribe("Open", function() {
    $("#ui").hide(500);
});
Events.Subscribe("Close", function() {
    $("#ui").show(500);
});
Events.Subscribe("Infos", function(firstname, lastname, job, grade, money, hunger, thirst, health) {
    $(".name").html(firstname + ' ' + lastname);
    $(".job").html(job + ' ' + grade);
    $(".money").html(money + "$");
    $('.pro-1').css('width', hunger + '%')
    $('.pro-2').css('width', thirst + '%')
    $('.pro-3').css('width', health + '%')
});

