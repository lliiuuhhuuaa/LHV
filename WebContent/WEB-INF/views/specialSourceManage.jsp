<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
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
<link href="css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
<link href="css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
<link href="css/animate.css" rel="stylesheet">
<link href="css/style.css?v=4.1.0" rel="stylesheet">
<!-- jqgrid-->
<link href="css/plugins/jqgrid/ui.jqgrid.css?0820" rel="stylesheet">
<!-- Sweet Alert -->
<link href="css/plugins/sweetalert/sweetalert.css" rel="stylesheet">
 <link href="css/plugins/colorpicker/css/bootstrap-colorpicker.min.css" rel="stylesheet">
<style type="text/css">
/* 自动填充 */
.autoComplate{
	background:#FFF;
	position:absolute;
	z-index:100000;
	top:32px;
	width:80%;
	display:none;
}
.autoComplate a{
	height:40px;
	line-height:20px;
	vertical-align: middle;
}
.autoComplate a:hover{
	/* background:#337AB7;
	color:#FFF; */
	cursor:pointer;
}
.autoComplate p{
	border:1px solid #CCCCCC;
	height:25px;
	line-height:25px;
	text-align:right;
	font-size:15px;
	padding:0 10px;margin:0;
}
.fileBox,.missionRecord{
	display:none;
}
.missionRecord li{
	list-style:none;
}
.sign.success{
	color:#5CB85C;
}
.sign.failed{
	color:#D9534F;
}
.selectFile{
	overflow:hidden;
}
.cancalPlan{
	text-align:center;
	display:none;
}
img.img{
	width:30px;
	margin:5px auto;
	cursor:pointer;
}
img.img.active{
	width:380px;
}
</style>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content  animated fadeInRight">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox ">
					<div class="ibox-content">
						<div class="jqGrid_wrapper">
							<table id="table_list"></table>
							<div id="pager_list"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="modal inmodal" id="editModal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content animated flipInY">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
				</button>
				<h4 class="modal-title">资源更新</h4>
        </div>
			<div class="modal-body">
                  <ul class="missionRecord animated">
					<li class="formPlan" data-type="form">基本数据(<span class="sign">准备提交</span>)
						<div class="progress progress-striped active">
                            <div style="width:0%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="75" role="progressbar" class="progress-bar progress-bar-danger">
                                <span class="sr-only">40% Complete (success)</span>
                            </div>
                        </div>
					</li>
					<li class="picPlan" data-type="pic">缩略图(<span class="sign">准备提交</span>)
						<div class="progress progress-striped active">
                            <div style="width:0%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="75" role="progressbar" class="progress-bar progress-bar-danger">
                                <span class="sr-only">40% Complete (success)</span>
                            </div>
                        </div><!-- <span class="sign"><i>0</i>%</span> -->
					</li>
					<li class="cancalPlan"><button class="btn btn-warning">我知道出错了</button></li>
				  </ul>
					<form id="sourceInforForm" method="post" autocomplete="off" class="animated">
					<table class="table">
						<input type="hidden" id="id" name="id"/>
					<tr>
						<td>
						<div class="input-group" data-toggle="popover" data-placement="top" data-content="资源不能为空">
							<span class="input-group-addon">资源名称</span>
								<input type="hidden" id="source_id" name="source.id"/>
								<input class="form-control seriesname sourcename" type="text" placeholder="输入关键字搜索" data-toggle="tooltip"
									data-placement="top" onkeydown='if(event.keyCode==13) return false;'>
							<div class="list-group autoComplate">
								<p>查询结果：总&nbsp;<strong><span class="searcRresult">0</span></strong>&nbsp;条记录</p>
							</div>
						</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="input-group">
								<div class="input-group-addon">迷之介绍</div>
								<input type="text" class="form-control" placeholder="填写一句话描述"
									name="oneDecript" data-toggle="tooltip" data-placement="top" />
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<!-- <div class="input-group">
								<div class="input-group-addon">周边主题</div>
								<input type="text" class="form-control" placeholder="填写资源名称，显示的名称[例:1集]"
									name="name" data-toggle="tooltip" data-placement="top" />
									
							</div> -->
							<div class="input-group">
								<div class="input-group-addon">周边主题</div>
								<input type="text" class="form-control colorpicker" placeholder="选择适合图片上面显示的文本颜色"
									name="theme" data-toggle="tooltip" data-placement="top" style="z-index:1"/>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<img class="img">
							<div class="input-group">
								<div class="input-group-addon">展&ensp;示&ensp;图</div>
								<button class="form-control selectFile imgfile" type="button"
									data-type="pic">点击选择文件</button>
							</div>
						</td>
					</tr>
					<tr>
						<td style="text-align: center">
							<button class="btn btn-primary" type="submit"
								data-toggle="tooltip" data-placement="top" title="点击开始">更新到数据库</button>
							<button class="btn btn-primary" type="button" data-dismiss="modal">关闭</button>
						</td>
					</tr>
				</table>
			</form>
		</div>
		</div>
	</div>
	</div>
<div class="fileBoxs"></div>
</body>
<script src="js/jquery/jquery.min.js?v=2.1.4"></script>
<script src="js/bootstrap.min.js?v=3.3.6"></script>
<!-- Peity -->
<script src="js/plugins/peity/jquery.peity.min.js"></script>

<!-- jqGrid -->
<script src="js/plugins/jqgrid/i18n/grid.locale-cn.js?0820"></script>
<script src="js/plugins/jqgrid/jquery.jqGrid.min.js?0820"></script>
<!-- 自定义js -->
<script src="js/content.js?v=1.0.0"></script>
<!-- Sweet alert -->
<script src="js/plugins/sweetalert/sweetalert.min.js"></script>
<!-- Bootstrap-Treeview plugin javascript -->
<script src="js/admin/specialSourceManage.js" type="text/javascript"></script>
<script src="js/admin/seriesAuto.js" type="text/javascript"></script>
<script src="js/md5/spark-md5.min.js" type="text/javascript"></script>
<!-- Color picker -->
 <script src="js/plugins/colorpicker/bootstrap-colorpicker.min.js"></script>
</html>
