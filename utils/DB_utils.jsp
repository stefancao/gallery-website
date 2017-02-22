<%--------------------------------------------------------------
Copyright Stefan Cao 2016 - All Rights Reserved          
												          
	Name: Stefan Cao								          
	ID#: 79267250									          
	Assignment: Mini-Project 2						          
												          
	File: DB_utils.jsp 										 
												          
	Description:	
		functions for DB		

	History:
		Date 	Update Description 	   		   Developer  
     --------  ---------------------          ------------	     
     10/11/2016 		Created 					SC
--------------------------------------------------------------%>

<%@ page import = "java.sql.*"%>

<%!
	
	private String getURL () {
		return "jdbc:mysql://127.0.0.1:3306/gallery";		
	}

	private String getUser () {
		return "gallery";
	}

	private String getPwd () {
		return "eecs118";	
	}

	private int preparedStatementDB (String prepareStatementSQL, ArrayList<String> insertValueList, int numOfValues) {

		// establish a connection with the DB
		try {
			Connection con = DriverManager.getConnection(getURL(),getUser(),getPwd());

			// create a prepared statement
			PreparedStatement pstmt = null;
			pstmt = con.prepareStatement(prepareStatementSQL, Statement.RETURN_GENERATED_KEYS);
			pstmt.clearParameters();

			for (int i=0; i < numOfValues; i++) {
				pstmt.setString(i+1, insertValueList.get(i));
			}
			
			pstmt.executeUpdate();
			ResultSet rs = pstmt.getGeneratedKeys();
			rs.next();
			return rs.getInt(1);

		} 
		catch(SQLException q) {}
		return -1;
	}
	
%>


