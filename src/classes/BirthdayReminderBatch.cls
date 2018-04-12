global class BirthdayReminderBatch implements Database.Batchable<sObject> {
    
    public Date today;
    public String myEmailAddress = 'cherihtodaytime@163.com';//这里的邮箱最好不写QQ邮箱地址，某些情况下Salesforce平台给QQ邮箱发送的邮件收不到

    global BirthdayReminderBatch() {
        today = Date.today();
        System.debug('today:' + today);
    }
    
    global List<Student__c> start(Database.BatchableContext BC) {
       //remainder__c:生日提醒是作为一个辅助字段存在，用公式来快速定位时间，避免在类中操作
        List<Student__c> list_con = new List<Student__c>([select Name from Student__c where remainder__c =: today]);
        return list_con;
    }

    global void execute(Database.BatchableContext BC, List<Student__c> scope) {
        System.debug('*****execute_contact*****' + scope);

            //发送邮件
        for(Student__c fri : scope){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

            email.setToAddresses(new String[]{myEmailAddress});
            
            email.setSubject('生日提醒');
            email.setHtmlBody('您好，' + fri.Name + '的生日还有三天，请做好相关准备!');

            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        }   
            
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }   
}