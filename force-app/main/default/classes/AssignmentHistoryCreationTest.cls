@isTest
public with sharing class AssignmentHistoryCreationTest {

    public static final User userOne = [select Id from User where name = 'Daniel San' limit 1 ];
    public static final User userTwo = [select Id from User where name = 'Santiago Fabre' limit 1 ];
    public static final User userThree = [select Id from User where name = 'Ben Affleck' limit 1 ];

    public static final String postalCodeNoTer = '123';
    public static final String postalCodeTerOne = '1234';
    public static final String postalCodeTerTwo = '5678';
    public static final String postalCodeTerThree = '1357';


    @TestSetup
    static void makeData(){

        Account accNoTer = new Account();
        accNoTer.Name = 'TestNoTerHistory' ;
        accNoTer.BillingPostalCode = postalCodeNoTer;
        accNoTer.OwnerId = userThree.Id;
        insert accNoTer;

        Territory__c terOne = new Territory__c();
        terOne.Zip_Code__c = postalCodeTerOne;
        terOne.Owner__c = userOne.Id;
        insert terOne;

        Account accWithTer = new Account();
        accWithTer.Name = 'TestWithTerHistory' ;
        accWithTer.BillingPostalCode = postalCodeTerOne;
        accWithTer.OwnerId = userOne.Id;
        insert accWithTer;

        Account accWithTerTwo = new Account();
        accWithTerTwo.Name = 'TestWithTerTwoHistory' ;
        accWithTerTwo.BillingPostalCode = postalCodeTerTwo;
        accWithTerTwo.OwnerId = userTwo.Id;
        insert accWithTerTwo;

        Territory__c terTwo = new Territory__c();
        terTwo.Zip_Code__c = postalCodeTerTwo;
        terTwo.Owner__c = userTwo.Id;
        insert terTwo;

        Territory__c terThree = new Territory__c();
        terThree.Zip_Code__c = postalCodeTerThree;
        terThree.Owner__c = userThree.Id;
        insert terThree;

        
    }
    @isTest
    public static void assignmentHistoryCreationTest() {

        Territory__c terOne = [select Id from Territory__c where Owner__c =: userOne.Id];
        Territory__c terTwo = [select Id from Territory__c where Owner__c =: userTwo.Id];


        Test.startTest();

        Account testAccNoTer = [select Id, Name, OwnerId, BillingPostalCode from Account where Name = 'TestNoTerHistory' limit 1];
        testAccNoTer.BillingPostalCode = postalCodeNoTer;

        Account testAccWithTer =  [select Id, Name, OwnerId, BillingPostalCode from Account where Name = 'TestWithTerHistory' limit 1];
        testAccWithTer.BillingPostalCode= postalCodeTerTwo;

        update testAccNoTer;
        update testAccWithTer;

        Test.stopTest();
        
        //Get the new Assignment History created.
        Assignment_History__c AsHisNoPreOwner = [select Name, Account__c, New_Owner__c, New_Territory__c,Previous_Owner__c,Previous_Territory__c 
        from Assignment_History__c where Name = 'TestNoTerHistory History' limit 1];
        
        Assignment_History__c AsHisWithPreOwner = [select Name, Account__c,  New_Owner__c, New_Territory__c,Previous_Owner__c,Previous_Territory__c 
        from Assignment_History__c where Name = 'TestWithTerHistory History' limit 1];


        // Assert Assignment History are correct;
        System.assertEquals(testAccNoTer.Id, AsHisNoPreOwner.Account__c);
        System.assertEquals(userThree.Id, AsHisNoPreOwner.New_Owner__c);
        System.assertEquals(null, AsHisNoPreOwner.New_Territory__c);
        System.assertEquals(null, AsHisNoPreOwner.Previous_Owner__c);
        System.assertEquals(null, AsHisNoPreOwner.Previous_Territory__c);

        System.assertEquals(testAccWithTer.Id, AsHisWithPreOwner.Account__c);
        System.assertEquals(userTwo.Id, AsHisWithPreOwner.New_Owner__c);
        System.assertEquals(terTwo.Id, AsHisWithPreOwner.New_Territory__c);
        System.assertEquals(userOne.Id, AsHisWithPreOwner.Previous_Owner__c);
        System.assertEquals(terOne.Id, AsHisWithPreOwner.Previous_Territory__c);

    }

    @isTest
    public static void assignmentHistoryCreationAccUpdateTest() {

        Territory__c terOne = [select Id from Territory__c where Owner__c =: userOne.Id];
        Territory__c terTwo = [select Id from Territory__c where Owner__c =: userTwo.Id];

        Test.startTest();

        Account testAccWithTer =  [select Id, Name, OwnerId, BillingPostalCode from Account where Name = 'TestWithTerTwoHistory' limit 1];

        testAccWithTer.BillingPostalCode = postalCodeTerThree;

        update testAccWithTer;

        Test.stopTest();

        //Get the new Assignment History created.
        Assignment_History__c AsHisWithPreOwner = [select Name, Account__c, New_Owner__c,New_Territory__c, Previous_Owner__c, Previous_Territory__c 
        from Assignment_History__c where Name = 'TestWithTerTwoHistory History' limit 1];

        
        // Assert Assignment History are correct;
        System.assertEquals(testAccWithTer.Id, AsHisWithPreOwner.Account__c);
        System.assertEquals(userThree.Id, AsHisWithPreOwner.New_Owner__c);
        System.assertEquals(terTwo.Id, AsHisWithPreOwner.New_Territory__c);
        System.assertEquals(userOne.Id, AsHisWithPreOwner.Previous_Owner__c);
        System.assertEquals(terOne.Id, AsHisWithPreOwner.Previous_Territory__c);
    }

    @isTest
    public static void assignmentHistoryOtherMethodTest() {
        Account acc = [select Id, Name, OwnerId, BillingPostalCode from Account where Name = 'TestWithTerHistory' limit 1];
        Territory__c terOne = [select Id from Territory__c where Owner__c =: userOne.Id];
        
        Boolean isTerritoryByAccount = AssignmentHistoryCreation.isTerritoryByAccount(acc);
        Id getTerritoryByAccount =  AssignmentHistoryCreation.getTerritoryByAccount(acc); 

        System.assertEquals(true, isTerritoryByAccount);
        System.assertEquals(terOne.Id, getTerritoryByAccount);

    }
}
