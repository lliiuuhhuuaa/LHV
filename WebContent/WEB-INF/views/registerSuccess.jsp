<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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

<title>${requestScope.updateUser?'更新资料':'注册成功'}</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<link rel="shortcut icon" href="favicon.ico">
<link href="css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
<link href="css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
<link href="css/plugins/steps/jquery.steps.css" rel="stylesheet">
<link href="css/animate.css" rel="stylesheet">
<!--图片裁剪-->
<link href="css/plugins/cropper/cropper.min.css" rel="stylesheet">
<link href="css/style.css?v=4.1.0" rel="stylesheet">
<style type="text/css">
	body,.ibox-content{
		background-color:#DDD;
	}
	.lover li{
		list-style:none;
		background:#FFF;
		height:30px;width:auto;
		line-height:30px;
		width:60px;
		text-align:center;
		float:left;
		margin:10px;
		overflow:hidden;
		border-radius:5px;
		-moz-user-select: none;
	    -webkit-user-select: none;
	    -ms-user-select: none;
	    -khtml-user-select: none;
	    user-select: none;
	}
	.lover li:hover{
		background:#6FD1BD;
		color:#FFF;
		cursor:pointer;
	}
	.lover li.selected{
		background:#1AB394;
		color:#FFF;
	}
	.head-img{
		border:1px solid #EEE;
		width:100%;
		max-width:200px;
	}
	.system_img{
		max-height:250px;
		overflow:auto;
		 -webkit-box-shadow: 0 0 5px #000;
	    -moz-box-shadow: 0 0 5px #000;
	    box-shadow: 0 0 5px #000;
	}
	.system_img li{
		float:left;
		list-style: none;
		width:31%;
		margin:0.5%;
		background:none;
		border:2px solid none;
	}
	.system_img li img{
		width:100%;
		background:none;
	}
	.system_img li.active{
		-webkit-box-shadow: 0 0 5px #1AB394;
	    -moz-box-shadow: 0 0 5px #1AB394;
	    box-shadow: 0 0 5px #1AB394;
		border:2px solid #1AB394;
	}
	.s_img:hover{
		border:2px solid #999;
		cursor:pointer;
	}
</style>
</head>

