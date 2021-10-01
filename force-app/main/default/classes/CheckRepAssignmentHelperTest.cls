@isTest
public with sharing class CheckRepAssignmentHelperTest {

    public static final User userOne = [select Id from User where name = 'Daniel San' limit 1 ];
    public static final User userTwo = [select Id from User where name = 'Santiago Fabre' limit 1 ];

    public static final String postalCodeTerOne = '1234';
    public static final String postalCodeTerTwo = '5678';
   

    @TestSetup
    static void makeData(){
        List<Territory__c> testTerList = new List<Territory__c>();
        for(Integer i=0; i<=2; i++){
            Territory__c ter = new Territory__c();
            ter.Owner__c = userOne.id;
            ter.Zip_Code__c = postalCodeTerOne;
            testTerList.add(ter);
        }
        insert testTerList;
    }
    @isTest
    public static void checkRepAssignmentHelperTest() {
        List<Territory__c> testTerList = [select Owner__c, Zip_Code__c from Territory__c where Zip_Code__c =: postalCodeTerOne];

        Territory__c ter = new Territory__c();
        ter.Owner__c = userTwo.Id;
        ter.Zip_Code__c = postalCodeTerOne;

        Test.startTest();
        try{
        insert ter;

        } catch (DmlException e){
            String message = e.getMessage();
            System.assert(message.contains('There are three or more Sales Rep for this Zip Code'));

        }
        Test.stopTest();
    }

    @isTest
    public static void checkRepAssignmentHelperUpdateTest() {
        List<Territory__c> testTerList = [select Owner__c, Zip_Code__c from Territory__c where Zip_Code__c =: postalCodeTerOne];

        Territory__c ter = new Territory__c();
        ter.Owner__c = userTwo.Id;
        ter.Zip_Code__c = postalCodeTerTwo;
        insert ter;

        Test.startTest();
        try{

        ter.Zip_Code__c = postalCodeTerOne;

        update ter;

        } catch (DmlException e){
            String message = e.getMessage();
            System.assert(message.contains('There are three or more Sales Rep for this Zip Code'));

        }
        Test.stopTest();
    }

    @isTest
    public static void checkRepAssignmentHelperOtherMethods() {
        Boolean moreThanTheree = CheckRepAssignmentHelper.moreThanTheree(postalCodeTerOne);

        System.assertEquals(true, moreThanTheree);
    }
}
