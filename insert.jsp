<%--------------------------------------------------------------
Copyright Stefan Cao 2016 - All Rights Reserved          
												          
	Name: Stefan Cao								          
	ID#: 79267250									          
	Assignment: Mini-Project 2						          
												          
	File: insert.jsp 										 
												          
	Description:	
		insert to database			

	History:
		Date 	Update Description 	   		   Developer  
     --------  ---------------------          ------------	     
     10/8/2016 		Created 					SC
--------------------------------------------------------------%>

<%@include file="includes/javaLib.jsp" %>
<%@include file="utils/DB_utils.jsp" %>

<%

	// init vars
	ArrayList<String> insertValueList = new ArrayList<String>();
	int numOfValues = 0;

	// start of insert string
	String insertSQL = "INSERT INTO ";

	// get the type
	String type = request.getParameter("t");

	String returnValue = "";
	int success = -1;
	
	// if type is gallery
	if (type.equals("g")) {
		
		// concatenate the insert string		
		insertSQL += "gallery VALUES (default,?,?)";

		// add the param values to the list
		insertValueList.add(request.getParameter("galleryName"));
		insertValueList.add(request.getParameter("galleryDescription"));

		// set the number of values is 2
		numOfValues = 2;
		returnValue = request.getParameter("galleryName");

		success = preparedStatementDB(insertSQL, insertValueList, numOfValues);

	}	

	// if type is image
	else if (type.equals("i")) {
		String artistId = request.getParameter("artistId");
		
		// if artist id is 0, insert an artist first
		if (artistId.equals("0")) {

			// concatenate the insert string		
			insertSQL += "artist VALUES (default,?,?,?,?)";

			// add the param values to the list
			insertValueList.add(request.getParameter("artistName"));
			insertValueList.add(request.getParameter("artistBirth"));
			insertValueList.add(request.getParameter("artistCountry"));
			insertValueList.add(request.getParameter("artistDescription"));

			// set the number of values is 4
			numOfValues = 4;
		
			artistId = String.valueOf(preparedStatementDB(insertSQL, insertValueList, numOfValues));

			// empty and reinit
			insertValueList.clear();
			insertSQL = "INSERT INTO ";

		}

		insertValueList.clear();
		// concatenate the insert string		
		insertSQL += "image VALUES (default,?,?,?,?,null)";

		// add the param values to the list
		insertValueList.add(request.getParameter("imageTitle"));
		insertValueList.add(request.getParameter("imageLink"));
		insertValueList.add(request.getParameter("galleryId"));
		insertValueList.add(artistId);

		// set the number of values is 4
		numOfValues = 4;
		returnValue = request.getParameter("imageTitle");

		String imageId = String.valueOf(preparedStatementDB(insertSQL, insertValueList, numOfValues));

		insertValueList.clear();
		insertSQL = "INSERT INTO detail VALUES (?,?,?,?,?,?,?,?)";

		insertValueList.add(imageId);
		insertValueList.add(imageId);
		insertValueList.add(request.getParameter("imageYear"));
		insertValueList.add(request.getParameter("imageType"));
		insertValueList.add(request.getParameter("imageWidth"));
		insertValueList.add(request.getParameter("imageHeight"));
		insertValueList.add(request.getParameter("imageLocation"));
		insertValueList.add(request.getParameter("imageDescription"));
		
		numOfValues = 8;

		success = preparedStatementDB(insertSQL, insertValueList, numOfValues);

		String updateSQL = "UPDATE image SET detail_id = " + imageId + " WHERE image_id = " + imageId;

		Connection con = DriverManager.getConnection(getURL(),getUser(),getPwd());

		// create a prepared statement
		PreparedStatement pstmt = null;
		pstmt = con.prepareStatement(updateSQL);
		pstmt.clearParameters();

		pstmt.executeUpdate();
		
	}

	// if type is artist
	else if (type.equals("a")) {

		// concatenate the insert string		
		insertSQL += "artist VALUES (default,?,?,?,?)";

		// add the param values to the list
		insertValueList.add(request.getParameter("artistName"));
		insertValueList.add(request.getParameter("artistBirth"));
		insertValueList.add(request.getParameter("artistCountry"));
		insertValueList.add(request.getParameter("artistDescription"));

		// set the number of values is 2
		numOfValues = 4;
		returnValue = request.getParameter("artistName");

		success = preparedStatementDB(insertSQL, insertValueList, numOfValues);
	}

	// int success = pstmt.executeUpdate();
	if (success <= 0) {
	%>
		<jsp:forward page="exit.jsp"/>
	<%
	} 
	
%>

<form method='post' id='sendFormId' action=
	<%
		out.println("'" + request.getParameter("location") + "?r=s'");
	%>	
>
	<input type='hidden' name='returnValue' value=
	<%
		out.println("'" + returnValue + "'");
	%>
	>
</form>	
<script type='text/javascript'>document.getElementById('sendFormId').submit();
</script>