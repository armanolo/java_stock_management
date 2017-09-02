package com.util;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.model.Clients;
import com.model.ProductsClient;
import com.model.Products;
import com.model.Users;

public class ManagerDB {

	// Connection
	private Connection connection = null;

	/**
	 * Constructor
	 */
	public ManagerDB() {
	}
	
	/**
	 * Delete products
	 * @param id
	 * @return
	 */
	public boolean deleteProductsClient(ProductsClient productsClient) {
		Connection conn = null;
		try {
			conn = getConnection();
			Statement statement = connection.createStatement();
			String deleteSql = "delete from productsclients where id = "+productsClient.getId();
			statement.executeUpdate(deleteSql);
			Products product = productsClient.getProduct();
			statement.executeUpdate("update products set amount = (amount + "+product.getAmount()+") where id_product = "+product.getId());
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
			try {
				if(conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return true;
	}
	
	/**
	 * Buy products
	 * @param product
	 * @param client
	 * @return
	 */
	public boolean buyProductsClients(ProductsClient productClient) {
		return actionProductsClients(productClient,0);
	}
	
	/**
	 * Reserve products
	 * @param product
	 * @param client
	 * @return
	 */
	public boolean reserveProductsClient(ProductsClient productClient) {
		return actionProductsClients(productClient,1);
	}
	
	/**
	 * Action for ProductsClients
	 * @param productClient
	 * @param reserve
	 * @return
	 */
	public boolean actionProductsClients(ProductsClient productClient, int reserve) {
		Connection conn = null;
		try {
			conn = getConnection();
			Statement statement = connection.createStatement();
			
			Products product = productClient.getProduct();
			Clients client = productClient.getClient();
			int idProductClient = productClient.getId();
			
			if(idProductClient > 0) {
				statement.executeUpdate("update productsclients set reserve = "+reserve+" where id = "+idProductClient);
			}else {
				int numProducts = product.getAmount();
				int idValue = 0;
				
				PreparedStatement stmt = conn.prepareStatement("insert into productsclients (id_product,id_client,amount,reserve) "+
						"values(?,?,?,?)");
				stmt.setInt(1, product.getId());
				stmt.setInt(2, client.getId());
				stmt.setInt(3, numProducts);
				stmt.setInt(4, reserve);
				stmt.execute();
				
				ResultSet rs = stmt.getGeneratedKeys();
				if (rs.next()){
					idValue=rs.getInt(1);
				}
				rs.close();
				productClient.setId(idValue);
				
				stmt.clearParameters();
				stmt.close();
				
				stmt = conn.prepareStatement("update products set amount = (amount - ?) where id_product = ?");
				stmt.setInt(1, numProducts);
				stmt.setInt(2, product.getId());
				stmt.execute();
				stmt.close();
				/*
				int numProducts = product.getAmount();
				int idValue = 0;
				statement.executeUpdate("insert into productsclients (id_product,id_client,amount,reserve) "+
						"values("+product.getId()+","+client.getId()+","+numProducts+","+reserve+")");
				ResultSet rs = statement.getGeneratedKeys();
				if (rs.next()){
					idValue=rs.getInt(1);
				}
				rs.close();
				productClient.setId(idValue);
				
				statement.executeUpdate("update products set amount = (amount - "+numProducts+") where id_product = "+product.getId());
				*/
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
			try {
				if(conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return true;
	}
	
	/**
	 * 
	 * @param id
	 * @return
	 */
	public boolean deleteProducts(int id) {
		Connection conn = null;
		try {
			conn = getConnection();
			Statement statement = connection.createStatement();
			String deleteSql = "delete from products where id_product = "+id;
			statement.executeUpdate(deleteSql);
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
			try {
				if(conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return true;
	}
	
	/**
	 * 
	 * @param id
	 * @return
	 */
	public boolean updateProducts(Products product) {
		Connection conn = null;
		try {
			conn = getConnection();
			PreparedStatement stmt = conn.prepareStatement("update products set name = ?, amount = ?"+
					" where id_product = ?");
			stmt.setString(1, product.getName());
			stmt.setInt(2, product.getAmount());
			stmt.setInt(3, product.getId());
			stmt.execute();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
			try {
				if(conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return true;
	}

	/**
	 * 
	 * @param product
	 * @return
	 */
	public int insertProducts(Products product) {
		int idValue = 0;
		Connection conn = null;
		try {
			conn = getConnection();
			PreparedStatement stmt = conn.prepareStatement("insert into products (name,amount) values(?,?)");
			stmt.setString(1, product.getName());
			stmt.setInt(2, product.getAmount());
			stmt.execute();
			
			ResultSet rs = stmt.getGeneratedKeys();
	        if (rs.next()){
	        		idValue=rs.getInt(1);
	        }
	        stmt.close();
	        rs.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
			return -1;
		} finally {
			try {
				if(conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		product.setId(idValue);
		return idValue;
	}
	
	/**
	 * 
	 * @return
	 */
	public boolean insertProductClient(Products product) {
		Connection conn = null;
		try {
			conn = getConnection();
			Statement statement = connection.createStatement();
			statement.executeUpdate("insert into products (name,amount) values('"+product.getName()+"',"+product.getAmount()+")");
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
			try {
				if(conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return true;
	}
	
	/**
	 * Get User or Client
	 * @param type
	 * @param id
	 * @return
	 */
	public Object getUser(int type, int id) {
		Object user = null;
		Connection conn = null;
		try {
			String stType = "users";
			conn = getConnection();
			Statement statement = conn.createStatement();
			boolean client = false;
			if(type == 1) {
				stType = "clients";
				client = true;
			}
			ResultSet rs = statement.executeQuery("select * from "+stType+" where id = "+id);
			if(client)
				user = new Clients(rs.getInt("id"), rs.getString("name"));
			else
				user = new Users(rs.getInt("id"), rs.getString("name"));
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if(conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		//statement.setQueryTimeout(30); // set timeout to 30 sec.
		return user;
	}
	
	/**
	 * Get products
	 * @return
	 */
	public List<Products> getProducts(boolean isAdmin) {
		ArrayList<Products> products = new ArrayList<Products>();
		Connection conn = null;
		try {
			conn = getConnection();
			Statement statement = conn.createStatement();
			ResultSet rs = statement.executeQuery("select * from products"+((isAdmin)?"":" where amount > 0"));
			while (rs.next()) {
				// read the result set
				Products product = new Products(rs.getInt("id_product"), rs.getString("name"), rs.getInt("amount"));
				products.add(product);
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if(conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		//statement.setQueryTimeout(30); // set timeout to 30 sec.
		return products;
	}
	
	/**
	 * Get products
	 * @return
	 */
	public List<ProductsClient> getProductsByClient(Clients client, boolean isReserved) {
		ArrayList<ProductsClient> productsClient = new ArrayList<ProductsClient>();
		Connection conn = null;
		try {
			conn = getConnection();
			Statement statement = conn.createStatement();
			String sqlProductsClients = "select pc.id, pc.id_product, pc.amount, pc.reserve, p.name from productsclients pc left join products p "+
			"on pc.id_product = p.id_product where pc.id_client = "+client.getId()+" and pc.reserve = "+((isReserved)?1:0);
			/*
			sqlProductsClients = "select pc.id, pc.id_product, pc.amount, pc.reserve, p.name from productsclients pc left join products p on pc.id_product = p.id_product where pc.id_client = 1 and pc.reserve = 1";
			sqlProductsClients = "select * from productsclients as pc";
			sqlProductsClients = "select * from products";
			*/
			ResultSet rs = statement.executeQuery(sqlProductsClients);
			while (rs.next()) {
				// read the result set
				ProductsClient productClient = new ProductsClient();
				Products product = new Products(rs.getInt("id_product"), rs.getString("name"), rs.getInt("amount"));
				
				productClient.setId(rs.getInt("id"));
				productClient.setProduct(product);
				productClient.setClient(client);
				
				productsClient.add(productClient);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if(conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return productsClient;
	}
	
	/**
	 * Create database 
	 * @throws SQLException 
	 */
	public void createDB(String name){
		try {
			Class.forName("org.sqlite.JDBC");
			this.connection = DriverManager.getConnection("jdbc:sqlite:"+name);
			Statement statement = connection.createStatement();
			//Delete tables if exists them
			statement.executeUpdate("drop table if exists clients");
			statement.executeUpdate("drop table if exists users");
			statement.executeUpdate("drop table if exists products");
			statement.executeUpdate("drop table if exists productsclients");
			//Create tables
			statement.executeUpdate("create table clients( id integer primary key autoincrement,name text not null)");	
			statement.executeUpdate("create table users( id integer primary key autoincrement,name text not null)");	
			statement.executeUpdate("create table products(id_product integer primary key autoincrement, name text not null, amount integer not null)");	
			statement.executeUpdate("create table productsclients(id integer primary key autoincrement, id_product integer, id_client integer, amount integer not null, reserve not null)");
			
			//Create inserts values
			statement.executeUpdate("insert into clients (name) values('client_1')");
			statement.executeUpdate("insert into clients (name) values('client_2')");
			statement.executeUpdate("insert into users (name) values('admin')");
			
			//Create inserts products
			statement.executeUpdate("insert into products (name,amount) values('laptop',5)");
		} catch (SQLException e) {
			System.err.println(e.getMessage());
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} finally {
			try {
				if(this.connection != null)
					this.connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public Connection getConnection() {
		// load the sqlite-JDBC driver using the current class loader
		if(this.connection == null) 
		{
			String filePathString = "test_stock.db";
			// create a database connection
			File f = new File(filePathString);
			if(!f.exists() && !f.isDirectory()) 
			{ 
				createDB(filePathString);
			}
			else 
			{
				try {
					Class.forName("org.sqlite.JDBC");
					this.connection = DriverManager.getConnection("jdbc:sqlite:"+filePathString);
					//System.out.println("Path file: "+f.getAbsolutePath());
				} catch (SQLException e) {
					System.err.println(e.getMessage());
				} catch (ClassNotFoundException e) {
					e.printStackTrace();
				}
			}
		}
		return this.connection;
	}
}
