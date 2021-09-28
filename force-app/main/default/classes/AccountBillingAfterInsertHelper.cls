public with sharing class AccountBillingAfterInsertHelper {
    public static void triggerHelper(List<Account> triggerList){
        for(Account acc : triggerList){
            if(acc.BillingPostalCode != null){
                AssignmentHistoryCreation.assignmentHistoryCreationAccountInsert(acc);
            }
        }
    }
}