<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	String serverPath = "ws://" + request.getServerName() + ":"
			+ request.getServerPort() + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>添加资源</title>
<link href="css/bootstrap.min.css" rel="stylesheet"
	type="text/css">
<link rel="stylesheet" href="css/admin/multipleChoice.css">
<link href="css/admin/addSource.css" rel="stylesheet" type="text/css">
<link href="css/animate.css" rel="stylesheet">
<style type="text/css">
body {
	background: #ecf0f5;
}
</style>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content  animated fadeInRight">
		<div class="sourceInfor move">
			<table class="table">
				<caption>
					<h2>批量扫描</h2>
				</caption>
				<tr>
					<td>
						<div class="input-group">
							<div class="input-group-addon">扫描路径</div>
							<input type="text" class="form-control" name="path"
								placeholder="填写资源路径[例:D:/abc]" data-toggle="tooltip" data-placement="top" title=""/>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="input-group">
							<div class="input-group-addon">扫描层数</div>
								<div class="input-group" style="position: relative;" id="scanLevel">
								<span class="input-group-addon minus" disabled><i class="glyphicon glyphicon-minus"></i></span>
								 <input type="text" class="form-control" value="1" placeholder="填写资源扫描的层数"
									style="font-size: 25px;width:200px; text-align: center;" maxlength="2" maxValue="20" sourceValue="1">
									<span class="input-group-addon add"><i class="glyphicon glyphicon-plus"></i></span>
								</div>
							</div>
					</td>
				</tr>
				<tr>
					<td style="position:relative">
						<div class="input-group">
							<div class="input-group-addon">智能识别</div>
							<div class="mc">
								<p class="on">ON</p>
								<p class="control"></p>
								<p class="off">OFF</p>
								<input type="hidden" value="1" name="autoSeries" class="mcControl">
							</div>
						</div>
						<span class="glyphicon glyphicon-info-sign readme" data-toggle="tooltip" data-placement="top" title="智能判断文件夹为系列名"></span>
					</td>
				</tr>
				<tr>
					<td>
						<div class="input-group">
							<div class="input-group-addon">支持格式</div>
							<div class="form-control" style="background:none;">.mp4, .mkv, .rmvb,.avi,.rm,mov,.wmv</div>
						</div>
					</td>
				</tr>
				<tr>
					<td style="text-align: center">
						<button class="btn btn-primary" id="scan" data-toggle="tooltip" data-placement="top" title="">开始扫描</button>
					</td>
				</tr>
			</table>
			</div>
			<!--记录盒子  -->
		<div class="recordBox move">
			<!-- missioning -->
			<!-- <div class="missionRecord">
				<h2>任务进度</h2>
				<div>
					<p>项目</p>
					<p>进度</p>
					<p>状态</p>
				</div>
				<ul>
				</ul>
			</div> -->
		<!-- missioning -->
		<div class="logRecord">
			<h2>执行日志</h2><span class="clearLog">清除日志<i class="glyphicon glyphicon-trash"></i></span>
			<textarea class="form-control logBoard" readonly="readonly" placeholder="还没有日志记录" style="height:300px;margin-left:4px;"></textarea>
		</div>
	</div>
	<!--记录盒子  -->
	</div>
</body>
<script src="js/jquery/jquery.min.js" type="text/javascript"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/move.js" type="text/javascript"></script>
<script src="js/websocket.js" type="text/javascript"></script>
<script src="js/admin/multipleChoice.js" type="text/javascript"></script>
<script type="text/javascript">
	var webSocketUri="<%=serverPath%>webSocketServer";
	$(function(){
	 /*批量添加资源*/
 $("#scan").click(function(){
	 var path = $("input[name=path]")[0];
	 var level = $("#scanLevel input")[0];
	 if(path.value==''){
		 tooltipUtil(path,"路径不能为空[例：D:/abc]");
		 return;
	 }
	 if(webSocket==null){
		 createLog("上传服务器未连接，无法进行扫描操作，请刷新网页重连");
		 tooltipUtil(this, "上传服务器未连接,无法进行操作");
		 return;
	 }
	 if(level.value==''){
		 level.value = 1;
	 }else if(parseInt(level.value)<1){
		 level.value = 1;
	 }
	 var data = "path="+path.value+"&level="+level.value+"&autoSeries="+$("input[name=autoSeries]").val();
	 $.post("json/scanFile/"+currentID,data,function(data){
		 if(data!=null){
			 data = eval("("+data+")");
			 if(data.message){
				 createLog(data.log);
			 }else{
				 createLog("扫描添加失败，原因："+data.cause);
			 }
		 }
	 })
	 
 })
 /*层数控制*/
 //输入数量
	$("#scanLevel input").keyup(function(e){
		if(/^[0-9]{1,4}$/.test(this.value)){
			var maxValue=parseInt($(this).attr("maxValue"));
			if(this.value>maxValue){
				$(this).val(maxValue);
				$(this).attr("sourceValue",this.value);
			}else if(this.value<1){
				$(this).val(1);
				$(this).attr("sourceValue",this.value);
			}
		}else{
			$(this).val($(this).attr("sourceValue"));
		}
	})
	//数量减少
	$("#scanLevel .minus").click(function(){
		var val = parseInt($("#scanLevel input").val())-1;
		if(val<1)val=1;
		$("#scanLevel input").val(val);
	})
	//数量增加
	$("#scanLevel .add").click(function(){
		var maxValue=$("#scanLevel input").attr("maxValue");
		var val = parseInt($("#scanLevel input").val())+1;
		if(val>maxValue)val=maxValue;
		$("#scanLevel input").val(val);
	})
	$(".readme").mouseover(function(){
		$(this).tooltip("show");
	})
	$(".clearLog").click(function(){
		$(".logBoard").html("");
	})
	})
	//显示执行日志
function createLog(text){
	$(".logBoard").append("----"+text+"----\r\n\r\n");
	var content = $(".logBoard")[0];
	content.scrollTop=content.scrollHeight;	//让滚动条在底部
}
//提示工具
function tooltipUtil(el,title){
	$(el).attr("title",title);
	 $(el).tooltip("show");
	 setTimeout(function(){
		 $(el).tooltip("destroy");
	 },3000)
}
function MissionState(){}
function MissionPlan(){}
</script>
</html>