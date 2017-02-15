<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>My JSP 'home.jsp' starting page</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<link rel="stylesheet" href="css/plugins/clock/jquery.hoverclock.2.1.0.css" />
<link href="css/animate.css" rel="stylesheet">
<script src="js/jquery/jquery.min.js"></script>
<style>
	span{
	 -moz-user-select: none;
    -webkit-user-select: none;
    -ms-user-select: none;
    -khtml-user-select: none;
    user-select: none;
	}
</style>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>home</title>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content  animated fadeIn">
	<div style="width:70%;margin:auto;">
		<div id="hoverclock"></div>
	</div>
	</div>
	<script src="js/plugins/clock/jquery.hoverclock.2.1.0.js"></script>
	<script>
		$("#hoverclock").hoverclock({
			"h_width" : "80%",
			"h_height" : "80%",
			//"h_hourNumSize": "80",
			// "h_hourNumRadii": "200",
			// "h_hourNumShow": false,
			// "h_minuteNumShow":false,
			"h_hourNumColor" : "deeppink",
			"h_backColor" : "none",
			// "h_borderColor": "gold",
			//"h_frontColor":"red",
			"h_linkText" : "LHV管理中心欢迎您"
		});
	</script>
</body>
</html>
