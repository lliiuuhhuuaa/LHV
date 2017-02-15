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
<link href="css/plugins/treeview/bootstrap-treeview.min.css" rel="stylesheet">
<!-- jqgrid-->
<link href="css/plugins/jqgrid/ui.jqgrid.css?0820" rel="stylesheet">
<!-- Sweet Alert -->
<link href="css/plugins/sweetalert/sweetalert.css" rel="stylesheet">
<link rel="stylesheet" href="css/admin/multipleChoice.css">
<style type="text/css">
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
<script src="js/admin/multipleChoice.js" type="text/javascript"></script>
<script src="js/admin/userManage.js" type="text/javascript"></script>
<script type="text/javascript">
	var userId ="${sessionScope.user.id}";
</script>
</html>
