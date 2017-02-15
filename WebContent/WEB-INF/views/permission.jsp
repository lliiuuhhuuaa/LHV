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

<title>权限查看</title>

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
<!-- jqGrid -->
<script src="js/plugins/jqgrid/i18n/grid.locale-cn.js?0820"></script>
<script src="js/plugins/jqgrid/jquery.jqGrid.min.js?0820"></script>
<!-- 自定义js -->
<!-- Bootstrap-Treeview plugin javascript -->
<script type="text/javascript">
	/**
 * 六画
 * 权限查看
 */
$(function() {
	$.jgrid.defaults.styleUI = 'Bootstrap';
	$("#table_list").jqGrid({
		url : "json/list/permission",
		contentType : 'application/json',
		mtype : "post",
		datatype : "json",
		prmNames : {
			search : "search"
		},
		jsonReader : {
			sourcedata : "sourcedata"
		},
		height : "auto",
		autowidth : true,
		shrinkToFit : true,
		rownumbers : true,
		rownumWidth : 40,
		rowNum : 15,
		rowList : [ 10, 15, 20, 30 ],
		colNames : [ 'id', '权限名称', '权限描述'],
		colModel : [
				{
					name : 'id',
					index : 'id',
					hidden : true
				},{
					name : 'name',
					index : 'name',
					editable : true,
					width : 50,
					sorttype : "string",
					search : true,
					searchoptions : {
					sopt : [ 'eq', 'ne', 'bw', 'bn', 'ew', 'en',
							'cn', 'nc' ]
					}
				},{
					name : 'decription',
					index : 'decription',
					editable : true,
					width : 50,
					sorttype : "string",
					search : true,
					searchoptions : {
					sopt : [ 'eq', 'ne', 'bw', 'bn', 'ew', 'en',
								'cn', 'nc' ]
					}
				}],
		pager : "#pager_list",
		viewrecords : true,
		caption : "权限查看",
		add : true,
		edit : true,
		addtext : 'Add',
		edittext : 'Edit',
		hidegrid : true
	});
	// Add selection
	$("#table_list").setSelection(4, true);

	// Setup buttons
	$("#table_list").jqGrid('navGrid', '#pager_list', {
		edit : false,
		add : false,
		del : false,
		search : true
	}, {
		height : 200,
		reloadAfterSubmit : true
	});
	// Add responsive to jqGrid
	$(window).bind('resize', function() {
		var width = $('.jqGrid_wrapper').width();
		$('#table_list').setGridWidth(width);
	});
})
</script>
</html>
