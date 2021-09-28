@isTest
public with sharing class AccountBillingPostalCodeUpdateTest {
    @TestSetup
    static void makeData(){
        
        Account acc = new Account();
        acc.Name = 'TestUpdateCode' ;
        acc.BillingPostalCode = '12345';
        acc.OwnerId = '0055f000000oz3EAAQ';
        insert acc;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.newInstance(2021, 12, 24);
        opp.StageName = 'Prospecting';
        insert opp;

        Contact con = new Contact();
        con.OwnerId = '0055f000000oz3EAAQ';
        con.AccountId = acc.Id;
        con.LastName = 'Test';
        con.Email = 'test@test.com';
        insert con;

        Territory__c ter = new Territory__c();
        ter.Owner__c = '0055f000000oz39AAA';
        ter.Zip_Code__c = '92010';
        insert ter;  
    }
    @isTest
    public static void accountBillingPostalCodeUpdateTest() {
        Test.startTest();
        Account acc = [select Name, BillingPostalCode, OwnerId from Account where Name = 'TestUpdateCode' limit 1];
        acc.BillingPostalCode = '92010';
        update acc;
        Test.stopTest();
        System.assertEquals(acc.OwnerId,  '0055f000000oz3EAAQ');
    }
}
