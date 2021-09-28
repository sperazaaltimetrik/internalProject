@isTest
public with sharing class SalesRepresentativeChangeHelperTest {
    @TestSetup
    static void makeData(){
        Territory__c ter = new Territory__c();
        ter.Name = 'testTerChange';
        ter.Owner__c = '0055f000000oz39AAA';
        ter.Zip_Code__c = '92010';
        insert ter;  

        Account acc = new Account();
        acc.Name= 'Test';
        acc.OwnerId = '0055f000000oz39AAA';
        acc.BillingPostalCode = '92010';
        insert acc;
    }
    @isTest
    public static void salesRepresentativeChangeHelperTest() {
        Territory__c ter = [select Owner__c, Zip_Code__c from Territory__c where Name = 'testTerChange' limit 1];
        ter.Owner__c ='0055f000000oz3EAAQ';
        update ter;        
    }
}
