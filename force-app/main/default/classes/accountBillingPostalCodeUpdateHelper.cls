// When an Account’s BillingPostalCode (aka Zip Code), is changed, 
// A)Change the Account Owner to the sales representative assigned to the new zip code
// B)Change the Owner field of all the Account’s Contacts to the same sales rep 
// C)Change the Owner field of all the Account’s Open Opportunities to the same sales rep

public with sharing class accountBillingPostalCodeUpdateHelper {
    public static void accBillPsCodeUpdate(List<Account> lista){
        
        Account acc = lista[0];
        List<Territory__c> salesReps = [Select Id, Name, Zip_Code__c From Territory__c where Zip_Code__c =: acc.BillingPostalCode];
        List<Contact> contactList = [select  Id, Name from Contact  where AccountId =: acc.id];
        List<Opportunity> oppList = [select Id, Name from Opportunity where (AccountId =: acc.id AND StageName !='Closed Won' AND StageName !='Closed Lost')];

        Id salesrepId = salesReps[0].Owner__c;

        if(salesReps.size() >0 ){
            acc.Owner.Id = salesrepId;
            for(Contact con : contactList){
                con.Id = salesrepId;
            }
            if(oppList.size()>0){
                for(Opportunity opp: oppList){
                    opp.OwnerId = salesrepId;
                }
            }
        }
    }
}
