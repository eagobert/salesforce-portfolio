({
    /**
    * @desc Creates url to navigate back to the My Tasks page.  
    * 		Stores value in the url variable.
    **/
    setUrl: function(cmp){
        var navService = cmp.find("navService");
        var pageRef = {
            type: "comm__namedPage",
            attributes: {
                name: "my_tasks_new__c"
            }
        }
        var defaultUrl = "#";
        navService.generateUrl(pageRef).then($A.getCallback(function(url){
            cmp.set("v.url", url ? url : defaultUrl);
        }), $A.getCallback(function(error){
            cmp.set("v.url", defaultUrl);
        }));
        
       console.log("v.url: " + JSON.stringify(cmp.get("v.url")));
    },
})