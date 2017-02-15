<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>正在观看--${requestScope.current_source.seriesname!=requestScope.current_source.id?requestScope.current_source.seriesname:''}
	${requestScope.current_source.name}</title>
<link href="css/play.css" rel="stylesheet" type="text/css">
<link href="css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="
css/danmuplayer.css" rel="stylesheet" type="text/css">
<style type="text/css">
.myInfo>ul>li>span {
	color: #BBB;
}

a {
	color: #999;
}

.signLine {
	height: 20px;
	padding: 3px;
	overflow: hidden;
	margin: 0;
	width: 100%;
}

.playNum {
	float: left;
	font-size: 15px;
}

.garde {
	float: right;
	font-size: 15px;
}

.playNum font, .garde font {
	font-size: 18px;
	padding: 2px;
}

.garde font {
	color: #ED5565;
}

.item_2 {
	float: left;
	padding: 5px;
}

.playListUl li a {
	color: #999;
}

.playListUl li.active, .playListUl li.active a {
	color: #FFF;
	background: #FF920B;
}

.score {
	cursor: pointer;
	padding: 0 5px;
}

.sendComment {
	background: #19A6D1 !important;
}

.currentVideo .decription {
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

#download:hover {
	color: #23B7E5;
	cursor: pointer;
}

.cate_li:hover a {
	color: #FF920B;
}
.hideList{
	position:absolute;
	left:0;top:40%;width:12px;height:75px;
	z-index:100;display:none;
}
.hideList.active{
	left:auto;right:0;display:none;
	width:20px;padding:0 4px;
}
.hideList:hover{
	color:#FFF;
	cursor:pointer;
	background:rgba(255,255,255,0.1);
}
</style>
</head>
<body>
	<div class="box">
		<div class="head" style="background:#222;height:800px;">
			<div class="container-fluid">
				<!--顶部-->
				<jsp:include page="head.jsp"></jsp:include>
				<!--顶部结束-->
				<div class="playCenter">
					<div class="player">
						<div id="danmup"
							style="width:100%;height:100%;outline:none;border:1px solid rgba(0,0,0,0.5);"
							tabindex="0"></div>
					</div>
					<div class="videoInfo">
						<p class="hideList">隐藏列表</p>
						<div class="menuListBox">
							<p class="playList active">播放列表</p>
							<p class="barrage">弹幕列表</p>
						</div>
						<c:if test="${not empty requestScope.current_source}">
							<ul class="playListUl">
								<h3>${requestScope.current_source.seriesname!=requestScope.current_source.id?requestScope.current_source.seriesname:requestScope.current_source.name}<span
										class="glyphicon glyphicon-star-empty collect_button"
										title="收藏"></span>
								</h3>
								<span> <c:forEach items="${requestScope.sources}"
										var="source">
										<li title="${source.name}"
											${requestScope.current_source.id==source.id?'class="active"':''}><a
											href="get_source/${source.id}">${source.name}</a></li>
									</c:forEach>
								</span>
							</ul>
							<div class="barrageUl" style="display: none;">
								<table>
									<thead>
										<tr>
											<th class="col-sm-3">时间</th>
											<th class="col-sm-5">弹幕内容</th>
											<th class="col-sm-4">发送日期</th>
										</tr>
									</thead>
									<tbody>
										<tr class="clear_tr">
											<td colspan="3" style="color:#555">请点击播放后装载弹幕或还没有弹幕</td>
										</tr>
									</tbody>
								</table>

							</div>
						</c:if>
					</div>
				</div>
				<div class="currentVideo">
					<h1
						style="max-width:300px;white-space: nowrap;overflow:hidden;text-overflow: ellipsis;"
						title="${requestScope.current_source.seriesname!=requestScope.current_source.id?requestScope.current_source.seriesname:requestScope.current_source.name}&nbsp;${requestScope.current_source.seriesname!=requestScope.current_source.id?requestScope.current_source.name:''}">
						<span>${requestScope.current_source.seriesname!=requestScope.current_source.id?requestScope.current_source.seriesname:requestScope.current_source.name}&nbsp;${requestScope.current_source.seriesname!=requestScope.current_source.id?requestScope.current_source.name:""}</span>&nbsp;&nbsp;
					</h1>
					<h1>
						<span style="color:#FF920B">${requestScope.current_source.log.score}</span>
						<span style="font-size:15px;" class="score_span">评分<i
							title="非常差(2分)" class="glyphicon glyphicon-star-empty score"></i><i
							title="差(4分)" class="glyphicon glyphicon-star-empty score"></i><i
							title="一般(6分)" class="glyphicon glyphicon-star-empty score"></i><i
							title="好看(8分)" class="glyphicon glyphicon-star-empty score"></i><i
							title="非常好看(10分)" class="glyphicon glyphicon-star-empty score"></i></span>
					</h1>
					<h1 style="margin-left:20px;">
						<span style="font-size:15px;" class="glyphicon glyphicon-eye-open">点击量:</span>
						<span>${requestScope.current_source.log.total_play}</span>
						<%-- <a href="download/${requestScope.current_source.id}" target="_blank"> --%>
						<span style="font-size:15px;" class="glyphicon glyphicon-save"
							id="download">下载</span>
						<!-- </a> -->
					</h1>
					<p class="clear"></p>
					<div class="row">
						<div class="col-md-6">
							<ul>
								<c:forEach items="${requestScope.current_source.category}"
									var="cate">
									<li title="${cate.name}" class="cate_li"><a
										href="list?searchString=${cate.id}">${cate.name}</a></li>
								</c:forEach>
							</ul>
						</div>
						<p class="col-md-6 decription"
							title="${requestScope.current_source.decription}">
							<span style="font-size:18px">描述:</span>${requestScope.current_source.decription}</p>
					</div>
				</div>
			</div>
		</div>
		<div class="container" style="width:80%">
			<!--精心推荐div-->
			<div class="wrapper wrapper-content animated fadeIn teleplay_div">
				<h2 title="更多">
					为您精心推荐<small style="font-size:12px;">--您可能喜欢</small>
				</h2>
				<div class="row">
					<c:if test="${not empty requestScope.hobbys}">
						<c:forEach items="${requestScope.hobbys}" end="4" var="source">
							<div class="col-sm-3 item_2">
								<div class="contact-box" style="padding:5px;">
									<a href="get_source/${source.id}">
										<div class="col-sm-12" style="padding:5px;">
											<div class="text-center">
												<img alt="image" title="视频预览图" class="m-t-xs img-responsive"
													src="source/img/min/${source.img.id}">
											</div>
										</div>
										<div class="col-sm-12">
											<div class="text-center">
												<h3 class="signLine" title="视频名称">
													<strong>${source.seriesname!=source.id?source.seriesname:source.name}</strong>
												</h3>
												<p>
													<span class="playNum" title="播放量"><i
														class="glyphicon glyphicon-eye-open"></i><font>${source.log.total_play}</font></span><span
														class="garde" title="评分"><i
														class="glyphicon glyphicon-heart"></i><font>${source.log.score}</font></span>
												</p>
											</div>
										</div>
										<div class="clearfix"></div>
									</a>
								</div>
							</div>
						</c:forEach>
					</c:if>
				</div>
			</div>
			<!--电视剧推荐div结束-->
			<div class="wrapper wrapper-content  animated fadeInRight"
				style="padding-top:0">
				<div class="row">
					<div class="col-sm-12">
						<h2 style="margin-top:0">
							影片评论<small style="font-size:12px;">--请文明用语，违反规定者将进行封号处理</small>
						</h2>

						<div class="social-feed-box">
							<div class="social-footer">
								<div class="social-comment send_div">
									<a href="javascript:void(0)" class="pull-left"> <img
										alt="image" class="myPhoto"
										src="${sessionScope.user!=null?'source/img/avatar/':'img/noPhoto.png'}${sessionScope.user!=null?sessionScope.user.avatar.id:''}">
									</a>
									<div class="media-body">
										<div class="input-group col-sm-12">
											<textarea class="form-control comment_input"
												placeholder="在这里写下您对此影片的评论..."></textarea>
											<span class="input-group-addon btn btn-info sendComment">评论</span>
										</div>
									</div>
								</div>

							</div>

						</div>

					</div>
				</div>
			</div>
		</div>
		<!-- 评论div -->
		<div class="comment_box" style="display:none">
			<div class="social-comment">
				<a href="javascript:void(0)" class="pull-left"> <img alt="image"
					class="img-circle send_comment_photo"
					src="${sessionScope.user!=null?'source/img/avatar/':'img/noPhoto.png'}${sessionScope.user!=null?sessionScope.user.avatar.id:''}">
				</a>
				<div class="media-body">
					<a href="javascript:void(0)" class="send_comment_name">
						${sessionScope.user==null?'游客':sessionScope.user.nickname!=null?sessionScope.user.nickname:sessionScope.user.username}
					</a> <span class="text-content"> </span><br />
					<a href="javascript:void(0)" class="small praise"><i
						class="fa fa-thumbs-up"></i> <span>0</span></a> - <small
						class="text-muted"></small>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="loginModal.jsp"></jsp:include>
