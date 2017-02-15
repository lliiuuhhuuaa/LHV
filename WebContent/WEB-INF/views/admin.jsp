
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.liuhua.com" prefix="mt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	//聊天服务头
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>后台管理</title>
<!-- Tell the browser to be responsive to screen width -->
<meta
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
	name="viewport">
	<link rel="shortcut icon" href="favicon.ico">
	<link href="css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
    <link href="css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
    <link href="css/animate.css" rel="stylesheet">
    <link href="css/style.css?v=4.1.0" rel="stylesheet">
    <style type="text/css">
    	.logout{
    		color:#555 !important;
    	}
    	.logout:hover{
    		color:#E00 !important;
    	}
    	.searchResult{
    		position:absolute;top:65px;width:100%;background:#FFF;
    		padding:10px;display:none;
    	}
    	.searchResult a{
    		padding:10px;font-size:15px;
    	}
    	.searchResult p{
    		position:absolute;
    		top:5px;right:10px;font-size:20px;
    	}
    	.searchResult p:hover{
    		color:#F00;cursor:pointer;
    	}
    </style>
</head>

<body class="fixed-sidebar full-height-layout gray-bg"
	style="overflow:hidden">
	<div id="wrapper">
		<!--左侧导航开始-->
		<nav class="navbar-default navbar-static-side" role="navigation">
		<div class="nav-close">
			<i class="fa fa-times-circle"></i>
		</div>
		<div class="sidebar-collapse">
			<ul class="nav" id="side-menu">
				<li class="nav-header">
					<div class="dropdown profile-element">
						<a data-toggle="dropdown" class="dropdown-toggle" href="#"> <span
							class="clear"> <span class="block m-t-xs"
								style="font-size:20px;"><img src="img/logo.png" style="width:150px">
							</span>
						</span>
						</a>
						<div><span style="float:left;line-height:30px;">欢迎您:</span><div style='font-size:20px;color:#869FB1;max-width:85px;overflow:hidden;height:30px;float:left' title="${user.nickname!=null?user.nickname:user.username}">${user.nickname!=null?user.nickname:user.username}</div> <a href="logout" class="logout" style="float:left;line-height:30px;">退出</a></div>
						<span style="clear:both;"></span>
					</div>
					<div class="logo-element" style="background:#1C2B36;"><img src="img/logo-min.png"></div>
				</li>
				<li class="hidden-folded padder m-t m-b-sm text-muted text-xs">
					<br/>
				</li>
				<li><a class="J_menuItem" href="home"> <i
						class="fa fa-home"></i> <span class="nav-label">主页</span>
				</a></li>
				<!-- <li><a href="#"> <i class="fa fa fa-bar-chart-o"></i> <span
						class="nav-label">统计图表</span> <span class="fa arrow"></span>
				</a>
					<ul class="nav nav-second-level">
						<li><a class="J_menuItem" href="graph_echarts.html">百度ECharts</a>
						</li>
					</ul></li> -->
				<li class="line dk"></li>
				<li class="hidden-folded padder m-t m-b-sm text-muted text-xs">
					<span class="ng-scope">管理</span>
				</li>
				<mt:isshow var="SelectUser">
				<li><a  href="#"><i class="fa fa-users"></i> <span
						class="nav-label">用户管理</span><span class="fa arrow"></span></a>
					<ul class="nav nav-second-level">
						<li><a class="J_menuItem"  href="userManage">用户管理</a>
						</li>
						<li><a class="J_menuItem"  href="headPortrait">默认头像管理</a>
						</li>
					</ul></li>
				</mt:isshow>
				<mt:isshow var="SelectCategory">
				<li><a class="J_menuItem"  href="allCategory"> <i
						class="fa fa-recycle"></i> <span class="nav-label">分类管理</span>
				</a></li>
				</mt:isshow>
				<li><a  href="#"><i class="fa fa-file"></i> <span
						class="nav-label">资源管理</span><span class="fa arrow"></span></a>
					<ul class="nav nav-second-level">
						<mt:isshow var="SelectSource">
						<li><a class="J_menuItem"  href="sourceManage">管理资源</a>
						</li>
						<li><a class="J_menuItem"  href="specialSourceManage">管理展示资源</a>
						</li>
						</mt:isshow>
						<mt:isshow var="AddSource">
						<li><a class="J_menuItem"  href="uploadSource">上传资源</a>
						</li></mt:isshow>
						<mt:isshow var="LocalScan">
						<li><a class="J_menuItem"  href="uploadSource2">批量添加资源</a>
						</li> </mt:isshow>
						<mt:isshow var="UtilsUsed">
						<li><a class="J_menuItem"  href="utils/mission">管理小工具</a></li></mt:isshow>
						</ul></li>
                    <li>
                        <a href="#"><i class="fa fa-hand-paper-o"></i> <span class="nav-label">权限管理</span><span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                        	<mt:isshow var="SelectUser,SelectRole">
                            <li><a class="J_menuItem"  href="manager">管理员维护</a>
                            </li></mt:isshow>
                            <mt:isshow var="SelectRole">
                            <li><a class="J_menuItem"  href="role">角色维护</a>
                            </li></mt:isshow>
                            <mt:isshow var="SelectJurisdiction">
                            <li><a class="J_menuItem"  href="permission">查看权限</a>
                            </li></mt:isshow>
                        </ul>
                    </li>

                </ul>
            </div>
		</nav>
		<!--左侧导航结束-->
		<!--右侧部分开始-->
		<div id="page-wrapper" class="gray-bg dashbard-1">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top" role="navigation"
					style="margin-bottom: 0">
				<div class="navbar-header">
					<a class="navbar-minimalize minimalize-styl-2 btn btn-info "
						href="javascript:void(0)"><i class="fa fa-bars"></i> </a>
					<form role="search" class="navbar-form-custom" method="post" onsubmit="return false">
						<div class="form-group">
							<input type="text" id="searchInput" placeholder="输入关键字搜索功能"
								class="form-control" name="top-search" id="top-search">
						</div>
					</form>
				</div>
				<div class="searchResult">
					<p class="colseSearchResult"><i class="fa fa-close"></i></p>
				</div>
				<!-- <ul class="nav navbar-top-links navbar-right">
					<li class="dropdown"><a class="dropdown-toggle count-info"
						data-toggle="dropdown" href="#"> <i class="fa fa-envelope"></i>
							<span class="label label-warning">16</span>
					</a>
						<ul class="dropdown-menu dropdown-messages">
							<li class="m-t-xs">
								<div class="dropdown-messages-box">
									<a href="profile.html" class="pull-left"> <img alt="image"
										class="img-circle" src="img/a7.jpg">
									</a>
									<div class="media-body">
										<small class="pull-right">46小时前</small> <strong>小四</strong>
										是不是只有我死了,你们才不骂爵迹 <br> <small class="text-muted">3天前
											2014.11.8</small>
									</div>
								</div>
							</li>
							<li class="divider"></li>
							<li>
								<div class="dropdown-messages-box">
									<a href="profile.html" class="pull-left"> <img alt="image"
										class="img-circle" src="img/a4.jpg">
									</a>
									<div class="media-body ">
										<small class="pull-right text-navy">25小时前</small> <strong>二愣子</strong>
										呵呵 <br> <small class="text-muted">昨天</small>
									</div>
								</div>
							</li>
							<li class="divider"></li>
							<li>
								<div class="text-center link-block">
									<a class="J_menuItem" href="mailbox.html"> <i
										class="fa fa-envelope"></i> <strong> 查看所有消息</strong>
									</a>
								</div>
							</li>
						</ul></li>
					<li class="dropdown"><a class="dropdown-toggle count-info"
						data-toggle="dropdown" href="#"> <i class="fa fa-bell"></i> <span
							class="label label-primary">8</span>
					</a>
						<ul class="dropdown-menu dropdown-alerts">
							<li><a href="mailbox.html">
									<div>
										<i class="fa fa-envelope fa-fw"></i> 您有16条未读消息 <span
											class="pull-right text-muted small">4分钟前</span>
									</div>
							</a></li>
							<li class="divider"></li>
							<li><a href="profile.html">
									<div>
										<i class="fa fa-qq fa-fw"></i> 3条新回复 <span
											class="pull-right text-muted small">12分钟钱</span>
									</div>
							</a></li>
							<li class="divider"></li>
							<li>
								<div class="text-center link-block">
									<a class="J_menuItem" href="notifications.html"> <strong>查看所有
									</strong> <i class="fa fa-angle-right"></i>
									</a>
								</div>
							</li>
						</ul></li>
				</ul> -->
				</nav>
			</div>
			<div class="row J_mainContent" id="content-main">
				<iframe id="J_iframe" width="100%" height="100%"
					src="home" frameborder="0" data-id="home" name="iframe"
					seamless></iframe>
			</div>
		</div>
		<!--右侧部分结束-->
	</div>

	<!-- 全局js -->
	<script src="js/jquery/jquery.min.js?v=2.2.2"></script>
	<script src="js/bootstrap.min.js?v=3.3.6"></script>
	<script src="js/admin/map.js"></script>
	<script src="js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<script src="js/plugins/layer/layer.min.js"></script>
	<!-- 自定义js -->
	<script src="js/hAdmin.js?v=4.1.0"></script>
	<!-- 第三方插件 -->
	<script src="js/plugins/pace/pace.min.js"></script>
	<script type="text/javascript">
	$(function(){
    //菜单点击
    $(".J_menuItem").on('click',function(){
        var url = $(this).attr('href');
        $("#J_iframe").attr('src',url);
        return false;
    });
    $(function(){
	    //将菜单放入到map，用于菜单搜索
		var menu = new Map();
		var menuSpans = $(".J_menuItem");
		for(var i=0;i<menuSpans.length;i++){
			menu.put($(menuSpans[i]).html(), menuSpans[i])
		}
		$("#searchInput").keyup(function(e){
			$(".searchResult a").remove();
			var value = this.value;
			if(value==''){
				$(".searchResult").hide();return;
			}
			var result = menu.likeKey(value);
			if(result.length>0){
				$(".searchResult").show();
				for(var i=0;i<result.length;i++){
					$(".searchResult").append($($(result[i]).parent().html()).attr("target","iframe"));
				}
			}
		})
		$(".colseSearchResult").click(function(){
			$(".searchResult a").remove();
			$(".searchResult").hide();
		})
	})
});
	</script>
</body>