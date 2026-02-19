@isTest(SeeAllData=true)
public class AssignedTasksManagerTest {
    
    @IsTest static void testGetSingleTask(){
        String taskId = '';
        List<Task> taskList = new List<Task>();
        taskList = [SELECT Id, OwnerId,Description, Priority, WhoId, Subject, WhatId, What.Name, Status, ActivityDate 
                    FROM Task LIMIT 1];
        
        taskId = String.valueOf(taskList[0].Id);
        Task actual = AssignedTasksManager.getSingleTask(taskId);
        Task expected = taskList[0];
        System.assertEquals(expected,actual);
    }
    
    @IsTest static void testVerifyIsGeneralTask(){
        List<sfal__SuccessPlan__c> planList= [SELECT sfal__Advisee__c 
                                              FROM sfal__SuccessPlan__c 
                                              WHERE (sfal__Status__c = 'Open' 
                                                     OR sfal__Status__c = 'Completed' OR sfal__Status__c = 'Cancelled') Limit 200];
        
        if(planList.size() > 0){
            List<String> idList = new List<String>();
            for(sfal__SuccessPlan__c sp : planList){
                String str = sp.sfal__Advisee__c;
                idList.add(str);
            }
            //Select a user
            List<User> portalUsers = [SELECT Id, contactId 
                                      FROM User 
                                      WHERE IsActive = true AND contactId IN :idList LIMIT 200];
            Set<String> userContacts = new Set<String>();
            for(User u : portalUsers){
                userContacts.add(String.valueOf(u.contactId));
            }
            
            if(userContacts.size() > 0){
                Set<String> strCaseSet = new Set<String>();
                List<Case> caseList = [SELECT Id, caseNumber 
                                       FROM Case 
                                       WHERE RecordType.Name = 'Advisee Record' 
                                       AND contactId IN :userContacts];
                for(Case c : caseList){
                    strCaseSet.add(c.caseNumber);
                }
                List<Task> taskList = [SELECT Id, OwnerId,Description, Priority, WhoId, Subject, WhatId, What.Name, Status, ActivityDate 
                                       FROM Task 
                                       WHERE OwnerId IN:portalUsers 
                                       AND WhoId IN :userContacts
                                       AND What.Name IN :strCaseSet LIMIT 1];
                
                if(taskList.size() > 0){
                    User portalUser = [SELECT Id, contactId FROM User WHERE Id =:taskList[0].OwnerId];
                    
                    System.runAs(portalUser){
                        
                        String taskWhatName = String.valueOf(taskList[0].What.Name);
                        Boolean expected = strCaseSet.contains(taskWhatName);
                        Boolean actual = AssignedTasksManager.verifyIsGeneralTask(taskWhatName);
                        System.assertEquals(expected, actual);
                    }
                }
            }
        }
    }
    
    @IsTest static void testGetSPList(){
        //Need a portal user with at least 1 success plan
        List<sfal__SuccessPlan__c> planList= [SELECT sfal__Advisee__c 
                                              FROM sfal__SuccessPlan__c 
                                              WHERE (sfal__Status__c = 'Open' OR sfal__Status__c = 'Completed' OR sfal__Status__c = 'Cancelled') Limit 50];        
        
        if(planList.size() > 0){
            List<String> idList = new List<String>();
            List<sfal__SuccessPlan__c> editedPlanList = new List<sfal__SuccessPlan__c>();
            for(sfal__SuccessPlan__c sp : planList){
                String str = sp.sfal__Advisee__c;
                idList.add(str);
            }
            
            //Select a user
            List<User> portalUsers = [SELECT Id, contactId 
                                      FROM User 
                                      WHERE IsActive = true AND contactId IN :idList LIMIT 1];
            
            if(portalUsers.size() > 0){
                User portalUser = portalUsers[0];
                System.runAs(portalUser){
                    System.debug('portal user id: ' + portalUser.Id);
                    
                    List<sfal__SuccessPlan__c> expected = [SELECT Id, Name, sfal__Advisee__r.Id, sfal__FromTemplate__r.Id
                                                           FROM sfal__SuccessPlan__c 
                                                           WHERE sfal__Advisee__r.Id =:portalUser.contactId];
                    
                    List<sfal__SuccessPlan__c> actual = AssignedTasksManager.getSuccessPlans();
                    System.assertEquals(expected.size(), actual.size());
                }
            }
        }   
    }
    
