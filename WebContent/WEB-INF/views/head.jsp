<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>My JSP 'head.jsp' starting page</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
<link href="css/top.css" rel="stylesheet" type="text/css">
<link href="css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
<link href="css/animate.css" rel="stylesheet">
<link href="css/style.css?v=4.1.0" rel="stylesheet">
<script src="js/jquery/jquery.min.js" type="text/javascript"></script>
<script src="js/bootstrap.min.js" type="text/javascript"></script>
</head>
<style>
.more_li a {
	color: #999 !important;
}

.more_li {
	border-top: 1px solid #999;
}

.more_li:hover {
	background: none !important;
}

.autoComplate {
	background: #FFF;
	position: absolute;
	z-index: 10;
	top: 32px;
	width: 80%;
	display: none;
}

.autoComplate a {
	height: 40px;
	line-height: 20px;
	vertical-align: middle;
}

.autoComplate a:hover {
	/* background:#337AB7;
	color:#FFF; */
	cursor: pointer;
}

.autoComplate p {
	border: 1px solid #CCCCCC;
	height: 25px;
	line-height: 25px;
	text-align: right;
	font-size: 15px;
	padding: 0 10px;
	margin: 0;
}
/* 自动填充 */
.categoryList {
	position: absolute;
	right: -180px;
	top: 0;
	height: 100%;
	display: none;
}

#treeview li {
	padding-left: 2px;
	text-align: left;
}

.categoryList>.ibox-content {
	overflow: auto;
	height: 90%;
}

.categoryUl {
	height: 70px;
	color: #555;
	cursor: pointer;
}

.categoryUl li {
	background: rgba(0, 0, 0, 0.5);
	color: #FFF;
	width: 50px;
	border-radius: 5px;
	padding: 2px;
	margin: 2px;
	text-align: center;
	position: relative;
	float: left;
	overflow: hidden;
	height: 25px;
}

.categoryUl li i {
	position: absolute;
	right: 0;
	top: 0;
	font-size: 12px;
}

.categoryUl li i:hover {
	color: #F00;
}

.fileBox, .missionRecord {
	display: none;
}

.missionRecord li {
	list-style: none;
}

.sign.success {
	color: #5CB85C;
}

.sign.failed {
	color: #D9534F;
}

.selectFile {
	overflow: hidden;
}

