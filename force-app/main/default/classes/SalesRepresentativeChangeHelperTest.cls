@isTest
public with sharing class SalesRepresentativeChangeHelperTest {

    public static final User userOne = [select Id from User where name = 'Daniel San' limit 1 ];
    public static final User userTwo = [select Id from User where name = 'Santiago Fabre' limit 1 ];

    public static final String postalCodeTer = '1234';

    @TestSetup
    static void makeData(){

        Territory__c ter = new Territory__c();
        ter.Name = 'testTerChange';
        ter.Owner__c = userOne.Id;
        ter.Zip_Code__c = postalCodeTer;
        insert ter;  

        Account acc = new Account();
        acc.Name= 'Test';
        acc.OwnerId = userOne.Id;
        acc.BillingPostalCode = postalCodeTer;
        insert acc;

    }

    @isTest
    public static void salesRepresentativeChangeHelperTest() {
        
        Territory__c ter = [select Owner__c, Zip_Code__c from Territory__c where Name = 'testTerChange' limit 1];

        Test.startTest();

        ter.Owner__c =userTwo.Id;
        update ter;      
        
        Test.stopTest();

        Account acc = [select OwnerId, Name from Account where name = 'Test' limit 1];

        System.assertEquals(userTwo.Id, acc.OwnerId);

    }

    @isTest
    public static void salesRepresentativeChangeHelperOtherMethod() {

        Territory__c ter = [select Owner__c, Zip_Code__c from Territory__c where Name = 'testTerChange' limit 1];
        Account acc = [select OwnerId, Name from Account where name = 'Test' limit 1];

        Test.startTest();

        List<Account> getAccountListbyTerritory = SalesRepresentativeChangeHelper.getAccountListbyTerritory(ter);

        Test.stopTest();

        System.assertEquals(acc.Id, getAccountListbyTerritory[0].Id);
        
    }
}
