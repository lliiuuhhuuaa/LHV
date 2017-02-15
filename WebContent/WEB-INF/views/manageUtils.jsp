<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	String serverPath = "ws://" + request.getServerName() + ":"
			+ request.getServerPort() + path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>资源管理</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<link rel="shortcut icon" href="favicon.ico">
<link href="css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
<link href="css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
<link href="css/animate.css" rel="stylesheet">
<link href="css/style.css?v=4.1.0" rel="stylesheet">
<style type="text/css">
.notes li{
	text-align:center;
}
</style>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content  animated fadeInUp">
		<ul class="notes">
			<li>
				<div>
					<small>六画</small>
					<h4>资源上线审核</h4>
					<p>用于资源的自动审核，此工具会自动扫描未上线资源是否符合上线规范，符合则自动进行上线处理</p>
					<button class="btn btn-success missionButton" id="autoOnline">创建任务</button>
				</div>
			</li>
			<li>
				<div>
					<small>六画</small>
					<h4>资源下线审核</h4>
					<p>用于资源的自动审核，此工具会自动扫描已经上线的资源是否存在资源丢失，丢失则自动进行下线处理</p>
					<button class="btn btn-success missionButton" id="autoOffline">创建任务</button>
				</div>
			</li>
			<li>
				<div>
					<small>六画</small>
					<h4>垃圾文件清理</h4>
					<p>自动对没有指向的资源记录和没有记录的文件进行清除处理</p>
					<button class="btn btn-success missionButton" id="clearRubbish">创建任务</button>
				</div>
			</li>
			<li>
				<div>
					<small>六画</small>
					<h4>视频格式转换</h4>
					<p>自动对资源格式进行兼容转换，具体参数使用转换配置文件设置，此操作需要耗费大量时间与计算机性能</p>
					<button class="btn btn-success missionButton" id="videoConver">创建任务</button>
				</div>
			</li>
		</ul>
		<div class="col-sm-4 move" style="position:absolute;right:10px;top:20px;">
			<div class="ibox">
				<div class="ibox-content">
					<h3>任务列表</h3>
					<ul class="sortable-list connectList agile-list">
						<c:if test="${empty requestScope.mission}">
							<li>你还没有进行的任务</li>	
						</c:if>
						<c:forEach items="${requestScope.mission}" var="mi">
							<li class="success-element mission-li ${mi.state==2?'pause':'ing' }" data-type="${mi.type}">${mi.name}(<span class="state">${mi.state==2?'已暂停任务':'正在进行' }</span>)<div class="agile-detail"><a class="pull-right btn btn-xs btn-white missionControl2">${mi.state==2?'继续任务':'暂停任务' }</a><a class="pull-right btn btn-xs btn-white missionControl1">取消任务</a><i class="fa fa-clock-o"></i>用时 <span class="time" time="${mi.usedtime}">00:00:00</span></div></li>
						</c:forEach>
						<!--  -->
					</ul>
				</div>
			</div>
		</div>
	</div>
