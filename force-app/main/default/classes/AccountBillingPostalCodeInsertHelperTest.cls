@isTest
public with sharing class AccountBillingPostalCodeInsertHelperTest {

    public static final User user = [select Id from User where name = 'Daniel San' limit 1 ];
    public static final String postalCodeTer = '1234';

    @TestSetup
    static void makeData(){

        Territory__c ter = new Territory__c();
        ter.Owner__c = user.Id;
        ter.Zip_Code__c = postalCodeTer;
        insert ter;  

    }

    @isTest
    public static void accountBillingPostalCodeInsertHelperTest() {

        Account acc = new Account();
        acc.Name = 'test';
        acc.BillingPostalCode = postalCodeTer;
        
        List<Account> accList = new List<Account>();
        accList.add(acc);
        insert accList;

        AccountBillingPostalCodeInsertHelper.triggerHelper(accList);
        Boolean isThereTerritoy = AccountBillingPostalCodeInsertHelper.isThereTerritoy(acc);
        Id getOwnerByZip = AccountBillingPostalCodeInsertHelper.getOwnerByZip(postalCodeTer);

        System.assertEquals(acc.OwnerId, user.Id);
        System.assertEquals(isThereTerritoy, true);
        System.assertEquals(getOwnerByZip, user.Id);
        
    }
}
