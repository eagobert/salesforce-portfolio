({  
    /**
    * @desc Gets section names from the section variable stored 
    * 		on parent component initialization to set activeSections 
    * 		on load
    **/
    loadActiveSections: function(cmp){
        var sections = cmp.get("v.sections");
        cmp.set("v.activeSections", sections);
    }
})