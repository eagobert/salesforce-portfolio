({
	/**
    * @desc Sets page reference and back navigation 
    * 		url on component initialization.
    **/
    onInit : function(cmp, evt, helper) {
        helper.setUrl(cmp);
        var recordId = cmp.get("v.recordId");
                if(!$A.util.isUndefinedOrNull(recordId)){
        var pageRef = {
                "type": "standard__recordPage",
                "attributes": {
                    "recordId": recordId,
                    "objectApiName": "Task",
                    "actionName": "view"
                }
            };
            cmp.set("v.pageReference", pageRef);
                    console.log("pageRef on Init: " + JSON.stringify(pageRef));
        };   
	}
})