.cancalPlan {
	text-align: center;
	display: none;
}
</style>
<body>
	<div class="head">
		<div class="col-lg-4 col-sm-4 col-md-4 logo">
			<a href="index"> <img src="img/logo.png">
			</a>
		</div>
		<div class="col-lg-4 col-sm-4 col-md-4 search">
			<div class="input-group">
				<span class="input-group-addon searchIcon"><i
					class="glyphicon glyphicon-search"></i></span> <input type="text"
					value="${requestScope.dataResponse.specialSearch }"
					class="form-control search_input" placeholder="输入视频关键字"
					style="color:#000"> <span class="input-group-btn">
					<button class="btn btn-warning search_button" type="button">
						<b>搜&nbsp;索</b>
					</button>
				</span>
			</div>
			<!-- /input-group -->
		</div>
		<div class="col-lg-4 col-sm-4 col-md-4 myInfo">
			<ul>
				<li><span class="color_span"> <i
						class="glyphicon glyphicon-pushpin"></i><br /> <span>签到</span></span>
					<div class="more">
						<input type="hidden" id="level" value="0" /> <i
							class="glyphicon glyphicon-triangle-top"></i>
						<ul class="login_state"
							style="${empty sessionScope.user?'display:none':''}">
							<li>
								<p class="title">
									<span class="glyphicon glyphicon-calendar"></span>签到 <span
										style="color:#F0AD4E;font-weight: bold"
										class="signrm account_sign_exp_is">+5</span>
								</p> <br /> <span class="title2">已连续签到 <span
									style="color:#F0AD4E;font-weight: bold"
									class="signCount account_sign_count"></span> 天,明天可领取 <span
									style="color:#F0AD4E;font-weight: bold"
									class="signTomorrow account_tomorrow_sign_exp"></span> 经验
							</span>
								<p class="button account_sign_button">已签到</p>
							</li>
							<li>
								<p class="title">
									<span class="glyphicon glyphicon-expand"></span>看视频10分钟 <span
										style="color:#F0AD4E;font-weight: bold"
										class="account-watch_exp_is">+5</span>
								</p> <br /> <span class="title2">一天可累计5次看视频经验</span>
								<p class="button" style="width:120px;">
									今日已完成：<span style="color:#F0AD4E;font-weight: bold"
										class="account_watch_exp">0</span>次
								</p>
							</li>
						</ul>
						<ul class="logout_state"
							style="${not empty sessionScope.user?'display:none':''}">
							<li data-toggle="modal" data-target="#loginModal"><span
								style="color:#999">您还没有登陆，点击登陆</span></li>
						</ul>
					</div></li>
				<li><span class="color_span"> <i
						class="glyphicon glyphicon-eye-open"></i><br /> <span>看过</span></span>
					<div class="more watched" style="width:150px;left:-50px;">
						<i class="glyphicon glyphicon-triangle-top" style="left:65px"></i>
						<ul style="font-size:12px;">
							<li class="clear_watched" style="color:#999">您最近还没有看过视频</li>
						</ul>
					</div></li>
				<li><span class="color_span"> <i
						class="glyphicon glyphicon-star-empty"></i><br /> <span>收藏</span></span>
					<div class="more collect">
						<i class="glyphicon glyphicon-triangle-top"></i>
						<ul style="font-size:12px;color:#000;">
							<li class="clear_collect" style="color:#999">您还没有收藏任何视频</li>
						</ul>
					</div></li>
				<li data-toggle="modal" data-target="#editModal"><span
					class="color_span"> <i class="glyphicon glyphicon-upload"></i><br />
						<span>上传</span></span></li>
				<li class="login_state"
					style="${empty sessionScope.user?'display:none':''}"><img
					class="myPhoto"
					src="${sessionScope.user!=null?'source/img/avatar/':''}${sessionScope.user!=null?sessionScope.user.avatar.id:''}" />
					<div class="more myMore"
						style="color:#000;font-size:15px;height:110px;">
						<i class="glyphicon glyphicon-triangle-top" style="color:#FFF"></i>
						<p>
							欢迎您：<span class="account_name"></span>
						</p>
						<p>
							<a href="updateUser" target="_blank" class="set"><span
								class="glyphicon glyphicon-cog" title="更新资料"></span></a>
						</p>
						<p>
							VIP等级:<b style="color:#008400;font-weight:bold;"
								class="glyphicon glyphicon-tree-conifer"><span
								class="account_leval"></span></b>&emsp;成长经验:<span
								style="color:#008400" class="account_now_exp"></span> / <span
								style="color:#008400" class="account_need_exp"></span>
						</p>
						<p class="btn btn-warning" data-toggle="modal"
							data-target="#loginModal">注销/更换账号</p>
						<button class="btn btn-danger logout" style="margin-left:20px;">退出</button>
					</div></li>
				<li class="logout_state" data-toggle="modal"
					data-target="#loginModal"
					style="${not empty sessionScope.user?'display:none':''}"><span
					class="color_span"><i class="glyphicon glyphicon-user"></i><br />
						<span>登陆</span></span></li>
			</ul>
		</div>
	</div>
