({  
    /**
    * @desc sets page reference to the "My Tasks Page"
    **/
    setPageRef: function(cmp){
        let pageRef = {
            type: "comm__namedPage",
            attributes: {
                name: "my_tasks_new__c"
            }
        }
        cmp.set("v.pageReference", pageRef);
    },
    
    /**
    * @desc sets current date for the logged in user
    **/
    setCurrentDate: function(cmp){
        let timezone = $A.get("$Locale.timezone");
        let now = new Date();
        $A.localizationService.getToday(timezone, function(today){
            cmp.set("v.currentDate", today);
        });
    },
    
    /**
    * @desc Stores parsed task and success plan data from server-side controller
    * 		to taskPlanMap variable
    * @returns { Map<String,Map<String,List<Task>>>}		
    **/    
    loadSuccessPlanTasks: function(cmp) {
        let action = cmp.get("c.getTasks");
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS"){
                let outerMap = response.getReturnValue();
                let successPlanNum = Object.keys(outerMap).length;
                let taskPlanMap = [];
                let activeSections = [];

                //Access success plan outer map<String, Map<String, List<Task>>>
                for(let key of Object.keys(outerMap)){
                    let innerMap = outerMap[key];
                    let outerMapObj = {};
                    outerMapObj.key = key.substr(18, key.length);
                    outerMapObj.value= [];
                    
                    //Access task by status inner map<String, List<Task>>
                    for(let key2 of Object.keys(innerMap)){

                        //Create labels for each accordion section
                        let keyCounter = new Number(taskPlanMap.length +1);
                        let name = new String(key2.concat(' ', keyCounter.toString()));
                        activeSections.push(name);

                        let taskbyStatusList = innerMap[key2];
                        let innerObj = {};
                        innerObj.key = key2;
                        innerObj.value = [];
                        
                        //Create generic object for each task to store additional table information
                        for(let i= 0; i < taskbyStatusList.length; i++){
                            let t = taskbyStatusList[i];
                            let dueDate= null;
                            let o = new Object();
                            
                            o.Id = t.Id.toString();
                            o.Subject = t.Subject.toString();
                            o.Status = t.Status.toString();

                            //Format Due Date
                            if($A.util.isUndefinedOrNull(t.ActivityDate)){
                                o.ActivityDate = ' ';
                                o.isOverdue =false;
                            }else{
                                dueDate= $A.localizationService.parseDateTimeISO8601(t.ActivityDate);
                                let locale = $A.get("$Locale.langLocale");
                                let formattedDueDate=$A.localizationService.formatDate(dueDate, "MM/dd/yyyy", locale);
                                
                                o.ActivityDate = formattedDueDate;

                                //Identify past due activity dates. Is past due if due date is earlier than current date.
                                if(dueDate.getTime() < Date.now()){
                                    o.isOverdue = true;
                                }else{
                                    o.isOverdue = false;
                                }
                            }//End format due date
                            innerObj.value.push(o);
                        }//End Task Loop
                      
                        outerMapObj.value.push(innerObj);               
                    }

                    taskPlanMap.push(outerMapObj);
                }
                this.sortTaskStatus(taskPlanMap);
                cmp.set("v.taskPlanMap", taskPlanMap);
                cmp.set("v.sections", activeSections);

            }else if(state === "ERROR"){
                let errors = response.getErrors();
                if(errors && Array.isArray(errors) && errors.length > 0){
                    for(let i=0; i < errors.length; i++ ){
                        console.error("Error: " + errors[i].message);
                    }
                }
            }else {
                console.log("No response from server or client is offline.");
            }
        });
        $A.enqueueAction(action);
    },
     /**
    * @desc Sorts incomplete tasks to display before complete tasks 
    **/ 
    sortTaskStatus: function(taskPlanMap){
        let unsortedMap = taskPlanMap;
        unsortedMap.forEach(function(obj1){
            let outerMapKey = obj1.Key;
            let innerMap = obj1.value;
            innerMap.sort(function(b,a){
                let keyA = a.key.toLowerCase();
                let keyB = b.key.toLowerCase();
                if(keyA < keyB){
                    return -1;
                }
                if(keyA > keyB ){
                    return 1;
                }
                return 0;
            });
        })
    }
})