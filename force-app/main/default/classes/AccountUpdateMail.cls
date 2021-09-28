public with sharing class AccountUpdateMail {
    public static void emailUpdate(Account acc){

        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();

        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        List<String> sendTo = getAddreses(acc);

        Assignment_History__c check = [select New_Owner__c, Previous_Owner__c from Assignment_History__c where Account__c =:acc.Id limit 1];

        if(check.Previous_Owner__c == null){
            mail.setToAddresses(sendTo);
            mail.setSubject('Account owner updated');
            String body = 'The account owner has been updated to ' + getNameById(acc.OwnerId);
            mail.setHtmlBody(body);
        } else{
       
            mail.setToAddresses(sendTo);
            mail.setSubject('Account owner updated');
            String body = 'The account owner has been updated from ' + getNameById(check.Previous_Owner__c) + ' to ' + getNameById(acc.OwnerId);
            mail.setHtmlBody(body);
        }
        mails.add(mail);
        Messaging.sendEmail(mails);
        }
    
    @TestVisible
    private static List<String> getAddreses(Account acc){
        Assignment_History__c check = [select New_Owner__c, Previous_Owner__c from Assignment_History__c where Account__c =:acc.Id limit 1];
        List<String> retorno = new List<String>();

        if(check.New_Owner__c != null){
            Id userId = check.New_Owner__c;
            User userEmail = [select Email from User where Id =: userId limit 1]; 
            retorno.add(userEmail.Email);
        }
        if(check.Previous_Owner__c != null){
            Id preUserId = check.Previous_Owner__c;
            User preUserEmail = [select Email from User where Id =: preUserId limit 1]; 
            retorno.add(preUserEmail.Email);
        }

        return retorno;
    }

    @TestVisible
    private static String getNameById(Id checkId){
        User u = [select Id, Name  from user where Id =: checkId limit 1];
        String name = u.Name;
        return name;
    }
    
}
