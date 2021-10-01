@isTest
public with sharing class AccountBillingPostalCodeUpdateTest {

    public static final User userOne = [select id from user where Name = 'Ben Affleck' limit 1];
    public static final User userTwo = [select id from user where Name = 'Daniel San' limit 1];

    public static final String PostalCodeWithTer = '1234';
    public static final String PostalCodeNoTer = '4321';

    
    @TestSetup
    static void makeData(){

        Account acc = new Account();
        acc.Name = 'TestUpdateCode' ;
        acc.BillingPostalCode = PostalCodeNoTer;
        acc.OwnerId = userOne.Id;
        insert acc;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp triger';
        opp.OwnerId = userOne.Id;
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.newInstance(2021, 12, 24);
        opp.StageName = 'Prospecting';
        insert opp;

        Contact con = new Contact();
        con.OwnerId = userOne.Id;
        con.AccountId = acc.Id;
        con.LastName = 'Test ConTrigger';
        con.Email = 'test@test.com';
        insert con;

        Territory__c ter = new Territory__c();
        ter.Owner__c = userTwo.Id;
        ter.Zip_Code__c = PostalCodeWithTer;
        insert ter;  
    }

    @isTest
    public static void accountBillingPostalCodeUpdateTest() {
        Test.startTest();
        
        List<Account> accList = new List<Account>();
        Map<Id, Account> oldAccountMap = new Map<Id,Account>();

        Account acc = [select Id,Name, BillingPostalCode, OwnerId, LastModifiedById from Account where Name = 'TestUpdateCode' limit 1];
        
        oldAccountMap.put(acc.Id, acc);
        
        acc.BillingPostalCode = PostalCodeWithTer;
        update acc;
        accList.add(acc);

        

        AccountBillingPostalCodeUpdateHelper.accountOwnerUpdate(accList, oldAccountMap);
        AccountBillingPostalCodeUpdateHelper.contactOwnerUpdate(acc);
        AccountBillingPostalCodeUpdateHelper.opportunityOwnerUpdate(acc);

        List<Opportunity> oppListTest = AccountBillingPostalCodeUpdateHelper.getOppListByAccount(acc);
        List<Contact> conListTest =AccountBillingPostalCodeUpdateHelper.getContactByAcc(acc);
        Id idTest = AccountBillingPostalCodeUpdateHelper.getOwnerByZip(PostalCodeWithTer);
        Boolean boolTest = AccountBillingPostalCodeUpdateHelper.isThereTerritoy(acc);

        Opportunity opp = [select OwnerId from Opportunity where Name ='Test opp triger' limit 1];
        Contact con = [select OwnerId from Contact where LastName = 'Test ConTrigger' limit 1];
        

        Test.stopTest();
        


        System.assertEquals(acc.OwnerId,  userTwo.Id);
        System.assertEquals(opp.OwnerId,  userTwo.Id);
        System.assertEquals(con.OwnerId,  userTwo.Id);
        System.assertEquals(acc.OwnerId,  userTwo.Id);

        System.assertEquals(oppListTest[0].OwnerId, userTwo.Id);
        System.assertEquals(conListTest[0].OwnerId, userTwo.Id);
        System.assertEquals(idTest, userTwo.Id);
        System.assertEquals(boolTest, true);


    }
}
