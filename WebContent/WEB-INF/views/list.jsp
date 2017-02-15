<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <title>所有视频</title>
    <link href="css/list.css" rel="stylesheet" type="text/css">
    <style type="text/css">
    .contact-box{
    padding:0 !important;margin:5px 0 !important;
}
        .big_img_div1,.big_img_div2{
    width:100%;height:600px;z-index:1 !important;
    position: absolute;top:0;left:0;
}
.item_2{
    padding:0 5px !important;
}
.item_2 .contact-box:hover{
    padding: 0;
    -webkit-box-shadow: 0 0 5px #000;
    -moz-box-shadow: 0 0 5px #000;
    box-shadow: 0 0 5px #000;
}
.signLine {
	white-space: nowrap;overflow:hidden;text-overflow: ellipsis;
	padding: 3px;
	margin: 0;
	width: 100%;
}

.playNum {
	margin-left: 10px;
	float: left;
	font-size: 15px;
}

.garde {
	margin-right: 10px;
	float: right;
	font-size: 15px;
}

.playNum font, .garde font {
	font-size: 18px;
	padding: 2px;
}

.garde font {
	color: #ED5565;
}

p {
	margin: 5px 0;
}

.decription {
	height: 55px;
	overflow: hidden;
}

.category a {
	color: #F29E50;
}

.col-img {
	padding: 0 5px;
}
    </style>
</head>
<body style="background-color: #EEE;">
<div class="box">
    <div class="head">
        <div class="container-fluid">
        	<!--顶部-->
				<jsp:include page="head.jsp"></jsp:include>
			<!--顶部结束-->
        </div>
    </div>
    <div class="pageInfo">
       <h3 style="line-height:50px;text-align:center">
       	<c:if test="${requestScope.dataResponse.page>1}">
       		<a class="pre" style="display:inline" href="list?searchString=${requestScope.dataResponse.parent_cate}&searchString=${requestScope.dataResponse.cate}&sidx=${requestScope.dataResponse.sidx}&page=${requestScope.dataResponse.page-1}&specialSearch=${requestScope.dataResponse.specialSearch}"><i style="display:inline" class="glyphicon glyphicon-arrow-left"></i>上一页</a>
       	</c:if>
       		 当前第 <span>${requestScope.dataResponse.page}</span> 页 / 总共 <span>${requestScope.dataResponse.total}</span> 页　总记录 <span>${requestScope.dataResponse.records}</span> 条
       	<c:if test="${requestScope.dataResponse.page<requestScope.dataResponse.total}">
         <a class="next" style="display:inline" href="list?searchString=${requestScope.dataResponse.parent_cate}&searchString=${requestScope.dataResponse.cate}&sidx=${requestScope.dataResponse.sidx}&page=${requestScope.dataResponse.page+1}&specialSearch=${requestScope.dataResponse.specialSearch}">下一页<i style="display:inline" class="glyphicon glyphicon-arrow-right"></i></a>
        </c:if>
        </h3>
    </div>
    <div class="container-fluid" style="width:90%;position: relative;margin:0 auto;">
       <div class="leftMenu">
           <ul class="level1">
               <li>
                   <ul class="level2 onlyOne"><p>类型:</p>
                   		<li class="${requestScope.dataResponse.parent_cate==null?'active':''}"><a href="list">全部</a></li>
                       	<c:forEach items="${applicationScope.category}" var="cate">
							<li class="${cate.id==requestScope.dataResponse.parent_cate?'active':''}"><a href="list?searchString=${cate.id}&sidx=${requestScope.dataResponse.sidx}">${cate.name}</a></li>
						</c:forEach>
                   </ul>
               </li>
               <li>
                   <ul class="level2"><p>分类：</p>
                       <li class="${requestScope.dataResponse.cate==null?'active':''}"><a href="list?searchString=${requestScope.dataResponse.parent_cate}">全部</a></li>
                       	<c:forEach items="${applicationScope.category}" var="cate">
                       		<c:if test="${cate.id==requestScope.dataResponse.parent_cate }">
                       			<c:forEach items="${cate.childs}" var="cate1">
									<li class="${cate1.id==requestScope.dataResponse.cate?'active':''}"><a href="list?searchString=${requestScope.dataResponse.parent_cate}&searchString=${cate1.id}&sidx=${requestScope.dataResponse.sidx}">${cate1.name}</a></li>
								</c:forEach>
                       		</c:if>
						</c:forEach>
                   </ul>
               </li>
               <li>
                   <ul class="level2 onlyOne"><p>排序：</p>
                       <li class="${requestScope.dataResponse.sidx=='log.uploadtime'?'active':'' }"><a href="list?searchString=${requestScope.dataResponse.parent_cate}&searchString=${cate1.id}&specialSearch=${requestScope.dataResponse.specialSearch}&sidx=log.uploadtime">最新</a></li>
                       <li class="${requestScope.dataResponse.sidx=='log.total_play'?'active':'' }"><a href="list?searchString=${requestScope.dataResponse.parent_cate}&searchString=${cate1.id}&specialSearch=${requestScope.dataResponse.specialSearch}&sidx=log.total_play">播放量</a></li>
                       <li class="${requestScope.dataResponse.sidx=='log.score'?'active':'' }"><a href="list?searchString=${requestScope.dataResponse.parent_cate}&searchString=${cate1.id}&specialSearch=${requestScope.dataResponse.specialSearch}&sidx=log.score">评价</a></li>
                   </ul>
               </li>
           </ul>
       </div>
        <div class="listContent">
            <div class="wrapper wrapper-content animated fadeIn cartoon_div">
			<div class="row">
				<c:if test="${empty requestScope.dataResponse.rows}">
					<h2>没有当前分类资源，请重新选择</h2>
				</c:if>
				<c:if test="${not empty requestScope.dataResponse.rows}">
					<c:forEach items="${requestScope.dataResponse.rows}"
						var="source">
						<div class="col-sm-3 item_2">
							<div class="contact-box">
								<a href="get_source/${source.id}">
									<div class="col-sm-12 col-img">
										<div class="text-center">
											<img alt="image" title="视频预览图" class="m-t-xs img-responsive"
												src="source/img/min/${source.img.id}">
											<!-- <ul class="down_ul"><li><i class="glyphicon glyphicon-star-empty"></i></li><li><i class="glyphicon glyphicon-save"></i></li></ul> -->
										</div>
									</div>
									<div class="col-sm-12">
										<div class="text-center">
											<h3 class="signLine"
												title="${source.seriesname!=source.id?source.seriesname:source.name}">
												<strong>${source.seriesname!=source.id?source.seriesname:source.name}</strong>
											</h3>
											<p>
												<span class="playNum" title="点击量"><i
													class="glyphicon glyphicon-eye-open"></i><font>${source.log.total_play}</font></span><span
													class="garde" title="评分"><i
													class="glyphicon glyphicon-heart"></i><font>${source.log.score}</font></span>
											</p>
										</div>
									</div>
									<div class="clearfix"></div>
								</a>
							</div>
						</div>
					</c:forEach>
				</c:if>
			</div>
		</div>
		<!--动漫推荐div结束-->
        </div>
    </div>
</div>
<jsp:include page="loginModal.jsp"></jsp:include>
</body>
</html>