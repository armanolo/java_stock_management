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
	String id = request.getParameter("id");
	String name = request.getParameter("name");
	
	JsonResult jsonResul = new JsonResult();
	jsonResul.setProduct(id, name, amount);
	Products product = jsonResul.getProduct();
	
	ManagerDB db = new ManagerDB();
	boolean result = false;
	if(id_type.equals("delete")){
		result = db.deleteProducts(product.getId());
	}else if(id_type.equals("insert")){
		product.setName("New item");
		product.setAmount(5);
		int idProd = db.insertProducts(product);
		if(idProd > 0){
			result = true;
			jsonResul.setProduct(product);
		}
	}else if(id_type.equals("update")){
		result = db.updateProducts(product);
	}
	jsonResul.setResult(result);
	
	response.setContentType("application/json");
	PrintWriter outW = response.getWriter();
    	outW.print(jsonResul.jsonProductToString());
    	outW.flush();
%>
