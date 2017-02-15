/**
 * Created by 甜橙六画 on 2016/6/11.
 */
$(function(){
	$(".move").bind("mouseover",function(){
		move(this);
	})
})
function move(ele){		//移动元素函数
    new Drag(ele);
}
var Drag = function(el){
    var drag = function(e) {
        e = e || window.event;
        !+"\v1" ? document.selection.empty() : window.getSelection().removeAllRanges();
        el.style.left = e.clientX - el.offset_x + "px";
        el.style.top = e.clientY - el.offset_y + "px";
    }
    var dragend = function(){
        document.onmouseup = null;
        document.onmousemove = null;
    }
    var dragstart = function(e){
        e = e || window.event;
        el.offset_x = e.clientX - el.offsetLeft;
        el.offset_y = e.clientY - el.offsetTop;
        document.onmouseup = dragend;
        if( el.offset_y>(el.getBoundingClientRect().top-el.offsetTop)+30)return;//getBoundingClientRect().top获取当前元素离浏览器top
        document.onmousemove = drag;
        return false;
    }
    el.onmousedown = dragstart;
}
var dragSuccess=false;
var Drag1 = function(el){
    var init_x,init_y,clientH=document.documentElement.clientHeight,clientW=document.documentElement.clientWidth;
    var drag = function(e) {
        if(el.offsetLeft<=5){
            el.setAttribute("class","left");
            el.style.left=6+"px";
            init_x = 6;
            init_y = (clientH - el.offsetHeight) / 2;
            dragend();
            direction="left";
        }
        else if(el.offsetTop<=5){
           var winList =  document.getElementById("winList");
            winList.style.top=document.documentElement.clientHeight-winList.offsetHeight + "px";
            el.setAttribute("class","up");
            el.style.top=6+"px";
            init_y=6;
            init_x = (clientW - el.offsetWidth) / 2;
            dragend();
            direction="up";
        }else if((document.documentElement.clientHeight-el.offsetTop-el.offsetHeight)<=5){
            document.getElementById("winList").style.top="0px";
            el.setAttribute("class","down");
            el.style.top=clientH-el.offsetHeight-6+"px";
            init_y = clientH-el.offsetHeight-6;
            init_x = (clientW - el.offsetWidth) / 2;
            dragend();
            direction="down";
        }else if((document.documentElement.clientWidth-el.offsetLeft-el.offsetWidth)<=5){
            el.setAttribute("class","right");
            el.style.left=clientW-el.offsetWidth+"px";
            init_x=clientW-el.offsetWidth-6;
            init_y = (clientH - el.offsetHeight) / 2;
            dragend();
            direction="right";
        }
        else {
            e = e || window.event;
          /*  !+"\v1" ? document.selection.empty() : window.getSelection().removeAllRanges();*/
            el.style.left = e.clientX - el.offset_x + "px";
            el.style.top = e.clientY - el.offset_y + "px";
        }
    }
    var dragend = function(){
        document.onmouseup = null;
        document.onmousemove = null;
        el.style.left=init_x+"px";
        el.style.top =init_y+"px";
    }
    var dragstart = function(e){
        dragSuccess = true;
        init_x = el.offsetLeft;init_y = el.offsetTop;
        e = e || window.event;
        el.offset_x = e.clientX - el.offsetLeft;
        el.offset_y = e.clientY - el.offsetTop;
        document.onmouseup = dragend;
        //if(el.offset_y>30||el.offset_x>30)return;//getBoundingClientRect().top获取当前元素离浏览器top
        document.onmousemove = drag;
        return false;
    }
    el.onmousedown = dragstart;
}
function dirMove(ele){
    var e = e || window.event;
   /* if(e.clientY - ele.offsetTop<=30&& e.clientX-ele.offsetLeft<=30){
        ele.style.cursor="move";
    }else{
        ele.style.cursor="default";
    }*/
    new Drag1(ele);
}