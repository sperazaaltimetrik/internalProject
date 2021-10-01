public with sharing class CheckRepAssignmentHelper {
    
    public static void triggerHelper(List<Territory__c> triggerList, Map<Id, Territory__c> oldList){
        
        for (Territory__c ter : triggerList){
            if (ter.Zip_Code__c != oldList.get(ter.Id).Zip_Code__c){
                if(moreThanTheree(ter.Zip_Code__c)){
                    ter.addError('There are three or more Sales Rep for this Zip Code');
                }
            }
        }
    }

    public static void beforeInsertHelper(List<Territory__c> triggerList){
        for (Territory__c ter : triggerList){
            if(moreThanTheree(ter.Zip_Code__c)){
                ter.addError('There are three or more Sales Rep for this Zip Code');
            }
        }
    }

    public static Boolean moreThanTheree(String zipCode){
        Integer ret = 0;
        List<Territory__c> terList =  [Select id, Zip_Code__c from Territory__c];

        for(Territory__c ter : terList){
            if(ter.Zip_Code__c == zipCode) ret++;
        }
        if(ret >= 3) return true;
        return false;
    }
}