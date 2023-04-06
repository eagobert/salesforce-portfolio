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
    },
    
    /*Handles navigation on button click*/
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
	}
})