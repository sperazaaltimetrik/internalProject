
public with sharing class AccountBillingPostalCodeUpdateHelper {
 
    public static void triggerHelper(List<Account> triggerList, Map<Id, Account> oldList){
        List<Account> updatablesAccounts = new List<Account>();
        Map<Id, Account> oldAccountMap = new Map<Id,Account>();

        for (Account acc : triggerList){
            if (acc.BillingPostalCode != oldList.get(acc.Id).BillingPostalCode){
                updatablesAccounts.add(acc);
                oldAccountMap.put(acc.Id, oldList.get(acc.Id));
            }
        }

        if(updatablesAccounts.size()>0) {   
            accountOwnerUpdate(updatablesAccounts, oldAccountMap); 
        }
    }
     
    public static void accountOwnerUpdate(List<Account> accList, Map<Id, Account> oldAccountMap){
        for(Account acc : accList){
            if(isThereTerritoy(acc)){
                
                accountUpdate(acc);
                
                contactOwnerUpdate(acc);

                opportunityOwnerUpdate(acc);

                AssignmentHistoryCreation.assignmentHistoryCreationAccountUpdate(acc, oldAccountMap);

                AccountUpdateMail.emailUpdate(acc);
            }
        }
        
    }

    public static void accountUpdate (Account acc){
        acc.OwnerId = getOwnerByZip(acc.BillingPostalCode);
    }

    public static void opportunityOwnerUpdate (Account acc){
        List<Opportunity> toUpdate = new List<Opportunity>();

        for(Opportunity opp : getOppListByAccount(acc)){
            opp.OwnerId = getOwnerByZip(acc.BillingPostalCode);
            toUpdate.add(opp);
        }
        update toUpdate;
    }

    @TestVisible
    private static List<Opportunity> getOppListByAccount(Account acc){
        return [Select Id, OwnerId from Opportunity where AccountId =: acc.Id];
    }

    public static void contactOwnerUpdate(Account acc){
        List<Contact> toUpdate = new List<Contact>();

        for(Contact con : getContactByAcc(acc)){
            con.OwnerId = getOwnerByZip(acc.BillingPostalCode);
            toUpdate.add(con);
        }
        update toUpdate;
    }

    @TestVisible
    private static List<Contact> getContactByAcc(Account acc){
        return [SELECT Id,  OwnerId FROM Contact where Account.Id =: acc.Id];
    }

    //Requirement #3
    @TestVisible
    private static Id getOwnerByZip(String zipCode){
        List<Territory__c> updatablesAccounts = [Select Id, Owner__c, Zip_Code__c From Territory__c where Zip_Code__c =: zipCode];
       
        Integer randomNumber = Integer.valueof((Math.random() * updatablesAccounts.size()));

        return updatablesAccounts[randomNumber].Owner__c;
    }

    @TestVisible
    private static Boolean isThereTerritoy(Account acc){
        return [Select Zip_Code__c from Territory__c where Zip_Code__c =: acc.BillingPostalCode].size() > 0;
    }  
}