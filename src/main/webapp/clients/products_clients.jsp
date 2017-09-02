<%@page import="com.model.ProductsClient"%>
<%@page import="com.model.Users"%>
<%@page import="com.model.Clients"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.model.Products"%>
<%@page import="java.util.List"%>
<%@page import="com.util.ManagerDB"%>
<%
	Clients client = null;
	if(session.getAttribute("client") != null){
		client = (Clients)session.getAttribute("client");
	}else
		response.sendRedirect("index.jsp");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Task - Manuel Martin Martin</title>
		<script type="text/javascript" src="../static/js/jquery-1.11.3.min.js"></script>
		<style type="text/css">
			.button_class_delete{
				background-color: red; /* Red */
    				border: none;
			    color: white;
			    padding: 2% 2%;
			    text-align: center;
			    text-decoration: none;
			    display: inline-block;
			    font-size: 16px;
			    margin: 5px;
			}
			.button_class_buy{
				background-color: #4CAF50; /* Green */
    				border: none;
			    color: white;
			    padding: 2% 2%;
			    text-align: center;
			    text-decoration: none;
			    display: inline-block;
			    font-size: 16px;
			    margin: 5px;
			}
			.button_class_reserve{
				background-color: blue; /* Blue */
    				border: none;
			    color: white;
			    padding: 2% 2%;
			    text-align: center;
			    text-decoration: none;
			    display: inline-block;
			    font-size: 16px;
			    margin: 5px;
			}
		</style>
	</head>
<body>
	<h3>Managment products: Hi client <% out.print(client.getName()); %><a style='margin-left: 5%;font-size:2vh'accesskey="h" id="home" href="javascript:gohome();">(home)</a></h3>
	<form>
		<hr/>
		<h2>Products in stock: </h2>
		<form id="idForm">
			<table width='100%' border>
				<tr>
					<th>Id</th>
					<th>Name</th>
					<th>Amount</th>
					<th></th>
				</tr>
				<%
					ManagerDB database = new ManagerDB();
	
					List<Products> products = database.getProducts(false);
					for(Products product : products){
						out.print("<tr>");
						out.print("<td><input type='text' name='id_product' readonly='true' value='"+product.getId()+"'/></td>");
						out.print("<td><input type='text' name='name' readonly='true' value='"+product.getName()+"'/></td>");
						out.print("<td><input type='number' name='amount' min='1' max='"+product.getAmount()+"' value='1'/></td>");
						out.print("<td align='center'><button class='button_class_reserve' type='button'>Reserve</button>");
						out.print("<button class='button_class_buy' type='button'>Buy</button></td>");
						out.print("</tr>");
					}
				%>
			</table>
		</form>
		<hr/>
		<h2>Products reserved: </h2>
		<table width='100%' border>
			<tr>
				<th>Id</th>
				<th>Name</th>
				<th>Amount</th>
				<th></th>
			</tr>
			<%
				database = new ManagerDB();
				List<ProductsClient> productsClientR = database.getProductsByClient(client, true);
				for(ProductsClient productClient : productsClientR){
					Products product = productClient.getProduct();
					out.print("<tr>");
					out.print("<td><input type='text' name='id_product_client' readonly='true' value='"+productClient.getId()+"'/></td>");
					out.print("<td><input type='hidden' name='id_product' readonly='true' value='"+product.getId()+"'/>");
					out.print("<input type='text' name='name' readonly='true' value='"+product.getName()+"'/></td>");
					out.print("<td><input type='number' readonly='true' name='amount' value='"+product.getAmount()+"'/></td>");
					out.print("<td align='center'><button class='button_class_buy' type='button'>Buy</button>");
					out.print("<button class='button_class_delete' type='button'>Delete</button></td>");
					out.print("</tr>");
				}
			%>
		</table>
		<hr/>
		<h2>Products bought: </h2>
		<table width='100%' border>
			<tr>
				<th>Id</th>
				<th>Name</th>
				<th>Amount</th>
			</tr>
			<%
				database = new ManagerDB();
				List<ProductsClient> productsClientB = database.getProductsByClient(client, false);
				for(ProductsClient productClient : productsClientB){
					Products product = productClient.getProduct();
					out.print("<tr>");
					out.print("<td><input type='text' name='id_product_client' readonly='true' value='"+productClient.getId()+"'/></td>");
					out.print("<td><input type='text' readonly='true' value='"+product.getName()+"'/></td>");
					out.print("<td><input type='number' name='amount' readonly='true' value='"+product.getAmount()+"'/></td>");
					out.print("</tr>");
				}
			%>
		</table>
	</form>
</body>
<script type="text/javascript">
$(document).ready(function(){

	/**
	*	Delete
	*/
	function deleteRow(button){
		client_process('delete',button);
	}
	
	/**
	*	Buy
	*/
	function buyRow(button){
		client_process('buy',button);
	}

	/**
	*	Update
	*/
	function reserveRow(button){
		client_process('reserve',button);
	}

	/**
	*	
	*/
	function client_process(typeProcess, button){
		//var idProd = $(button).closest('tr').find('input:first').val();
		//var nameProd = $(button).closest('tr').find('input:first').val();
		var arrayData = new Object();
		$.grep($(button).closest('tr').find('input'),function(a){
			arrayData[$(a).attr('name')] = $(a).val();
		});
		arrayData['id_type'] = typeProcess;
		arrayData['id_client'] = <% out.print(client.getId());%>;

		
		var maximumVal = $(button).closest('tr').find('input[name=amount]').attr('max');
		
		var request = true;
		if(maximumVal != null){
			if(parseInt(maximumVal) < parseInt(arrayData['amount'])){
				request = false;
				alert('The maximum is '+maximumVal);
			}
		}
		
		if(request)
		{
			$.ajax({
			    url: 'client_process.jsp',
			    method: 'POST',
			    data: arrayData,
			    dataType: 'json',
			    error: function(e){
					debugger;
			    },
			    success: function(outResult){
			    		window.location.href = window.location.href;
			    }
			});
		}
		
	}

	/**
	*	Export file
	*/
	function exportFie(button){
		if($(button).text() == 'CSV')
			$('#export').val('csv');
		else if($(button).text() == 'XML')
			$('#export').val('xml');
		else
			$('#export').val('txt');
		$('form').submit();
	}

	$('.button_class_buy').click(function(){buyRow(this);});
	$('.button_class_delete').click(function(){deleteRow(this);});
	$('.button_class_reserve').click(function(){reserveRow(this);});

});

/**
* Go main page
*/
function gohome()
{
	window.location.href="../index.jsp"
}
</script>
</html>