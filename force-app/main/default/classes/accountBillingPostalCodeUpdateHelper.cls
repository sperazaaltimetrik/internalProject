// When an Account’s BillingPostalCode (aka Zip Code), is changed, 
// A)Change the Account Owner to the sales representative assigned to the new zip code
// B)Change the Owner field of all the Account’s Contacts to the same sales rep 
// C)Change the Owner field of all the Account’s Open Opportunities to the same sales rep
//Territory object
public with sharing class AccountBillingPostalCodeUpdateHelper {
 
    public static void triggerHelper(List<Account> triggerList, Map<Id, Account> oldList){
        List<Account> aux = new List<Account>();
        Map<Id, Account> oldRecords = new Map<Id,Account>();

        for (Account acc : triggerList){
            if (acc.BillingPostalCode != oldList.get(acc.Id).BillingPostalCode){
                aux.add(acc);
                oldRecords.put(acc.Id, oldList.get(acc.Id));
            }
        }

        if(aux.size()>0) {
            accountOwnerUpdate(aux);
            AssignmentHistoryCreation.assignmentHistoryCreationAccountUpdate(aux, oldRecords);
        }
    }
     
    public static void accountOwnerUpdate(List<Account> accList){
        for(Account acc : accList){
            if(isThereTerritoy(acc)){
                acc.OwnerId = getOwnerByZip(acc.BillingPostalCode);
                
                contactOwnerUpdate(acc);

                opportunityOwnerUpdate(acc);

                AccountUpdateMail.emailUpdate(acc);
                
            }
        }
    }

    public static void opportunityOwnerUpdate (Account acc){
        List<Opportunity> toUpdate = new List<Opportunity>();

        for(Opportunity opp : getOppListByAccount(acc)){
            opp.OwnerId = getOwnerByZip(acc.BillingPostalCode);
            toUpdate.add(opp);
        }
        update toUpdate;
    }

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

    private static List<Contact> getContactByAcc(Account acc){
        return [SELECT Id, Name FROM Contact where Account.Id =: acc.Id];
    }

    //Requirement #3
    private static Id getOwnerByZip(String zipCode){
        List<Territory__c> aux = [Select Id, Owner__c, Zip_Code__c From Territory__c where Zip_Code__c =: zipCode];
       
        Integer randomNumber = Integer.valueof((Math.random() * aux.size()));

        return aux[randomNumber].Owner__c;
    }

    private static Boolean isThereTerritoy(Account acc){
        return [Select Zip_Code__c from Territory__c where Zip_Code__c =: acc.BillingPostalCode].size() > 0;
    }  
}