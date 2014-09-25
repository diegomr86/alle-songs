var ALERTS_CONTAINER_ID,Alert;ALERTS_CONTAINER_ID="pa-page-alerts-box",Alert=function(){return this},Alert.DEFAULTS={type:"warning",close_btn:!0,classes:!1,namespace:"pa_page_alerts",animate:!0,auto_close:!1,container:ALERTS_CONTAINER_ID},Alert.TYPES_HASH={warning:"",danger:"alert-danger",success:"alert-success",info:"alert-info"},Alert.prototype.init=function(){var t;return t=this,$("#main-wrapper").on("click.pa.alerts",".pa_page_alerts .close",function(){return t.close($(this).parents(".alert")),!1})},Alert.prototype.add=function(t,e){var a,n,r,i,o,l;return e=$.extend({},Alert.DEFAULTS,e||{}),a=$('<div class="alert alert-page '+e.namespace+" "+Alert.TYPES_HASH[e.type]+'" />').html(t),e.classes&&a.addClass(e.classes),e.close_btn&&a.prepend($('<button type="button" class="close" />').html("&times;")),e.animate&&a.attr("data-animate","true"),r=$("#"+e.container),r.length||(r=$('<div id="'+e.container+'" />').prependTo($("#content-wrapper"))),n=$("#"+e.container+" ."+e.namespace),i=a.css({visibility:"hidden",position:"absolute",width:"100%"}).appendTo("body").outerHeight(),l=a.css("padding-top"),o=a.css("padding-bottom"),e.animate&&a.attr("style","").css({overflow:"hidden",height:0,"padding-top":0,"padding-bottom":0}),n.length?n.last().after(a):r.append(a),e.animate?a.animate({height:i,"padding-top":l,"padding-bottom":o},500,function(t){return function(){return a.attr("style",""),e.auto_close?$.data(a,"timer",setTimeout(function(){return t.close(a)},1e3*e.auto_close)):void 0}}(this)):a.attr("style","")},Alert.prototype.close=function(t){return"true"===t.attr("data-animate")?t.animate({height:0,"padding-top":0,"padding-bottom":0},500,function(){return $.data(t,"timer")&&clearTimeout($.data(t,"timer")),t.remove()}):($.data(t,"timer")&&clearTimeout($.data(t,"timer")),t.remove())},Alert.prototype.clear=function(t,e){var a,n;return null==t&&(t=!0),null==e&&(e="pa_page_alerts"),a=$("#"+ALERTS_CONTAINER_ID+" ."+e),a.length?(n=this,t?a.each(function(){return n.close($(this))}):a.remove()):void 0},Alert.prototype.clearAll=function(t){var e;return null==t&&(t=!0),t?(e=this,$("#"+ALERTS_CONTAINER_ID+" .alert").each(function(){return e.close($(this))})):$("#"+ALERTS_CONTAINER_ID).remove()},Alert.prototype.getContainerId=function(){return ALERTS_CONTAINER_ID},Alert.Constructor=Alert,PixelAdmin.addInitializer(function(){return PixelAdmin.initPlugin("alerts",new Alert)});