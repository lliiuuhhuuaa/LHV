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

<title>管理员维护</title>

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
	li{
		list-style: none;
	}
	#add-user-linkman{
		cursor:pointer;
	}
	#add-user-linkman:hover{
		background:#FFF;
	}
	.selectUserList{
		height:30px;
		cursor:pointer;
	}
	.selectUserList:hover{
		background:rgba(0,0,0,0.2);
	}
	.selectUserList.active_0{
		height:30px;
		background:rgba(0,150,0,0.5);
	}
	#selectUserTable{
		height:200px;
		overflow:auto;
	}
	.selectUserSearchInput{
		width:300px;
		float:left;
	}
	#selectUserListSearch{
		cursor:pointer;
	}
	.add_username{
		margin:0;padding:0;
		height:40px;
		line-height:40px;
		border:1px solid #CCCCCC;
		overflow:hidden;
	}
	.add_username>div{
		width:440px;
	}
	.input-group-addLinkMan{
		float:left;
	}
	#addManagerArea{
		overflow:hidden;
	}
	#add_username_ul{
		margin:0;padding:0;
		height:40px;
		 width:1000px;
		line-height:40px;
		border:1px solid #CCCCCC;
		overflow:hidden;
	}
	#add_username_input{
		width:450px;
		float:left;
		border:none;
		outline:none;
	}
	.member{
		height:40px;
		float:left;
		margin:0 2px;
	}
	.member:hover{
		height:40px;
	}
	.autoComplate{
		background:#FFF;
		position:fixed;
		z-index:10;
		display:none;
	}
	.autoComplate a{
		height:40px;
		line-height:20px;
		vertical-align: middle;
	}
	.autoComplate a:hover{
		/* background:#337AB7;
		color:#FFF; */
		cursor:pointer;
	}
	.autoComplate p{
		border:1px solid #CCCCCC;
		height:25px;
		line-height:25px;
		text-align:right;
		font-size:15px;
		padding:0 10px;margin:0;
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
		<!--添加管理员开始-->
		<div class="modal fade" id="addManager" tabindex="-1" role="dialog"
			aria-labelledby="myModalLabelMoreData" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content" id="addManagerArea">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title switch-title">添加管理员</h4>
					</div>
					<div class="modal-body">
						<table class="table">
							<tbody>
								<tr>
									<td><div class="input-group" id="add-user"
											data-toggle="popover" data-placement="top"
											data-content="必须至少选择一位用户！">
											<span class="input-group-addon">用户：</span>
											<div class="add_username">
												<div>
													<!-- 多加一个div是为了适应bootstrap -->
													<ul id="add_username_ul">
														<li id="add_username_input_li"><input
															id="add_username_input" type="text" source-data=""
															placeholder="输入关键字搜索"></li>
													</ul>
												</div>
												<div class="list-group autoComplate"
													id="autoComplateContext">
													<p>查询结果：总&nbsp;<strong><span id="searcRresult">0</span></strong>&nbsp;条记录</p>
												</div>
											</div>
											<span class="input-group-addon" id="add-user-linkman"
												data-toggle="modal" data-target="#addLinkMan"> <span
												class="glyphicon glyphicon-user"></span>
											</span>
										</div></td>
								</tr>
								<tr>
									<td><div class="input-group" id="add-role"
											data-toggle="popover" data-placement="top"
											data-content="选择赋予的角色 ！">
											<span class="input-group-addon" style="width:50px">角色：</span>
											<div style="margin-left:10px;">
											<c:forEach items="${requestScope.roles}" var="s">
												<label class="radio-inline"> <input type="radio" data-text="${s.name}" 
													name="addRadioOptions" id="inlineRadio${s.id}"
													data-id="${s.id}" value="${s.id}">${s.name}
												</label>
											</c:forEach>
											</div>
										</div></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
						<button type="button" class="btn btn-primary" id="suerAddManager"
							data-toggle="popover" data-placement="left"
							data-content="添加管理员失败">添加</button>
					</div>
				</div>
			</div>
			<div class="modal fade" id="addLinkMan" tabindex="-1" role="dialog"
				aria-labelledby="myModalLabelMoreData" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close addLinManClose"
								aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
							<h4 class="modal-title">选择用户</h4>
						</div>
						<div class="modal-body" style="padding:10;">
							<table class="table" style="margin:0;">
								<thead>
									<tr>
										<th>序号</th>
										<th>用户名</th>
										<th>邮箱</th>
										<th>手机号</th>
									</tr>
								</thead>
							</table>
							<div id="selectUserTable" data-spy="scroll"
								data-target="#myScrollspy" data-offset="0">
								<table class="table" style="margin:0;">
									<tbody id="selectUserListBox"
										style="height:300px;position: relative;" data-page="1"
										total-page="1"></tbody>
								</table>
							</div>
						</div>
						<div class="modal-footer" style="padding-top:0;">
							<div class="col-lg-12">
								<span class="input-group-addon">查询结果：总&nbsp;<strong><span
										class="showTotalNum">0</span></strong>&nbsp;条 </span>
								<div class="input-group selectUserSearchInput"
									style="width:350px">
									<input type="text" class="form-control"
										id="selectUserSearchContext"
										placeholder="输入关键字搜索"> <span
										class="input-group-addon" id="selectUserListSearch"
										style="width:50px"> <span
										class="glyphicon glyphicon-search"></span>
									</span>
									<!-- /input-group -->
								</div>
								<button type="button" class="btn btn-default addLinManClose">关闭</button>
								<button type="button" class="btn btn-primary addLinManClose">确定</button>
							</div>
						</div>
						<!-- /.row -->
					</div>
				</div>
			</div>
		</div>
		<!-- 添加管理员结束 -->
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
		url : "json/list/manager",
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
		colNames : [ 'id','用户名','邮箱','手机号码','昵称','当前角色','最后一次登陆时间'],
		colModel : [
				{
					name : 'id',
					index : 'id',
					hidden : true
				},
				{
					name : 'username',
					index : 'username',
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
					name : 'email',
					index : 'email',
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
					name : 'phoneNo',
					index : 'phoneNo',
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
					name : 'nickname',
					index : 'nickname',
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
					name : 'role',
					index : 'role',
					editable : true,
					width : 50,
					sorttype : "string",
					search : true,
					formatter : roleFormat,
					searchoptions : {
						sopt : [ 'eq', 'ne', 'bw', 'bn', 'ew', 'en',
								'cn', 'nc' ]
					}
				},
				{
					name : 'lastLoginTime',
					index : 'log.lastLoginTime',
					editable : true,
					width : 100,
					sorttype : "date",
					formatter : dateFormat,
					search : false
				} ],
		pager : "#pager_list",
		viewrecords : true,
		caption : "管理员维护",
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
				$("#add-user-linkman").hide();
				$("#add_username_input_li").hide();
				$(".switch-title").html("修改管理员");
				$("#suerAddManager").html("修改");
				fillSourceData($("#table_list").getRowData(ids));
				$("#addManager").modal("show");
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
			$("input[name=addRadioOptions]").prop("checked",false);
			$("#add-user-linkman").show();
			$("#add_username_input_li").show();
			$(".switch-title").html("添加管理员");
			$("#suerAddManager").html("添加");
			$(".member").remove();
			$(".selectUserList").removeClass("active_0");
			$("#addManager").modal("show");
		},
		position : "first"
	})
	// Add responsive to jqGrid
	$(window).bind('resize', function() {
		var width = $('.jqGrid_wrapper').width();
		$('#table_list').setGridWidth(width);
	});
	//选择用户搜索
	$("#selectUserSearchContext").keydown(function(event){
		if(event.which==13){
			selectUserListSearch();
		}
	})
	$("#selectUserListSearch").click(function(){
		selectUserListSearch();
	})
	
   $("#addManager").on("hide.bs.modal",function() {
   	if ($(".modal-backdrop").get(1) != null) {
			$(".modal-backdrop").get(1).remove();
		}
   })
   $("#addManager").on("shown.bs.modal", function() {
		$("#add_username_input").focus();
	})
	$("#addManager").on("hidden.bs.modal", function() {
		$("#add-user-linkman").unbind();
		$("#sureAddManager").unbind();
	})
   //选择用户显示时
	 $("#addLinkMan").on("show.bs.modal",function() {
		$("#addLinkMan").css("top",$("#addManagerArea").offset().top + 150);
		$(".addLinManClose").click(function() {
			$("#addLinkMan").modal("hide");
		})
		if($("#selectUserListBox").html()==''){
			showSelectUserRow=0;
			selectUserListSearch();
		}

	})
	$("#addLinkMan").on("hidden.bs.modal", function() {
		$(".addLinManClose").unbind();
	})
	$("#suerAddManager").click(function(){
		addManagerSure();
	})
	/* 实现延迟加载数据 */
	var mousewheel = document.all ? "mousewheel" : "DOMMouseScroll";
	$("#selectUserTable").bind("mousewheel", function(event, delta) {
		var table = $(this);
		if (delta < 0) {
			console.log($(this).scrollTop() + "=" + (this.scrollHeight - 300))
			if ($(this).scrollTop() >= this.scrollHeight - 300) { // 此除去除滚动条本身高度200,另100是预加载
				if (sysnchronized)
					return;
				sysnchronized = true;//同步
				var currentPage = $("#selectUserListBox").attr("data-page");
				var totalPage = $("#selectUserListBox").attr("total-page");
				if (currentPage < totalPage) {	//当前页少于总页时请求数据
					$("#selectUserListBox").attr("data-page", ++currentPage);
					getNoRoleUser();
				} else
					sysnchronized = false;
			}
		}
	});
	 $("#selectUserTable").scroll(function(event){
		 console.log($(this).scrollTop() + "=" + (this.scrollHeight - 200))
		 if ($(this).scrollTop() >= this.scrollHeight - 200) { // 此除去除滚动条本身高度200,另100是预加载
				if (sysnchronized)
					return;
				sysnchronized = true;//同步
				var currentPage = $("#selectUserListBox").attr("data-page");
				var totalPage = $("#selectUserListBox").attr("total-page");
				if (currentPage < totalPage) {	//当前页少于总页时请求数据
					$("#selectUserListBox").attr("data-page", ++currentPage);
					getNoRoleUser();
				} else
					sysnchronized = false;
			}
	 });
	//添加管理员用户搜索
	$("#add_username_input").keyup(function(event){
		if(event.which==40){
			var aTags = $("#autoComplateContext a");
			$("#autoComplateContext a").removeClass();
			$("#autoComplateContext a").addClass("list-group-item");
			var aLength = $("#autoComplateContext a").length;
			if(aLength<6&&currentCursorRow==aLength-1||currentCursorRow==5){
				currentCursorRow=-1;
			}
			aTags[++currentCursorRow].setAttribute("class", "list-group-item active")
		}else if(event.which==38){
			var aTags = $("#autoComplateContext a");
			$("#autoComplateContext a").removeClass();
			$("#autoComplateContext a").addClass("list-group-item");
			var aLength = $("#autoComplateContext a").length;
			if(currentCursorRow<=0){
				if(aLength<6)currentCursorRow=aLength;
				else currentCursorRow=6;
			}
			aTags[--currentCursorRow].setAttribute("class", "list-group-item active")
		}else if(event.which==13&&$("#autoComplateContext a").length>0){
			var currentA = $("#autoComplateContext a[class='list-group-item active']");
			if(currentA.length<1){	//如果此时没有选中项则默认选则第一项
				currentA=$("#autoComplateContext a:first");
			}
			var value = currentA[0].innerHTML;
			value = value.substr(value.indexOf("：")+1);
			this.value="";	//清空输入值
			addMember(currentA.attr("data-text"),value);	//添加成员
			$("#autoComplateContext").hide();	//隐藏自动提示
			$(this).attr("source-data","");
		}else{
			if(this.value.trim()==''){
				$("#autoComplateContext a").remove();
				$("#autoComplateContext").hide();
			}else if(this.value.trim()!=$(this).attr("source-data")){
				currentCursorRow=-1
				autoComplate(this)
			}
			$(this).attr("source-data",this.value.trim());
		}
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
	$.post("json/cancelRoleForUser", "id=" + ids, function(data) {
		if(!(data instanceof Object))data = eval("("+data+")");
		if (data.message && data.result > 0) {
			if (ids.toString().indexOf(",") != -1) {
				var idArr = ids.toString().split(",");
				for (var i = 0; i < idArr.length; i++)
					$("#table_list").delRowData(idArr[i]);
			} else {
				$("#table_list").delRowData(ids);
			}
			parent.layer.msg('已删除' + data.result + '个记录', {
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
//自动完成
var currentCursorRow=-1;
function autoComplate(el){
	var data = "page=1&rows=6&search=true&searchField=username&searchField=phoneNo&searchField=email&"
	+"searchOper=nn&searchOper=nn&searchOper=nn&searchString="+el.value.trim()
	+"&searchString="+el.value.trim()+"&searchString="+el.value.trim();
		$.post("json/list/getNoRoleUsers",data,function(data) {
			$("#autoComplateContext a").remove();
			$("#autoComplateContext").show();
			$("#searcRresult").html(data.records);
			for (var i = 0; i < data.rows.length&&i<7; i++) {
				fillAutoComplateData(data.rows[i],el.value.trim());
			}
			$("#autoComplateContext a").unbind();
			$("#autoComplateContext a").mouseover(function(){
				$("#autoComplateContext a").removeClass();
				$("#autoComplateContext a").addClass("list-group-item");
				this.setAttribute("class","list-group-item active");
				currentCursorRow = $("#autoComplateContext a").index(this);//获取当前下标
			})
			$("#autoComplateContext a").mousedown(function(){
				var value = this.innerHTML;
				value = value.substr(value.indexOf("：")+1);
				el.value="";
				$("#autoComplateContext").hide();
				addMember($(this).attr("data-text"),value);
			})
			//sysnchronized = false;
			
		}
	)
}
function fillAutoComplateData(data,value){
	console.log(data)
	var text = data.username!=null&&data.username.indexOf(value)!=-1?"用户名："
			+data.username:data.email!=null&&data.email.indexOf(value)!=-1?"邮箱："+data.email:"手机号："+data.phoneNo;
	var aTag = $("<a class='list-group-item' data-text="+data.id+">"+text+"</a>");
	$("#autoComplateContext p").before(aTag);
}
//添加用户确认按钮事件
function addManagerSure(){
	var members = $(".member");
	if(members.length<1){
		$("#add-user").popover("show")
		return;
	}
	$("#add-user").popover("destroy")
	var selectRole = $("#add-role input:radio:checked").val();
	if(selectRole==null){
		$("#add-role").popover("show");
		return;
	}
	$("#add-role").popover("destroy");
	if(selectRole<currentLevel){
		parent.layer.msg('修改权限不能高于自己！！', {icon : 2});
		return;
	}
	var data="";
	for(var i=0;i<members.length;i++){
		data += "member="+members[i].getAttribute("data-text")+"&";
	}
	data += "roleId="+selectRole;
	$.post("json/updateRoleForUser",data,function(data){
			if(!(data instanceof Object))data = eval("("+data+")");
			$("#addManager").modal("hide");
			if(data.message){
				parent.layer.msg('成功操作'+data.result+"位管理员", {shift :1});
				$("#table_list").trigger("reloadGrid");
				return;
			}else{
				parent.layer.msg('操作失败:'+data.cause, {shift :6});
			}
		})
	
}
//选择用户搜索方法中转
function selectUserListSearch(){
	showSelectUserRow=0;
	$("#selectUserListBox").html("");
	var page = $("#selectUserListBox").attr("data-page","1");
	getNoRoleUser();
}
var sysnchronized = false;	//用作同步
function getNoRoleUser() {
	var search=$("#selectUserSearchContext").val();
	var data = "page="+$("#selectUserListBox").attr("data-page")+"&rows=10"+(search!=''?"&search=true&searchField=username&searchField=phoneNo&searchField=email&"
		+"searchOper=nn&searchOper=nn&searchOper=nn&searchString="+search+"&searchString="+search+"&searchString="+search:"");
	var page = $("#selectUserListBox").attr("data-page");
	$.post("json/list/getNoRoleUsers",data,function(data) {
		$("#selectUserListBox").attr("total-page",	//设置总页属性
				data.total);
		$(".showTotalNum").html(data.records);	//设置显示的总条数
		console.log(data.rows.length)
		for (var i = 0; i < data.rows.length; i++) {
			fillData(data.rows[i]);
		}
		sysnchronized = false;
		$(".selectUserList").unbind("click");
		$(".selectUserList").click(function(){
			selectUserListClick(this);
		});
	})
}
function selectUserListClick(el){
		if($(".member").length>=3){
			parent.layer.msg('一次只能选择3位！！', {icon : 2});
			return;
		}
		$(el).addClass("active_0");
			var tds = el.getElementsByTagName("td");
			var text = (tds[1].innerHTML == '-' ? tds[2].innerHTML == '-' ? tds[3].innerHTML
					: tds[2].innerHTML
					: tds[1].innerHTML);
			
			addMember($(el).attr("data-text"),text);
			$(el).unbind("click");
			$(el).click(function(){
				$(this).removeClass("active_0");
				$(".member[data-text='"+$(el).attr("data-text")+"']").remove();
				$(this).click(function(){
					selectUserListClick(this);
				})
			});
}
function addMember(id,text){
	if($(".member[data-text='"+id+"']").length>0)return;
	if($(".member").length>=3){
		parent.layer.msg('一次只能选择3位！！', {icon : 2});
		return;
	}
	var li = $("<li class='member' data-text='"+id+"'><span>"
			+ text
			+ "</span><button type='button' class='close' onclick='removeWin(this)' aria-label='Close'><span>&times;</span></li>");
	$("#add_username_input_li").before(li);
	var selectUserList = $(".selectUserList[data-text='"+id+"'");
	if(selectUserList.length>0){	//添加成员时判断是否有没被选中的，有则选中
		$(selectUserList[0]).addClass("active_0");
	}
}
var showSelectUserRow=0;//显示行数
function fillData(data) {
	var boolContain=false;//用于记录当前数据是否已被选中
	//获取第一个不为空的值
	//var text = data.username!=null?data.username:data.email!=null?data.email:data.phone;
	//var boolText = data.username+data.email+data.phone;	//用于判断已选择成员是否包含其内
	var classText = "selectUserList";
	var member = $(".member>span");
	//判断获取的数据是否有已选中的
	for(var i=0;i<member.length;i++){
		if($(".member[data-text='"+data.id+"']").attr("data-text")==data.id){
			boolContain = true;
			classText = "selectUserList active_0";
		}
	}
	var tr = $("<tr class='"+classText+"' data-text='"+data.id+"'><td>"+(++showSelectUserRow)+"</td><td>"
			+ (data.username == null ? '-' : data.username) + "</td><td>"
			+ (data.email == null ? '-' : data.email) + "</td><td>"
			+ (data.phoneNo == null ? '-' : data.phoneNo) + "</td></tr>")
	$("#selectUserListBox").append(tr);
	if(boolContain){
		$(".selectUserList.active_0[data-text='"+data.id+"'").unbind("click");
		$(".selectUserList.active_0[data-text='"+data.id+"'").click(function(){
			$(this).removeClass("active_0");
			$(".member[data-text='"+data.id+"']").remove();
			$(this).click(function(){
				selectUserListClick(this);
			})
		});
	}
}
function pagingGo(el) { // 分页数据请求
	var current = el.getElementsByTagName("a")[0].getAttribute("paging-data");
	if (current != null) {
		if (current != currentPage && current <= totalPage) {
			parent.loaderAnimation();
			$("#currentPage").val(current);
			$("#ScopeSearch").submit();
		}
	}
}

//格式化权限显示
function roleFormat(cellvalue, options, rowObject) {
	return cellvalue.name;
}
function dateFormat(cellvalue, options, rowObject) {
	if(cellvalue==null)return "未登陆";
	return new Date(cellvalue).Format("yyyy-MM-dd hh:mm:ss");
}
function fillSourceData(obj) {
	$(".member").remove();
	$("#add_username_ul").append($('<li class="member" data-text="'+obj.id+'"><span>'+obj.username+'</span></li>'));
	$("input[name=addRadioOptions]").prop("checked",false);
	$("input[name=addRadioOptions][data-text="+obj.role.trim()+"]").prop("checked",true);
}
//移除selectUserListChecked
function removeWin(el) {
	var text = $(el).parent().attr("data-text");
	$(el.parentNode).remove();
	var selectUserListChecked = $(".selectUserList.active_0[data-text='"+text+"']")[0];
	if(selectUserListChecked!=null){
		$(selectUserListChecked).removeClass("active_0");
		selectUserListChecked.click(function(){
			selectUserListClick(this);
		})
	}
}
Date.prototype.Format = function (fmt) { 
    var o = {
        "M+": this.getMonth() + 1, //月份 
        "d+": this.getDate(), //日 
        "h+": this.getHours(), //小时 
        "m+": this.getMinutes(), //分 
        "s+": this.getSeconds(), //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds() //毫秒 
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}
</script>
</html>
