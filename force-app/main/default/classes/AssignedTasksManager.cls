/** 
* @desc Manages functionality of the AssignedTasks 
*		and TaskRecordDetail components
**/
public with sharing class AssignedTasksManager{
    public static String recordId = '';
    public static String userContactId = '';
    
    /**
    * @desc Gets a single Task record
    * @param {String} The id of the task record
    * @returns {Task} Task record
    **/
    @AuraEnabled
    public static Task getSingleTask(String taskId){
        List<Task> taskList = new List<Task>();
        Task singleTask = new Task();
        try{
            tasklist = [SELECT Id, OwnerId,Description, Priority, WhoId, Subject, WhatId, What.Name, Status, ActivityDate 
                        FROM Task 
                        WHERE Id=:taskId LIMIT 1];
            
            if(!taskList.isEmpty()){
                singleTask = taskList[0];
            }
        }catch(Exception e){
            System.debug(e.getTypeName()+ ' Error on ' + e.getLineNumber()+ ': ' + e.getMessage());
            System.debug(' Stack Trace String: ' + e.getStackTraceString());
        }
        System.debug('Task ' + taskId+': '+singleTask);
        return singleTask;
    }
    
    /**
    * @desc Verifies if a task belongs to the "General Tasks category"
    * @param {String} The What.Name value of the task to evaluate
    * @returns {Boolean}
    **/
    @auraEnabled
    public static Boolean verifyIsGeneralTask(String taskWhatName){
        List<String> strCaseList = new List<String>();
        Boolean isGeneralTask = false;
        setUserContactId();
        
        if(String.isNotBlank(userContactId)){
            List<Case> caseList = [SELECT Id, caseNumber 
                                   FROM Case 
                                   WHERE RecordType.Name = 'Advisee Record' AND contactId =:userContactId];
            
            for(Case cs : caseList){
                strCaseList.add(String.valueOf(cs.caseNumber));
            }
            Boolean whatNameIsCaseNumber = (strCaseList.contains(taskWhatName));
            if(whatNameIsCaseNumber == true){
                isGeneralTask = true;
            } 
        }
        return isGeneralTask; 
    }
    
    /**
    * @desc Sets user id of the logged in user
    **/
    @AuraEnabled 
    public static void setUserContactId(){
        if(String.isBlank(recordId) && String.isBlank(userContactId)){
            recordId = UserInfo.getUserId();
            userContactId = [SELECT Id, contactId FROM User WHERE Id=:recordId LIMIT 1].contactId;
        }
    }
    
    /**
    * @desc Gets success plan data of the logged in user
    * @returns {List<sfal__SuccessPlan__c>}
    **/
    @AuraEnabled
    public static List<sfal__SuccessPlan__c> getSuccessPlans(){
        List<sfal__SuccessPlan__c> studentSP = new List<sfal__SuccessPlan__c>();
        try{
            setUserContactId();
            if(String.isNotBlank(recordId) && String.isNotBlank(userContactId)){
                studentSP = [SELECT Id, Name, sfal__Advisee__r.Id, sfal__FromTemplate__r.Id
                             FROM sfal__SuccessPlan__c 
                             WHERE sfal__Advisee__r.Id =:userContactId];
            }
        }catch(Exception e){
            System.debug(e.getTypeName()+' Error: '+ e.getMessage() +', Line#: ' + e.getLineNumber());
        }
        return studentSP;
    }
    
    /**
    * @desc Gets tasks assigned to the logged in user
    * @returns {Map<String,Map<String,List<Task>>>}
    **/
    @AuraEnabled
    public static Map<String,Map<String,List<Task>>> getTasks(){
        Map<String,Map<String,List<Task>>> planTaskMap = new Map<String,Map<String,List<Task>>>();
        List<Task> taskList = new List<Task>();
        List<String> spNameList = new List<String>();
        Map<String, String> spNameMap = new Map<String, String>();
        List<String> taskStatusList = new List<String>();
        List<Case> caseList = new List<Case>();
        List<String> strCaseList = new List<String>();
        
        try{
            List<sfal__SuccessPlan__c> studentSP = getSuccessPlans();
            
            //Allow for duplicate success plan names
            for(sfal__SuccessPlan__c plan: studentSP){
                String planId = String.valueOf(plan.Id);
                String planName = planId + plan.Name;
                spNameMap.put(planId, planName);
            }
            String gtPlanId = '000000000000000000';
            String gtPlanName = 'General Tasks';
            spNameMap.put(gtPlanId, gtPlanId + gtPlanName);
            
            if(String.isNotBlank(recordId) && String.isNotBlank(userContactId)){
                caseList = [SELECT Id, caseNumber 
                            FROM Case 
                            WHERE RecordType.Name = 'Advisee Record' AND contactId =:userContactId];
                
                for(Case cs : caseList){
                    strCaseList.add(String.valueOf(cs.caseNumber));
                }
                
                taskList = [SELECT Id, OwnerId, WhoId, Subject, WhatId, What.Name, Status, ActivityDate
                            FROM Task 
                            WHERE OwnerId =:recordId AND WhoId =:userContactId];
                
                for(Task t : taskList){
                    if(!taskStatusList.contains(t.Status)){
                        taskStatusList.add(t.Status);
                    }
                }
                
                for(String planId : spNameMap.keySet()){
                    Map<String,List<Task>> taskByStatusMap = new Map<String,List<Task>>();
                    List<Task> cTaskList = new List<Task>();
                    List<Task> iTaskList = new List<Task>();
                    Set<Task> iTaskSet = new Set<Task>();
                    Set<Task> cTaskSet = new Set<Task>();
                    
                    for(String planName : spNameMap.values()){
                        
                        //Evaluate plan name that begins with plan id
                        if(planName.startsWithIgnoreCase(planId)){
                            for(String stat : taskStatusList){
                                Integer i = 1;
                                for(Task t : taskList){
                                    Boolean statusIsMatch = (t.Status == stat);
                                    Boolean planIsNone = (planId == '000000000000000000');
                                    Boolean statEqualsCompleted = (t.Status == 'Completed');
                                    Boolean whatNameIsCaseNumber = (strCaseList.contains(t.What.Name));
                                    Boolean planIdIsWhatId = (planId == String.valueOf(t.WhatId));
                                    Boolean whatNameEndsPlanName = (planName.endsWithIgnoreCase(t.What.Name));
                                    
                                    if(statusIsMatch == true){
                                        //Success Plan Tasks: task with associated success plan
                                        if((whatNameEndsPlanName == true)&&(planIdIsWhatId == true) && (planIsNone == false)){
                                            if((statEqualsCompleted == true)){
                                                System.debug('Task'+i+': ' + t);
                                                cTaskSet.add(t);
                                            }
                                            if(statEqualsCompleted == false){
                                                System.debug('Task'+i+': ' + t);
                                                iTaskSet.add(t);
                                            }
                                        }
                                        
                                        //General Tasks: task with no success plan and associated with an advisee case record
                                        if((whatNameEndsPlanName == false) && (planIdIsWhatId == false) && ((planIsNone == true))){
                                            if((whatNameIsCaseNumber == true)){
                                                if(statEqualsCompleted == true){
                                                    System.debug('Task'+i+': ' + t);
                                                    cTaskSet.add(t);
                                                }
                                                if(statEqualsCompleted == false){
                                                    System.debug('Task'+i+': ' + t);
                                                    iTaskSet.add(t);
                                                }
                                            }
                                        }
                                    }
                                    i++;
                                }
                                cTaskList = new List<Task>(cTaskSet);
                                iTaskList = new List<Task>(iTaskSet);
                                taskByStatusMap.put('Complete Tasks', cTaskList);
                                taskByStatusMap.put('Incomplete Tasks', iTaskList);
                                
                            }   
                            planTaskMap.put(planName,taskByStatusMap);    
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug(e.getTypeName()+' Error: '+ e.getMessage() +', Line#: ' + e.getLineNumber());
        }
        return planTaskMap;
    }
}