trigger TerritoryUpdateTrigger  on Territory__c (before insert, before update) {
   
    if(Trigger.isInsert){
        CheckRepAssignmentHelper.beforeInsertHelper(trigger.new);
    }
    if(Trigger.isUpdate){
        CheckRepAssignmentHelper.triggerHelper(trigger.new, trigger.oldMap);
        SalesRepresentativeChangeHelper.triggerHelper(trigger.new, trigger.oldMap);
    }
}
