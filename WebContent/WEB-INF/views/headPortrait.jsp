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
<!--图片裁剪-->
<link href="css/plugins/cropper/cropper.min.css" rel="stylesheet">
<style type="text/css"> /* 自动填充 */
.autoComplate {
	background: #FFF;
	position: absolute;
	z-index: 100000;
	top: 32px;
	width: 80%;
	display: none;
}

.autoComplate a {
	height: 40px;
	line-height: 20px;
	vertical-align: middle;
}

.autoComplate a:hover { /* background:#337AB7;
color:#FFF; */
	cursor: pointer;
}

.autoComplate p {
	border: 1px solid #CCCCCC;
	height: 25px;
	line-height: 25px;
	text-align: right;
	font-size: 15px;
	padding: 0 10px;
	margin: 0;
}

.fileBox, .missionRecord {
	display: none;
}

.missionRecord li {
	list-style: none;
}

.sign.success {
	color: #5CB85C;
}

.sign.failed {
	color: #D9534F;
}

.selectFile {
	overflow: hidden;
}

.cancalPlan {
	text-align: center;
	display: none;
}

img.img {
	width: 30px;
	margin: 5px auto;
	cursor: pointer;
}

img.img.active {
	width: 380px;
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
<script src="js/admin/headPortrait.js" type="text/javascript"></script>
<script src="js/md5/spark-md5.min.js" type="text/javascript"></script>
<!--图片裁剪-->
<!-- Image cropper -->
<script src="js/plugins/cropper/cropper.min.js"></script>
<!--/图片裁剪-->
<script type="text/javascript">
	$(function() {
		var $image = $(".image-crop > img")
		$($image).cropper({
			aspectRatio : 1,
			preview : ".img-preview",
			done : function(data) {
				// 输出结果
			}
		});

		var $inputImage = $("#inputImage");
		if (window.FileReader) {
			$inputImage.change(function() {
				var fileReader = new FileReader(),
					files = this.files,
					file;

				if (!files.length) {
					return;
				}

				file = files[0];

				if (/^image\/\w+$/.test(file.type)) {
					fileReader.readAsDataURL(file);
					fileReader.onload = function() {
						$inputImage.val("");
						$image.cropper("reset", true).cropper("replace", this.result);
					};
				} else {
					showMessage("请选择图片文件");
				}
				//重置窗口事件
			    if( document.createEvent){
			        var evObj = document.createEvent('HTMLEvents');
			        evObj.initEvent( 'resize', true, false );
			        document.body.dispatchEvent(evObj);
			    }else if( document.createEventObject ){
				      document.body.fireEvent('onresize');
				  }
			});
		} else {
			$inputImage.addClass("hide");
		}

		$("#download").click(function() {
			$("#headPort-modal").modal("hide");
	        var formData = new FormData($(".avatar-form")[0]);
			var data=window.atob($image.cropper("getDataURL").split(",")[1]);
			var ia = new Uint8Array(data.length);
			for (var i = 0; i < data.length; i++) {
			    ia[i] = data.charCodeAt(i);
			};
			// canvas.toDataURL 返回的默认格式就是 image/png
			var blob=new Blob([ia], {type:"image/png"});
	        formData.append("img",blob);//  
	        $.ajax({    
	            url: "json/admin/uploadImg",  
	            type: 'POST',    
	            data: formData,    
	            timeout : 10000, //超时时间设置，单位毫秒  
	            async: true,    
	            cache: false,    
	            contentType: false,    
	            processData: false,   
	            success: function (data) {
	            	if(!(data instanceof Object))data = eval("("+data+")");
	            	if(data.result){
	            		$("#table_list").trigger("reloadGrid");
	            		parent.layer.msg('添加成功', {icon : 1});
	            	}else{
	            		parent.layer.msg('添加失败：'+data.cause, {icon : 2});
	            	}
	            },    
	            error: function (returndata) {
	            	parent.layer.msg('发生错误：'+data.cause, {icon : 2});
	            }  
	        });  
		});

		$("#zoomIn").click(function() {
			$image.cropper("zoom", 0.1);
		});

		$("#zoomOut").click(function() {
			$image.cropper("zoom", -0.1);
		});

		$("#rotateLeft").click(function() {
			$image.cropper("rotate", 45);
			//重置窗口事件
			    if( document.createEvent){
			        var evObj = document.createEvent('HTMLEvents');
			        evObj.initEvent( 'resize', true, false );
			        document.body.dispatchEvent(evObj);
			    }else if( document.createEventObject ){
				      document.body.fireEvent('onresize');
				  }
		});

		$("#rotateRight").click(function() {
			$image.cropper("rotate", -45);
			//重置窗口事件
			    if( document.createEvent){
			        var evObj = document.createEvent('HTMLEvents');
			        evObj.initEvent( 'resize', true, false );
			        document.body.dispatchEvent(evObj);
			    }else if( document.createEventObject ){
				      document.body.fireEvent('onresize');
				  }
		});

		$("#setDrag").click(function() {
			$image.cropper("setDragMode", "crop");
		});
	})
</script>
</html>
