@IsTest
public with sharing class AccountUpdateMailTest {

    public static final User userOne = [select Id, Name, Email from User where name = 'Daniel San' limit 1 ];
    public static final User userTwo = [select Id, Name, Email from User where name = 'Santiago Fabre' limit 1 ];

    public static final String postalCodeTerOne = '1234';
    public static final String postalCodeTerTwo = '5678';

    @TestSetup
    static void makeData(){

        Account acc = new Account();
        acc.Name = 'TestAccForEmail';
        acc.OwnerId = userOne.Id;
        insert acc;

        Territory__c terNew = new Territory__c();
        terNew.Owner__c = userOne.Id;
        terNew.Zip_Code__c = postalCodeTerOne;
        insert terNew;

        Territory__c terOld = new Territory__c();
        terOld.Owner__c = userOne.Id;
        terOld.Zip_Code__c = postalCodeTerTwo;
        insert terOld;

        Assignment_History__c assignHis = new Assignment_History__c();
        assignHis.New_Owner__c = userOne.Id;
        assignHis.Previous_Owner__c = userTwo.Id;
        assignHis.Name = 'Test assign';
        assignHis.New_Territory__c = terNew.Id;
        assignHis.Previous_Territory__c = terOld.Id;
        assignHis.Account__c = acc.Id;
        insert assignHis;
    }

    @isTest
    public static void accountUpdateMailTest() {
        Account acc = [select Id, Name, OwnerId from Account where Name = 'TestAccForEmail' limit 1];

        Test.startTest();

        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');
        AccountUpdateMail.emailUpdate(acc);
        System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');
        
        List<String> addressListTest = AccountUpdateMail.getAddreses(acc);
        String nameTest = AccountUpdateMail.getNameById(userTwo.Id);

        Test.stopTest();

        System.assertEquals(addressListTest[0], userTwo.Email);
        System.assertEquals(nameTest, userTwo.Name);
    }
}
