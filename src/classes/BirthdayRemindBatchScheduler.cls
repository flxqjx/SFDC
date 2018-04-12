global class BirthdayRemindBatchScheduler implements Schedulable{
    global void execute(SchedulableContext SC){
        Database.executeBatch(new BirthdayReminderBatch(),200);
    }
}