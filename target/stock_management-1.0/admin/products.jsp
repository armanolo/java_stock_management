<%--

    Copyright 2017, ManuelMartinMartin

    Task for rindus

--%>
<%@page import="com.model.Users"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.model.Products"%>
<%@page import="java.util.List"%>
<%@page import="com.util.ManagerDB"%>
<%
	Users admin = null;
	if(session.getAttribute("user") != null){
		admin = (Users)session.getAttribute("user");
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
			}
			.button_class_new{
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
			.button_class_update{
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
	<h3>Managment products: Hi user <% out.print(admin.getName()); %><a style='margin-left: 5%;font-size:2vh'accesskey="h" id="home" href="javascript:gohome();">(home)</a></h3>
	<form>
		<input type="hidden" id="export" name="export" value="txt">
		<table width='100%' border>
			<tr>
				<th>Id</th>
				<th>Name</th>
				<th>Amount</th>
				<th></th>
			</tr>
			<%
				ManagerDB database = new ManagerDB();

				List<Products> products = database.getProducts(true);
				for(Products product : products){
					out.print("<tr>");
					out.print("<td><input type='text' name='id' readonly='true' value='"+product.getId()+"'/></td>");
					out.print("<td><input type='text' name='name' value='"+product.getName()+"'/></td>");
					out.print("<td><input type='number' name='amount' value='"+product.getAmount()+"'/></td>");
					out.print("<td align='center'><button class='button_class_update' type='button'>Update</button>");
					out.print("<button class='button_class_delete' type='button'>Delete</button></td>");
					out.print("</tr>");
				}
			%>
			<tr>
				<td> </td><td> </td><td> </td><td align='center'><button class='button_class_new' type='button'>New</button></td>
			<tr>
		</table>
	</form>
</body>
<script type="text/javascript">
$(document).ready(function(){

	/**
	*	Create a new row
	*/
	function newRow(button, object){
		var objTr = $(button).closest('tr');
		
		var newTr = $('<tr>');
		var tdId = $('<td>').append($('<input>',{type:'text',name:'id',readonly:true,value:object.id}));
		var tdName = $('<td>').append($('<input>',{type:'text',name:'name',value:object.name}));
		var tdAmount = $('<td>').append($('<input>',{type:'number',name:'amount',value:object.amount}));
		var tdButton = $('<td>',{align:'center'}).
			append($('<button>',{'class':'button_class_update',type:'button',text:'Update'}).
				click(function(){updateRow(this)})).
			append($('<button>',{'class':'button_class_delete',type:'button',text:'Delete'}).
						click(function(){deleteRow(this)}));
		newTr.append(tdId);
		newTr.append(tdName);
		newTr.append(tdAmount);
		newTr.append(tdButton);
		
		newTr.insertBefore(objTr);
	}

	/**
	*	Delete
	*/
	function deleteRow(button){
		admin_process('delete',button);
	}

	/**
	*	Update
	*/
	function updateRow(button){
		admin_process('update',button);
	}

	/**
	*	
	*/
	function admin_process(typeProcess, button){
		//var idProd = $(button).closest('tr').find('input:first').val();
		//var nameProd = $(button).closest('tr').find('input:first').val();
		var arrayData = new Object();
		$.grep($(button).closest('tr').find('input'),function(a){
			arrayData[$(a).attr('name')] = $(a).val();
		});
		arrayData['id_type'] = typeProcess;
		$.ajax({
		    url: 'admin_process.jsp',
		    method: 'POST',
		    data: arrayData,
		    dataType: 'json',
		    error: function(e){
				debugger;
		    },
		    success: function(outResult){
		    		if(outResult){
		    			if(outResult.result){
		    				switch(typeProcess){
		    					case 'delete':{$(button).closest('tr').remove();break;}
		    					case 'insert':{newRow(button,outResult.object);break;}
		    					case 'update':{alert('Product updated');/*$(button).closest('tr').remove()*/;break;}
		    				}
		    			}
		    		}
		    }
		});
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

	$('.button_class_delete').click(function(){deleteRow(this);});
	$('.button_class_new').click(function(){admin_process('insert',this);});
	$('.button_class_update').click(function(){updateRow(this);});
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