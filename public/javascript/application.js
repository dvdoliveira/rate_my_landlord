$(document).ready(function() {

  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
});

$('#mapModal').on('show.bs.modal', function(){
    $.get("remote.htm", function(data){
        $('#mapModal').find('.modal-content').html(data);
    })
})