</body>
<!-- 全局js -->
<script src="js/jquery/jquery.min.js?v=2.2.2"></script>
<script src="js/bootstrap.min.js?v=3.3.6"></script>
<script src="js/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="js/move.js"></script>
<!-- layer javascript -->
<script src="js/plugins/layer/layer.min.js"></script>
<!-- 自定义js -->
<script src="js/content.js?v=1.0.0"></script>
<script type="text/javascript">
	var webSocketUri="<%=serverPath%>webSocketServer";
	$(function(){
		if($(".mission-li").length>0){
			setStaticTime();
			bindEvent();
		}
		/* $("#autoOnline").click(function(){
			//询问框
			parent.layer.confirm('资源审核操作比较消耗系统资源，建议在闲时进行操作', {
			    btn: ['现在就很闲','等会再来'], //按钮
			    shade:  0.5 //不显示遮罩
			}, function(){
				createMission("autoOnline","资源上线审核");
			}, function(){
			    parent.layer.msg('您已取消审核操作', {shift: 6});
			});
		})
		$("#autoOffline").click(function(){
			//询问框
			parent.layer.confirm('资源审核操作比较消耗系统资源，建议在闲时进行操作', {
			    btn: ['现在就很闲','等会再来'], //按钮
			    shade:  0.5 //不显示遮罩
			}, function(){
				createMission("autoOffline","资源下线审核");
			}, function(){
			    parent.layer.msg('您已取消审核操作', {shift: 6});
			});
		})
		$("#clearRubbish").click(function(){
			//询问框
			parent.layer.confirm('资源审核操作比较消耗系统资源，建议在闲时进行操作', {
			    btn: ['现在就很闲','等会再来'], //按钮
			    shade:  0.5 //不显示遮罩
			}, function(){
				createMission("clearRubbish","垃圾文件清理");
			}, function(){
			    parent.layer.msg('您已取消审核操作', {shift: 6});
			});
		}) */
		$(".missionButton").click(function(){
			var _this = this;
			//询问框
			parent.layer.confirm('资源审核操作比较消耗系统资源，建议在闲时进行操作', {
			    btn: ['现在就很闲','等会再来'], //按钮
			    shade:  0.5 //不显示遮罩
			}, function(){
				createMission($(_this).attr("id"),$(_this).parent().find("h4").html());
			}, function(){
			    parent.layer.msg('您已取消审核操作', {shift: 6});
			});
		})
		//通信服务器
		openWebSocket();
		var linkTimer = setInterval(function() {
		if(webSocket==null){
			openWebSocket();
		}else{
			clearInterval(linkTimer)
		}
	}, 3000);
	})
