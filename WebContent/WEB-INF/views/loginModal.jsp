<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>My JSP 'head.jsp' starting page</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<link rel="stylesheet" href="css/admin/multipleChoice.css">
<link href="css/plugins/treeview/bootstrap-treeview.min.css"
	rel="stylesheet">
<style type="text/css">
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

<body>
<!--登陆模态框  -->
<div class="modal inmodal" id="loginModal">
    <div class="modal-dialog">
        <div class="modal-content animated fadeIn" style="width:300px;margin:auto">
            <div class="modal-header" style="padding:5px">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
            </div>
            <div class="modal-body">
             <div class="text-center">
            <div style="padding:0 30px;">
                <h1 class="logo-name"><img alt="logo" src="img/logo3.png"></h1>
            </div>
            <h3 style="text-align:center;width:100%">欢迎使用 LHV</h3>
            <form class="m-t" role="form" action="login" method="post" id="loginForm">
                <div class="form-group">
                    <input type="text" class="form-control" placeholder="用户名/邮箱/手机号" name="account">
                </div>
                <div class="form-group">
                    <input type="password" class="form-control" placeholder="密码" name="password">
                </div>
                <button type="submit" class="btn btn-primary block full-width m-b">登 录</button>


                <p class="text-muted text-center"> <a href="login.html#" style="color:#555"><small>忘记密码了？</small></a> | <a href="register" style="color:#555">注册一个新账号</a>
                </p>

            </form>
        </div>
            </div>
        </div>
    </div>
</div>
<!--/登陆模态框  -->
<div class="modal inmodal" id="editModal" tabindex="-1" role="dialog"
		aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content animated flipInY">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title">上传视频</h4>
					<div class="ibox float-e-margins categoryList">
						<div class="ibox-title">
							<h5>分类列表</h5>
							<div class="ibox-tools">
								<a class="close-link"> <i class="fa fa-times"></i>
								</a>
							</div>
						</div>
						<div class="ibox-content">
							<div id="treeview"></div>
						</div>
					</div>
				</div>
				<div class="modal-body">
					<ul class="missionRecord animated">
						<li class="formPlan" data-type="form">基本数据(<span class="sign">准备提交</span>)
							<div class="progress progress-striped active">
								<div style="width:0%" aria-valuemax="100" aria-valuemin="0"
									aria-valuenow="75" role="progressbar"
									class="progress-bar progress-bar-danger">
									<span class="sr-only">40% Complete (success)</span>
								</div>
							</div>
						</li>
						<li class="picPlan" data-type="pic">缩略图(<span class="sign">准备提交</span>)
							<div class="progress progress-striped active">
								<div style="width:0%" aria-valuemax="100" aria-valuemin="0"
									aria-valuenow="75" role="progressbar"
									class="progress-bar progress-bar-danger">
									<span class="sr-only">40% Complete (success)</span>
								</div>
							</div>
							<!-- <span class="sign"><i>0</i>%</span> -->
						</li>
						<li class="sourcePlan" data-type="file">资源文件(<span
							class="sign">准备提交</span>)
							<div class="progress progress-striped active">
								<div style="width: 0%" aria-valuemax="100" aria-valuemin="0"
									aria-valuenow="75" role="progressbar"
									class="progress-bar progress-bar-danger">
									<span class="sr-only">40% Complete (success)</span>
								</div>
							</div>
						</li>
						<li class="cancalPlan"><button class="btn btn-warning">我知道出错了</button></li>
					</ul>
					<form id="sourceInforForm" method="post" autocomplete="off"
						class="animated">
						<input type="hidden" name="id" id="id" value="1234567890"/>
						<table class="table">
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
									<div class="input-group" data-content="必须至少选择一位用户！">
										<span class="input-group-addon">系列名称</span> <input
											class="form-control seriesname" type="text"
											placeholder="输入关键字搜索" 
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
											placeholder="填写资源名称，显示的名称[例:1集]" name="name" />
									</div>
								</td>
							</tr>
							<tr>
								<td>
									<div class="input-group">
										<input type="hidden" name="category">
										<div class="input-group-addon">分类</div>
										<ul class="form-control categoryUl" title="点击添加资源分类"
											tabindex="0"></ul>
									</div>
								</td>
							</tr>
							<tr>
								<td><img class="img">
									<div class="input-group">
										<div class="input-group-addon">缩&ensp;略&ensp;图</div>
										<button class="form-control selectFile imgfile" type="button"
											data-type="pic">点击选择文件</button>
									</div></td>
							</tr>
							<tr>
								<td>
									<div class="input-group">
										<div class="input-group-addon">资源路径</div>
										<button class="form-control selectFile sourcefile"
											type="button" data-type="file">点击选择文件</button>
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
									<button class="btn btn-primary" type="submit" title="点击开始">更新到数据库</button>
									<button class="btn btn-primary" type="button"
										data-dismiss="modal">关闭</button>
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
		</div>
	</div>
