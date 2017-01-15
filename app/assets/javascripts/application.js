//= require jquery
//= require bootstrap
//= require feedcast-player
//= require_tree .

try{
var pageItems = document.querySelectorAll('.pagination li.page-item'), active;
for(var i in pageItems){
  if(pageItems[i].className.indexOf('active') !== -1){
    active = i;
    break;
  }
}
pageItems[( active - 1 )].className += " show";
} catch(e){}
