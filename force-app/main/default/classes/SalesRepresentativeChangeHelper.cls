public with sharing class SalesRepresentativeChangeHelper {
    
    public static void triggerHelper(List<Territory__c> triggerList, Map<Id, Territory__c> oldList){
        
        List<Territory__c> updatableTerritoryList = new List<Territory__c>();
        Map<Id, Territory__c> oldRecords = new Map<Id,Territory__c>();

        for (Territory__c territory : triggerList){
            if (territory.Owner__c != oldList.get(territory.Id).Owner__c){
                updatableTerritoryList.add(territory);
                oldRecords.put(territory.Id, oldList.get(territory.Id));
            }
        }
        updateRelatedAccounts(updatableTerritoryList, oldRecords);
        
    }

    @TestVisible
    private static void updateRelatedAccounts(List<Territory__c> updatableTerritoryList,  Map<Id, Territory__c> oldRecords){
        
        for(Territory__c ter : updatableTerritoryList){
            List<Account> accbeforeUpdate = (getAccountListbyTerritory(oldRecords.get(ter.id)));
            updateAccount(accbeforeUpdate, ter);
        }  
    }

    @TestVisible
    private static void updateAccount(List<Account> accbeforeUpdate, Territory__c ter){
        for(Account acc : accbeforeUpdate){
            acc.OwnerId = ter.Owner__c;
        }
        update accbeforeUpdate;
    }

    @TestVisible
    private static List<Account> getAccountListbyTerritory(Territory__c ter){
        return [Select Id, OwnerId from Account where OwnerId =: ter.Owner__c];
    }

}
