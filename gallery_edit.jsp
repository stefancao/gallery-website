<%--------------------------------------------------------------
Copyright Stefan Cao 2016 - All Rights Reserved          
												          
	Name: Stefan Cao								          
	ID#: 79267250									          
	Assignment: Mini-Project 2						          
												          
	File: gallery_edit.jsp 										 
												          
	Description:	
		edit gallery

	History:
		Date 	Update Description 	   		   Developer  
     --------  ---------------------          ------------	     
     10/26/2016 		Created 					SC
--------------------------------------------------------------%>
<% String pageTitle = "Gallery Edit"; %>

<%@include file="includes/header.jsp" %>
<%@include file="utils/DB_utils.jsp" %>

<%!
	// function to generate the edit input box
	private String generateEditInputBox (String divId, String labelFor, String labelTitle, String inputID, String inputName, String inputValue, String labelId, String erMessage) {

		return "<div class='form-group' id='" + divId + "'><label for='" + labelFor + "' class='col-lg-2 control-label'>" + labelTitle + "</label><div class='col-lg-10'><input type='text' class='form-control' id='" + inputID + "' name='" + inputName + "' value='" + inputValue + "'></div><label id='" + labelId + "' style='display: none' class='col-lg-6 control-label' for='inputError'>" + erMessage + "</label></div>";
	}

	// function to generate the edit text input box
	private String generateEditTextInputBox (String divId, String labelFor, String labelTitle, String inputID, String inputName, String inputValue, String labelId, String erMessage) {

		return "<div class='form-group' id='" + divId + "'><label for='" + labelFor + "' class='col-lg-2 control-label'>" + labelTitle + "</label><div class='col-lg-10'><textarea class='form-control' id='" + inputID + "' name='" + inputName + "' rows='8'>" + inputValue + "</textarea></div><label id='" + labelId + "' style='display: none' class='col-lg-6 control-label' for='inputError'>" + erMessage + "</label></div>";
	}
%>

<%
	String galleryId = request.getParameter("id");

	try {

		// establish a connection
		Connection con = DriverManager.getConnection(getURL(),getUser(),getPwd());
		Statement stmt = con.createStatement();

		// get the specific gallery given the gallery_id 
		String sql = "SELECT * FROM gallery WHERE gallery_id = " + galleryId;
		ResultSet rs = stmt.executeQuery(sql);

		rs.next();

		// output the form 
		out.println("<center><form class='form-horizontal' name='galleryEditForm' method='post' action='update.jsp?t=g' onsubmit='return checkValidation()'>");

		// send the gallery_id to update.jsp
		out.println("<input type='hidden' name='gallery_id' value='" + galleryId + "'>");

		// output the input boxes with the value of the previous
		out.println(generateEditInputBox ("nameDiv", "editGallery-Div", "Name:", "nameId", "name", rs.getString("name"), "nameLabel", "Please fill in gallery name"));

		out.println(generateEditTextInputBox ("descriptionDiv", "editGallery-Div", "Description:", "descriptionId", "description", rs.getString("description"), "descriptionLabel", "Please fill in gallery description"));

		out.println("<button class='btn btn-primary' type='submit'>Update</button></form></center>");

		con.close();
		stmt.close();
		rs.close();
	}
	catch(Exception e)
	{
		out.println(e.toString());
	} 

%>

<script>

	// check validation before submitting to post
	function checkValidation() {
		var name = document.forms["galleryEditForm"]["name"].value;
		var description = document.forms["galleryEditForm"]["description"].value;
		
		// make sure no input boxes are null or empty
		if (name == null || name == "" 
			|| description == null || description == "") {
			
			alert ("Please fill fix the indicated inputs");

			if (name == null || name == "") {
				$('#nameDiv').addClass('has-error');
				document.getElementById("nameLabel").style.display = "block";
			}
			else {
				$('#nameDiv').removeClass('has-error');
				document.getElementById("nameLabel").style.display = "none";
			}

			if (description == null || description == "") {
				$('#descriptionDiv').addClass('has-error');
				document.getElementById("descriptionLabel").style.display = "block";
			}
			else {
				$('#descriptionDiv').removeClass('has-error');
				document.getElementById("descriptionLabel").style.display = "none";
			}
				
			// return false if any inputs are empty	
			return false;
		} 
	}

</script>
	
<%@include file="includes/footer.jsp" %>