// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require turbolinks
//= require_tree .
function shop_list_tbl_heigth_fix() { return 213;}
function cust_item_tbl_heigth_fix() { return 374;}

$(window).load(function() {
    var h = $(window).height();
    
    $('#shop_list_tbl').css({'height': h - shop_list_tbl_heigth_fix()});
    $('#cust_item_tbl').css({'height': h - cust_item_tbl_heigth_fix()});
});

$(window).resize(function() {
	var h = $(window).height();
    
    $('#shop_list_tbl').css({'height': h - 203});
    $('#cust_item_tbl').css({'height': h - 335});
});
