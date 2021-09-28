@isTest
public with sharing class MidnightCheckTest {
    @TestSetup
    static void makeData(){
        Account acc = new Account();
        acc.Name = 'Test Midnight';
        acc.OwnerId = '0055f000000ogTPAAY';
        acc.BillingPostalCode = '92010';
        insert acc;
        
        Territory__c ter = new Territory__c();
        ter.Owner__c = '0055f000000ogTPAAY';
        ter.Zip_Code__c = '12345';
        insert ter;
    }
    @isTest
    public static void midnightCheckTest() {
        Test.startTest();
        Account testAcc = [select Name, OwnerId, BillingPostalCode from Account where Name = 'Test Midnight' limit 1];
        testAcc.OwnerId =  '0055f000000oz3EAAQ';
        update testAcc;

        MidnightCheck.getOwnerByZip('12345');

        SchedulableContext sc = null;
        MidnightCheck tsc = new MidnightCheck();
        tsc.execute(sc);

        Test.stopTest();
    }
}
