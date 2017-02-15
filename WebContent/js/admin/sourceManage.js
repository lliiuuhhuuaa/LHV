/**
 * 六画
 * 资源管理
 */
$(function() {
	$.jgrid.defaults.styleUI = 'Bootstrap';
	$("#table_list").jqGrid({
		url : "json/list/source",
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
		colNames : [ 'id', '资源名称', '上传日期', '系列', '是否通过', '分类', '缩略地址',
				'资源地址', '描述' ],
		colModel : [
				{
					name : 'id',
					index : 'id',
					hidden : true
				},
				{
					name : 'name',
					index : 'name',
					editable : true,
					width : 150,
					sorttype : "string",
					search : true,
					searchoptions : {
						sopt : [ 'eq', 'ne', 'bw', 'bn', 'ew', 'en',
								'cn', 'nc' ]
					}
				},
				{
					name : 'log',
					index : 'log',
					width : 100,
					sorttype : "date",
					formatter : uploadtimeFormatter,
					formatoptions : {
						srcformat : 'Y-m-d H:i:s',
						newformat : 'Y-m-d H:i:s'
					},
					search : false
				},
				{
					name : 'seriesname',
					index : 'seriesname',
					editable : true,
					width : 50,
					sorttype : "string",
					formatter : seriesnameFormatter,
					search : true,
					searchoptions : {
						sopt : [ 'eq', 'ne', 'bw', 'bn', 'ew', 'en',
								'cn', 'nc' ]
					}
				},
				{
					name : 'ispass',
					index : 'ispass',
					width : 50,
					align : "center",
					sorttype : "float",
					formatter : passFmatter,
					search : true,
					searchoptions : {
						sopt : [ 'eq', 'ne' ]
					}
				},
				{
					name : 'category',
					index : 'category',
					width : 40,
					align : "center",
					formatter : categoryFmatter,
					search : false
					/*searchoptions : {
						sopt : [ 'cn', 'nc' ]
					}*/
				},
				{
					name : 'img',
					index : 'img',
					editable : true,
					width : 50,
					search : false,
					formatter : pathFmatter
					/*searchoptions : {
						sopt : [ 'eq', 'ne', 'bw', 'bn', 'ew', 'en',
								'cn', 'nc' ]
					}*/
				},
				{
					name : 'source',
					index : 'source',
					editable : true,
					width : 50,
					search : false,
					formatter : pathFmatter
					/*searchoptions : {
						sopt : [ 'eq', 'ne', 'bw', 'bn', 'ew', 'en',
								'cn', 'nc' ]
					}*/
				}, {
					name : 'decription',
					index : 'decription',
					editable : true,
					width : 100,
					search : true,
					searchoptions : {
						sopt : [ 'cn', 'nc' ]
					}
				} ],
		pager : "#pager_list",
		viewrecords : true,
		caption : "资源管理",
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
				if(planNum<1)
				fillSourceData($("#table_list").getRowData(ids));
				$("#editModal").modal("show");
			}
		},
		position : "first"
	})
	// Add responsive to jqGrid
	$(window).bind('resize', function() {
		var width = $('.jqGrid_wrapper').width();
		$('#table_list').setGridWidth(width);
	});
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
			var fileBox = $(".fileBox[data-type=" + $(this).attr("data-type")+ "]");
			var suffix = $(this).attr("data-type") == 'pic' ? 'accept="image/png,image/gif,image/jpeg"': '';
			// 判断当前是否有对应类型的file，没有则创建一个
			if (fileBox.length < 1) {
				fileBox = $('<div class="fileBox" data-type="'+$(this).attr("data-type") + '"><input type="file" name="file" '+ suffix + '></div>');
				$(".fileBoxs").append(fileBox);
			}else{
				if($(fileBox).find("input[type=file][name=file]")[0].files.length>0){
					$(fileBox).find("input[type=file]").attr("name",null);
					$(fileBox).append('<input type="file" name="file" '+ suffix + '>')
				}
			}
			//文件选择后事件监听
			bindEvent();
			$(fileBox).find("input[type=file][name=file]").trigger("click")
		})
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
   /*$('#editModal').on('hidden.bs.modal', function (e) {
	   $("#sourceInforForm").removeClass("rotateOutUpLeft");
	   $("#sourceInforForm").show();
	  // $("#sourceInforForm").hide();
	   $("#editModal .modal-title").html("资源更新");
	   $(".missionRecord").removeClass("rotateInUpLeft")
	   $(".missionRecord").hide();
   })*/
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
   //初始化分类
   requestCategory();
})
function bindEvent(){
    //文件更改事件
    $(".fileBox").unbind();
    $(".fileBox").bind("change",function(){
        var file = $(this).find("input[type=file][name=file]")[0].files;
        var selectFile = $(".selectFile[data-type="+$(this).attr('data-type')+"]");
        if(file.length>0){
            $(selectFile).html("已选择："+file[0].name);
            $(this).find("input[type=file][name=file]").siblings().remove();
        }else{
        	 $(this).find("input[type=file][name=file]").remove();
        	 $(this).find("input[type=file]").attr("name","file");
        }
    });
}
function passFmatter(cellvalue, options, rowObject) {
	if (cellvalue == 0)
		return '0(未通过)';
	else
		return '1(已通过)';
}
function uploadtimeFormatter(cellvalue, options, rowObject) {
	if(cellvalue!=null){
		return cellvalue.uploadtime;
	}else{
		return "";
	}
}
function seriesnameFormatter(cellvalue, options, rowObject) {
	if(cellvalue!=null&&cellvalue!=rowObject.id){
		return cellvalue;
	}else{
		return "";
	}
}
function categoryFmatter(cellvalue, options, rowObject) {
	var context = "";
	for(var i=0;i<cellvalue.length;i++){
		context += "<span data-id="+cellvalue[i].id+" style='margin-right:5px;'>"+cellvalue[i].name+"</span>";
	}
	return context;
}
//提示工具
function tooltipUtil(el,title){
	$(el).attr("title",title);
	 $(el).tooltip("show");
	 setTimeout(function(){
		 $(el).tooltip("destroy");
	 },3000)
}
function pathFmatter(cellvalue, options, rowObject){
	if(cellvalue!=null&&cellvalue instanceof Object){
		return cellvalue.path;
	}else{
		return "没有地址";
	}
}
function deleteData(ids) {
	$.post("json/deleteSource", "id=" + ids, function(data) {
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
// 填充更新的资源数据
function fillSourceData(obj) {
	$(".cancalPlan").hide();
	$("#sourceInforForm input").val("");
	$("#sourceInforForm input[name=id]").val(obj.id);
	if (obj.seriesname == ''){
		$("#sourceInforForm .seriesname").parents("tr").hide();
		$("input.mcControl").val("0");
	}else {
		$("#sourceInforForm .seriesname").parents("tr").show();
		$("#sourceInforForm .seriesname").attr("name", "seriesname");
		$("input.mcControl").val("1");
		$("#sourceInforForm input[name=seriesname]").val(obj.seriesname);
	}
	myMc($("div.mc")[0]);
	$("#sourceInforForm input[name=name]").val(obj.name);
	$("#sourceInforForm textarea[name=decription]").val(obj.decription);
	// 首页进行分类数据获取
	if (!hasCategory)
		requestCategory();
	// 缩略图路径数据填充
	if (obj.img != ''&&obj.img!='没有地址') {
		// 从地址里提取名字
		var name = obj.img.toString();
		name = name.substr(name.lastIndexOf("\\") + 1);
		$("button.imgfile").html("已选择文件:" + name);
	}else{
		$("button.imgfile").html("点击选择文件");
	}
	// 资源路径数据填充
	if (obj.source != ''&&obj.source!="没有地址") {
		// 从地址里提取名字
		var name = obj.source.toString();
		name = name.substr(name.lastIndexOf("\\") + 1);
		$("button.sourcefile").html("已选择文件:" + name);
	}else{
		$("button.sourcefile").html("点击选择文件");
	}
	//清空分类
	 $(".categoryUl").html("");
	//分类数据填充
	
	if(obj.category.toString()!=''){
		$("#treeview").treeview('expandAll', {silent: true });
		 var categorys = $(obj.category);
		for(var i=0;i<categorys.length;i++){
			var cli = $(".categoryList li[data-id="+$(categorys[i]).attr("data-id")+"]");
			if(cli!=null){
				fillCategory($(categorys[i]).attr("data-id"),$(cli).attr("data-content"),$(cli).attr("data-nodeid"));
			}
		}
		$('#treeview').treeview('collapseAll', { silent: true });
	}
}
// 移除分类
function delCategory(id) {
	$(".categoryUl li[data-id=" + id + "]").remove();
}
// 添加分类
function fillCategory(id, text, nid) {
	var li = $(".categoryUl li[data-id=" + id + "]");
	if (li.length > 0)return;
	$(".categoryUl").append($('<li data-id="'+ id+ '" node-id="'
							+ nid+ '"><span>'+ text+ '</span><i class="glyphicon glyphicon-remove"></i></li>'));
	bindCategoryRmove();
	categoryValueSet();
}
var hasCategory = false;
var categoryData;
function requestCategory() {
	$.post("json/category", '', function(data) {
		if (data.length > 0){
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
	$(".categoryUl li i").bind("click",function() {
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
var planNum=0;
function PLANNUM(a){
	if(a==0){
		planNum=0;
	}else if(a=='+'){
		planNum++;
	}else{
		planNum--;
		if(planNum<1){
			$("#editModal").modal("hide");
			parent.layer.msg('更新完成');
			$("#table_list").trigger("reloadGrid");
			$(".fileBox").remove();
			planNum=0;
		}
	}
}
//开始当前资源ID的上传任务 
function updateForm(){
	PLANNUM("+");
	$(".formPlan .sign").attr("class","sign").html("<i>0</i>%");
	$.post("json/updateSource/form",$('#sourceInforForm').serialize(),function(data) {
			if (!(data instanceof Object)) data = eval("(" + data + ")");
				if(data.message){
					$(".formPlan .sign").addClass("success").html("更新完成");
					MissionPlan("form",100);
					/*/缩略图上传*/
					 //判断是否有文件需要上传
					   var picFile = $(".fileBox[data-type=pic] input[type=file][name=file]");
					   var sourceFile = $(".fileBox[data-type=file] input[type=file][name=file]");
					   if(picFile.length>0&&picFile[0].files.length>0){
						  uploadFile("pic");//上传图片
					   }
					   if(sourceFile.length>0&&sourceFile[0].files.length>0){
						   uploadFile("file");//上传资源
					   }
					   //判断是否有文件需要上传
					   PLANNUM("-");
				}else{
					$(".formPlan .sign").addClass("failed").html("更新失败");
					$(".cancalPlan").show();
				}
		})
}
function uploadFile(type){
	PLANNUM("+");
	//if(type=='pic')
	$(".missionRecord li[data-type="+type+"] .sign").attr("class","sign").html("<i>0</i>%");
	var formData = new FormData();
	formData.append("file",$(".fileBox[data-type="+type+"] input[type=file][name=file]")[0].files[0]);
	$.ajax({
		type: "POST",
		 url: "json/updateSource/"+type+"/"+$("#sourceInforForm #id").val(),
		 data: formData ,  //这里上传的数据使用了formData 对象
		 processData : false, //必须false才会自动加上正确的Content-Type 
		contentType : false , 
	    //这里我们先拿到jQuery产生的 XMLHttpRequest对象，为其增加 progress 事件绑定，然后再返回交给ajax使用
	    xhr: function(){
	      var xhr = $.ajaxSettings.xhr();
	      if(onprogress && xhr.upload) {
	        xhr.upload.addEventListener("progress" , function(evt){onprogress(id,type,evt)}, false);
	        return xhr;
	      }
	    },
	    success:function(data){
	    	if(data!=null){
	    		data = eval("("+data+")");
	    		if(data.message){
	    			$(".missionRecord li[data-type="+type+"] .sign").addClass("success").html("更新完成");
					MissionPlan(type,100);
					PLANNUM("-");
					return;
	    		}
	    	}
	    	$(".missionRecord li[data-type="+type+"] .sign").addClass("failed").html("更新失败");
	    	$(".cancalPlan").show();
			return;
	    }
	  });
}
//任务进度条改变
function MissionPlan(type,plan){
	$(".missionRecord li[data-type="+type+"] .progress-bar").css("width",plan+"%").html(plan+"%");
	$(".missionRecord li[data-type="+type+"] .sign i").html(plan);
}
/**
 * 侦查附件上传情况 ,这个方法大概0.05-0.1秒执行一次
 */
function onprogress(id,type,evt){
 var loaded = evt.loaded;     //已经上传大小情况 
 var tot = evt.total;      //附件总大小 
 var per = Math.floor(100*loaded/tot);  //已经上传的百分比 
 MissionPlan(type,per);
}
//自动填充分类
function fillAutoCategory(key,value){
	$(".categoryUl").html("");
	var arr = value.split(",");
	for(var i=0;i<arr.length;i++){
		$('#treeview').treeview('expandAll', {silent: true });
		var lis = $('#treeview').treeview('getExpanded');
		$('#treeview').treeview('collapseAll', { silent: true });
		for(var j=0;j<lis.length;j++){
			if(arr[i]==lis[j].id){
				$('#treeview').treeview('selectNode', [lis[j].nodeId, { silent: true } ]);
				fillCategory(arr[i], lis[j].text, lis[j].nodeId);
				break;
			}
		}
	} 
}