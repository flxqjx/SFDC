public with sharing class FutureSample {
     @future
    public static void futuremethod(List<ID> ids) {
        String sql = 'SELECT ID,Name,Education__c,Sex__c,ScoreID__r.Score__c ,ScoreID__r.Name  FROM  Student__c where Id in :ids';
        List<Student__c> students = Database.query(sql);
        for(Student__c student : students) {
            System.debug(student.Id);
        }
    }
}