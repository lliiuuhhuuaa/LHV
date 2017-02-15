$(function() {
	//退出监听
	$("#logout").click(function() {
		var bool = confirm("确定要退出当前用户吗？");
		if (bool) {
			window.location.href = "adminuserLogout";
			return false;
		} else {
			return false;
		}
	})
	// 设置菜单点击监听
	$(".liMenu").bind("click", function() {
		//headerText($(this).attr("class"))
	})
	// 显示设置--每页显示条数更改监听
	$("#rowNum").bind("change", function() {
		saveSet();
	})
	$(".sidebar-menu .liMenu").bind("click",loaderAnimation);
	//将菜单放入到map，用于菜单搜索
	var menu = new Map();
	var menuSpans = $(".liMenu");
	for(var i=0;i<menuSpans.length;i++){
		menu.put($(menuSpans[i]).find("span").html(), menuSpans[i])
	}
	$("#menuSearch").bind("keyup",function(){
		if(this.value==''){
			$(".search-sidebar-menu").html("");
			$(".sidebar-menu").show();
		}else{
			$(".search-sidebar-menu").html("");
			var likeArray = menu.likeKey(this.value);
			for(var i=0;i<likeArray.length;i++){
				$(".search-sidebar-menu").append("<li style='margin:10px 0;'>"+likeArray[i].innerHTML+"</li>");
			}
			$(".sidebar-menu").hide();
		}
	})
	$(".paidOrderForm").bind("click",function(){
		$(".newOrderFormNum").html(0);
		$(".newOrderForm").hide();
		$(".newOrderFormBar").css("width","0%");
	})
	$(".newOrderFormButton").click(function(){
		$(".paidOrderForm").trigger("click");
	})
	$(".adminWinClose").click(function(){
		$(this).parents(".chatWinBox").hide();
	})
	window.onresize=function(){
		reinitIframeEND();
	}
})
function removeLoader() {
    $(".loaderMenuBox").remove();
}
function reinitIframeEND() {
	$("#iframepage").css("height","100%");
	removeLoader();
}
var loaderAnimation=function (){
	$(".loaderMenuBox").remove();
	$(".content-wrapper").append($('<div class="loaderMenuBox"><div class="loaderMenu"><div class="loader-inner pacman"><div></div><div></div><div></div><div></div><div></div></div></div></div>'))
}
function showWarning(isPass, str) {// 显示提示框
	if (isPass) {
		$("#warning").removeClass("alert-warning");
		$("#warning").addClass("alert-success");
		$("#warning i").removeClass("fa-warning");
		$("#warning i").addClass("fa-check");
	} else {
		$("#warning").removeClass("alert-success");
		$("#warning").addClass("alert-warning");
		$("#warning i").removeClass("fa-check");
		$("#warning i").addClass("fa-warning");
	}
	$("#warning-text").html(str);
	$("#warning").slideDown(500);
	var closeTimer = window.setTimeout(function() {
		$("#warning").slideUp(500);
	}, 5000)
}