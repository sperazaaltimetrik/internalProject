public with sharing class AssignmentHistoryCreation {
    public static void assignmentHistoryCreationAccountUpdate(List<Account> updateList, Map<Id, Account> oldRecords){
        List<Assignment_History__c> creationList = new List<Assignment_History__c>();

        for(Account acc : updateList){
            Assignment_History__c toAdd = new Assignment_History__c();

            toAdd.Name = acc.Name + ' History';

            toAdd.Account__c = acc.Id;
            toAdd.Changed_By__c = acc.LastModifiedBy.Id;
            
            toAdd.Previous_Owner__c = oldRecords.get(acc.Id).OwnerId;
            toAdd.New_Owner__c = acc.OwnerId;

            if(isTerritoryByAccount(oldRecords.get(acc.Id))) {
                toAdd.Previous_Territory__c = getTerritoryByAccount(oldRecords.get(acc.Id));
            } 
            
            if(isTerritoryByAccount(acc)){
            toAdd.New_Territory__c = getTerritoryByAccount(acc);
            }
            creationList.add(toAdd);
        }

        insert creationList;
    }

    public static void assignmentHistoryCreationAccountInsert(Account acc){
        Assignment_History__c toAdd = new Assignment_History__c();

            toAdd.Name = acc.Name + ' History';

            toAdd.Account__c = acc.Id;
            toAdd.Changed_By__c = acc.LastModifiedById;
            
            toAdd.New_Owner__c = acc.OwnerId;
            
            if(isTerritoryByAccount(acc)){
            toAdd.New_Territory__c = getTerritoryByAccount(acc);
            }
            insert toAdd;
    }

    private static Boolean isTerritoryByAccount(Account account){
        return [Select Id, Owner__c, Zip_Code__c From Territory__c where Zip_Code__c =: account.BillingPostalCode limit 1].size() > 0;
    }

    private static Id getTerritoryByAccount(Account account){
        Territory__c aux = [Select Id, Owner__c, Zip_Code__c From Territory__c where Zip_Code__c =: account.BillingPostalCode limit 1];
        return aux.id;
    }
}
