<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
 <link rel="stylesheet" href="css/bootstrap.min.css">
 <link rel="stylesheet" href="css/admin/easyTree.css">
 <link href="css/animate.css" rel="stylesheet">
 <style type="text/css">
 	body{
 		background:#ecf0f5;
 	}
 	.easy-tree>ul>li{
 	float:left;
 	}
 </style>
</head>
<body>
<div class="wrapper wrapper-content  animated fadeInLeft">
	<div class="col-md-12">
    <div class="easy-tree">
    	<ul>
    		<c:forEach items="${requestScope.categorys}" var="category">
    			<li data-id="${category.id}">${category.name}
    				<c:if test="${not empty category.childs}">
   						<ul>
   						<c:forEach items="${category.childs}" var="category1">
   							<li data-id="${category1.id}">${category1.name}</li>
   						</c:forEach>
   						</ul>
    				</c:if>
    			</li>
    		</c:forEach>
    	</ul>
    </div>
</div>
</div>
<script src="js/jquery/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<!-- Peity -->
<script src="js/plugins/peity/jquery.peity.min.js"></script>
<script src="js/admin/easyTree.js"></script>
<script>
    (function ($) {
        function init() {
            $('.easy-tree').EasyTree({
                addable: true,
                editable: true,
                deletable: true
            });
        }

        window.onload = init();
    })(jQuery)
</script>
</body>
</html>