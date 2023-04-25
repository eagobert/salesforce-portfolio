({
	validateInput : function(cmp,evt, helper) {
        //find all the input components to validate by aura:id.  An array of form fields are returned.
		var contactForm = cmp.find("formField");
        //Check validity of each component using JS reduce method.  Method parameters: reducer callback function, initial value.
            //create reducer callback funtion in the reduce method that checks validity of each field.  The reducer function evaluates until there is only one single response. function parameters: accumulator, currentValue
        		//accumulator = validSoFar.  This is the accumulated value (or sum) of each evaluation plus the initial value, if provided. On the last evaluation, the accumulator is what is returned.  I think of it as the variable assigned to the accumulated value.
            	//currentValue = inputCmp. This is what is being evaluated in each iteration.  I think of this as the variable assigned to the item being evaluated.	
            //initial value = set to true.  The starting value for evaluation of form validity.  This value can change on each return of the anonymous callback function.
        contactForm.reduce(function(validSoFar, inputCmp){
            //function body = instructions for evaluating each field in the array.  Here we are checking validity.
            inputCmp.reportValidity();
            console.log('report valid: ' + inputCmp.reportValidity());
            console.log('check valid: ' + inputCmp.checkValidity());
            console.log('validSoFar: ' + validSoFar && inputCmp.checkValidity());
            return validSoFar && inputCmp.checkValidity();
        }, true);
	}
})