//创建任务
var missionNum=0;
function createMission(type,text){
	var mission = $('<li class="success-element mission-li wait" data-type="'+type+'">'+text+'(<span class="state">等待中</span>)<div class="agile-detail"><a class="pull-right btn btn-xs btn-white missionControl2">开始任务</a><a class="pull-right btn btn-xs btn-white missionControl1">取消任务</a><i class="fa fa-clock-o"></i>用时 <span class="time" time="0">00:00:00<span></div></li>');
	if($(".connectList li.mission-li").length<1) $(".connectList").html("");
	if($(".connectList li.mission-li[data-type="+type+"]").length>0){
		parent.layer.msg(text+'已存在于任务列表中', {shift: 6});
	}else{
		missionNum++;
		$(".connectList").append(mission);
		parent.layer.msg('已创建资源审核任务', {icon: 1});
		bindEvent();
	}
}
function startMission(type,code){
	var data = "type="+type+"&code="+code+"&state=1&id="+currentID+"&name="+(type=='autoOnline'?'资源上线审核':type=='autoOffline'?'资源下线审核':'垃圾文件清理');
	$.post("utils/mission",data,function(data){
		data = eval("("+data+")");
		if(!data.message){
			parent.layer.msg(data.cause, {shift: 6});
		}
	})
}
var webSocket = null;
var linkTime = 1;
var currentID = null;
function openWebSocket(){
	if ('WebSocket' in window)  
		 webSocket = new WebSocket(webSocketUri);  
    else if ('MozWebSocket' in window)  
    	webSocket = new MozWebSocket(webSocketUri);  
    else  
    	console.log("你浏览器不支持webSocket通信/not support WebSocket!");  
	webSocket.onopen = function() {
		console.log("连接服务器成功")
	};

	webSocket.onmessage = function(event) {
		var data = eval("("+event.data+")");
		if(data.state=='100'){
			currentID = data.id;
		}else if(data.state=='10'){
			var mission_li = $(".mission-li[data-type="+data.type+"]");
			$(mission_li).find(".state").html("已完成→处理记录:"+data.handler+"条");
			$(mission_li).attr("class","success-element mission-li done");
			$(mission_li).find(".missionControl2").remove();
			$(mission_li).find(".missionControl1").html("删除任务");
		}else if(data.state=='8'){
			var mission_li = $(".mission-li[data-type="+data.type+"]");
			$(mission_li).find(".state").html("任务失败");
			$(mission_li).attr("class","success-element mission-li failed");
			$(mission_li).find(".missionControl2").remove();
			$(mission_li).find(".missionControl1").html("删除任务");
		}
	};

	webSocket.onclose = function(event) {
		console.log("服务器已断开")
	};
}
function bindEvent(){
	$(".missionControl2").unbind();
	$(".missionControl2").bind("click",function(){
		if(webSocket==null){
			parent.layer.msg('通信服务器未连接,马上尝试重连...', {shift: 6});
			openWebSocket();
			if(webSocket==null){
				parent.layer.msg('连接失败，请检查您的网络是否连接...', {shift: 6});
				return;
			}
		}
		var parentLi = $(this).parents(".mission-li")[0];
		if($(parentLi).hasClass("wait")){
			$(parentLi).removeClass("wait");
			$(parentLi).addClass("ing");
			$(parentLi).find(".state").html("正在进行");
			$(this).html("暂停任务");
			setTime(parentLi);
			startMission($(parentLi).attr("data-type"),1);
		}else if($(parentLi).hasClass("pause")){
			$(parentLi).removeClass("pause");
			$(parentLi).addClass("ing");
			$(parentLi).find(".state").html("正在进行");
			$(this).html("暂停任务");
			startMission($(parentLi).attr("data-type"),1);
			setTime(parentLi);
			var type = $(parentLi).attr("data-type");
		}else if($(parentLi).hasClass("ing")){
			$(parentLi).removeClass("ing");
			$(parentLi).addClass("pause");
			$(parentLi).find(".state").html("已暂停任务");
			$(this).html("继续任务");
			startMission($(parentLi).attr("data-type"),2);
		}
		return false;
	})
	$(".missionControl1").unbind();
	$(".missionControl1").bind("click",function(){
		var pli = $(this).parents(".mission-li");
		if($(pli).hasClass("done")||$(pli).hasClass("failed")){
			$(pli).remove();
			if($(".mission-li").length<1){
				$(".connectList ").append('<li>你还没有进行的任务</li>')
			}
			return;
		}
		//询问框
		parent.layer.confirm('确认要放弃该任务吗？', {
		    btn: ['YES','NO'], //按钮
		    shade: 0.5 //不显示遮罩
		}, function(){
			if(!($(pli).hasClass("done")||$(pli).hasClass("failed")||$(pli).hasClass("wait"))){
				 startMission($(pli).attr("data-type"),0);
			}
		    $(pli).remove();
		    if($(".mission-li").length<1){
				$(".connectList ").append('<li>你还没有进行的任务</li>')
			}
		    parent.layer.msg('已放弃任务', {icon: 1});
		}, function(){
		});
	})
}
function setTime(el){
try{
	var timeIndex=0;
	var timeEL = $(el).find(".time");
	timeIndex =	parseInt($(timeEL).attr("time"));
	var timer = setInterval(function() {
		 var hour = parseInt(timeIndex / 3600);    // 计算时 
		 var minutes = parseInt((timeIndex % 3600) / 60);    // 计算分 
		 var seconds = parseInt(timeIndex % 60);    // 计算秒  
		 hour = hour < 10 ? "0" + hour : hour;
		 minutes = minutes < 10 ? "0" + minutes : minutes;
		 seconds = seconds < 10 ? "0" + seconds : seconds;
		 $(timeEL).html(hour + ":" + minutes + ":" + seconds);
		 timeIndex++;
		 $(timeEL).attr("time",timeIndex);
		 if($(el).hasClass("pause")||$(el).hasClass("done")||$(el).hasClass("failed"))clearInterval(timer);
	}, 1000);
}catch(e){}

}
function setStaticTime(lis){
	var lis = $(".mission-li");
	for(var i=0;i<lis.length;i++){
		var timeEL = $(lis[i]).find(".time");
		var timeIndex =	parseInt($(timeEL).attr("time"));
		var hour = parseInt(timeIndex / 3600);    // 计算时 
		 var minutes = parseInt((timeIndex % 3600) / 60);    // 计算分 
		 var seconds = parseInt(timeIndex % 60);    // 计算秒  
		 hour = hour < 10 ? "0" + hour : hour;
		 minutes = minutes < 10 ? "0" + minutes : minutes;
		 seconds = seconds < 10 ? "0" + seconds : seconds;
		 $(timeEL).html(hour + ":" + minutes + ":" + seconds);
		 setTime(lis[i])
	}
}
</script>
</html>
