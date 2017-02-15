$(document).ready(function () {
     $("#form").steps({
     bodyTag: "fieldset",
     onStepChanging: function (event, currentIndex, newIndex) {
         // Always allow going backward even if the current step contains invalid fields!
        if(currentIndex==0){
        	var phone = $("#phoneNo")[0];
        	var ispass=true;
        	if($(phone).attr('error')!=undefined){
        		showError(phone);
        		ispass=false;
        	}
        	var email = $("#email")[0];
        	if($(email).attr('error')!=undefined){
        		showError(email);
        		ispass=false;
        	}
        	var question = $("#question")[0];
        	if(question.value!='0'){
        		if($("#answer").val()==''){
        			popover("答案不能为空",$("#answer"));
        			ispass = false;
        		}else{
        			$("input[name=question]").val(question.value+","+$("#answer").val())
        		}
        	}
        	if(!ispass)return false;
        }else if(currentIndex==1){
        	
        }
         if (currentIndex > newIndex) {
             return true;
         }
         // Forbid suppressing "Warning" step if the user is to young
         if (newIndex === 3 && Number($("#age").val()) < 18) {
             return false;
         }

         var form = $(this);

         // Clean up if user went backward before
         if (currentIndex < newIndex) {
             // To remove error styles
             $(".body:eq(" + newIndex + ") label.error", form).remove();
             $(".body:eq(" + newIndex + ") .error", form).removeClass("error");
         }

         // Disable validation on fields that are disabled or hidden.
         form.validate().settings.ignore = ":disabled,:hidden";

         // Start validation; Prevent going forward if false
         return form.valid();
     },
     onStepChanged: function (event, currentIndex, priorIndex) {
         // Suppress (skip) "Warning" step if the user is old enough.
         if (currentIndex === 2 && Number($("#age").val()) >= 18) {
             $(this).steps("next");
         }

     },onCanceled:function(event){
    	parent.layer.confirm('确认是否放弃填写？', {
		    btn: ['我确定','我再想想'], //按钮
		    shade: false //不显示遮罩
		}, function(){
		    window.location.href="login";
		}, function(){
		});
     },
     onFinishing: function (event, currentIndex) {
         var form = $(this);

         // Disable validation on fields that are disabled.
         // At this point it's recommended to do an overall check (mean ignoring only disabled fields)
         form.validate().settings.ignore = ":disabled";

         // Start validation; Prevent form submission if false
         return form.valid();
     },
     onFinished: function (event, currentIndex) {
         var form = $(this);

         // Submit form input
         form.submit();
     }
 }).validate({
     errorPlacement: function (error, element) {
         element.before(error);
     },
     rules: {
         confirm: {
             equalTo: "#password"
         }
     }
 });
 $(".lover li").bind("click",function(){
 	if($(this).hasClass("selected")){
 		$(this).removeClass("selected");
 	}else{
 		if($(".lover li.selected").length>9){
 			parent.layer.msg('添加的类型不能超过10个哦', {shift : 6});
 			return false;
 		}else
 		$(this).addClass("selected");
 	}
 	var lis = $(".lover li.selected");
 	var text="";
 	for(var i=0;i<lis.length;i++){
		if(i==lis.length-1)
 			text += $(lis[i]).attr("value");
 		else
 			text += $(lis[i]).attr("value")+",";
 	}
 	$("input[name=hobby]").val(text);
 })
 $("#phoneNo").bind("change blur",function(){
 	if(this.value!=''&&!/^[1][3-8][0-9]{9}$/.test(this.value)){
		popover("手机号码格式不正确",this);
		return false;
	}else{
		clearError(this);
	}
 	checkExist("phoneNo",this);
 })
 $("#email").bind("change blur",function(){
 	if(this.value!=''&&!/^[0-9a-zA-Z]+@[0-9a-zA-Z]+[.][0-9a-zA-Z]+$/.test(this.value)){
 		popover("邮箱格式不正确",this);
        return false;
 	}else{
 		clearError(this);
 	}
 	checkExist("email",this);
 })
 $("#nickname").bind("change blur",function(){
 	if(this.value!=''){
 		checkExist("nickname",this);
 	}else{
 		clearError(this);
 	}
 	checkExist("nickname",this);
 })
 $("#question").change(function(){
 	if(this.value=='0'){
 		$("#answer").removeClass("error").val("");
 		$("input[name=question]").val("");
 		clearError($("#answer"));
 	}
 })
 $("#answer").bind("change",function(){
 	if($("#question").val()!='0'&&this.value==''){
 		popover("答案不能为空", this);
 	}else if(this.value.length>20){
 		popover("长度过长", this);
 	}else
 		clearError($("#answer"));
 })
 $("#name").bind("change",function(){
 	if(this.value!=''&&this.value.length>40)
 		popover("名字过长", this);
 	else
 		clearError(this);
 })
 $("#presentation").bind("change",function(){
 	if(this.value!=''&&this.value.length>100)
 		popover("自我介绍过长", this);
 	else
 		clearError(this);
 })
 $(".s_img").bind("click",function(){
 	$(".s_img").removeClass("active");
 	$(this).addClass("active");
 	$("#avatar_id").val($(this).attr("data-id"));
 	$(".head-img").attr("src",$(this).find("img").attr("src"));
     })
 });
   //工具提示
   function popover(text,el){
    	$(el).attr("error",text);
	$(el).attr("data-content",text).attr("data-toggle","popover").attr("data-placement","top");
	$(el).popover("show");
	$(el).addClass("error")
   }
   function showError(el){
    	$(el).attr("data-content",$(el).attr("error")).attr("data-toggle","popover").attr("data-placement","top");
	$(el).popover("show");
	$(el).addClass("error")
   }
 function checkExist(type,el){
 	if(el.value=='')return;
$.post("json/checkIsExist","type="+type+"&value="+el.value,function(data) { // 此处可以
		data = eval("("+data+")")
		if(data.message){
			var text;
			if($(el).attr("name")=='phoneNo'){
				text = "手机号码已被使用_请换一个";
			}else if($(el).attr("name")=="email"){
				text = "邮箱地址已被使用_请换一个";
			}else if($(el).attr("name")=="nickname"){
				text = "昵称已被使用_请换一个";
				}
				popover(text,el)
			}else{
				clearError(el);
			}
	})
 }
 function clearError(el){
 	$(el).removeAttr("error");
$(el).popover("destroy");
 }
 //头像上传
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
			        var i=5;
			        var interTimer = window.setInterval(function(){//窗口重置
			        	 document.body.dispatchEvent(evObj);
			        	 if(i--<=0)clearInterval(interTimer);
			        },500);
			    }else if( document.createEventObject ){
				      document.body.fireEvent('onresize');
				      var i=5;
				       var interTime = window.setInterval(function(){
				    	  document.body.fireEvent('onresize');
				    	  if(i--<=0)clearInterval(interTimer);
				      },500);
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
	            url: "json/uploadImg",  
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
	            		$("#avatar_id").val("");
	            		parent.layer.msg('头像成功设置', {icon : 1});
	            		$(".head-img").attr("src","source/img/superMax/"+data.id);
	            		$(".s_img").removeClass("active");
	            	}else{
	            		parent.layer.msg('头像设置失败：'+data.cause, {icon : 2});
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