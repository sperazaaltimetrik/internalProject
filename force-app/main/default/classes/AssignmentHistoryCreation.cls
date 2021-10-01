public with sharing class AssignmentHistoryCreation {
    public static void assignmentHistoryCreationAccountUpdate(Account acc, Map<Id, Account> oldAccountMap){

        Assignment_History__c assignHistory = new Assignment_History__c();

        assignHistory.Name = acc.Name + ' History';

        assignHistory.Account__c = acc.Id;
        assignHistory.Changed_By__c = acc.LastModifiedById;
        
        assignHistory.Previous_Owner__c = oldAccountMap.get(acc.Id).OwnerId;
        assignHistory.New_Owner__c = acc.OwnerId;

        if(isTerritoryByAccount(oldAccountMap.get(acc.Id))) {
            assignHistory.Previous_Territory__c = getTerritoryByAccount(oldAccountMap.get(acc.Id));
        } 
        
        if(isTerritoryByAccount(acc)){
            assignHistory.New_Territory__c = getTerritoryByAccount(acc);
        }

        insert assignHistory;
    }

    public static void assignmentHistoryCreationAccountInsert(Account acc){
        Assignment_History__c assignHistory = new Assignment_History__c();

            assignHistory.Name = acc.Name + ' History';

            assignHistory.Account__c = acc.Id;
            assignHistory.Changed_By__c = acc.LastModifiedById;
            
            assignHistory.New_Owner__c = acc.OwnerId;
            assignHistory.Previous_Owner__c = null;
            
            if(isTerritoryByAccount(acc)){
                assignHistory.New_Territory__c = getTerritoryByAccount(acc);
            } 
            assignHistory.Previous_Territory__c = null;

            insert assignHistory;
    }

    @TestVisible
    private static Boolean isTerritoryByAccount(Account account){
        return [Select Id, Owner__c, Zip_Code__c From Territory__c where Zip_Code__c =: account.BillingPostalCode limit 1].size() > 0;
    }

    @TestVisible
    private static Id getTerritoryByAccount(Account account){
        Territory__c aux = [Select Id, Owner__c, Zip_Code__c From Territory__c where Zip_Code__c =: account.BillingPostalCode limit 1];
        return aux.id;
    }
}
