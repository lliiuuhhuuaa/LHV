/**
 * Created by 甜橙六画 on 2016/12/7.
 */
$(function () {
    /*播放列表*/
    $(".menuListBox>p").click(function(){
       if($(this).attr("class")=='barrage'){
            $(".playListUl").hide();
            $(".barrageUl").show();
        }else if($(this).attr("class")=='playList'){
           $(".barrageUl").hide();
           $(".playListUl").show();
       }
        $(".menuListBox>p").removeClass("active");
        $(this).addClass("active");
    })
    $(".playListUl>li").click(function(){
        $(".playListUl>li").removeClass("active");
        $(this).addClass("active");
    })
    /*播放列表*/
    /*播放暂停动作*/
    var isFirst=true;
    $("#danmup").click(function(){
        if(isFirst){
            isFirst=false;return;
        }
        palyOrPause();
    });
    $("#danmup").focus(function(){
        $(window).bind("keyup",function(event){
            if (event.keyCode == 32) {
                palyOrPause();
            }
        });
    });
    $("#danmup").blur(function(){
        $(window).unbind("keyup");
    });
    $(".vjs-control-bar").click(function(e){
        e = e || window.event;
        e.stopPropagation();
    });
    $(".tooltip71452").click(function(e){
        e = e || window.event;
        e.stopPropagation();
    });
    /*播放暂停动作*/
    bindClick();
    /*收藏*/
    $(".collect_button").bind("click",function(){
    	var _this = this;
    	if(!isLogin){
    		$("#loginModal").modal('show');
    	}else{
    		$.post("json/saveCollect/"+current_source_id,null,function(data){
    			if(!(data instanceof Object))data = eval("("+data+")");
    			if(data.result){
    				tooltipUtil(_this,"收藏成功");
    				requestCollect();
    				return;
    			}else{
    				tooltipUtil(_this,"收藏失败:"+data.cause);
    			}
    		})
    	}
    })
    /*收藏*/
    /*评分*/
    $(".score").bind("mouseover",function(){
    	if($(".score_span").hasClass("active")){
    		layer.tips('您已经点评了', '.score_span');return;
    	}
    	var scores = $(".score");
    	for(var i=0;i<$(this).index()+1;i++){
	    	$(scores[i]).removeClass("glyphicon-star-empty");
	    	$(scores[i]).addClass("glyphicon-star");
	    	$(scores[i]).css("color","#FF920B");
    	}
    	for(var i=4;i>$(this).index();i--){
    		$(scores[i]).addClass("glyphicon-star-empty");
    		$(scores[i]).removeClass("glyphicon-star");
    		$(scores[i]).css("color","#CCC");
    	}
    })
    $(".score").bind("click",function(){
    	var scores = $(".score");
    	for(var i=0;i<$(this).index()+1;i++){
	    	$(scores[i]).removeClass("glyphicon-star-empty");
	    	$(scores[i]).addClass("glyphicon-star");
	    	$(scores[i]).css("color","#FF920B");
    	}
    	for(var i=4;i>$(this).index();i--){
    		$(scores[i]).addClass("glyphicon-star-empty");
    		$(scores[i]).removeClass("glyphicon-star");
    		$(scores[i]).css("color","#CCC");
    	}
    	if(!$(".score_span").hasClass("active"))
	    	$.post("json/score/"+current_source_id,"index="+$(this).index(),function(data){
	    		if(!(data instanceof Object))data = eval("("+data+")");
	    		console.log(data)
	    		if(data.result){
	    			layer.tips('评分成功', '.score_span');
	    			$(".score_span").addClass("active");
	    		}else{
	    			layer.tips('评分失败', '.score_span');
	    		}
	    	})
	    else layer.tips('您已经点评了', '.score_span');
    });
    /*评分*/
    /*评论*/
    requestComment();
    $(".sendComment").click(function(){
    	var value = $(".comment_input").val();
    	if(value==''||value.trim()=='')return;
    	$.post("json/saveComment/"+current_source_id,"text="+value,function(data){
    		if(!(data instanceof Object))data = eval("("+data+")");
    		if(data.result){
    			$(".clear_comment").remove();
    			var $newComm = $($(".comment_box").html());
    	    	$newComm.find(".text-content").html(filter(value));
    	    	$newComm.find(".text-muted").html(new Date().Format("MM月dd日"));
    	    	$newComm.find(".praise").attr("time",data.time);
    	        $(".send_div").after($newComm);
    	        $(".comment_input").val("");
    	        bindClick();
    		}else{
    			layer.tips('发送评论失败', '.sendComment');
    		}
    	})
    })
    /*评论*/
    
});
//请求评论
function requestComment(){
	$(".send_div").after($('<div class="sk-spinner sk-spinner-three-bounce"><div class="sk-bounce1"></div><div class="sk-bounce2"></div><div class="sk-bounce3"></div></div>'))
	$.post("json/getComment/"+current_source_id,null,function(data){
		if(data!=null&&data!=''){
			$(".clear_comment").remove();
			if(!(data instanceof Object))data = eval("("+data+")");
			for(var d in data){
				console.log(data[d])
				var $newComm = $($(".comment_box").html());
		    	$newComm.find(".text-content").html(data[d].text);
		    	$newComm.find(".text-muted").html(new Date(data[d].time/1000).Format("MM月dd日"));
		    	$newComm.find(".praise").attr("time",data[d].time);
		    	$newComm.find(".praise").find("span").html(data[d].support);
		    	if(data[d].img_id!=null) $newComm.find("img").attr("src","source/img/avatar/"+data[d].img_id);
		    	else $newComm.find("img").attr("src","img/noPhoto.png");
		    	if(data[d].name!=null) $newComm.find(".send_comment_name").html(data[d].name);
		    	else $newComm.find(".name").html("游客");
		        $(".send_div").after($newComm);
			}
			bindClick();
		}else{
			$(".send_div").after($('<h4 class="clear_comment">还没有人对影片发表评论呢</h4>'));
		}
		$(".social-footer .sk-spinner").remove();
	})
}
function palyOrPause(){
    if ($("video")[0].paused) {
        $("video")[0].play();   //  播放
        $(".vjs-default-skin .vjs-big-play-button").hide();
    }else{
        $("video")[0].pause();  //  暂停
        $(".vjs-default-skin .vjs-big-play-button").show();
    }
}
function bindClick(){
    /*评论*/
    $(".praise").unbind();
    $(".praise").bind("click",function(){
    	var _this = this;
        if(!$(this).hasClass("active")){
            $.post("json/praise/"+current_source_id,"time="+$(this).attr("time"),function(data){
            	if(!(data instanceof Object))data = eval("("+data+")");
            	if(data.result){
            		 $(_this).addClass("active");
                     var i = $(_this).find("span")[0];
                     i.innerHTML = parseInt(i.innerHTML)+1;
            	}else{
            		layer.tips('点赞失败', '.praise');
            	}
            })
        }
    });
    /*评论*/
}
//日期时间原型增加格式化方法

