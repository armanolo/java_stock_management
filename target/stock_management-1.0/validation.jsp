<%--

    Copyright 2017, ManuelMartinMartin

    Task for rindus

--%>
<%@page import="com.model.Users"%>
<%@page import="com.util.ManagerDB"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String typeUser = request.getParameter("type");
	String id = request.getParameter("id");

	//Validation: get type user
	if(typeUser != null && id != null)
	{
		ManagerDB database = new ManagerDB();
		int intType = typeUser.equals("client")?1:0;
		Object user = database.getUser(intType, Integer.parseInt(id));
		session.setAttribute(typeUser, user);
		if(intType == 1)
			response.sendRedirect("./clients/products_clients.jsp");
		else
			response.sendRedirect("./admin/products.jsp");
	}else{
		response.sendRedirect("./index.jsp");
	}
%>