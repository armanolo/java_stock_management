package com.model;

/**
 * Class products
 * @author manuelmartinmartin
 *
 */
public class Products {
	private int id = 0;
	private String name;
	private int amount = 0;

	
	public int getId() {
		return id;
	}


	public void setId(int id) {
		this.id = id;
	}


	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getAmount() {
		return amount;
	}


	public void setAmount(int amount) {
		this.amount = amount;
	}


	/**
	 * Constructor Products
	 */
	public Products() {
	}
	
	/**
	 * Constructor Products
	 * @param id
	 * @param name
	 * @param amount
	 */
	public Products(int id, String name, int amount) {
		this.id = id;
		this.name = name;
		this.amount = amount;
	}

}
