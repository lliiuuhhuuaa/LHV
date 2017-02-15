/**
 * 六画
 * 资源管理
 */
$(function() {
	$.jgrid.defaults.styleUI = 'Bootstrap';
	$("#table_list").jqGrid({
		url : "json/list/user",
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
		colNames : [ 'id', '用户名', '手机号码', '邮箱地址', 'VIP等级','一句话描述' ],
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
					name : 'phoneNo',
					index : 'phoneNo',
					width : 100,
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
					width : 100,
					sorttype : "string",
					search : true,
					searchoptions : {
						sopt : [ 'eq', 'ne', 'bw', 'bn', 'ew', 'en',
								'cn', 'nc' ]
					}
				},
				{
					name : 'vipLevel',
					index : 'vipLevel',
					width : 50,
					align : "center",
					sorttype : "int",
					search : false
				},
				{
					name : 'presentation',
					index : 'presentation',
					search : true,
					searchoptions : {
						sopt : [ 'cn', 'nc' ]
					}
				}],
		pager : "#pager_list",
		viewrecords : true,
		caption : "用户管理",
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
			}else if(ids.indexOf(userId)!=-1){
				parent.layer.msg("不能删除当前登陆账户");
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
	/*$("#table_list").navButtonAdd('#pager_list', {
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
				if(planNum<1)
				fillSourceData($("#table_list").getRowData(ids));
				$("#editModal").modal("show");
			}
		},
		position : "first"
	})*/
	// Add responsive to jqGrid
	$(window).bind('resize', function() {
		var width = $('.jqGrid_wrapper').width();
		$('#table_list').setGridWidth(width);
	});
		 //表单提交 
   $("#sourceInforForm").submit(function(){
	   var isPass = true;
	   if($(".sourceInfor input[name=name]").val()==''){
		   tooltipUtil($(".sourceInfor input[name=name]"),"名称不能为空");
		   isPass = false;
	   }
	   if($(".categoryUl li").length<1){
		   tooltipUtil($(".categoryUl"),"分类至少选择一项");
		   isPass = false;
	   }
	   //系列开关
	   if($("#sourceInforForm .mcControl").val()=='1'){
		   if($("#sourceInforForm .seriesname").val().trim()==''){
			   tooltipUtil($("#sourceInforForm .seriesname"),"系列名不能为空");
			   isPass = false;
		   }
		   if($("#sourceInforForm .seriesname").attr("name")=='undefined'){
			   $("#sourceInforForm .seriesname").attr("name","seriesname");
		   }
	   }else{
		   $("#sourceInforForm .seriesname").attr("name",null);
	   }
	   if(isPass){
		   PLANNUM("0");
		   $(".categoryList").hide();
		   //获取选中的节点
		   var ids = $("#treeview").treeview('getSelected');
		   //取消选中节点 
		   $("#treeview").treeview('unselectNode', [ids, { silent: true } ]);
		   //显示进度条隐藏表单
		   $("#sourceInforForm").addClass("rotateOutUpLeft");
		   $("#sourceInforForm").hide();
		   $("#editModal .modal-title").html("更新进度");
		   $(".missionRecord").addClass("rotateInUpLeft");
		   $(".missionRecord").show();
		   updateForm();//表单进行提交
		 //判断是否有文件需要上传
		   var picFile = $(".fileBox[data-type=pic] input[type=file][name=file]");
		   var sourceFile = $(".fileBox[data-type=file] input[type=file][name=file]");
		   if(picFile.length>0&&picFile[0].files.length>0){
			  $(".missionRecord li[class=picPlan]").show();
		   }else{
			   $(".missionRecord li[class=picPlan]").hide();
		   }
		   if(sourceFile.length>0&&sourceFile[0].files.length>0){
			   $(".missionRecord li[class=sourcePlan]").show();
		   }else{
			   $(".missionRecord li[class=sourcePlan]").hide();
		   }
		   //判断是否有文件需要上传
	   }else{
		   tooltipUtil($(this).find("button[type=submit]"),"资源基本信息还未完善");
	   }
	   return false;
   })
})
//提示工具
function tooltipUtil(el,title){
	$(el).attr("title",title);
	 $(el).tooltip("show");
	 setTimeout(function(){
		 $(el).tooltip("destroy");
	 },3000)
}
function rowIdFmatter(cellvalue, options, rowObject) {
	return options.rowId;
}
function deleteData(ids) {
	$.post("json/deleteUser", "id=" + ids, function(data) {
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
			parent.layer.msg('删除失败:'+data.cause, {
				icon : 2
			});
		}
	})
}
