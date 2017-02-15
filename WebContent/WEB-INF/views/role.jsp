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
<link href="css/admin/levelControl.css" rel="stylesheet">
<style type="text/css">
	.changeNorm{
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
	<div class="modal fade" id="addRoleModal" tabindex="-1" role="dialog"
			aria-labelledby="myModalLabeladdRole" aria-hidden="true">
			<div class="modal-dialog">
				<input type="hidden" id="roleId" name="id">
				<div class="modal-content" id="addRoleArea">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title">添加角色</h4>
					</div>
					<div class="modal-body">
						<table class="table">
							<tbody>
								<tr>
									<td><div class="input-group has-feedback" id="add_role">
											<span class="input-group-addon">角色名：</span> <input type="text"
												class="form-control" id="addRole_input" data-placement="top"
												data-content="角色名格式错误"
												placeholder="填写角色名"> <span
												id="add_role_icon" class="form-control-feedback"
												aria-hidden="true"></span> <span id="inputError2Status"
												class="sr-only">(error)</span>
										</div></td>
								</tr>
								<tr>
									<td><div class="input-group" id="add_permission"
											data-placement="top"
											data-content="必须至少选择一项！">
											<span class="input-group-addon">权限名：</span>
											<div class="add_role_permissions">
												<%-- <s:iterator var="s" value="#session.allPermissions">
													<label class="checkbox-inline"><input
														type="checkbox" name="addcheckboxOptions"
														id="inlineCheckbox${s.id}" value="${s.id}">
														${s.name} </label>
												</s:iterator> --%>
												<c:forEach items="${requestScope.permissions}" var="permission">
													<label class="checkbox-inline"><input
														type="checkbox" name="addcheckboxOptions"
														id="inlineCheckbox${permission.id}" value="${permission.id}" decription-data="${permission.decription}">
														${permission.decription} </label>
												</c:forEach>
											</div>
										</div></td>
								</tr>
								<tr>
									<td>
										<div class="input-group has-feedback" id="role_level">
											<span class="input-group-addon">控制级别：</span>
											<div class="level">
												<p class="level-control" data-toggle="tooltip"
													data-placement="top" title="150" id="level-control"></p>
											</div>
										</div>
									</td>
								</tr>

								<tr>
									<td>添加角色注意事项：
										<button type="button"
											class="btn btn-primary btn-md changeNormButton">阅读修改规范</button></td>
								</tr>
								<tr>
									<td class="changeNorm">
										<div class="alert alert-success" role="alert">
											<strong>角色名！</strong>长度需在5-20位,由字母数字组成,不能含有特殊字符,且必须以字母开头
										</div>
										<div class="alert alert-success" role="alert">
											<strong>权限！</strong>必须选择一项，不能赋予当前角色没有的权限
										</div>
										<div class="alert alert-success" role="alert">
											<strong>控制级别！</strong>最终控制级别会在当前操作角色级别加上设置的控制级别,0表示与当前操作角色控制级别一样
										</div>
										<div class="alert alert-success" role="alert">
											<strong>注意！</strong> 控制级别低的不能操作控制级别高的
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
						<button type="button" class="btn btn-primary" id="suerAddRole"
							data-placement="left"
							data-content="添加失败！请阅读修改规则...">添加</button>
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
<script src="js/admin/levelControl.js"></script>
<script type="text/javascript">
		/**
 * 六画
 * 资源管理
 */
$(function() {
	$.jgrid.defaults.styleUI = 'Bootstrap';
	$("#table_list").jqGrid({
		url : "json/list/role",
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
		colNames : [ 'id','permissions','control','角色名', '拥有权限', '控制级别' ],
		colModel : [
				{
					name : 'id',
					index : 'id',
					hidden : true
				},{
					name : 'permissions',
					hidden : true
				},{
					name : 'level',
					hidden : true
				},
				{
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
				},
				{
					name : 'permissions',
					index : 'permissions',
					editable : true,
					width : 150,
					sorttype : "string",
					search : true,
					formatter : permissionFormat,
					searchoptions : {
						sopt : [ 'eq', 'ne', 'bw', 'bn', 'ew', 'en',
								'cn', 'nc' ]
					}
				},
				{
					name : 'level',
					index : 'level',
					editable : true,
					width : 50,
					sorttype : "string",
					search : true,
					align:"center",
					formatter:levelFormat,
					searchoptions : {
						sopt : [ 'eq', 'ne', 'bw', 'bn', 'ew', 'en',
								'cn', 'nc' ]
					}
				} ],
		pager : "#pager_list",
		viewrecords : true,
		caption : "角色管理",
		add : true,
		edit : true,
		addtext : 'Add',
		edittext : 'Edit',
		multiselect : true,
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
	// 向表格添加删除按钮
	$("#table_list").navButtonAdd('#pager_list', {
		caption : "",
		title : "删除",
		buttonicon : "glyphicon glyphicon-trash",
		position : "first",
		onClickButton : function() {
			// 多行选取
			var ids = $("#table_list").jqGrid("getGridParam", "selarrrow");
			if (ids == '') {
				parent.layer.msg("请选择要删除的行");
				return;
			}
			parent.layer.confirm('确认删除已选中的数据吗？', {
				btn : [ '马上删除', '让我再想想' ], // 按钮
				shade : [ 0.2, '#000' ]
			// 不显示遮罩
			}, function() {
				deleteData(ids);
			}, function() {
				parent.layer.msg('已取消', {
					shift : 6
				});
			});
		}
	})
	// 向表格添加编辑按钮
	$("#table_list").navButtonAdd('#pager_list', {
		caption : "",
		title : "编辑",
		buttonicon : "glyphicon glyphicon-edit",
		onClickButton : function() {
			// 多行选取
			var ids = $("#table_list").jqGrid("getGridParam", "selarrrow");
			if (ids == '') {
				parent.layer.msg("请选择要编辑的行");
				return;
			} else if (ids.toString().indexOf(",") != -1) {
				parent.layer.msg("一次只能选择一行进行编辑");
				return;
			} else {
				$(".modal-title").html("更新角色");
				$("#suerAddRole").html("更新");
				fillSourceData($("#table_list").getRowData(ids));
				$("#addRoleModal").modal("show");
			}
		},
		position : "first"
	})
	// 向表格添加按钮
	$("#table_list").navButtonAdd('#pager_list', {
		caption : "",
		title : "添加",
		buttonicon : "glyphicon glyphicon-plus",
		onClickButton : function() {
			$(".modal-title").html("添加角色");
			$("#suerAddRole").html("添加");
			$("#addRoleModal").modal("show");
		},
		position : "first"
	})
	// Add responsive to jqGrid
	$(window).bind('resize', function() {
		var width = $('.jqGrid_wrapper').width();
		$('#table_list').setGridWidth(width);
	});
   $('#editModal').on('show.bs.modal', function (e) {
	   if(planNum<1){
		   $("#sourceInforForm").removeClass("rotateOutUpLeft");
		   $("#sourceInforForm").show();
		   // $("#sourceInforForm").hide();
		   $("#editModal .modal-title").html("资源更新");
		   $(".missionRecord").removeClass("rotateInUpLeft")
		   $(".missionRecord").hide();
		   MissionPlan("pic",0);
		   MissionPlan("file",0);
	   }
   })
   $(".cancalPlan").click(function(){
	   planNum=0;
	   $('#editModal').modal("hide");
   })
   /*
	 * 修改规范打开与关闭
	 */
	$(".changeNormButton").bind("click", function(e) {
		var cn =$(".changeNorm");
		if($(cn).is(":hidden")){
			$(cn).show();
			$(this).html("隐藏修改规范");
		}else{
			$(cn).hide();
			$(this).html("阅读修改规范");
		}
	})
	$(".changeNorm").css("display", "none");//[0].style.display = "none";
	//添加角色
	$("#addRole_input").bind("change",function(){
		addRoleInputVerify(this);
	})
	//确认添加角色
	$("#suerAddRole").bind("click", function(){
		suerAddRole();
	})
	$("#addRoleModal").on("hidden.bs.modal",function(e){
		$("#addRole_input").val("");
		$("#roleId").val("");
		$("#addRole_input").parent().attr("class","input-group has-feedback");
		$("input[name=addcheckboxOptions]").attr("checked",false);
		$("*").popover("destroy")
	})
})
var currentLevel=${user.role.level};
//提示工具
function tooltipUtil(el,title){
	$(el).attr("title",title);
	 $(el).tooltip("show");
	 setTimeout(function(){
		 $(el).tooltip("destroy");
	 },3000)
}
function rowIdFmatter(cellvalue, options, rowObject) {
	alert($("#table_list").jqGrid("getGridParam", "selrow"));
	return options.rowId;
}
function deleteData(ids) {
	$.post("json/deleteRole", "id=" + ids, function(data) {
		data = eval("(" + data + ")");
		if (data.message && data.num > 0) {
			if (ids.toString().indexOf(",") != -1) {
				var idArr = ids.toString().split(",");
				for (var i = 0; i < idArr.length; i++)
					$("#table_list").delRowData(idArr[i]);
			} else {
				$("#table_list").delRowData(ids);
			}
			parent.layer.msg('已删除' + data.num + '个记录', {
				icon : 1
			});
			$("#table_list").trigger("reloadGrid");
		} else {
			parent.layer.msg('删除失败，'+data.cause, {
				icon : 2
			});
		}
	})
}
//确认添加角色
function suerAddRole(){
	var el = $("#addRole_input").get(0);
	var value = el.value;
	if(value==''){
		$("#add_role").addClass("has-error");
		$("#add_role_icon").addClass("glyphicon glyphicon-remove");
		el.setAttribute("data-content", "格式错误，不能为空！");
		$(el).popover('show');
		el.focus();
		return false;
	}else if(/[`~!@#$%^&&*()_|=+-<>?:“：｜｛｝《》？。，、＇＼［］）×（＊＆＾％＄#＠！￣｀"{},.\/;'[\]]+/.test(value)){
			if(!/[0-9]+/.test(value)){
			$("#add_role").addClass("has-error");
			$("#add_role_icon").addClass("glyphicon glyphicon-remove");
			el.setAttribute("data-content","格式错误:不能包含特殊字符");
			$(el).popover('show');
			return false;
		}
	}
	if(!/^(.){2,10}$/.test(value)){
		$("#add_role").addClass("has-error");
		$("#add_role_icon").addClass("glyphicon glyphicon-remove");
		el.setAttribute("data-content", "格式错误:长度需在2-10位");
		$(el).popover('show');
		return false;
	}
	if($("#add_permission input:checked").length<1){
		$("#add_permission").popover("show");
		return;
	}else{
		$("#add_permission").popover("destroy");
		if(!$("#addRole_input").hasClass("has-error")){
			addRole(value);
		}
	}
}
function addRole(value){
	var id = $("#roleId").val();
	var data = "name="+value+"&level="+$("#level-control").attr("data-original-title")+(id!=''?'&id='+id:'');
	var permissionInput = $("#add_permission input:checked");
	for(var i=0;i<permissionInput.length;i++){
		data += "&permissions="+permissionInput[i].value;
	}
	$.post("json/addRole",data,function(data){
		if(data!=null){
			data = eval("("+data+")");
			if(data.message){
				$("#addRoleModal").modal("hide");
				$("#table_list").trigger("reloadGrid");
				parent.layer.msg('操作角色成功', {icon : 1});
				return;
			}else{
				$("#suerAddRole").attr("data-content", "操作失败："+data.cause);
				$("#suerAddRole").popover("show");
				return;
			}
		}
		$("#suerAddRole").attr("data-content", "操作失败：权限不足");
		$("#suerAddRole").popover("show");
		return;
	})
}
//角色名验证
function addRoleInputVerify(el){
	var value = el.value;
	if(value==''){
		$("#add_role").addClass("has-error");
		$("#add_role_icon").addClass("glyphicon glyphicon-remove");
		el.setAttribute("data-content", "格式错误:不能为空！");
		$(el).popover('show');
		el.focus();
		return false;
	}
	if(/[`~!@#$%^&&*()_|=+-<>?:“：｜｛｝《》？。，、＇＼［］）×（＊＆＾％＄#＠！￣｀"{},.\/;'[\]]+/.test(value)){
			if(!/[0-9]+/.test(value)){
			$("#add_role").addClass("has-error");
			$("#add_role_icon").addClass("glyphicon glyphicon-remove");
			el.setAttribute("data-content", "格式错误:不能包含特殊字符");
			el.focus();
			$(el).popover('show');
			return false;
		}
	}
	if(!/^(.){2,10}$/.test(value)){
		$("#add_role").addClass("has-error");
		$("#add_role_icon").addClass("glyphicon glyphicon-remove");
		el.setAttribute("data-content", "格式错误:长度需在2-10位");
		$(el).popover('show');
		el.focus();
		return false;
	}
	verifyRoleName(value,el);
}
//验证角色名是否已存在 
function verifyRoleName(name,el){
	$.post("json/verifyRoleName", "name=" + name,function(data) {
			if (data != null) {
			data = eval("(" + data + ")");
			if(data.message){
				$("#add_role").addClass("has-error");
				$("#add_role_icon").addClass("glyphicon glyphicon-remove");
				el.setAttribute("data-content", "角色名已被使用！！");
				$(el).popover('show');
				el.focus();
				return false;
			}else{
				$("#add_role").removeClass("has-error");
				$("#add_role").addClass("has-success");
				$("#add_role_icon").removeClass("glyphicon glyphicon-remove");
				$("#add_role_icon").addClass("glyphicon glyphicon-ok");
				$(el).popover('destroy');
				return true;
			}
		}
	})
}
//格式化权限显示
function permissionFormat(cellvalue, options, rowObject) {
	var text="";
	for(var i=0;i<cellvalue.length;i++)
		if(i==cellvalue.length)
			text += cellvalue[i].decription;
		else
			text += cellvalue[i].decription+"、";
	return text;
}
//格式化控制级别显示
function levelFormat(cellvalue, options, rowObject) {
	if(cellvalue<=100){
		return cellvalue+"(最高)";
	}else if(cellvalue>100&&cellvalue<301){
		return cellvalue+"(高)";
	}else if(cellvalue>300&&cellvalue<500){
		return cellvalue+"(中)";
	}else{
		return cellvalue+"(低)";
	}
}
function fillSourceData(obj) {
	$("#roleId").val(obj.id);
	$("#addRole_input").val(obj.name);
	var level = parseInt(obj.level.toString().substr(0,obj.level.toString().indexOf("(")))-${user.role.level}-1;
	$("#level-control").css("left",level).attr("data-original-title",level);
	var lis = $("input[name=addcheckboxOptions]");
	for(var i=0;i<lis.length;i++){
		if(obj.permissions.toString().indexOf($(lis[i]).attr("decription-data"))!=-1){
			$(lis[i]).prop("checked",true);
		}
	}
}
</script>
</html>
