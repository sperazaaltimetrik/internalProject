trigger AccountUpdateTrigger on Account (before insert, after insert, before update) {

    if(Trigger.IsBefore){

        if(Trigger.isInsert){
        AccountBillingPostalCodeInsertHelper.triggerHelper(trigger.new);
        }

        if(Trigger.isUpdate){
            AccountBillingPostalCodeUpdateHelper.triggerHelper(trigger.new, trigger.oldMap);
        }

        if(Trigger.isDelete){}
    }

    if(Trigger.isAfter){
        if(Trigger.isInsert){
        AccountBillingAfterInsertHelper.triggerHelper(trigger.new);
        }
    }   
}