    @IsTest static void testGetTaskList(){
        List<sfal__SuccessPlan__c> planList= [SELECT sfal__Advisee__c 
                                              FROM sfal__SuccessPlan__c 
                                              WHERE (sfal__Status__c = 'Open' OR sfal__Status__c = 'Completed' OR sfal__Status__c = 'Cancelled') Limit 50];        
        
        if(planList.size() > 0){
            List<String> idList = new List<String>();
            
            for(sfal__SuccessPlan__c sp : planList){
                String str = sp.sfal__Advisee__c;
                idList.add(str);
            }
            
            List<User> portalUsers = [SELECT Id, contactId 
                                      FROM User 
                                      WHERE IsActive = true AND contactId IN :idList LIMIT 1];
            
            if(portalUsers.size() > 0){
                User portalUser = portalUsers[0];
                
                System.runAs(portalUser){
                    Map<String,Map<String,List<Task>>> expected = new Map<String,Map<String,List<Task>>>();
                    List<sfal__SuccessPlan__c> studentSP = new List<sfal__SuccessPlan__c>();
                    List<Task> taskList = new List<Task>();
                    List<String> spNameList = new List<String>();
                    List<String> taskStatusList = new List<String>();
                    
                    studentSP = [SELECT Id, Name, sfal__Advisee__r.Id, sfal__FromTemplate__r.Id
                                 FROM sfal__SuccessPlan__c 
                                 WHERE sfal__Advisee__r.Id =:portalUser.contactId];
                    
                    for(sfal__SuccessPlan__c plan: studentSP){
                        if(!spNameList.contains(plan.Name)){
                            spNameList.add(plan.Name);
                        }
                    }
                    spNameList.add('General Tasks');
                    taskList = [SELECT Id, OwnerId, WhoId, Subject, WhatId, What.Name,Status, ActivityDate 
                                FROM Task
                                WHERE WhoId =:portalUser.contactId];
                    
                    for(Task t : taskList){
                        if(!taskStatusList.contains(t.Status)){
                            taskStatusList.add(t.Status);
                        }
                    }
                    
                    for(String pn : spNameList){
                        Map<String,List<Task>> taskByStatusMap = new Map<String,List<Task>>();
                        for(String stat : taskStatusList){
                            Set<Task> iTaskSet = new Set<Task>();
                            Set<Task> cTaskSet = new Set<Task>();
                            for(Task t : taskList){
                                if(((pn == 'General Tasks') && (pn != t.What.Name)) && (stat == t.Status)){
                                    if(t.Status == 'Completed'){
                                        cTaskSet.add(t);
                                    }else{
                                        iTaskSet.add(t);
                                    } 
                                }
                                if((pn == t.What.Name) && (stat == t.Status)){
                                    if(t.Status == 'Completed'){
                                        cTaskSet.add(t);
                                    }else{
                                        iTaskSet.add(t);
                                    } 
                                }
                            }
                            List<Task> cTaskList = new List<Task>(cTaskSet);
                            List<Task> iTaskList = new List<Task>(iTaskSet);
                            
                            if(stat != 'Completed'){
                                taskByStatusMap.put('Incomplete Tasks', iTaskList);
                            }else{
                                taskByStatusMap.put('Complete Tasks', cTaskList);
                            }   
                        }
                        expected.put(pn,taskByStatusMap);
                    }
                    
                    Map<String,Map<String,List<Task>>> actual = AssignedTasksManager.getTasks();
                    System.assertEquals(expected.size(), actual.size());
                }
            }
        }
    }
}