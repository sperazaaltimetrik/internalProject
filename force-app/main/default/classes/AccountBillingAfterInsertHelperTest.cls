@isTest
public with sharing class AccountBillingAfterInsertHelperTest {
    @TestSetup
    static void makeData(){
        List<Territory__c> testTerList = new List<Territory__c>();
        for(Integer i=0; i<=2; i++){
            Territory__c ter = new Territory__c();
            ter.Owner__c = '0055f000000oz39AAA';
            ter.Zip_Code__c = '92010';
            testTerList.add(ter);
        }
        insert testTerList;
    }
    @isTest   
    public static void accountBillingAfterInsertHelperTest() {
        Account acc = new Account();
        acc.Name = 'test';
        acc.BillingPostalCode = '92010';
        insert acc;

        System.assertEquals(acc.OwnerId, null);
    }
}
