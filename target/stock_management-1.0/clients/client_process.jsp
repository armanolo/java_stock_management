<%--

    Copyright 2017, ManuelMartinMartin

    Task for rindus

--%>
<%@page import="com.model.Clients"%>
<%@page import="com.model.ProductsClient"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="com.util.JsonResult"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.util.ManagerDB"%>
<%@page import="com.model.Products"%>
<%@page import="com.model.Users"%>
<%
	String id_type = request.getParameter("id_type");
	String amount = request.getParameter("amount");
	String idProduct = request.getParameter("id_product");
	String idProductClient = request.getParameter("id_product_client");
	String idClient = request.getParameter("id_client");
	
	JsonResult jsonResul = new JsonResult();
	//jsonResul.setProduct(id, name, amount);
	//Products product = jsonResul.getProduct();
	
	ProductsClient productClient = new ProductsClient();
	Products product = new Products();
	Clients client = new Clients(Integer.parseInt(idClient));
	
	if(idProductClient != null){
		productClient.setId(Integer.parseInt(idProductClient));
	}
	if(idProduct != null){
		product.setId(Integer.parseInt(idProduct));
	}
	if(amount != null){
		product.setAmount(Integer.parseInt(amount));
	}

	productClient.setProduct(product);
	productClient.setClient(client);
	
	ManagerDB db = new ManagerDB();
	boolean result = false;
	if(id_type.equals("delete")){
		result = db.deleteProductsClient(productClient);
	}else if(id_type.equals("buy")){
		result = db.buyProductsClients(productClient);
	}else if(id_type.equals("reserve")){
		result = db.reserveProductsClient(productClient);
	}
	
	jsonResul.setResult(result);
	
	response.setContentType("application/json");
	PrintWriter outW = response.getWriter();
    	outW.print(jsonResul.jsonProductToString());
    	outW.flush();
%>