Date.prototype.Format = function (formatStr) {
    var str = formatStr;
    var Week = ['日', '一', '二', '三', '四', '五', '六'];

    str = str.replace(/yyyy|YYYY/, this.getFullYear());
    str = str.replace(/yy|YY/, (this.getYear() % 100) > 9 ? (this.getYear() % 100).toString() : '0' + (this.getYear() % 100));
    var month = this.getMonth() + 1;
    str = str.replace(/MM/, month > 9 ? month.toString() : '0' + month);
    str = str.replace(/M/g, month);

    str = str.replace(/w|W/g, Week[this.getDay()]);

    str = str.replace(/dd|DD/, this.getDate() > 9 ? this.getDate().toString() : '0' + this.getDate());
    str = str.replace(/d|D/g, this.getDate());

    str = str.replace(/hh|HH/, this.getHours() > 9 ? this.getHours().toString() : '0' + this.getHours());
    str = str.replace(/h|H/g, this.getHours());
    str = str.replace(/mm/, this.getMinutes() > 9 ? this.getMinutes().toString() : '0' + this.getMinutes());
    str = str.replace(/m/g, this.getMinutes());

    str = str.replace(/ss|SS/, this.getSeconds() > 9 ? this.getSeconds().toString() : '0' + this.getSeconds());
    str = str.replace(/s|S/g, this.getSeconds());
    return str;
}