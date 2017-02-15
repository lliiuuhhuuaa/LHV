<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>登陆中心</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="shortcut icon" href="favicon.ico"> <link href="css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
    <link href="css/font-awesome.min.css?v=4.4.0" rel="stylesheet">

    <link href="css/animate.css" rel="stylesheet">
    <link href="css/style.css?v=4.1.0" rel="stylesheet">
    <style type="text/css">
    	.error{
    		border-color:#F00;
    	}
    </style>
    <!--[if lt IE 9]>
    <meta http-equiv="refresh" content="0;ie.html" />
    <![endif]-->
    <script>if(window.top !== window.self){ window.top.location = window.location;}</script>
</head>

<body class="gray-bg">

    <div class="middle-box text-center loginscreen  animated fadeInDown">
        <div>
            <div style="padding:30px;">
                <h1 class="logo-name"><img alt="logo" src="img/logo3.png"></h1>
            </div>
            <h3>欢迎使用 LHV</h3>

            <form class="m-t" role="form" action="login${requestScope.admin}" method="post">
                <div class="form-group">
                    <input type="text" class="form-control" placeholder="用户名/邮箱/手机号" name="account">
                </div>
                <div class="form-group">
                    <input type="password" class="form-control" placeholder="密码" name="password">
                </div>
                <button type="submit" class="btn btn-primary block full-width m-b">登 录</button>


                <p class="text-muted text-center"> <a href="login.html#"><small>忘记密码了？</small></a> | <a href="register">注册一个新账号</a>
                </p>

            </form>
        </div>
    </div>
    <!-- 全局js -->
    <script src="js/jquery/jquery.min.js?v=2.1.4"></script>
    <script src="js/bootstrap.min.js?v=3.3.6"></script>
    <script src="js/plugins/layer/layer.min.js"></script>
    <c:if test="${not empty requestScope.error}">
		<script type="text/javascript">
			parent.layer.msg("${requestScope.error}");
		</script>
    </c:if>
	<script type="text/javascript">
		$(function(){
			$("form").submit(function(){
				if($("input[name=account]").val()==''){
					parent.layer.msg("账号不能为空");return false;
				}
				if($("input[name=password]").val()==''){
					parent.layer.msg("密码不能为空");return false;
				}
			})
		})
	</script>
  </body>
</html>
