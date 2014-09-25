angular.module("ngDraggable",[]).directive("ngDrag",["$rootScope","$parse",function(t,e){return{restrict:"A",link:function(n,o,a){n.value=a.ngDrag;var r,i,c,u,l,f="ontouchstart"in document.documentElement,g="touchstart mousedown",s="touchmove mousemove",d="touchend mouseup",v=$(document),p=$(window),m=null,h=!1,b=null,D=e(a.ngDragSuccess)||null,x=function(){o.attr("draggable","false"),y(!0)},y=function(t){t&&(n.$on("$destroy",w),a.$observe("ngDrag",C),n.$watch(a.ngDragData,k),o.on(g,E),f||o.on("mousedown",function(){return!1}))},w=function(){y(!1)},k=function(t){m=t},C=function(t){h=n.$eval(t)},E=function(t){h&&(f?(X(),b=setTimeout(function(){X(),Y(t)},100),v.on(s,X),v.on(d,X)):Y(t))},X=function(){clearTimeout(b),v.off(s,X),v.off(d,X)},Y=function(e){h&&(e.preventDefault(),r=o.offset(),o.centerX=o.width()/2,o.centerY=o.height()/2,o.addClass("dragging"),i=e.pageX||e.originalEvent.touches[0].pageX,c=e.pageY||e.originalEvent.touches[0].pageY,u=i-o.centerX-p.scrollLeft(),l=c-o.centerY-p.scrollTop(),v.on(s,P),v.on(d,z),t.$broadcast("draggable:start",{x:i,y:c,tx:u,ty:l,element:o,data:m}))},P=function(e){h&&(e.preventDefault(),i=e.pageX||e.originalEvent.touches[0].pageX,c=e.pageY||e.originalEvent.touches[0].pageY,u=i-o.centerX-p.scrollLeft(),l=c-o.centerY-p.scrollTop(),S(u,l),t.$broadcast("draggable:move",{x:i,y:c,tx:u,ty:l,element:o,data:m}))},z=function(e){h&&(e.preventDefault(),t.$broadcast("draggable:end",{x:i,y:c,tx:u,ty:l,element:o,data:m,callback:A}),o.removeClass("dragging"),T(),v.off(s,P),v.off(d,z))},A=function(t){D&&n.$apply(function(){D(n,{$data:m,$event:t})})},T=function(){o.css({left:"",top:"",position:"","z-index":""})},S=function(t,e){o.css({left:t,top:e,position:"fixed","z-index":99999})};x()}}}]).directive("ngDrop",["$parse","$timeout",function(t,e){return{restrict:"A",link:function(n,o,a){n.value=a.ngDrop;var r=!1,i=t(a.ngDropSuccess),c=function(){u(!0)},u=function(t){t&&(a.$observe("ngDrop",f),n.$on("$destroy",l),n.$on("draggable:start",g),n.$on("draggable:move",s),n.$on("draggable:end",d))},l=function(){u(!1)},f=function(t){r=n.$eval(t)},g=function(t,e){r&&v(e.x,e.y,e.element)},s=function(t,e){r&&v(e.x,e.y,e.element)},d=function(t,o){r&&(v(o.x,o.y,o.element)&&(o.callback&&o.callback(t),e(function(){i(n,{$data:o.data,$event:t})})),p(!1,o.element))},v=function(t,e,n){var o=m(t,e);return p(o,n),o},p=function(t,e){t?(o.addClass("drag-enter"),e.addClass("drag-over")):(o.removeClass("drag-enter"),e.removeClass("drag-over"))},m=function(t,e){var n=o.offset();return n.right=n.left+o.outerWidth(),n.bottom=n.top+o.outerHeight(),t>=n.left&&t<=n.right&&e<=n.bottom&&e>=n.top};c()}}}]).directive("ngDragClone",["$parse","$timeout",function(){return{restrict:"A",link:function(t,e){var n;t.clonedData={};var o=function(){n=$(e.find("img")),e.attr("draggable","false"),n.attr("draggable","false"),l(),a(!0)},a=function(e){e&&(t.$on("draggable:start",i),t.$on("draggable:move",c),t.$on("draggable:end",u),r())},r=function(){n.off("mousedown touchstart touchmove touchend touchcancel",g),n.on("mousedown touchstart touchmove touchend touchcancel",g)},i=function(n,o){t.$apply(function(){t.clonedData=o.data}),e.css("width",o.element.height()),e.css("height",o.element.height()),f(o.tx,o.ty)},c=function(t,e){f(e.tx,e.ty)},u=function(){l()},l=function(){e.css({left:0,top:0,position:"fixed","z-index":-1,visibility:"hidden"})},f=function(t,n){e.css({left:t,top:n,position:"fixed","z-index":99999,visibility:"visible"})},g=function(t){var e=t.originalEvent;return e.preventDefault&&e.preventDefault(),e.stopPropagation&&e.stopPropagation(),e.cancelBubble=!0,e.returnValue=!1,!1};o()}}}]).directive("ngPreventDrag",["$parse","$timeout",function(){return{restrict:"A",link:function(t,e){var n=function(){e.attr("draggable","false"),o(!0)},o=function(t){t&&e.on("mousedown touchstart touchmove touchend touchcancel",a)},a=function(t){var e=t.originalEvent;return e.preventDefault&&e.preventDefault(),e.stopPropagation&&e.stopPropagation(),e.cancelBubble=!0,e.returnValue=!1,!1};n()}}}]);