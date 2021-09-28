global with sharing class MidnightCheck implements Schedulable {
    global void execute(SchedulableContext ctx) {
        List<Account> accList = [Select Id, OwnerId, BillingPostalCode from Account];
        List<Territory__c> terList = [select Zip_Code__c, Owner__c from Territory__c];

        for(Account acc: accList){
            Boolean billCodeMatch = false;
            Boolean correctOwner = false;
            for(Territory__c ter : terList){
                if(acc.BillingPostalCode == ter.Zip_Code__c) billCodeMatch = true;
            }
            if(billCodeMatch){
                for(Territory__c ter : terList){
                    if(acc.ownerId == ter.Owner__c) correctOwner = true;
                }
                if(!correctOwner){
                    acc.ownerId = getOwnerByZip(acc.BillingPostalCode);
                }
            }
        }
    }

    @TestVisible
    private static Id getOwnerByZip(String zipCode){
        List<Territory__c> aux = [Select Id, Owner__c, Zip_Code__c From Territory__c where Zip_Code__c =: zipCode];
       
        Integer randomNumber = Integer.valueof((Math.random() * aux.size()));

        return aux[randomNumber].Owner__c;
    }
}
