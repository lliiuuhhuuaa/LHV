/**
 * 六画
 * 资源管理
 */
$(function() {
	$.jgrid.defaults.styleUI = 'Bootstrap';
	$("#table_list").jqGrid({
		url : "json/list/specialSource",
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
		colNames : [ 'id', '资源名称或系列名称', '主题','展示大图地址','一句话描述' ],
		colModel : [
				{
					name : 'id',
					index : 'id',
					hidden : true
				},{
					name : 'source',
					index : 'source',
					width : 50,
					align : "center",
					sorttype : "float",
					formatter : sourceFmatter,
					search : true,
					searchoptions : {
						sopt : [ 'eq', 'ne' ]
					}
				},
				{
					name : 'theme',
					index : 'theme',
					width : 40,
					align : "center",
					formatter :colorFmatter,
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
					formatter : imgFmatter
					/*searchoptions : {
						sopt : [ 'eq', 'ne', 'bw', 'bn', 'ew', 'en',
								'cn', 'nc' ]
					}*/
				}, {
					name : 'oneDecript',
					index : 'oneDecript',
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
				$("#editModal .modal-title").html("更新展示资源");
				$("#editModal button[type=submit]").html("确认更新");
				$("img.img").attr("src",null).attr("title",null);
				$("#editModal").modal("show");
			}
		},
		position : "first"
	})
	// 向表格添加编辑按钮
	$("#table_list").navButtonAdd('#pager_list', {
		caption : "",
		title : "添加",
		buttonicon : "glyphicon glyphicon-plus",
		onClickButton : function() {
			// 多行选取
			var ids = $("#table_list").jqGrid("getDataIDs", "none");
			if(ids.length>=10){
				parent.layer.msg("最多只能添加10条展示");
				return;
			}
			$("#editModal .modal-title").html("添加展示资源");
			$("#editModal button[type=submit]").html("确认添加");
			$("#sourceInforForm input").val("");
			$("button.selectFile").html("点击选择文件");
			$("img.img").attr("src",null).attr("title",null);
			$("#editModal").modal("show");
		},
		position : "first"
	})
	// Add responsive to jqGrid
	$(window).bind('resize', function() {
		var width = $('.jqGrid_wrapper').width();
		$('#table_list').setGridWidth(width);
	});
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
	   if($("#source_id").val()==''){
		   tooltipUtil($("#sourceInforForm .sourcename"),"名称不能为空");
		   isPass = false;
	   }
	   if($("#sourceInforForm input[name=oneDecript]").val()==''){
		   tooltipUtil($("#sourceInforForm input[name=oneDecript]"),"介绍不能为空");
		   isPass = false;
	   }
	   if($("#sourceInforForm input[name=theme]").val()==''){
		   tooltipUtil($("#sourceInforForm input[name=theme]"),"主题颜色不能为空");
		   isPass = false;
	   }
	   var picFile = $(".fileBox[data-type=pic] input[type=file][name=file]");
	   if(!(picFile.length>0&&picFile[0].files.length>0)&&$("#id").val()==""){
		   tooltipUtil($("#sourceInforForm .selectFile"),"图片不能不选呀");
		   isPass = false;
	   }
	   if(isPass){
		   PLANNUM("0");
		   //显示进度条隐藏表单
		   $("#sourceInforForm").addClass("rotateOutUpLeft");
		   $("#sourceInforForm").hide();
		   $("#editModal .modal-title").html("更新进度");
		   $(".missionRecord").addClass("rotateInUpLeft");
		   $(".missionRecord").show();
		   updateForm();//表单进行提交
		 //判断是否有文件需要上传
		   
		   if(picFile.length>0&&picFile[0].files.length>0){
			  $(".missionRecord li[class=picPlan]").show();
		   }else{
			   $(".missionRecord li[class=picPlan]").hide();
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
   //初始化颜色插件
   $('.colorpicker').colorpicker();
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
            if($("#sourceInforForm .img").length<1){
        		$(".selectFile[data-type=pic]").parent().before('<img class="img" src="'+window.URL.createObjectURL(file[0])+'">')
        	}else{
        		$(".selectFile[data-type=pic]").parents("td").find(".img").attr("src",window.URL.createObjectURL(file[0]));
        	}
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
        }else{
        	 $(this).find("input[type=file][name=file]").remove();
        	 $(this).find("input[type=file]").attr("name","file");
        }
    });
}
function colorFmatter(cellvalue, options, rowObject) {
	if(cellvalue!=null){
		return "<p style='width:80px;height:20px;border:1px solid #000;background:"+cellvalue+"' data-theme='"+cellvalue+"'></p>";
	}else{
		return "";
	}
}
function sourceFmatter(cellvalue, options, rowObject) {
	if(cellvalue!=null){
		if(cellvalue.seriesname!=cellvalue.id){
			return "<span data-id='"+cellvalue.id+"'>"+cellvalue.seriesname+"</span>";
		}else{
			return "<span data-id='"+cellvalue.id+"'>"+cellvalue.name+"</span>";
		}
	}
	return "";
}
function imgFmatter(cellvalue, options, rowObject) {
	if(cellvalue!=null&&cellvalue.path!=null){
		return cellvalue.path;
	}else{
		return "没有地址";
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
function deleteData(ids) {
	$.post("json/deleteSpecialSource", "id=" + ids, function(data) {
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
	$("#source_id").val($(obj.source).attr("data-id"));
	$("#sourceInforForm .seriesname").val($(obj.source).html());
	$("#sourceInforForm input[name=oneDecript]").val(obj.oneDecript);
	$("#sourceInforForm input[name=theme]").val($(obj.theme).attr("data-theme"));
	// 缩略图路径数据填充
	if (obj.img != ''&&obj.img!='没有地址') {
		// 从地址里提取名字
		var name = obj.img.toString();
		name = name.substr(name.lastIndexOf("\\") + 1);
		$("button.imgfile").html("已选择文件:" + name);
	}else{
		$("button.imgfile").html("点击选择文件");
	}
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
	$.post("json/updateSpecialSource/form",$('#sourceInforForm').serialize(),function(data) {
			if (!(data instanceof Object)) data = eval("(" + data + ")");
				if(data.message){
					$(".formPlan .sign").addClass("success").html("更新完成");
					MissionPlan("form",100);
					$("#sourceInforForm #id").val(data.id);
					/*/缩略图上传*/
					 //判断是否有文件需要上传
					   var picFile = $(".fileBox[data-type=pic] input[type=file][name=file]");
					   if(picFile.length>0&&picFile[0].files.length>0){
						  uploadFile("pic");//上传图片
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
		 url: "json/updateSpecialSource/"+$("#sourceInforForm #id").val(),
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
