<%--------------------------------------------------------------
Copyright Stefan Cao 2016 - All Rights Reserved          
												          
	Name: Stefan Cao								          
	ID#: 79267250									          
	Assignment: Mini-Project 2						          
												          
	File: form_utils.jsp 										 
												          
	Description:	
		functions for for		

	History:
		Date 	Update Description 	   		   Developer  
     --------  ---------------------          ------------	     
     10/15/2016 		Created 					SC
--------------------------------------------------------------%>

<%!
	private String generateInputBox (String divId, String labelFor, String labelTitle, String inputID, String inputName, String inputPlaceholder, String labelId, String erMessage) {

		return "<div class='form-group' id='" + divId + "'><label for='" + labelFor + "' class='col-lg-2 control-label'>" + labelTitle + "</label><div class='col-lg-10'><input type='text' class='form-control' id='" + inputID + "' name='" + inputName + "' placeholder='" + inputPlaceholder + "'></div><label id='" + labelId + "' style='display: none' class='col-lg-6 control-label' for='inputError'>" + erMessage + "</label></div>";
	}

	private String generateInputTextBox (String divId, String labelFor, String labelTitle, String inputID, String inputName, String inputPlaceholder, String labelId, String erMessage) {
		return "<div class='form-group' id='" + divId + "'><label for='" + labelFor + "' class='col-lg-2 control-label'>" + labelTitle + "</label><div class='col-lg-10'><textarea class='form-control' id='" + inputID + "' name='" + inputName + "' rows='8' placeholder='" + inputPlaceholder + "'></textarea></div><label id='" + labelId + "' style='display: none' class='col-lg-6 control-label' for='inputError'>" + erMessage + "</label></div>";
	}
%>


