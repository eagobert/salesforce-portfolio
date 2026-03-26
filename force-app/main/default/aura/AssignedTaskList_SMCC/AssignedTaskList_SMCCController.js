({
	/** 
    * @desc loads current date, navigation page reference, and page data on
    * 		component initialization
    **/
    onInit: function(cmp, evt, helper) {
        helper.setCurrentDate(cmp);
        helper.setPageRef(cmp);
        helper.loadSuccessPlanTasks(cmp);

	},
    
    /**
    * @desc navigates the user from the task list to task record detail page
    **/
    handleClick: function(cmp, evt, helper){
        var pageRef = cmp.get("v.pageReference");
        var navService = cmp.find("navService");
        var recordId = evt.target.getAttribute("id");
        if(!$A.util.isUndefinedOrNull(recordId)){
            pageRef = {    
                "type": "standard__recordPage",
                "attributes": {
                    "recordId": recordId,
                    "objectApiName": "Task",
                    "actionName": "view"
                }
            };
        }
        evt.preventDefault();
            navService.navigate(pageRef);
    }
})