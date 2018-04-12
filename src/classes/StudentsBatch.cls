global with sharing class StudentsBatch implements Database.Batchable<sObject>,Database.Stateful{
    Integer queryCount = 0;
    
    String myEmailAddress = 'cherishtodaytime@163.com';
    
    global Database.QueryLocator start(database.BatchableContext bc )
    {
        String query = 'SELECT   Name,Education__c,Sex__c  FROM  Student__c';
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc, List<Student__c> students)
    {
        for(Student__c student : students) {
            student.Name='qjx'+queryCount;
            queryCount +=1;
        }
        upsert students;
    }
    
    global void finish(Database.BatchableContext bc)
    {
        /*--------execute finish----------*/
        /*注意：如果不实现Database.Stateful接口，则queryCount为0
              因为在execute执行完成便会回滚到初始状态*/
        System.debug('query count:' + queryCount);
        //send email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{myEmailAddress});//set mail getter
        email.setSubject('show count'); //set subject
        email.setHtmlBody('query Count:' + queryCount);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
}
/*
StudentsBatch studentsBatch = new StudentsBatch();
Id batchId = Database.executeBatch(studentsBatch);
*/