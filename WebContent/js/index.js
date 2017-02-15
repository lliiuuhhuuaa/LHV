/**
 * Created by 甜橙六画 on 2016/12/4.
 */
$(function(){
    $(".marketingMenu ul li").bind("mouseover",function(){
        $(".marketingMenu ul li").removeClass("checked");
        $(this).addClass("checked");
        switch_img($(this).attr("data"));
        index = $(this).index();
        $("nav.rootMenu ul li a").css("color",$(this).attr("theme"));
        $(".color_span").css("color",$(this).attr("theme"));

    })
    specailPic();
    setInterval(function(){
    	specailPic();
    },10000);
    /* 实现延迟加载图片 */
    showPic();
	var mousewheel = document.all ? "mousewheel" : "DOMMouseScroll";
	$(document).bind("mousewheel", function(event, delta) {
		showPic();
	})
	/* 实现延迟加载图片 */
	 $(document).scroll(function(event){
		 showPic();
	});
})
var index=9;//滚动展示下标
var moreTimer;
var i=2;
//展示大图
function specailPic(){
	index = index>=9?0:++index;
	switch_img($(".marketingMenu ul li:eq("+index+")").attr("data"));
    $(".marketingMenu ul li").removeClass("checked");
    $(".marketingMenu ul li:eq("+index+")").addClass("checked");
    $("nav.rootMenu ul li a").css("color",$(".marketingMenu ul li:eq("+index+")").attr("theme"));
    $(".color_span").css("color",$(".marketingMenu ul li:eq("+index+")").attr("theme"));
}
//延迟显示图片
function showPic(){
	var a = $(".teleplay_div").offset().top - $(document).scrollTop() - $(window).height();
	var b = $(".teleplay_div").height() + $(window).height();
	if(!(a>0 || a < -b)){
		var tele = $(".teleplay_div img");
		for(var i=0;i<tele.length;i++){
			if($(tele[i]).attr("src")==undefined){
				$(tele[i]).attr("src",$(tele[i]).attr("data-src"));
				$(tele[i]).attr("data-src",null);
			}
		}
	}
	var a = $(".cartoon_div").offset().top - $(document).scrollTop() - $(window).height();
	var b = $(".cartoon_div").height() + $(window).height();
	if(!(a>0 || a < -b)){
		var tele = $(".cartoon_div img");
		for(var i=0;i<tele.length;i++){
			if($(tele[i]).attr("src")==undefined){
				$(tele[i]).attr("src",$(tele[i]).attr("data-src"));
				$(tele[i]).attr("data-src",null);
			}
		}
	}
}
function switch_img(url){
    i==1?i++:i--;
    $(".big_img_div"+i).removeClass("fadeOut").addClass("fadeIn").css("z-index",10);
    $(".big_img_div"+i).css("background-image","url("+url+")");
    $(".big_img_div"+(i==1?2:1)).removeClass("fadeIn").addClass("fadeOut").css("z-index",1);
}
