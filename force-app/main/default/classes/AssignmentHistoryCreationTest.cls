@isTest
public with sharing class AssignmentHistoryCreationTest {
    @TestSetup
    static void makeData(){
        
        
        Account acc = new Account();
        acc.Name = 'TestHistory' ;
        acc.BillingPostalCode = '12345';
        insert acc;

        Territory__c ter = new Territory__c();
        ter.Zip_Code__c = '91001';
        ter.Owner__c = '0055f000000oz39AAA';
        insert ter;

        Territory__c terTwo = new Territory__c();
        ter.Zip_Code__c = '92020';
        ter.Owner__c = '0055f000000oz39AAA';
        insert terTwo;

        Account accWithTer = new Account();
        accWithTer.Name = 'TestWithTerHistory' ;
        accWithTer.BillingPostalCode = '91001';
        insert accWithTer;
    }
    @isTest
    public static void assignmentHistoryCreationTest() {
        Account testAcc = [select Id, Name, BillingPostalCode from Account where Name = 'TestHistory' limit 1];
        testAcc.BillingPostalCode = '91000';

        Account testAccWithTer =  [select Id, Name, BillingPostalCode from Account where Name = 'TestWithTerHistory' limit 1];
        testAccWithTer.BillingPostalCode= '91000';
    
        update testAcc;
        update testAccWithTer;

        testAccWithTer.BillingPostalCode= '92020';
        update testAccWithTer;


        Assignment_History__c testNoPreOwner = [select Name, Account__c, Changed_By__c, CreatedById, New_Owner__c,
        New_Territory__c,Previous_Owner__c,Previous_Territory__c from Assignment_History__c where Name = 'TestHistory History' limit 1];
        
        Assignment_History__c testWithPreOwner = [select Name, Account__c, Changed_By__c, CreatedById, New_Owner__c,
        New_Territory__c,Previous_Owner__c,Previous_Territory__c from Assignment_History__c where Name = 'TestWithTerHistory History' limit 1];

        System.assertEquals(testNoPreOwner.Account__c, testAcc.Id);
        System.assertEquals(testWithPreOwner.Account__c, testAccWithTer.Id);

    }

    @isTest
    public static void assignmentHistoryCreationAccUpdateTest() {
        Account testAccWithTer =  [select Id, Name, BillingPostalCode from Account where Name = 'TestWithTerHistory' limit 1];
        testAccWithTer.BillingPostalCode= '92020';
        update testAccWithTer;
    }
}