<div class="fileBoxs"></div>
<script src="js/admin/seriesAuto.js" type="text/javascript"></script>
<script src="js/admin/multipleChoice.js" type="text/javascript"></script>
<!-- Bootstrap-Treeview plugin javascript -->
<script src="js/plugins/treeview/bootstrap-treeview.min.js"></script>
<script type="text/javascript">
	/*login handler*/
	$("#loginForm").submit(function() {
		if ($("input[name=account]").val() == '') {
			parent.layer.msg("账号不能为空");return false;
		}
		if ($("input[name=password]").val() == '') {
			parent.layer.msg("密码不能为空");return false;
		}
		//login request
		$.post("json/login", $("#loginForm").serialize(), function(data) {
			if (!(data instanceof Object))
				data = eval("(" + data + ")");
			if (data.message) { //login success
				$("#loginModal").modal("hide");
				stateChange("login");
			} else { //login failed
				parent.layer.alert(data.cause);
			}
		})
		return false;
	})
	// 分类输入框点击事件
	$(".categoryUl").click(function() {
		var modal = $("#editModal .modal-content")[0];
		$(".categoryList").css("left", modal.offsetWidth);
		$(".close-link").unbind();
		$(".close-link").bind("click", function() {
			$(".categoryList").hide();
		})
		$(".categoryList").toggle();
	})
	// 文件选择绑定
	$(".selectFile").click(function() {
		var fileBox = $(".fileBox[data-type=" + $(this).attr("data-type") + "]");
		var suffix = $(this).attr("data-type") == 'pic' ? 'accept="image/png,image/gif,image/jpeg"' : '';
		// 判断当前是否有对应类型的file，没有则创建一个
		if (fileBox.length < 1) {
			fileBox = $('<div class="fileBox" data-type="' + $(this).attr("data-type") + '"><input type="file" name="file" ' + suffix + '></div>');
			$(".fileBoxs").append(fileBox);
		} else {
			if ($(fileBox).find("input[type=file][name=file]")[0].files.length > 0) {
				$(fileBox).find("input[type=file]").attr("name", null);
				$(fileBox).append('<input type="file" name="file" ' + suffix + '>')
			}
		}
		//文件选择后事件监听
		bindEvent();
		$(fileBox).find("input[type=file][name=file]").trigger("click")
	})
	//表单提交 
	$("#sourceInforForm").submit(function() {
		var isPass = true;
		if ($("#sourceInforForm input[name=name]").val() == '') {
			tooltipUtil($("#sourceInforForm input[name=name]"), "名称不能为空");
			isPass = false;
		}
		if ($(".categoryUl li").length < 1) {
			tooltipUtil($(".categoryUl"), "分类至少选择一项");
			isPass = false;
		}
		//系列开关
		if ($("#sourceInforForm .mcControl").val() == '1') {
			if ($("#sourceInforForm .seriesname").val().trim() == '') {
				tooltipUtil($("#sourceInforForm .seriesname"), "系列名不能为空");
				isPass = false;
			}
			if ($("#sourceInforForm .seriesname").attr("name") == 'undefined') {
				$("#sourceInforForm .seriesname").attr("name", "seriesname");
			}
		} else {
			$("#sourceInforForm .seriesname").attr("name", null);
		}
		var sourceFile = $(".fileBox[data-type=file] input[type=file][name=file]");
		if (!(sourceFile.length > 0 && sourceFile[0].files.length > 0)) {
			tooltipUtil($(".sourcefile"), "文件不能为空");
			isPass = false;
		}
		if (isPass) {
			PLANNUM("0");
			$(".categoryList").hide();
			//获取选中的节点
			var ids = $("#treeview").treeview('getSelected');
			//取消选中节点 
			$("#treeview").treeview('unselectNode', [ ids, {
				silent : true
			} ]);
			//显示进度条隐藏表单
			$("#sourceInforForm").addClass("rotateOutUpLeft");
			$("#sourceInforForm").hide();
			$("#editModal .modal-title").html("上传进度");
			$(".missionRecord").addClass("rotateInUpLeft");
			$(".missionRecord").show();
			updateForm(); //表单进行提交
			//判断是否有文件需要上传
			var picFile = $(".fileBox[data-type=pic] input[type=file][name=file]");
			var sourceFile = $(".fileBox[data-type=file] input[type=file][name=file]");
			if (picFile.length > 0 && picFile[0].files.length > 0) {
				$(".missionRecord li[class=picPlan]").show();
			} else {
				$(".missionRecord li[class=picPlan]").hide();
			}
			if (sourceFile.length > 0 && sourceFile[0].files.length > 0) {
				$(".missionRecord li[class=sourcePlan]").show();
			} else {
				$(".missionRecord li[class=sourcePlan]").hide();
			}
		//判断是否有文件需要上传
		} else {
			tooltipUtil($(this).find("button[type=submit]"), "资源基本信息还未完善");
		}
		return false;
	})
	/*$('#editModal').on('hidden.bs.modal', function (e) {
	   $("#sourceInforForm").removeClass("rotateOutUpLeft");
	   $("#sourceInforForm").show();
	  // $("#sourceInforForm").hide();
	   $("#editModal .modal-title").html("资源更新");
	   $(".missionRecord").removeClass("rotateInUpLeft")
	   $(".missionRecord").hide();
	})*/
	$('#editModal').on('show.bs.modal', function(e) {
		if(!isLogin){
			parent.layer.alert("需要登陆才能上传哦");
			return false;
		}
		if (planNum < 1) {
			$("#sourceInforForm").removeClass("rotateOutUpLeft");
			$("#sourceInforForm").show();
			// $("#sourceInforForm").hide();
			$(".missionRecord").removeClass("rotateInUpLeft")
			$(".missionRecord").hide();
			MissionPlan("pic", 0);
			MissionPlan("file", 0);
			//数据清空
			$("#sourceInforForm .seriesname").val("");
			$("#sourceInforForm input[name=name]").val("");
			$("#sourceInforForm input[name=name]").val("");
			$("#sourceInforForm textarea[name=decription]").val("");
			$(".fileBoxs").html("");
			$(".selectFile").html("点击选择文件");
			$(".categoryUl").html("");
		}
	})
	$(".cancalPlan").click(function() {
		planNum = 0;
		$('#editModal').modal("hide");
	})
	//初始化分类
	requestCategory();
	function bindEvent() {
		//文件更改事件
		$(".fileBox").unbind();
		$(".fileBox").bind("change", function() {
			var file = $(this).find("input[type=file][name=file]")[0].files;
			if(file[0].size>2048000000){
				parent.layer.alert("文件大小不能超过2G");
				$(this).find("input[type=file][name=file]").val("");
				return false;
				
			}
			var selectFile = $(".selectFile[data-type=" + $(this).attr('data-type') + "]");
			if (file.length > 0) {
				$(selectFile).html("已选择：" + file[0].name);
				$(this).find("input[type=file][name=file]").siblings().remove();
			} else {
				$(this).find("input[type=file][name=file]").remove();
				$(this).find("input[type=file]").attr("name", "file");
			}
			if($(this).attr('data-type')=='pic'){
	        	if($("#sourceInforForm .img").length<1){
	        		$(".selectFile[data-type=pic]").parent().before('<img class="img" src="'+window.URL.createObjectURL(file[0])+'">')
	        	}else{
	        		$(".selectFile[data-type=pic]").parents("td").find(".img").attr("src",window.URL.createObjectURL(file[0]));
	        	}
	        	bindEvent();
        	}
		});
		/*图片预览*/ 
    $("#sourceInforForm .img").unbind();
    $("#sourceInforForm .img").bind("click",function(){
    	if($(this).hasClass("active")){
    		$(this).removeClass("active");
    		$(this).attr("title","点击预览大图")
    	}else{
    		$(this).addClass("active");
    		$(this).attr("title","点击关闭预览")
    		
    	}
    })
    /*/图片预览*/
    $(".logout").unbind();
	$(".logout").bind("click",function(){
    	$.get("logout",null,function(){
    		stateChange("logout");
    	})
    })
      //签到
      $(".sign").unbind();
    $(".sign").bind("click",function(){
    	$.post("json/sign",null,function(data){
    		if(!(data instanceof Object))data = eval("("+data+")");
    		if(data.message){
    			requestSign();
    		}else{
    			parent.layer.msg("签到失败:"+data.cause);
    		}
    	})
    })
	}
	// 移除分类
	function delCategory(id) {
		$(".categoryUl li[data-id=" + id + "]").remove();
	}
	// 添加分类
	function fillCategory(id, text, nid) {
		var li = $(".categoryUl li[data-id=" + id + "]");
		if (li.length > 0) return;
		$(".categoryUl").append($('<li data-id="' + id + '" node-id="'
			+ nid + '"><span>' + text + '</span><i class="glyphicon glyphicon-remove"></i></li>'));
		bindCategoryRmove();
		categoryValueSet();
	}
	var hasCategory = false;
	var categoryData;
	function requestCategory() {
		$.post("json/category", '', function(data) {
			if (data.length > 0) {
				hasCategory = true;
				categoryData = data;
			}
			// 为了配合节点树，把名称替换，节点替换，原文件添加data-id属性
			data = JSON.stringify(data);
			data = data.replace(/name/g, "text").replace(/childs/g, "nodes");
			data = eval("(" + data + ")");
			// 节点树设置
			$('#treeview').treeview({
				data : data,
				levels : 5,
				multiSelect : true
			});
			// 关闭所 有节点
			$('#treeview').treeview('collapseAll', {
				silent : true
			});
			// 点击事件
			$('#treeview').on('nodeSelected', function(event, data) {
				fillCategory(data.id, data.text, data.nodeId)
			});
			$('#treeview').on('nodeUnselected', function(event, data) {
				delCategory(data.id)
			});
		})
	}
	// 设置分类form value
	function categoryValueSet() {
		var lis = $(".categoryUl li");
		var value = '';
		for (var i = 0; i < lis.length; i++) {
			if (i == lis.length - 1)
				value += $(lis[i]).attr("data-id");
			else
				value += $(lis[i]).attr("data-id") + ",";
		}
		$("input[name=category]").val(value);
	}
	// 绑定分类移除事件
	function bindCategoryRmove(id) {
		$(".categoryUl li i").unbind();
		$(".categoryUl li i").bind("click", function() {
			// 这里要把获得的字符串转为整数
			$('#treeview').treeview('unselectNode',
				[ parseInt($(this).parent().attr("node-id")), {
					silent : true
				} ]);
			$(this).parent().remove();
			categoryValueSet();
			return false;
		})
	}
	//任务值监听
	var planNum = 0;
	function PLANNUM(a) {
		if (a == 0) {
			planNum = 0;
		} else if (a == '+') {
			planNum++;
		} else {
			planNum--;
			if (planNum < 1) {
				$("#editModal").modal("hide");
				parent.layer.alert("上传完成");
				$("#table_list").trigger("reloadGrid");
				$(".fileBox").remove();
				planNum = 0;
			}
		}
	}
	//提示工具
