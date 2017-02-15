/**
 * Created by 甜橙六画 on 2016/12/7.
 */
$(function () {
    //选择文件
    $(".selectFile").click(function(){
        var fileBox = $(".fileBox[data-id="+FID()+"][data-type="+$(this).attr("data-type")+"]");
        //判断当前是否有对应ID的file，没有则创建一个
        if(fileBox.length<1) {
        	var suffix = $(this).attr("data-type")=='pic'?'accept="image/png,image/gif,image/jpeg"':'';
            fileBox = $('<div class="fileBox" data-type="' + $(this).attr("data-type") + '" data-id="' + FID() + '"><input type="file" name="file" '+suffix+'></div>');
            $(".fileBoxs").append(fileBox);
            bindEvent();//绑定事件
        }
        $(fileBox).find("input[type=file]").trigger("click");
    });
    //名称输入后事件
    $("input[name=name]").change(function(){
    	 formRecord();//表单任务设置
    });
    //重置
    $("button[type=reset]").click(function(){
    	var lis = $(".missionRecord li[data-id="+FID()+"][data-type=form]");
    	if(lis.length>0){
    		if($(lis).find(".waitUpload").length>0){
    			if(!confirm("当前资源任务还没有上传，确认放弃当前资源任务吗？")){
    				return false;
    			}else{
    				$(".missionRecord li[data-id="+FID()+"]").remove();
    				$(".fileBox[data-id="+FID()+"]").remove();
    			}
    		}
    	}
    	if($("input[name=name]").val()==''&&$(".fileBox[data-id="+FID()+"]").length>0){
    		$(".missionRecord li[data-id="+FID()+"]").remove();
    		$(".fileBox[data-id="+FID()+"]").remove();
    	}
        $("#id").val("");
        $(".selectFile").html("点击选择文件");
        $(".categoryUl").html("");
        $("#sourceInforForm .img").remove();
        cancelAllSelect();
    })
    //分类选择
    $(".categoryUl").click(function(){
    	$(".categoryTree").toggle();
    	return false;
    })
    //关闭事件
    $(".closeMySelf").click(function(){
    	$(this).parent().hide();
    })
    //表单提交 
   $("#sourceInforForm").submit(function(){
	   if(isSubmiting)return;
	   isSubmiting=true;
	   createLog("开始进行资源信息验证");
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
	   if($(".missionRecord li[data-id="+FID()+"][data-type=form]").length<1){
		   formRecord();
		   tooltipUtil($(this).find("button[type=submit]"),"资源基本信息还未完善");
		   isPass = false;
	   }
	   if(isPass){
		   createLog("资源信息验证通过");
		   if(missionExist(FID(),"form")){
			   createLog("资源信息已存在于任务列表");
			   isSubmiting=false;
			   return false;
		   }
		   updateMission(FID())
	   }else{
		   createLog("资源信息验证失败");	
		   isSubmiting=false;
	   }
	   return false;
   })
  /* $("#sourceInforForm").change(function(){
	   alert("change")
   })*/

	 //初始化分类
	 requestCategory();
 // 分类输入框点击事件
	$(".categoryUl").click(function() {
		var modal = $(".sourceInfor")[0];
		$(".categoryList").css("left", modal.offsetWidth);
		$(".close-link").unbind();
		$(".close-link").bind("click", function() {
			$(".categoryList").hide();
		})
		$(".categoryList").toggle();
	})
});
//防止表单重复提交
var isSubmiting=false;
//移除分类
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
//分类请求
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
			if($(".categoryUl li").length>=10){
				$('#treeview').treeview('unselectNode',[data.nodeId, {silent : true}]);
				parent.layer.msg("最多添加10个分类");
			}else
				fillCategory(data.id, data.text, data.nodeId)
		});
		$('#treeview').on('nodeUnselected', function(event, data) {
			delCategory(data.id)
		});
	})
}
//创建上传记录
function createRecord(id,type,value,size){
    removeRecord(id,type);
    var newLi = $('<li data-id="'+id+'" data-type="'+type+'" data-size="'+size+'"><div>'+value+'</div><div><div class="progress"><div class="progress-bar" style="width:0%;">0%</div></div></div><div class="state waitUpload">等待上传</div></li>');
    if(type=='form'){
    	var li = $(".missionRecord li[data-id="+id+"]");
    	if(li.length>0)
    		$(li[0]).before(newLi);
    	else
    		$(".missionRecord ul").append(newLi);
    	
    }else
    	$(".missionRecord ul").append(newLi);
    bindEvent();//绑定事件
}
//移除上传记录
function removeRecord(id,type){
   var li = $(".missionRecord ul li[data-id="+id+"][data-type="+type+"]");
    if(li.length>0){
        if($(li).find(".waitUpload").length>0)
            $(li).remove();
        else
            alert("任务不是准备状态，不能修改，请重构新资源!!");
    }
}
//获取当前ID
function FID(){
    if($("#id").val()==''){
        $("#id").val(new Date().getTime());
    }
    return $("#id").val();
}
//绑定全局事件
function bindEvent(){
    //文件更改事件
    $(".fileBox").unbind();
    $(".fileBox").bind("change",function(){
        var file = $(this).find("input[type=file]")[0].files;
        var selectFile = $(".selectFile[data-type="+$(this).attr('data-type')+"]");
        if(file.length>0){
            $(selectFile).html("已选择："+file[0].name);
            createRecord($(this).attr("data-id"),$(this).attr("data-type"),"文件:"+file[0].name,file[0].size);
        }else{
            $(selectFile).html("点击选择文件");
            removeRecord($(this).attr("data-id"),$(this).attr("data-type"));
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
    //状态取消事件
    $(".state").unbind();
    $(".state").bind("mouseenter",function(){
        $(this).attr("sourceState",$(this).html());
        $(this).html("取消任务");
        $(this).addClass("active");
        var _this = this;
        $(this).click(function(){
        	$("button[type=reset]").trigger("click");
           /* var id = $(_this).parent().attr("data-id");
            var type = $(_this).parent().attr("data-type");
            if(FID()==id){
                if(type=='form') $("input[name=name]").val("");
                else $(".selectFile[data-type="+type+"]").html("点击选择文件");
            }
            $(".fileBox[data-id="+id+"][data-type="+type+"]").remove();*/
            $(this).parent().remove();
        })
    });
    $(".state").bind("mouseleave",function(){
        $(this).html($(this).attr("sourceState"));
        $(this).removeClass("active");
    })
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
}
//绑定分类移除事件
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
//取消已选择分类
function cancelUlSelectLi(id){
	$(".categoryUl li[data-id="+id+"]").remove();
}
//设置分类form value
function categoryValueSet(){
	var lis = $(".categoryUl li");
	var value='';
	for(var i=0;i<lis.length;i++){
		if(i==lis.length-1)
			value += $(lis[i]).attr("data-id");
		else
			value += $(lis[i]).attr("data-id")+",";
	}
	$("input[name=category]").val(value);
}
//提示工具
function tooltipUtil(el,title){
	$(el).attr("title",title);
	 $(el).tooltip("show");
	 setTimeout(function(){
		 $(el).tooltip("destroy");
	 },3000)
}
//添加表单任务事件
function formRecord(){
	if($("#sourceInforForm input[name=name]").val()!=''){
		createRecord(FID(),"form","资源信息:"+$("#sourceInforForm input[name=name]").val());
	}else{
		removeRecord(FID(),'form');
	}
}
//开始当前资源ID的上传任务 
function updateMission(id){
	var form = $(".missionRecord li[data-id="+id+"][data-type=form] .waitUpload").parent()[0];
	var pic = $(".missionRecord li[data-id="+id+"][data-type=pic] .waitUpload").parent()[0];
	var file = $(".missionRecord li[data-id="+id+"][data-type=file] .waitUpload").parent()[0];
	if(form!=null){
		createLog("开始资源信息上传");
		MissionState(id,"form","uploading");
		$.post("json/updateSource/form",$('#sourceInforForm').serialize(),function(data) {
				if (data != null) {
					data = eval("(" + data + ")");
					if(data.message){
						realDataID(id,data.id);//设置数据库返回ID
						createLog("资源信息上传完毕");
						MissionState(id,"form","uploadSuccess");
						MissionPlan(id,"form",100);
						/*$("button[type=reset]").trigger("click");*/
						isSubmiting=false;
						/*缩略图上传*/
						if(pic!=null)uploadFile(id,"pic");
						/*/缩略图上传*/
						/*资源文件上传*/
						if(file!=null)uploadFile(id,"file");
						/*/缩略图上传*/
					}else{
						createLog("资源信息上传失败");
						MissionState(id,"form","uploadFailed");
					}
				}
			}
		)
	}
}
function uploadFile(id,type){
	createLog(type=='pic'?"开始缩略图上传":"开始资源文件上传");
	MissionState(id,"file","uploading");
	var formData = new FormData();
	formData.append("file",$(".fileBox[data-id="+id+"][data-type="+type+"] input[type=file]")[0].files[0]);
	$.ajax({
		type: "POST",
		 url: "json/updateSource/"+type+"/"+realDataID(id,null),
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
	    			createLog(type=='pic'?"缩略图上传完毕":"资源文件上传完毕");
					MissionState(id,type,"uploadSuccess");
					MissionPlan(id,type,100);
					return;
	    		}
	    	}
	    	createLog(type=='pic'?"缩略图上传失败":"资源文件上传失败");
			MissionState(id,type,"uploadFailed");
			return;
	    }
	  });
}
//显示执行日志
function createLog(text){
	$(".logBoard").append("----"+text+"----\r\n\r\n");
	var content = $(".logBoard")[0];
	content.scrollTop=content.scrollHeight;	//让滚动条在底部
}
//任务状态改变
function MissionState(id,type,state){
	var sValue = state=='uploading'?'正在上传':state=='uploadFailed'?'上传失败':state=='uploadSuccess'?'上传成功':'等待上传';
	$(".missionRecord li[data-id="+id+"][data-type="+type+"] .state").attr("class","state").addClass(state).html(sValue);
}
//任务进度条改变
function MissionPlan(id,type,plan){
	$(".missionRecord li[data-id="+id+"][data-type="+type+"] .progress-bar").css("width",plan+"%").html(plan+"%");
}
//查询任务是否已存在(存在返回ture)
function missionExist(id,type){
	var li = $(".missionRecord li[data-id="+id+"][data-type="+type+"]");
	if(li.length>0&&$(li).find(".waitUpload").length>0){
		return false;
	}
	return true;
}
//获取并设置当前 inpu file
function setFileId(id,type){
	$(".fileBox input[type=file]").attr("id",null);
	$(".fileBox[data-id="+id+"][data-type="+type+"] input[type=file]").attr("id","file");
}
//设置或返回数据ID(当sourceId为空是为获取)
function realDataID(id,sourceId){
	if(sourceId==null)
		return $(".missionRecord li[data-id="+id+"]").attr("source-id");
	else
		$(".missionRecord li[data-id="+id+"]").attr("source-id",sourceId);
}
/**
 * 侦查附件上传情况 ,这个方法大概0.05-0.1秒执行一次
 */
function onprogress(id,type,evt){
 var loaded = evt.loaded;     //已经上传大小情况 
 var tot = evt.total;      //附件总大小 
 var per = Math.floor(100*loaded/tot);  //已经上传的百分比 
 MissionPlan(id,type,per);
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
