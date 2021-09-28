@IsTest
public with sharing class AccountUpdateMailTest {
    @isTest
    public static void accountUpdateMailTest() {
        Account acc = new Account();
        acc.Name = 'TestEmail';
        acc.OwnerId = '0055f000000ogTPAAY';
        insert acc;

        Territory__c terNew = new Territory__c();
        terNew.Owner__c = '0055f000000ogTPAAY';
        terNew.Zip_Code__c = '123412';
        insert terNew;

        Territory__c terOld = new Territory__c();
        terOld.Owner__c = '0055f000000ogTPAAY';
        terOld.Zip_Code__c = '54321';
        insert terOld;

        Assignment_History__c assignHis = new Assignment_History__c();
        assignHis.New_Owner__c = '0055f000000ogTPAAY';
        assignHis.Previous_Owner__c = '0055f000000oz39AAA';
        assignHis.Name = 'Test assign';
        assignHis.New_Territory__c = terNew.Id;
        assignHis.Previous_Territory__c = terOld.Id;
        assignHis.Account__c = acc.Id;
        insert assignHis;

        Test.startTest();
        AccountUpdateMail.emailUpdate(acc);
        
        System.assertEquals(AccountUpdateMail.getNameById('0055f000000ogTPAAY'),'Santiago Fabre');

        AccountUpdateMail.getAddreses(acc);
        
        Test.stopTest();
    }
}
