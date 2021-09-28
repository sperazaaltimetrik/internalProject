@isTest
public with sharing class AccountBillingPostalCodeInsertHelperTest {
    @TestSetup
    static void makeData(){
        Territory__c ter = new Territory__c();
        ter.Owner__c = '0055f000000oz39AAA';
        ter.Zip_Code__c = '92010';
        insert ter;  
    }
    @isTest
    public static void accountBillingPostalCodeInsertHelperTest() {
        Account acc = new Account();
        acc.Name = 'test';
        acc.BillingPostalCode = '92010';
        insert acc;
    }
}
