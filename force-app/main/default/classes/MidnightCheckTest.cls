@isTest
public with sharing class MidnightCheckTest {

    public static final User userOne = [select Id from User where name = 'Daniel San' limit 1 ];
    public static final User userTwo = [select Id from User where name = 'Santiago Fabre' limit 1 ];

    public static final String postalCodeNoTer = '1234';
    public static final String postalCodeTer = '5678';


    @TestSetup
    static void makeData(){

        Account acc = new Account();
        acc.Name = 'Test Midnight';
        acc.OwnerId = userOne.Id;
        acc.BillingPostalCode = postalCodeNoTer;
        insert acc;
        
        Territory__c ter = new Territory__c();
        ter.Owner__c = userOne.Id;
        ter.Zip_Code__c = postalCodeTer;
        insert ter;

    }

    @isTest
    public static void midnightCheckTest() {

        Territory__c ter = [select Id from Territory__c where Owner__c =: userOne.Id];
        Account testAcc = [select Name, OwnerId, BillingPostalCode from Account where Name = 'Test Midnight' limit 1];


        Test.startTest();

        testAcc.OwnerId =  userTwo.Id;
        
        update testAcc;

        Id getOwnerByZip = MidnightCheck.getOwnerByZip(postalCodeTer);

        SchedulableContext sc = null;
        MidnightCheck tsc = new MidnightCheck();
        tsc.execute(sc);

        Test.stopTest();


        System.assertEquals(userOne.Id, getOwnerByZip);

    }
}
