$('a.popup').live('click', function(e) {
    e.preventDefault();
    var result = window.open($(this).attr('href'), 'new window', 'height=480,width=640,status=no');
});
