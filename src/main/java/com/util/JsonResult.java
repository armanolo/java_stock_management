package com.util;

import com.model.Products;

/**
 * Class for json result
 * @author manuelmartinmartin
 *
 */
public class JsonResult {
	public boolean result;
	public Products product;
	
	public boolean isResult() {
		return result;
	}

	public void setResult(boolean result) {
		this.result = result;
	}

	public Products getProduct() {
		return product;
	}

	public void setProduct(Products product) {
		this.product = product;
	}
	
	public void setProduct(String id, String name, String amount) {
		Products product = new Products(); 
		if(id != null){
			product.setId(Integer.parseInt(id));
		}
		if(name != null){
			product.setName(name);
		}
		if(amount != null){
			product.setAmount(Integer.parseInt(amount));
		}
		this.product = product;
	}

	public JsonResult() {
	}
	
	/**
	 * String to JSON
	 * @return
	 */
	public String jsonProductToString() {
		StringBuilder outString = new StringBuilder("{\"result\":"+isResult());
		//out.print("{result:"+result+"}");
		Products product = getProduct();
		if( product != null && product.getId() > 0 && product.getName() != null && product.getAmount() > 0 ) {
			outString.append(" , \"object\": { \"id\": "+product.getId()+", \"name\":\""+product.getName()+"\", \"amount\":"+product.getAmount()+"}}");
		}else {
			outString.append("}");
		}
		return outString.toString();
		//return "\"{ key1: 'value1', key2: 'value2' }\"";
	}

}
