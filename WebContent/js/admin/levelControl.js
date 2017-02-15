$(function(){
	$('[data-toggle="tooltip"]').tooltip();
	$(".level-control").mouseover(function(){
		new DragMove(this);
	})
	$(".level-control").on("hide.bs.tooltip", function(){
		if(tooltipCheck){
			return false;
		}
	})
	$(".level-control").mousedown(function(){
		tooltipCheck=true;
	})
	$(".level-control").mouseup(function(){
	})
})

var tooltipCheck=false;
function moveControl(ele){		//移动元素函数
	new DragMove(ele);
}
var DragMove = function(el){
    var drag = function(e) {
        e = e || window.event;
        el.style.cursor = "pointer";
        el.style.left = e.clientX - el.offset_x + "px";
        if(el.offsetLeft<=0){
        	el.style.left=0;
        }else if(el.offsetLeft>=el.parentNode.offsetWidth-el.offsetWidth){
        	el.style.left =el.parentNode.offsetWidth-el.offsetWidth+"px";
        }
        $(el).attr("data-original-title", el.offsetLeft)
        var tooltip = $(el).siblings(".tooltip").get(0);
        if(tooltip!=null)
        if(el.offsetLeft<10){
        	tooltip.style.left=el.offsetLeft-1+"px";
        }else if(el.offsetLeft<100){
        	tooltip.style.left=el.offsetLeft-5+"px";
        }else{
        	tooltip.style.left=el.offsetLeft-9+"px";
        }
        $(".tooltip-inner").html(el.offsetLeft);
        try{
        setFontSize(el.offsetLeft);
        }catch(e){}
    }
    var dragend = function(){
    	tooltipCheck=false;
		$(".level-control").tooltip("hide");
        document.onmouseup = null;
        document.onmousemove = null;
    }
    var dragstart = function(e){
        e = e || window.event;
        el.offset_x = e.clientX - el.offsetLeft;
        var elParent_left = el.parentNode.offsetLeft;
        document.onmouseup = dragend;
        document.onmousemove = drag;
        return false;
    }
    el.onmousedown = dragstart;
}