<script type="text/javascript">
	var isLogin=${sessionScope.user!=null?true:false};
	var watchExpCount=0;
	var moreTimer;
	$(function(){
		 $(".myInfo ul li").bind("mouseover",function(){
        clearTimeout(moreTimer);
        $(".myInfo .more").hide();
        $(this).find(".more").show();
    })
    $(".myInfo ul li").bind("mouseout",function(){
        var _this = this;
        moreTimer = setTimeout(function () {
            $(_this).find(".more").hide();
        }, 500)
    })
    $(".myInfo .more").bind("mouseover",function(){
        clearTimeout(moreTimer)
        $(this).show();
    })
    $(".myInfo .more").bind("mouseout",function(){
        $(this).hide();
    })
    //搜索事件
    $(".search_button").click(function(){
    	var value = $(".search_input").val();
    	if(value.trim()=='')return;
    	window.location.href="list?specialSearch="+value;
    })
    $(".search_input").keyup(function(e){
    	if(e.keyCode==13){
	    	if(this.value.trim()=='')return;
	    	window.location.href="list?specialSearch="+this.value;
    	}
    })
   
    //请求收藏
    if(isLogin){
    	requestCollect();
    	requestSign();
    }
    //请求看过
    requestWatched();
     //事件绑定
    bindEvent();
})
//提示工具
function tooltipUtil(el,title){
	$(el).attr("title",title);
	$(el).attr("data-toggle","tooltip");
	$(el).attr("data-placement","bottom");
	 $(el).tooltip("show");
	 setTimeout(function(){
		 $(el).tooltip("destroy");
	 },3000)
}
function requestCollect(){
	var category="电影,电视剧,动漫,教程,音乐,教学"
	$.post("json/watched_collect/collect",null,function(data){
		if(!(data instanceof Object))data = eval("("+data+")");
		if(data.length>0){
			$(".collect ul").html("");
			for(var i=0;i<data.length;i++){
				var cate = data[i].source.category;
				var this_cate;
				for(var j=0;j<cate.length;j++){
					if(category.indexOf(cate[j].name)!=-1){
						this_cate = cate[j].name;break;
					}
				}
				var name = data[i].seriesname!=data[i].source.id?data[i].seriesname:data[i].source.name;
				$(".collect ul").append($('<li><a href="${pageContext.request.contextPath}/get_source/'+data[i].source.id+'"><span class="collectLi"><span style="float:left;min-width:60px;text-align:left;">['+this_cate+']</span>&nbsp;<span style="max-width:150px;height:20px;overflow:hidden;">'+name+'</span></span><span style="color:#FF920B;float:right">'+data[i].source.log.score+' 分</span></a></li>'));
			}
			if(data.length>=5)$(".collect ul").append($('<li class="more_li"><a>查看更多</a></li>'));
		}
	})
}
var isWatched=false;
//保存看过
function watched(){
	$.post("json/saveWatched/"+current_source_id,"name="+current_source_name);
	isWatched=true;
	if(isLogin){
		watch_exp("add");
	}
}
//30分钟添加一次经验
var watchTimer;
function watch_exp(type){
	if(type=='cancel'){
		if(watchTimer==null) clearInterval(watchTimer);
	}else
	watchTimer = setInterval(function() {
		if(watchExpCount<5)
			$.post("json/watchExp",null,function(data){
				if(!(data instanceof Object))data = eval("("+data+")");
				$(".account_watch_exp").html(data.count);
				watchExpCount=data.count;
				requestSign();
				if(data.count>=5) clearInterval(watchTimer);
			})
		else clearInterval(watchTimer);
	}, 1000*60*10+10000)
}
//获取看过
function requestWatched(){
	$.post("json/watched_collect/watched",null,function(data){
		if(data==null||data=='')return;
		if(!(data instanceof Object))data = eval("("+data+")");
		if(data.length>0)$(".watched ul").html("");
		var i =0;
		for(var temp in data){
			if(temp=='length')continue;
			i++;
			$(".watched ul").append($('<li><a href="${pageContext.request.contextPath}/get_source/'+temp+'">'+data[temp]+'</a></li>'));
		}
		if(i>=5)$(".watched ul").append($('<li class="more_li"><a>查看更多</a></li>'));
	})
}
//请求签到与视频任务与账户经验
function requestSign(){
	$.post("json/getSign",null,function(data){
		if(data==null)return;
		isLogin=true;
		$(".login_state").show();
		$(".logout_state").hide();
		if(!(data instanceof Object))data = eval("("+data+")");
		$(".account_tomorrow_sign_exp").html(((data.log.signCount<1?1:data.log.signCount)+1)*5)
		if(data.log.sign){
			$(".account_sign_exp_is").hide();
			$(".account_sign_button").removeClass("sign").html("已签到");
		}else{
			$(".account_sign_exp_is").show();
			$(".account_sign_button").addClass("sign").html("签到");
			bindEvent();
		}
		$(".account_sign_count").html(data.log.signCount);
		if(data.log.watchExpCount>5){
			$(".account-watch_exp_is").hide();
		}else{
			$(".account-watch_exp_is").show();
		}
		$(".myPhoto").attr("src","source/img/avatar/"+data.avatar.id);
		$(".account_name").html(data.nickname!=null?data.nickname:data.username);
		$(".comment_box .send_comment_photo").attr("src","source/img/avatar/"+data.avatar.id);
		$(".comment_box .send_comment_name").html(data.nickname!=null?data.nickname:data.username);
		$(".account_watch_exp").html(data.log.watchExpCount);
		$(".account_leval").html(data.log.myLevel[0]);
		$(".account_now_exp").html(data.log.myLevel[1]);
		$(".account_need_exp").html(data.log.myLevel[2]);
		$("#level").val(data.log.myLevel[0]);
	});
}
//登陆状态变更
function stateChange(type){
	if(type=='login'){
		requestSign();
		requestCollect();
		requestWatched();
		bindEvent();
		if(isWatched)watch_exp("add");
	}else{
		initSign()
	}
}
//初始化未登陆状态
function initSign(){
		isLogin=false;
		$(".login_state").hide();
		$(".logout_state").show();
		$(".account_tomorrow_sign_exp").html(0)
		$(".account_sign_count").html(0);
		$(".account_watch_exp").html(0);
		$(".account_name").html("");
		$(".account_leval").html(0);
		$(".account_now_exp").html(0);
		$(".account_need_exp").html(0);
		$(".myPhoto").attr("src","img/noPhoto.png");
		$(".comment_box .send_comment_photo").attr("src","img/noPhoto.png");
		$(".comment_box .send_comment_name").html("游客");
		$("#level").val(0);
		watch_exp("cancel");
}
function filter(message){
	if(message == null){
		return null;
	}
	return message.replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/&/g,"&amp;").replace(/"/g,"&quot;");
}
</script>
</body>
</html>
