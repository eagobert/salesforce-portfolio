({
	/**
    *@desc	sets the activesection attribute on the lightning:accordionSection
    *		component on component initialization
    **/
    onInit: function(cmp, evt, helper) {
        helper.loadActiveSections(cmp);
	},
    
    /**
    *@desc handles navigation to view task in mobile view.
    		navigates user to a single task record
    **/
    handleViewTask: function(cmp, evt, helper){
        let pageRef = cmp.get("v.pageReference");
        let navService = cmp.find("navService");
        
        //Table View Button 
        let recordId = evt.getParam("value");
        
        //Mobile View Button
        if($A.util.isUndefined(recordId)){
            recordId = evt.getSource().get("v.value");
        }
        if(!$A.util.isUndefinedOrNull(recordId)){
            pageRef = {    
                "type": "standard__recordPage",
                "attributes": {
                    "recordId": recordId,
                    "objectApiName": "Task",
                    "actionName": "view"
                }
            };
            evt.preventDefault();
            navService.navigate(pageRef);
        };  
    },
    
    /**
    *@desc handles navigation to view task in desktop view.
    		navigates user to a single task record
    **/
    handleClick: function(cmp, evt, helper){
        let pageRef = cmp.get("v.pageReference");
        let navService = cmp.find("navService");
        let recordId = evt.target.getAttribute("id");
        
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