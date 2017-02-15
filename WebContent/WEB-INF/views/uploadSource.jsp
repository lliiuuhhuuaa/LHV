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
<link href="css/admin/addSource.css" rel="stylesheet" type="text/css">
<link href="css/plugins/treeview/bootstrap-treeview.min.css" rel="stylesheet">
<link rel="stylesheet" href="css/admin/multipleChoice.css">
<link href="css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
<link href="css/style.css?v=4.1.0" rel="stylesheet">
<!-- Sweet Alert -->
<link href="css/plugins/sweetalert/sweetalert.css" rel="stylesheet">
<link href="css/animate.css" rel="stylesheet">
<style type="text/css">
body {
	background: #ecf0f5;
}
.categoryList{
	position:absolute;
	right:-180px;top:0;
	height:100%;
	display:none;
}
#treeview li{
	padding-left:2px;
	text-align:left;
}
.categoryList >.ibox-content{
	overflow:auto;
	height:90%;
}
</style>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content  animated fadeInRight">
		<div class="sourceInfor move">
			<div class="ibox float-e-margins categoryList">
                <div class="ibox-title">
                    <h5>分类列表</h5>
                    <div class="ibox-tools">
                        <a class="close-link">
                            <i class="fa fa-times"></i>
                        </a>
                    </div>
                </div>
                <div class="ibox-content">
                    <div id="treeview">
                    </div>
                </div>
            </div>
			<form id="sourceInforForm" method="post" autocomplete="off">
				<table class="table">
					<input type="hidden" id="id" name="id" />
					<caption>
						<h2>资源信息</h2>
					</caption>
					<tr>
						<td>
							<div class="input-group">
								<input type="hidden">
								<div class="input-group-addon">系列</div>
								<div class="mc">
									<p class="on">ON</p>
									<p class="control"></p>
									<p class="off">OFF</p>
									<input type="hidden" value="0" class="mcControl">
								</div>
							</div>
						</td>
					</tr>
					<tr style="display:none;">
						<td>
							<div class="input-group" data-toggle="popover"
								data-placement="top" data-content="必须至少选择一位用户！">
								<span class="input-group-addon">系列名称</span> <input
									class="form-control seriesname" type="text"
									placeholder="输入关键字搜索" data-toggle="tooltip"
									data-placement="top"
									onkeydown='if(event.keyCode==13) return false;'>
								<div class="list-group autoComplate">
									<p>
										查询结果：总&nbsp;<strong><span class="searcRresult">0</span></strong>&nbsp;条记录
									</p>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="input-group">
								<div class="input-group-addon">资源名称</div>
								<input type="text" class="form-control"
									placeholder="填写资源名称，显示的名称[例:1集]" name="name"
									data-toggle="tooltip" data-placement="top" />
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="input-group">
								<input type="hidden" name="category">
								<div class="input-group-addon">分类</div>
								<ul class="form-control categoryUl" title="点击添加资源分类"
									tabindex="0" data-toggle="tooltip" data-placement="top"></ul>
							</div>
						</td>
					</tr>
					<tr>
						<td><img class="img">
							<div class="input-group">
								<div class="input-group-addon">缩略图</div>
								<button class="form-control selectFile" type="button"
									data-type="pic">点击选择文件</button>
							</div></td>
					</tr>
					<tr>
						<td>
							<div class="input-group">
								<div class="input-group-addon">资源路径</div>
								<button class="form-control selectFile" type="button"
									data-type="file">点击选择文件</button>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="input-group">
								<div class="input-group-addon">描述</div>
								<textarea class="form-control" placeholder="填写资源描述文字"
									name="decription"></textarea>
							</div>
						</td>
					</tr>
					<tr>
						<td style="text-align: center">
							<button class="btn btn-primary" type="submit"
								data-toggle="tooltip" data-placement="top" title="点击开始">开始上传</button>
							<button class="btn btn-primary" type="reset">重构新资源</button>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<!--记录盒子  -->
		<div class="recordBox move">
			<!-- missioning -->
			<div class="missionRecord">
				<h2>任务进度</h2>
				<div>
					<p>项目</p>
					<p>进度</p>
					<p>状态</p>
				</div>
				<ul>
				</ul>
			</div>
			<!-- missioning -->
			<div class="logRecord">
				<h2>执行日志</h2>
				<span class="clearLog">清除日志<i
					class="glyphicon glyphicon-trash"></i></span>
				<textarea readonly="readonly" class="logBoard" placeholder="还没有日志记录"></textarea>
			</div>
		</div>
		<!--记录盒子  -->
		<!--文件盒子-->
		<div class="fileBoxs"></div>
		<!--/文件盒子-->
	</div>
</body>
<script src="js/jquery/jquery.min.js" type="text/javascript"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/plugins/treeview/bootstrap-treeview.min.js"></script>
<!-- 自定义js -->
<script src="js/content.js?v=1.0.0"></script>
<!-- Sweet alert -->
<script src="js/plugins/sweetalert/sweetalert.min.js"></script>
<script>
	var webSocketUri="<%=serverPath%>webSocketServer";
</script>
<!--流动布局-->
<script src="js/layout/pinterest_grid.js"></script>
<script src="js/admin/addSource.js" type="text/javascript"></script>
<script src="js/admin/seriesAuto.js" type="text/javascript"></script>
<script src="js/websocket.js" type="text/javascript"></script>
<script src="js/move.js" type="text/javascript"></script>
<script src="js/admin/multipleChoice.js" type="text/javascript"></script>
</html>