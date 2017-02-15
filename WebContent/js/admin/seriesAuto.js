/**
 * 
 */
$(function(){
	 //系列行显示事件
    $("#sourceInforForm .mc").click(function() {
		if ($("#sourceInforForm .mcControl").val() == '1') {
			$("#sourceInforForm .seriesname").parents("tr").hide();
			$("#sourceInforForm .seriesname").attr("name",null);
		} else {
			$("#sourceInforForm .seriesname").parents("tr").show();
			$("#sourceInforForm .seriesname").attr("name","seriesname");

		}
	})
})
 /*自动填充*/
 //当输入框失去焦点时隐藏自动提示框
 $(".seriesname").blur(function(){
 	$(".autoComplate").hide();
 	$(".autoComplate a.active").removeClass("active");
 })
 //系列自动搜索
 $(".seriesname").keyup(function(event){
 	if(event.which==40){
 		var aTags = $(".autoComplate a");
 		$(".autoComplate a").removeClass("active");
 		var aLength = $(".autoComplate a").length;
 		if(aLength<6&&currentCursorRow==aLength-1||currentCursorRow==5){
 			currentCursorRow=-1;
 		}
 		$(aTags[++currentCursorRow]).addClass("active")
 	}else if(event.which==38){
 		var aTags = $(".autoComplate a");
 		$(".autoComplate a").removeClass("active");
 		var aLength = $(".autoComplate a").length;
 		if(currentCursorRow<=0){
 			if(aLength<6)currentCursorRow=aLength;
 			else currentCursorRow=6;
 		}
 		$(aTags[--currentCursorRow]).addClass("active")
 	}else if(event.keyCode==13&&$(".autoComplate a").length>0){
 		var currentA = $(".autoComplate a.active");
 		if(currentA.length<1){	//如果此时没有选中项则默认选则第一项
 			currentA=$(".autoComplate a:first");
 		}
 		$(".seriesname").val(currentA[0].innerHTML);
 		//addMember(currentA.attr("data-text"),value);	//添加成员
 		$(".autoComplate").hide();	//隐藏自动提示
 		$(".autoComplate a.active").removeClass("active");
 		$(this).attr("source-data","");
 		//判断是搜索系列名称还是系列和资源名称
		if(!$(this).hasClass("sourcename")){
	 		fillAutoCategory(currentA[0].innerHTML,$(currentA[0]).attr("category"));
	 		$("textarea[name=decription]").val($(currentA[0]).attr("decription"))
		}else{
			$(".seriesname").val(currentA[0].innerHTML.toString().substr(currentA[0].innerHTML.toString().indexOf("：")+1));
			$("#source_id").val($(currentA[0]).attr("id"));
		}
 		return false;
 	}else{
 		if(this.value.trim()==''){
 			$(".autoComplate a").remove();
 			$(".autoComplate").hide();
 			$(".autoComplate a.active").removeClass("active");
 		}else if(this.value.trim()!=$(this).attr("source-data")){
 			currentCursorRow=-1;
 			//判断是搜索系列名称还是系列和资源名称
 			if($(this).hasClass("sourcename")){
 				autoComplate2(this);
 			}else
 				autoComplate(this)
 		}
 		$(this).attr("source-data",this.value.trim());
 	}
 })
 /*自动填充*/
 //自动完成
var currentCursorRow=-1;
//系列名请求
function autoComplate(el){
	$.post("json/findSeries","keyword="+el.value.trim(),function(data) {
		$(".autoComplate a").remove();
		$(".autoComplate").show();
		$(".searcRresult").html(data.length);
			$(".autoComplate").css("width",$("#sourceInforForm .seriesname")[0].offsetWidth);
			for(var i=0;i<8&&i<data.length;i++){
				fillAutoComplateData(data[i]);
			}
			$(".autoComplate a").unbind();
			$(".autoComplate a").mouseover(function(){
				$(".autoComplate a").removeClass("active");
				$(this).addClass("active");
				currentCursorRow = $(".autoComplate a").index(this);//获取当前下标
			})
			$(".autoComplate a").mousedown(function(){
				el.value=this.innerHTML;
				fillAutoCategory(this.innerHTML,$(this).attr("category"));
				$("textarea[name=decription]").val($(this).attr("decription"));
			})
			//sysnchronized = false;
		},"json"
	)
}
function autoComplate2(el){
	$.post("json/findSeriesAndName","keyword="+el.value.trim(),function(data) {
		$(".autoComplate a").remove();
		$(".autoComplate").show();
		$(".searcRresult").html(data.length);
			$(".autoComplate").css("width",$("#sourceInforForm .seriesname")[0].offsetWidth);
			for(var i=0;i<8&&i<data.length;i++){
				fillAutoComplateData2(data[i]);
			}
			$(".autoComplate a").unbind();
			$(".autoComplate a").mouseover(function(){
				$(".autoComplate a").removeClass("active");
				$(this).addClass("active");
				currentCursorRow = $(".autoComplate a").index(this);//获取当前下标
			})
			$(".autoComplate a").mousedown(function(){
				el.value=this.innerHTML.substr(this.innerHTML.indexOf("：")+1);
				$("#source_id").val($(this).attr("id"));
			})
			//sysnchronized = false;
		},"json"
	)
}
//填充自动完成数据
function fillAutoComplateData(data){
	$(".autoComplate p").before($("<a class='list-group-item' category='"+data.category+"' id='"+data.id+"' decription='"+data.decription+"'>"+data.seriesname+"</a>"));
}
function fillAutoComplateData2(data){
	$(".autoComplate p").before($("<a class='list-group-item' name='"+data.name+"' id='"+data.id+"' seriesname='"+data.seriesname+"'>"+(data.seriesname==data.id?"资源名称："+data.name:"系列名称："+data.seriesname)+"</a>"));
}