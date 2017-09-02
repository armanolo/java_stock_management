<%@page import="com.model.Products"%>
<%@page import="java.util.List"%>
<%@page import="com.util.ManagerDB"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	ManagerDB database = new ManagerDB();
	database.getConnection();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Task - Manuel Martin Martin</title>
		<script type="text/javascript" src="static/js/jquery-1.11.3.min.js"></script>
		<style type="text/css">
			div{
			    height:auto; 
			    margin:0 auto; 
			}
			
			#div_form{
				width:100%; 
			    margin:0 auto;
			}
			
			.button_class_client{
				background-color: #4CAF50; /* Green */
    			border: none;
			    color: white;
			    padding: 2% 2%;
			    text-align: center;
			    text-decoration: none;
			    display: inline-block;
			    font-size: 16px;
			}
			.button_class_user{
				background-color: blue; /* Blue */
    			border: none;
			    color: white;
			    padding: 2% 2%;
			    text-align: center;
			    text-decoration: none;
			    display: inline-block;
			    font-size: 16px;
			}
		</style>
	</head>
<body>
	<h3>Developer: Manuel Martin Martin. Task developed in Java with JSP</h3>
	<div>
		<div id='div_form'>
	      <button class="button_class_client" onclick="goTo('client',1)">Client 1</button>
	      <button class="button_class_client" onclick="goTo('client',2)">Client 2</button>
	      <button class="button_class_user" onclick="goTo('user',1)">Admin</button>
		<div>
	</div>
</body>
<script type="text/javascript">
//Go to validation
function goTo(type,id){
	window.location='validation.jsp?type='+type+'&id='+id;
}
</script>
</html>