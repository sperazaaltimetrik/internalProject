@isTest
public with sharing class AccountBillingAfterInsertHelperTest {

    public static final User userOne = [select Id from User where name = 'Daniel San' limit 1 ];
    public static final String postalCodeTer = '1234';
    
    @TestSetup
    static void makeData(){
     
        Territory__c terOne = new Territory__c();
        terOne.Zip_Code__c = postalCodeTer;
        terOne.Owner__c = userOne.Id;
        insert terOne;

    }

    @isTest   
    public static void accountBillingAfterInsertHelperTest() {
        
        Territory__c ter = [select Id from Territory__c where Owner__c =: userOne.Id];

        Account acc = new Account();
        acc.Name = 'test';
        acc.BillingPostalCode = postalCodeTer;
        
        List<Account> accList = new List<Account>();
        accList.add(acc); 
        insert accList; 

        AccountBillingAfterInsertHelper.triggerHelper(accList);
        
        Assignment_History__c AsHisCreation = [select Name, Account__c, New_Owner__c, New_Territory__c,Previous_Owner__c,Previous_Territory__c 
        from Assignment_History__c where Name = 'test History' limit 1];

        System.assertEquals(acc.Id, AsHisCreation.Account__c);
        System.assertEquals(userOne.Id, AsHisCreation.New_Owner__c);
        System.assertEquals(ter.Id, AsHisCreation.New_Territory__c);
        System.assertEquals(null, AsHisCreation.Previous_Owner__c);
        System.assertEquals(null, AsHisCreation.Previous_Territory__c);

    }
}