function tooltipUtil(el,title){
	$(el).attr("title",title);
	 $(el).tooltip("show");
	 setTimeout(function(){
		 $(el).tooltip("destroy");
	 },3000)
}
	//开始当前资源ID的上传任务 
	function updateForm() {
		PLANNUM("+");
		$(".formPlan .sign").attr("class", "sign").html("<i>0</i>%");
		$.post("json/user/addSource/form", $('#sourceInforForm').serialize(), function(data) {
			if (!(data instanceof Object))
				data = eval("(" + data + ")");
			if (data.message) {
				$(".formPlan .sign").addClass("success").html("上传完成");
				MissionPlan("form", 100);
				$("#id").val(data.id);
				/*/缩略图上传*/
				//判断是否有文件需要上传
				var picFile = $(".fileBox[data-type=pic] input[type=file][name=file]");
				var sourceFile = $(".fileBox[data-type=file] input[type=file][name=file]");
				if (picFile.length > 0 && picFile[0].files.length > 0) {
					uploadFile("pic"); //上传图片
				}
				if (sourceFile.length > 0 && sourceFile[0].files.length > 0) {
					uploadFile("file"); //上传资源
				}
				//判断是否有文件需要上传
				PLANNUM("-");
			} else {
				$(".formPlan .sign").addClass("failed").html("上传失败");
				$(".cancalPlan").show();
			}
		})
	}
	function uploadFile(type) {
		PLANNUM("+");
		//if(type=='pic')
		$(".missionRecord li[data-type=" + type + "] .sign").attr("class", "sign").html("<i>0</i>%");
		var formData = new FormData();
		formData.append("file", $(".fileBox[data-type=" + type + "] input[type=file][name=file]")[0].files[0]);
		$.ajax({
			type : "POST",
			url : "json/user/updateSource/" + type + "/" + $("#sourceInforForm #id").val(),
			data : formData,  //这里上传的数据使用了formData 对象
			processData : false, //必须false才会自动加上正确的Content-Type 
			contentType : false, 
			//这里我们先拿到jQuery产生的 XMLHttpRequest对象，为其增加 progress 事件绑定，然后再返回交给ajax使用
			xhr : function() {
				var xhr = $.ajaxSettings.xhr();
				if (onprogress && xhr.upload) {
					xhr.upload.addEventListener("progress", function(evt) {
						onprogress(id, type, evt)
					}, false);
					return xhr;
				}
			},
			success : function(data) {
				if (data != null) {
					data = eval("(" + data + ")");
					if (data.message) {
						$(".missionRecord li[data-type=" + type + "] .sign").addClass("success").html("更新完成");
						MissionPlan(type, 100);
						PLANNUM("-");
						return;
					}
				}
				$(".missionRecord li[data-type=" + type + "] .sign").addClass("failed").html("更新失败");
				$(".cancalPlan").show();
				return;
			}
		});
	}
	//任务进度条改变
	function MissionPlan(type, plan) {
		$(".missionRecord li[data-type=" + type + "] .progress-bar").css("width", plan + "%").html(plan + "%");
		$(".missionRecord li[data-type=" + type + "] .sign i").html(plan);
	}
	/**
	 * 侦查附件上传情况 ,这个方法大概0.05-0.1秒执行一次
	 */
	function onprogress(id, type, evt) {
		var loaded = evt.loaded; //已经上传大小情况 
		var tot = evt.total; //附件总大小 
		var per = Math.floor(100 * loaded / tot); //已经上传的百分比 
		MissionPlan(type, per);
	}
	//自动填充分类
	function fillAutoCategory(key, value) {
		$(".categoryUl").html("");
		var arr = value.split(",");
		for (var i = 0; i < arr.length; i++) {
			$('#treeview').treeview('expandAll', {
				silent : true
			});
			var lis = $('#treeview').treeview('getExpanded');
			$('#treeview').treeview('collapseAll', {
				silent : true
			});
			for (var j = 0; j < lis.length; j++) {
				if (arr[i] == lis[j].id) {
					$('#treeview').treeview('selectNode', [ lis[j].nodeId, {
						silent : true
					} ]);
					fillCategory(arr[i], lis[j].text, lis[j].nodeId);
					break;
				}
			}
		}
	}
</script>
</body>
</html>
