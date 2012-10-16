$(function(){
  var form = $('.card-histories-search-form');

  form.find('label').remove();
  form.find('input[type="submit"]').remove();

  form.find('select').change(function(event){
    $(this).parent().submit();
  });
})