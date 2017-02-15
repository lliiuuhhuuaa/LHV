/**
 * 六画
 */
$(function(){
	createLog("开始尝试连接上传服务器");
	openWebSocket();
	var linkTimer = setInterval(function() {
		if(webSocket==null){
			createLog("上传服务器连接失败：正在尝试重新连接 "+(linkTime++)+"次");
			openWebSocket();
		}else{
			clearInterval(linkTimer)
		}
	}, 3000)
})
var webSocket = null;
var linkTime = 1;
var currentID = null;
function openWebSocket(){
	if ('WebSocket' in window)  
		 webSocket = new WebSocket(webSocketUri);  
    else if ('MozWebSocket' in window)  
    	webSocket = new MozWebSocket(webSocketUri);  
    else  
    	createLo("你浏览器不支持webSocket通信/not support WebSocket!");  
	webSocket.onopen = function() {
		createLog("连接上传服务器成功")
	};

	webSocket.onmessage = function(event) {
		var data = eval("("+event.data+")");
		if(data.state=='100'){
			currentID = data.id;
		}else{
			MissionState(data.id,data.type,data.state);
			MissionPlan(data.id,data.type,data.mission);
			createLog(data.log);
		}
		//createLog(event.data);
	};

	webSocket.onclose = function(event) {
		createLog("上传服务器已断开")
	};
}