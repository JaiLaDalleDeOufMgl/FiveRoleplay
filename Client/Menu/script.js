$(init);

function init(){
    $('[data-type="window"]').hide(0);
}

Events.Subscribe("open", function() {
    $('[data-type="window"]').show(0);
    $('[data-type="window"]').each(function(k) {
        let elm = $(this);
        elm.addClass("window");
        this.id = "w"+k;
    });
    $('.players ul li').click((e) => {
        $('.players ul li.selected').removeClass("selected");
        $(e.target).addClass("selected");
    })
    $('.cattegorys li').click((e) => {
        $('.cattegorys li.selected').removeClass("selected");
        $(e.target).addClass("selected");
    })
});

Events.Subscribe("close", function() {
    $('[data-type="window"]').hide(0);
});