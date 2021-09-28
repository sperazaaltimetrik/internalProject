@isTest
public with sharing class CheckRepAssignmentHelperTest {
    @TestSetup
    static void makeData(){
        List<Territory__c> testTerList = new List<Territory__c>();
        for(Integer i=0; i<=2; i++){
            Territory__c ter = new Territory__c();
            ter.Owner__c = '0055f000000oz39AAA';
            ter.Zip_Code__c = '92010';
            testTerList.add(ter);
        }
        insert testTerList;
    }
    @isTest
    public static void checkRepAssignmentHelperTest() {
        List<Territory__c> testTerList = [select Owner__c, Zip_Code__c from Territory__c where Zip_Code__c = '92010'];

        Territory__c ter = new Territory__c();
        ter.Owner__c = '0055f000000oz2LAAQ';
        ter.Zip_Code__c = '92010';

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
        List<Territory__c> testTerList = [select Owner__c, Zip_Code__c from Territory__c where Zip_Code__c = '92010'];

        Territory__c ter = new Territory__c();
        ter.Owner__c = '0055f000000oz2LAAQ';
        ter.Zip_Code__c = '92023';
        insert ter;

        Test.startTest();
        try{
        ter.Zip_Code__c='92010';

        update ter;

        } catch (DmlException e){
            String message = e.getMessage();
            System.assert(message.contains('There are three or more Sales Rep for this Zip Code'));

        }
        Test.stopTest();
    }
}
