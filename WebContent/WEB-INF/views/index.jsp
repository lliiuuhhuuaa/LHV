<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	//聊天服务头
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>LHV视频</title> <link href="css/index.css" rel="stylesheet"
type="text/css">
<style type="text/css">
.wrapper-content {
	background: #EEE;
	padding-bottom: 0;
}

h2 {
	margin: 0;
}

a:link {
	color: #676A6C;
}

.signLine {
	white-space: nowrap;overflow:hidden;text-overflow: ellipsis;
	padding: 3px;
	margin: 0;
	width: 100%;
}

.playNum {
	margin-left: 10px;
	float: left;
	font-size: 15px;
}

.garde {
	margin-right: 10px;
	float: right;
	font-size: 15px;
}

.playNum font, .garde font {
	font-size: 18px;
	padding: 2px;
}

.garde font {
	color: #ED5565;
}

p {
	margin: 5px 0;
}

.decription {
	height: 55px;
	overflow: hidden;
}

.category a {
	color: #F29E50;
}

.col-img {
	padding: 0 5px;
}
</style>
</head>
<body>
	<div class="box">
		<div class="head">
			<div class="big_img_div1 animated fadeIn"></div>
			<div class="big_img_div2 animated fadeOut"></div>
			<div class=""
				style="position: absolute;top:0;left:0;z-index:100;width:100%">
				<!--顶部-->
				<jsp:include page="head.jsp"></jsp:include>
				<!--顶部结束-->
				<!--菜单开始-->
				<nav class="rootMenu">
				<ul>
					<c:forEach items="${applicationScope.category}" var="cate">
						<li><a href="list?searchString=${cate.id}">${cate.name}</a></li>
					</c:forEach>
					<li><a>|</a></li>
					<c:forEach items="${applicationScope.category[0].childs}"
						var="cate">
						<li><a href="list?searchString=${applicationScope.category[0].id}&searchString=${cate.id}">${cate.name}</a></li>
					</c:forEach>
					<li><a>|</a></li>
					<c:forEach items="${applicationScope.category[1].childs}"
						var="cate">
						<li><a href="list?searchString=${applicationScope.category[1].id}&searchString=${cate.id}">${cate.name}</a></li>
					</c:forEach>

				</ul>
				</nav>
				<!--菜单结束-->
			</div>
			<div class="marketingMenu">
				<ul>
					<c:if test="${not empty applicationScope.specialSource}">
						<c:forEach items="${applicationScope.specialSource}" var="source"
							varStatus="s">
							<li data="source/img/superMax/${source.img.id}"
								theme="${source.theme}" class="checked"><a
								href="get_source/${source.source.id}">${source.oneDecript}</a></li>
						</c:forEach>
					</c:if>
				</ul>
			</div>
		</div>
		<!--最新推荐div-->
		<div class="wrapper wrapper-content animated fadeIn">
			<h2>
				最新推荐<small>知人者智,自知者明.胜人者有力,自胜者强.---老子</small>
			</h2>
			<div class="row">
				<c:if test="${not empty applicationScope.source_new}">
					<div class="col-sm-4 item_1">
						<div class="contact-box" style="padding: 10px;">
							<a href="get_source/${applicationScope.source_new[0].id}">
								<div class="col-sm-12 col-img">
									<img alt="image" title="视频预览图" class="m-t-xs"
										src="source/img/max/${applicationScope.source_new[0].img.id}"
										style="width:100%;">
								</div>
								<div class="col-sm-12">
									<h3 class="signLine"
										title="${applicationScope.source_new[0].seriesname!=applicationScope.source_new[0].id?applicationScope.source_new[0].seriesname:applicationScope.source_new[0].name}">
										<strong>${applicationScope.source_new[0].seriesname!=applicationScope.source_new[0].id?applicationScope.source_new[0].seriesname:applicationScope.source_new[0].name}</strong>
										<span style="float:right"><span class="playNum"
											title="点击量"><i class="glyphicon glyphicon-eye-open"></i><font>${applicationScope.source_new[0].log.total_play}</font></span><span
											class="garde" title="评分"><i
												class="glyphicon glyphicon-heart"></i><font>${applicationScope.source_new[0].log.score}</font></span></span>
									</h3>
									<p title="关键字" class="category">
										<strong> <c:forEach
												items="${applicationScope.source_new[0].category}"
												var="cate">
												<a href="list?searchString=${cate.id}">${cate.name}</a>
											</c:forEach>
										</strong>
									</p>
									<p title="视频描述" class="decription">
										<strong>描述：</strong>${applicationScope.source_new[0].decription}</p>
								</div>
								<div class="clearfix"></div>
							</a>
						</div>
					</div>
				</c:if>
				<c:if test="${not empty applicationScope.source_new}">
					<c:forEach items="${applicationScope.source_new}" begin="1"
						var="source">
						<div class="col-sm-2 item_2">
							<div class="contact-box">
								<a href="get_source/${source.id}">
									<div class="col-sm-12 col-img">
										<div class="text-center">
											<img alt="image" title="视频预览图" class="m-t-xs img-responsive"
												src="source/img/min/${source.img.id}">
										</div>
									</div>
									<div class="col-sm-12">
										<div class="text-center">
											<h3 class="signLine"
												title="${source.seriesname!=source.id?source.seriesname:source.name}">
												<strong>${source.seriesname!=source.id?source.seriesname:source.name}</strong>
											</h3>
											<p>
												<span class="playNum" title="点击量"><i
													class="glyphicon glyphicon-eye-open"></i><font>${source.log.total_play}</font></span><span
													class="garde" title="评分"><i
													class="glyphicon glyphicon-heart"></i><font>${source.log.score}</font></span>
											</p>
										</div>
									</div>
									<div class="clearfix"></div>
								</a>
							</div>
						</div>
					</c:forEach>
				</c:if>

				<!--推荐结束-->
			</div>
		</div>
		<!--最新推荐div结束-->
		<!--电影推荐div-->
		<div class="wrapper wrapper-content animated fadeIn">
			<a href="list?searchString=${applicationScope.category[0].id}"><h2 title="更多">
					电影推荐<small>书到用时方恨少,事非经过不知难.---陆游</small>
				</h2></a>
			<div class="row">
				<c:if test="${not empty applicationScope.source_movie}">
					<div class="col-sm-4 item_1">
						<div class="contact-box" style="padding: 10px;">
							<a href="get_source/${applicationScope.source_movie[0].id}">
								<div class="col-sm-12 col-img">
									<img alt="image" title="视频预览图" class="m-t-xs"
										src="source/img/max/${applicationScope.source_movie[0].img.id}"
										style="width:100%;">
								</div>
								<div class="col-sm-12">
									<h3 class="signLine"
										title="${applicationScope.source_movie[0].seriesname!=applicationScope.source_movie[0].id?applicationScope.source_movie[0].seriesname:applicationScope.source_movie[0].name}">
										<strong>${applicationScope.source_movie[0].seriesname!=applicationScope.source_movie[0].id?applicationScope.source_movie[0].seriesname:applicationScope.source_movie[0].name}</strong>
										<span style="float:right"><span class="playNum"
											title="点击量"><i class="glyphicon glyphicon-eye-open"></i><font>${applicationScope.source_movie[0].log.total_play}</font></span><span
											class="garde" title="评分"><i
												class="glyphicon glyphicon-heart"></i><font>${applicationScope.source_movie[0].log.score}</font></span></span>
									</h3>
									<p title="关键字" class="category">
										<strong> <c:forEach
												items="${applicationScope.source_movie[0].category}"
												var="cate">
												<a href="list?searchString=${cate.id}">${cate.name}</a>
											</c:forEach>
										</strong>
									</p>
									<p title="视频描述" class="decription">
										<strong>描述：</strong>${applicationScope.source_movie[0].decription}</p>
								</div>
								<div class="clearfix"></div>
							</a>
						</div>
					</div>
				</c:if>
				<c:if test="${not empty applicationScope.source_movie}">
					<c:forEach items="${applicationScope.source_movie}" begin="1"
						var="source">
						<div class="col-sm-2 item_2">
							<div class="contact-box">
								<a href="get_source/${source.id}">
									<div class="col-sm-12 col-img">
										<div class="text-center">
											<img alt="image" title="视频预览图" class="m-t-xs img-responsive"
												src="source/img/min/${source.img.id}">
										</div>
									</div>
									<div class="col-sm-12">
										<div class="text-center">
											<h3 class="signLine"
												title="${source.seriesname!=source.id?source.seriesname:source.name}">
												<strong>${source.seriesname!=source.id?source.seriesname:source.name}</strong>
											</h3>
											<p>
												<span class="playNum" title="点击量"><i
													class="glyphicon glyphicon-eye-open"></i><font>${source.log.total_play}</font></span><span
													class="garde" title="评分"><i
													class="glyphicon glyphicon-heart"></i><font>${source.log.score}</font></span>
											</p>
										</div>
									</div>
									<div class="clearfix"></div>
								</a>
							</div>
						</div>
					</c:forEach>
				</c:if>
			</div>
		</div>
		<!--电影推荐div结束-->
		<!--电视剧推荐div-->
		<div class="wrapper wrapper-content animated fadeIn teleplay_div">
			<a href="list?searchString=${applicationScope.category[1].id}"><h2 title="更多">
					电视剧推荐<small>决定一个人的一生,以及整个命运的,只是一瞬之间.---歌德</small>
				</h2></a>
			<div class="row">
				<c:if test="${not empty applicationScope.source_teleplay}">
					<div class="col-sm-4 item_1">
						<div class="contact-box" style="padding: 10px;">
							<a href="get_source/${applicationScope.source_teleplay[0].id}">
								<div class="col-sm-12 col-img">
									<img alt="image" title="视频预览图" class="m-t-xs"
										data-src="source/img/max/${applicationScope.source_teleplay[0].img.id}"
										style="width:100%;">
								</div>
								<div class="col-sm-12">
									<h3 class="signLine"
										title="${applicationScope.source_teleplay[0].seriesname!=applicationScope.source_teleplay[0].id?applicationScope.source_teleplay[0].seriesname:applicationScope.source_teleplay[0].name}">
										<strong>${applicationScope.source_teleplay[0].seriesname!=applicationScope.source_teleplay[0].id?applicationScope.source_teleplay[0].seriesname:applicationScope.source_teleplay[0].name}</strong>
										<span style="float:right"><span class="playNum"
											title="点击量"><i class="glyphicon glyphicon-eye-open"></i><font>${applicationScope.source_teleplay[0].log.total_play}</font></span><span
											class="garde" title="评分"><i
												class="glyphicon glyphicon-heart"></i><font>${applicationScope.source_teleplay[0].log.score}</font></span></span>
									</h3>
									<p title="关键字" class="category">
										<strong> <c:forEach
												items="${applicationScope.source_teleplay[0].category}"
												var="cate">
												<a href="list?searchString=${cate.id}">${cate.name}</a>
											</c:forEach>
										</strong>
									</p>
									<p title="视频描述" class="decription">
										<strong>描述：</strong>${applicationScope.source_teleplay[0].decription}</p>
								</div>
								<div class="clearfix"></div>
							</a>
						</div>
					</div>
				</c:if>
				<c:if test="${not empty applicationScope.source_teleplay}">
					<c:forEach items="${applicationScope.source_teleplay}" begin="1"
						var="source">
						<div class="col-sm-2 item_2">
							<div class="contact-box">
								<a href="get_source/${source.id}">
									<div class="col-sm-12 col-img">
										<div class="text-center">
											<img alt="image" title="视频预览图" class="m-t-xs img-responsive"
												data-src="source/img/min/${source.img.id}">
										</div>
									</div>
									<div class="col-sm-12">
										<div class="text-center">
											<h3 class="signLine"
												title="${source.seriesname!=source.id?source.seriesname:source.name}">
												<strong>${source.seriesname!=source.id?source.seriesname:source.name}</strong>
											</h3>
											<p>
												<span class="playNum" title="点击量"><i
													class="glyphicon glyphicon-eye-open"></i><font>${source.log.total_play}</font></span><span
													class="garde" title="评分"><i
													class="glyphicon glyphicon-heart"></i><font>${source.log.score}</font></span>
											</p>
										</div>
									</div>
									<div class="clearfix"></div>
								</a>
							</div>
						</div>
					</c:forEach>
				</c:if>
			</div>
		</div>
		<!--电视剧推荐div结束-->
		<!--动漫推荐div-->
		<div class="wrapper wrapper-content animated fadeIn cartoon_div">
			<a href="list?searchString=${applicationScope.category[2].id}"><h2 title="更多">
					动漫推荐<small>生命不可能有两次,但许多人连一次也不善于度过.---吕凯特</small>
				</h2></a>
			<div class="row">
				<c:if test="${not empty applicationScope.source_cartoon}">
					<div class="col-sm-4 item_1">
						<div class="contact-box" style="padding: 10px;">
							<a href="get_source/${applicationScope.source_cartoon[0].id}">
								<div class="col-sm-12 col-img">
									<img alt="image" title="视频预览图" class="m-t-xs"
										data-src="source/img/max/${applicationScope.source_cartoon[0].img.id}"
										style="width:100%;">
								</div>
								<div class="col-sm-12">
									<h3 class="signLine"
										title="${applicationScope.source_cartoon[0].seriesname!=applicationScope.source_cartoon[0].id?applicationScope.source_cartoon[0].seriesname:applicationScope.source_cartoon[0].name}">
										<strong>${applicationScope.source_cartoon[0].seriesname!=applicationScope.source_cartoon[0].id?applicationScope.source_cartoon[0].seriesname:applicationScope.source_cartoon[0].name}</strong>
										<span style="float:right"><span class="playNum"
											title="点击量"><i class="glyphicon glyphicon-eye-open"></i><font>${applicationScope.source_cartoon[0].log.total_play}</font></span><span
											class="garde" title="评分"><i
												class="glyphicon glyphicon-heart"></i><font>${applicationScope.source_cartoon[0].log.score}</font></span></span>
									</h3>
									<p title="关键字" class="category">
										<strong> <c:forEach
												items="${applicationScope.source_cartoon[0].category}"
												var="cate">
												<a href="list?searchString=${cate.id}">${cate.name}</a>
											</c:forEach>
										</strong>
									</p>
									<p title="视频描述" class="decription">
										<strong>描述：</strong>${applicationScope.source_cartoon[0].decription}</p>
								</div>
								<div class="clearfix"></div>
							</a>
						</div>
					</div>
				</c:if>
				<c:if test="${not empty applicationScope.source_cartoon}">
					<c:forEach items="${applicationScope.source_cartoon}" begin="1"
						var="source">
						<div class="col-sm-2 item_2">
							<div class="contact-box">
								<a href="get_source/${source.id}">
									<div class="col-sm-12 col-img">
										<div class="text-center">
											<img alt="image" title="视频预览图" class="m-t-xs img-responsive"
												data-src="source/img/min/${source.img.id}">
										</div>
									</div>
									<div class="col-sm-12">
										<div class="text-center">
											<h3 class="signLine"
												title="${source.seriesname!=source.id?source.seriesname:source.name}">
												<strong>${source.seriesname!=source.id?source.seriesname:source.name}</strong>
											</h3>
											<p>
												<span class="playNum" title="点击量"><i
													class="glyphicon glyphicon-eye-open"></i><font>${source.log.total_play}</font></span><span
													class="garde" title="评分"><i
													class="glyphicon glyphicon-heart"></i><font>${source.log.score}</font></span>
											</p>
										</div>
									</div>
									<div class="clearfix"></div>
								</a>
							</div>
						</div>
					</c:forEach>
				</c:if>
			</div>
		</div>
		<!--动漫推荐div结束-->
	</div>
	<div class="foot" style="background-color:#eee">
		<p style="margin:0;">
			Copyright © 1998 - 2016 Liuhua. All Rights Reserved.<br /> 六画公司 版权所有
			六画网络文化经营许可证
		</p>
	</div>
	<jsp:include page="loginModal.jsp"></jsp:include>
</body>
<script src="js/index.js" type="text/javascript"></script>
<script src="js/plugins/layer/layer.min.js"></script>
<script src="js/content.js?v=1.0.0"></script>
<script>
	$(document).ready(function() {
		$('.contact-box').each(function() {
			animationHover(this, 'pulse');
		});
	});
</script>
</html>