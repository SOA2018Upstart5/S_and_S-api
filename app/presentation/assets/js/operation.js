//make texts tabel can link to each text of informaiton 
$(document).ready(function($) {
    $(".table-row").click(function() {
        window.document.location = $(this).data("href");
    });
});

//make an control to choose pic

$(".left_right").click(function(){
    
    var dir=this.id;
    $('#keyword-url').attr("herf",each_keyword.keyword_url(0))
});

