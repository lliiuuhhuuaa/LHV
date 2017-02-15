<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>注册账号</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	 <link rel="shortcut icon" href="favicon.ico"> <link href="css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
    <link href="css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
    <link href="css/plugins/iCheck/custom.css" rel="stylesheet">
    <link href="css/animate.css" rel="stylesheet">
    <link href="css/style.css?v=4.1.0" rel="stylesheet">
    <script>if(window.top !== window.self){ window.top.location = window.location;}</script>
	<style type="text/css">
		.checkbox i{
			 -moz-user-select: none;
		    -webkit-user-select: none;
		    -ms-user-select: none;
		    -khtml-user-select: none;
		    user-select: none;
		}
		.username-error{
			/* position:absolute;right:0;top:0; */
			display:none;
			color:#F00;
		}
		.password-error{
			/* position:absolute;right:0;top:0; */
			display:none;
			color:#F00;
		}
		.error{
			border-color:#F00;
		}
	</style>
</head>

<body class="gray-bg">
	<form:errors path="user.username" cssClass="username-error"/>
	<form:errors path="user.password" cssClass="password-error"/>
    <div class="middle-box text-center loginscreen   animated fadeInDown">
        <div>
            <div style="padding:30px;">
 				<h1 class="logo-name"><img alt="logo" src="img/logo3.png"></h1>
            </div>
            <h3>欢迎注册 LHV</h3>
            <p>创建一个LH新账户</p>
            <form class="m-t" role="form" action="register" method="post" modelAttribute="user">
                <div class="form-group" style="position:relative">
                    <input type="text" class="form-control" placeholder="请输入用户名" name="username" value="${user.username}">

                </div>
                <div class="form-group" style="position:relative">
                    <input type="password" class="form-control" placeholder="请输入密码" name="password">
                </div>
                <div class="form-group">
                    <input type="password" class="form-control" placeholder="请再次输入密码" name="password2">
                </div>
                <div class="form-group text-left">
                    <div class="checkbox i-checks">
                        <label class="no-padding">
                            <input type="checkbox" checked><i> 我同意注册协议</i></label>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary block full-width m-b">注 册</button>

                <p class="text-center"><small>已经有账户了？</small><a href="login">点此登录</a>
                </p>
            </form>
        </div>
    </div>
	
    <!-- 全局js -->
    <script src="js/jquery/jquery.min.js?v=2.1.4"></script>
    <script src="js/bootstrap.min.js?v=3.3.6"></script>
    <script src="js/plugins/layer/layer.min.js"></script>
    <!-- iCheck -->
    <script src="js/plugins/iCheck/icheck.min.js"></script>
    <script>
        $(document).ready(function () {
            $('.i-checks').iCheck({
                checkboxClass: 'icheckbox_square-green',
                radioClass: 'iradio_square-green',
            });
            $('.i-checks').on("ifClicked",function(event){
            	 if($(".checkbox div").hasClass("checked")){
            	 	$("button[type=submit]").addClass("disabled");
            	 }else{
            	 	$("button[type=submit]").removeClass("disabled");
            	 }
			})
			$("input").focus(function(){
				$(this).popover("destroy");
				$(this).removeClass("error");
			})
			var isIng = false;
			$("form").submit(function(){
				if($("button[type=submit]").hasClass("disabled"))return false;
				if(isIng)return false;
				isIng = true;
				var ispass = true;
				var username = $("input[name=username]")[0];
				if(username.value==""){
					tooltip('用户名不能为空', username);
					ispass=false;
				}else if(username.value.length<5||username.value.length>15){
					tooltip('用户名长度需在5-15位', username);
					ispass=false;
				}
				var password = $("input[name=password]")[0];
				if(password.value==''){
					tooltip('密码不能为空', password);
					ispass=false;
				}else if(password.value.length<6||password.value.length>20){
					tooltip('密码长度需在6-20位', password);
					ispass=false;
				}
				var password2 = $("input[name=password2]")[0];
				if(password2.value==''){
					tooltip('密码不能为空', password2);
					ispass=false;
				}else if(password.value!=password2.value){
					tooltip('两次密码输入不一致', password2);
					ispass=false;
				}
				isIng=false;
				if(!ispass)return false;
			})
			var ur = "${requestScope.error}"==""?$(".username-error").html():"${requestScope.error}";
			var pr = $(".password-error").html();
			if(ur!=undefined){
				tooltip(ur,$("input[name=username]"));
			}
			if(pr!=undefined){
				tooltip(pr,$("input[name=password]"));
			}
			$("input[name=username]").change(function(){
				var _this = this;
				if(this.value!=null){
					$.post("json/checkIsExist","type=username&value="+this.value,function(data) { // 此处可以
						data = eval("("+data+")");
						if(data.message){
							tooltip("用户名已经被使用",_this);
						}
					})
				}
			})
        });
        //工具提示
        function tooltip(text,el){
        	if(text=='')return;
        	$(el).attr("data-content",text).attr("data-toggle","popover").attr("data-placement","top");
        	$(el).popover("show");
        		$(el).addClass("error")
        	/* setTimeout(function(){
        		$(el).popover("destroy");
        	},3000) */
        }
    </script>

  </body>
</html>
