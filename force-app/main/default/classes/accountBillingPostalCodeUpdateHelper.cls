// When an Account’s BillingPostalCode (aka Zip Code), is changed, 
// A)Change the Account Owner to the sales representative assigned to the new zip code
// B)Change the Owner field of all the Account’s Contacts to the same sales rep 
// C)Change the Owner field of all the Account’s Open Opportunities to the same sales rep

public with sharing class accountBillingPostalCodeUpdateHelper {
    public void accBillPsCodeUpdate(List<Account> lista){
        
        Account acc = lista[0];
        List<Territory__c> salesReps = [Select Id, Name, Zip_Code__c From Territory__c where Zip_Code__c =: acc.BillingPostalCode];
        List<Account> contactList = [select (select Id, Name from Contacts) from account where id =: acc.id];
        List<Account> oppList = [select (select Id, Name from Opportunity where (StageName !='Closed Won' && StageName !='Closed Lost') from account where id =: acc.id];

        Id salesrepId = salesReps[0].id;

        if(salesReps.length()>0){
            acc.Owner = salesrepId;
            for(Account con : contactList){
                con.Contact.Id = salesrepId;
            }
            if(oppList.length()>0){
                for(Account opp: oppList){
                    opp.Opportunity.OwnerId = salesrepId;
                }
            }
        }
    }
}
