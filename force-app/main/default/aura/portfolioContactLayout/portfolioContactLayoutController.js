({
	/*Sets page reference on initialization*/
    doInit : function(cmp, evt, helper){
        //Set Page Reference
        var pageRef = {
            type: 'comm__namedPage',
            attributes: {
                name: 'portfolioContact__c',
            }
        };
        cmp.set("v.pageReference", pageRef);
        
        //Load empty lead record
        cmp.find("leadCreator").getNewRecord(
            "Lead",null,false,$A.getCallback(function(){
                var rec = cmp.get("v.templateLeadRecord");
                var error = cmp.get("v.leadError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    return;
                }
                console.log(rec.apiName + "record template initialized");
            }));
    },
    
    /*Handles navigation on icon button click*/
    handleClick : function(cmp, evt) {
        var pageRef = cmp.get("v.pageReference");
        var btnName = evt.getSource().get("v.name");
        console.log("Button Name: " + btnName);
        var navService = cmp.find("navService");
        var pagRef = cmp.get("v.pageReference");
        
        switch (btnName){
        /* If name is 'linkedIn' navigate to linkedIn site*/
            case "linkedIn":
                pageRef = {
                    type: 'standard__webPage',
                    attributes: {
                        url: 'https://www.linkedin.com/in/eagobert/'
                    }
                };
                break;
        /* If name is 'github' navigate to github site*/
            case "github":
                pageRef = {
                    type: 'standard__webPage',
                    attributes: {
                        url: 'https://github.com/eagobert'
                    }
                };
                break;
         /* If name is 'trailhead' navigate to trailhead site*/
            case "trailhead":
                pageRef = {
                    type: 'standard__webPage',
                    attributes: {
                        url: 'https://trailblazer.me/id/erinagobert'
                    }
                };
                break;
            default:
                console.log("No page reference for navigation.");
		}
        evt.preventDefault();
        navService.navigate(pageRef);
	},
    
     /*Submits lead on contact form button click*/
    handleSubmitLead : function(cmp, evt, helper){
        //Set company field
        var fName = cmp.get("v.leadRecord.FirstName");
        var lName = cmp.get("v.leadRecord.LastName");
        var cName = cmp.get("v.leadRecord.Company");
        if(cName === null || cName === ''){
            if(fName !== null && lName !== null){ 
                cmp.set("v.leadRecord.Company", fName.trim().concat(" ", lName.trim()));
            }
        } 
         
        //Set custom validity on Phone & Email fields
        var phone = cmp.get("v.leadRecord.Phone");
        var email = cmp.get("v.leadRecord.Email");
        var message = "";
        
        if(email === null || email.trim() === ""){
            if(phone === null || phone.trim() === ""){
                message = "Please enter a phone or email."
                cmp.set("v.isRequired", true );
                pField = cmp.find("Phone").setCustomValidity(message);
                eField = cmp.find("Email").setCustomValidity(message);
            } 
        }else{
            cmp.set("v.isRequired", false );
            pField = cmp.find("Phone").setCustomValidity(message);
            eField = cmp.find("Email").setCustomValidity(message);
        }
        
       console.log('leadRecord: ' + JSON.stringify(cmp.get("v.leadRecord")));
       var validateInput = helper.validateInput(cmp);
       if(validateInput){
            cmp.find("leadCreator").saveRecord($A.getCallback(function(SaveRecordResult){
                var state = SaveRecordResult.state;
                if(state === "SUCCESS" || state === "DRAFT"){
                    console.log('state: ' + state);
                    cmp.find("notifLib").showToast({
                        title: "Success!",
                        message: "Contact has been submitted successfully.",
                        variant: "success",
                        mode: "dismissable"
                    });
                    cmp.find("leadCreator").reloadRecord();
                    
                } else if(state === "INCOMPLETE"){
                    console.log('state: ' + state);
                    
                }else if(state === "ERROR"){
                    console.log('Save lead Error: ' + JSON.stringify(SaveRecordResult.error));
                    cmp.find("notifLib").showToast({
                        title: "Error!",
                        message: "Problem submitting record.  Please submit your request by email to contact@erinagobert.com.",
                        variant: "error",
                        mode: "dismissable"
                    });
                };
            }));
         } else{
             cmp.find("notifLib").showToast({
                        title: "Warning!",
                        message: "Please update the invalid form entries and try again.",
                        variant: "warning",
                        mode: "dismissable"
                    });
         }
    }
})