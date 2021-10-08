public with sharing class AccountBillingPostalCodeInsertHelper {
    
    public static void triggerHelper(List<Account> triggerList){
        for(Account acc : triggerList){
            if(isThereTerritoy(acc)){
                acc.OwnerId = getOwnerByZip(acc.BillingPostalCode);
            }
        }   
    }

    @TestVisible
    private static Boolean isThereTerritoy(Account acc){
        return [Select Zip_Code__c from Territory__c where Zip_Code__c =: acc.BillingPostalCode].size() > 0; //this query is called inside loop, ALWAYS AVOID QUERIES IN LOOPS
    }

    @TestVisible
    private static Id getOwnerByZip(String zipCode){
        List<Territory__c> aux = [Select Id, Owner__c, Zip_Code__c From Territory__c where Zip_Code__c =: zipCode]; //this query is called inside loop, ALWAYS AVOID QUERIES IN LOOPS
       
        Integer randomNumber = Integer.valueof((Math.random() * aux.size()));

        return aux[randomNumber].Owner__c;
    }
}