<body>
	<div class="ibox-content">
		<div style="text-align:center;">
			<div style="padding:30px;">
	 				<h1 class="logo-name"><img alt="logo" src="img/logo3.png"></h1>
	            </div>
			<h1>${requestScope.updateUser?'更新资料':'注册成功<small>欢迎您加入</small>'}</h1>
		</div>
		<h2>更多设置</h2>
		<form id="form" action="${pageContext.request.contextPath}/request/updateUser" class="wizard-big" method="post">
			<input type="hidden" name="id" value="${sessionScope.user.id}">
			<h1>账户安全</h1>
			<fieldset>
				<h2>安全绑定<small>(用于忘记密码或账户时找回)</small></h2>
				<div class="row">
					<div class="col-sm-8">
						<div class="form-group">
							<label>手机号码</label> <input id="phoneNo" name="phoneNo" maxLength="11" value="${sessionScope.user.phoneNo}"
								type="text" class="form-control {digits:true,maxlength:11}" placeholder="填写有效手机号码(非必填)填写后可用于登陆">
						</div>
						<div class="form-group">
							<label>邮箱</label> <input id="email" name="email" value="${sessionScope.user.email }"
								type="text" class="form-control" placeholder="填写有效邮箱地址(非必填)填写后可用于登陆">
						</div>
						<div class="form-group">
							<input type="hidden" name="question" value="${sessionScope.user.question}"/>
							<label>安全问题</label><br/>
							 <select class="form-control m-b col-sm-3" id="question" style="width:30%;">
                                  <option value="0" style="color: #b6b6b6" selected>选择问题</option>
                                   <option value="1" ${requestScope.question!=null&&requestScope.question[0]==1?'selected':''}>有房吗？</option>
                                   <option value="2" ${requestScope.question!=null&&requestScope.question[0]==2?'selected':''}>有车吗？</option>
                                   <option value="3" ${requestScope.question!=null&&requestScope.question[0]==3?'selected':''}>有存款吗？</option>
                                   <option value="4" ${requestScope.question!=null&&requestScope.question[0]==4?'selected':''}>有老婆吗？</option>
                               </select>
								<input id="answer" style="width:70%;" value="${requestScope.question!=null?requestScope.question[1]:''}"
									type="text" class="form-control col-sm-9" placeholder="填写问题的答案(如已选问题则必填)">
						</div>
					</div>
					<div class="col-sm-4">
						<div class="text-center">
							<div style="margin-top: 20px">
								<i class="fa fa-sign-in"
									style="font-size: 180px;color: #e5e5e5 "></i>
							</div>
						</div>
					</div>
				</div>

			</fieldset>
			<h1>个人资料</h1>
			<fieldset>
				<div class="row">
					<div class="col-sm-6">
						<h2>个人资料信息</h2>
						<div class="col-sm-6">
							<div class="form-group">
								<label>姓名(保密)</label> <input id="name" name="name" type="text" value="${sessionScope.user.name}"
									class="form-control" placeholder="填写姓名(非必填)">
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group">
								<label>昵称(网站显示)</label> <input id="nickname" name="nickname" type="text" value="${sessionScope.user.nickname }"
									class="form-control" placeholder="填写显示昵称(非必填)">
							</div>
						</div>
						<div class="col-sm-12">
							<div class="form-group">
								<label>写一句简单自我介绍</label> <input id="presentation" name="presentation" value="${sessionScope.user.presentation}"
									type="text" class="form-control" placeholder="填写一句话介绍(非必填)">
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<input type="hidden" name="avatar.id" id="avatar_id" value="${sessionScope.user.avatar==null?requestScope.avatar!=null?requestScope.avatar[0]:'':sessionScope.user.avatar.id}">
						<div class="col-sm-4"><label style="text-align:center">头像设置</label><img class="head-img img-circle" alt="头像预览" 
						src="source/img/superMax/${sessionScope.user.avatar==null?requestScope.avatar!=null?requestScope.avatar[0]:'':sessionScope.user.avatar.id}">
						</div>
						<label>头像选择</label>
						<ul class="system_img col-sm-8">
						<c:forEach items="${requestScope.avatar}" var="av" varStatus="vs">
							<li data-id="${av}" class="s_img ${sessionScope.user.avatar==null?vs.count==1?'active':'':sessionScope.user.avatar.id==av}"><img src="source/img/superMax/${av}"></li>
						</c:forEach>
							<li style="width:95%;"><button class="btn btn-info" style="width:90%;margin:0 5%;" data-toggle="modal" data-target="#headPort-modal" type="button">上传本地图片</button></li>
						</ul>
					</div>
				</div>
			</fieldset>

			<h1>谈谈梦想</h1>
			<fieldset>
				<div>
					<input type="hidden" name="hobby" value="${sessionScope.user.hobby}"/>
					<h2>你喜欢什么类型的视频呢？</h2>
					<ul class="lover">
					<c:forEach items="${requestScope.categorys}" var="cate">
						<li value="${cate.id}" class="${sessionScope.user.hobby!=null?fn:contains(sessionScope.user.hobby,cate.id)?'selected':'':''}">${cate.name}</li>
					</c:forEach>
					</ul>
				</div>
			</fieldset>

			<h1>完成</h1>
			<fieldset>
				<div style="text-align:center;">
					<h2>恭喜您完成所有设置</h2>
					<span>请尽情体验本站为您带来的欢乐</span><br/>
					<span>点击完成设置后会跳转到主页</span>
				</div>
			</fieldset>
		</form>
	</div>
	<div class="modal fade" id="headPort-modal" aria-hidden="true"
		aria-labelledby="headPort-modal" role="dialog" tabindex="-1">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<form class="avatar-form" action="#" enctype="multipart/form-data"
					method="get">
					<div class="modal-header">
						<button class="close" data-dismiss="modal" type="button">&times;</button>
						<h4 class="modal-title" id="avatar-modal-label"
							style="color:#000;">选择本地头像</h4>
					</div>
					<div class="modal-body">
						<div class="row">
							<div class="col-md-8">
								<div class="image-crop">
									<img src="">
								</div>
							</div>
							<div class="col-md-4">
								<h4>头像预览：</h4>
								<div class="img-preview img-preview-sm"></div>
								<h4>说明：</h4>
								<p>你可以选择新图片上传，然后上传裁剪后的图片</p>
								<div class="btn-group">
									<label title="上传图片" for="inputImage" class="btn btn-primary">
										<input type="file" accept="image/*" name="file"
										id="inputImage" class="hide"> 选择图片
									</label> <label title="下载图片" id="download" class="btn btn-primary">上传</label>
								</div>
								<div class="btn-group">
									<button class="btn btn-white" id="zoomIn" type="button">放大</button>
									<button class="btn btn-white" id="zoomOut" type="button">缩小</button>
									<button class="btn btn-white" id="rotateLeft" type="button">左旋转</button>
									<button class="btn btn-white" id="rotateRight" type="button">右旋转</button>
								</div>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	<!-- /.modal -->
<!-- 全局js -->
<script src="js/jquery/jquery.min.js?v=2.1.4"></script>
<script src="js/bootstrap.min.js?v=3.3.6"></script>
<!-- Steps -->
<script src="js/plugins/staps/jquery.steps.min.js"></script>
 <!-- Jquery Validate -->
<script src="js/plugins/validate/jquery.validate.min.js"></script>
<script src="js/plugins/validate/messages_zh.min.js"></script>
<script src="js/plugins/layer/layer.min.js"></script>
<!--图片裁剪-->
<!-- Image cropper -->
<script src="js/plugins/cropper/cropper.min.js"></script>
<script type="text/javascript" src="js/registerSuccess.js"></script>
<!--/图片裁剪-->

</body>
</html>
