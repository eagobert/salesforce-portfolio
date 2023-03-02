({
	doInit : function(component, event, helper) {
        var url = $A.get('$ContentAsset.PortfolioBackground2');
        component.set('v.backgroundUrl', url);
		
	}
})