</body>
<script type="text/javascript" src="js/ie/html5media.min.js"></script>
<script src="js/play.js" type="text/javascript"></script>
<script src="js/plugins/layer/layer.min.js"></script>
<script src="js/plugins/iCheck/icheck.min.js"></script>
<!--备用播放器  -->
<script type="text/javascript" src="ckplayer/ckplayer.js"
	charset="utf-8"></script>
<!--备用播放器  -->
<script src="js/danmuplayer.js" type="text/javascript"></script>
<script type="text/javascript">
	var current_source_id = "${requestScope.current_source.id}";
	var current_source_name = "${requestScope.current_source.seriesname!=requestScope.current_source.id?requestScope.current_source.seriesname:''} ${requestScope.current_source.name}";
	var has_previous = $(".playListUl li.active").index() == 0 ? false : true; //是否有上一个视频
	var has_next = $(".playListUl li.active").index() == $(".playListUl li").length - 1 ? false : true; //是否有下一个视频
	$("#danmup").danmuplayer({
		src : "${pageContext.request.contextPath}/play/${requestScope.sources!=null?requestScope.current_source.source.id:''}", //视频源
		width : "100%", //视频宽度
		height : "100%", //视频高度 
		url_to_get_danmu : "json/getBarrage/${requestScope.current_source.id}",
		url_to_post_danmu : "json/saveBarrage/${requestScope.current_source.id}"
	});
	$(function() {
		$('.i-checks').iCheck({
			checkboxClass : 'icheckbox_square-green',
			radioClass : 'iradio_square-green',
		});
		//下载
		$("#download").click(function(){
			if(!isLogin||isLogin&&parseInt($("#level").val())<1){
				layer.tips('只有达到1级的用户才可以下载资源', this);
				return false;
			}
			$.post("json/checkDownload",function(data){
				if(!(data instanceof Object))data = eval("("+data+")");
				if(data.result){
					window.location.href="download/${requestScope.current_source.id}";
					return;
				}else{
					layer.tips("您还不能下载："+data.cause, "#download");
					return false;
				}
			})
		})
		//隐藏列表
		show_hide();
		$(".hideList").click(function(){
			if(!$(this).hasClass("active")){
				$(this).addClass("active");
				$(".player").attr("wid",$(".player")[0].style.width);
				$(".player").css("width","100%");
				$(".videoInfo").hide();
				$(".player").append(this);
				$(this).html("显示列表");
				show_hide();
			}else{
				$(this).removeClass("active");
				$(".player").css("width",$(".player").attr("wid"));
				$(".videoInfo").show();
				$(".videoInfo").append(this);
				$(this).html("隐藏列表");
				show_hide();
			}
		})
		
	})
	function show_hide(){
		$(".player").unbind();
		$(".player").bind("mouseover",function(){
			$(".hideList.active").show();
		}).bind("mouseout",function(){
			$(".hideList.active").hide();
		})
		$(".videoInfo").unbind();
		$(".videoInfo").bind("mouseover",function(){
			$(".hideList").show();
		}).bind("mouseout",function(){
			$(".hideList").hide();
		})
	}
	//上一个视频
	function previous_source() {
		var li_href = $(".playListUl li.active").prev().find("a").attr("href");
		if (li_href != undefined)
			window.location.href = "${pageContext.request.contextPath}/" + li_href;
		return false;
	}
	//下一个视频
	function next_source() {
		var li_href = $(".playListUl li.active").next().find("a").attr("href");
		if (li_href != undefined)
			window.location.href = "${pageContext.request.contextPath}/" + li_href;
		return false;
	}
	//填充弹幕
	function fill_barrage_li(data) {
		$(".barrageUl table .clear_tr").remove();
		$(".barrageUl table tbody").append($('<tr><td>' + calc_time(data.time) + '</td><td>' + data.text + '</td><td>' + new Date(data.send_time * 1000).Format("MM-dd hh:mm:ss") + '</td></tr>'));
	}
	//计算弹幕的时间段
	function calc_time(time) {
		var minutes = parseInt(time / 600); // 计算分 
		var seconds = parseInt((time % 600) / 10); // 计算秒  
		var least = parseInt(time % 10);
		minutes = minutes < 10 ? "0" + minutes : minutes;
		seconds = seconds < 10 ? "0" + seconds : seconds;
		return minutes + ":" + seconds + "." + least;
	}
	//切换播放器
	function switch_play(){
		$("#danmup").remove();
		$(".player").append($('<div id="a1" style="height:100%;width:100%"></div>'));
		var flashvars={
		f:'${pageContext.request.contextPath}/play/${requestScope.sources!=null?requestScope.current_source.source.id:''}',//视频地址
		c:0,
		b:0,
		};
		var params={bgcolor:'#FFF',allowFullScreen:true,allowScriptAccess:'always',wmode:'transparent'};
	    CKobject.embedSWF('ckplayer/ckplayer.swf','a1','ckplayer_a1','100%','100%',flashvars,params);
		try{
			query();
		}catch(e){
			$.get("json/getBarrage/${requestScope.current_source.id}", function(data, status) {
				if(data!=null&&data!='')
				if(!(data instanceof Object))data = eval("("+data+")");
				for (var i = 0; i < data.length; i++) {
					fill_barrage_li(data[i]);
				}
			});
			watched();
		}
	}
	//播放完后调用此方法
	function play_next(){
		if(has_next){
			parent.layer.msg('马上进入下一个视频', {icon : 1});
			setTimeout(function(){
				next_source();
			},3000)
		}
	}
</script>
</html>
<%-- <code style="font-family: Consolas, 'Liberation Mono', Menlo, Courier, monospace; font-size: 13.6000003814697px; margin: 0px; border-radius: 3px; word-break: normal; white-space: pre; border: 0px; display: inline; max-width: initial; overflow: initial; line-height: inherit; word-wrap: normal; background-image: initial; background-attachment: initial; background-size: initial; background-origin: initial; background-clip: initial; background-position: initial; background-repeat: initial;">DanmuPlayer (//github.com/chiruom/danmuplayer/) - Licensed under the MIT license</code> --%>