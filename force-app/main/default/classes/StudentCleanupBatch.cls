public with sharing class StudentCleanupBatch implements Database.Batchable<SObject> 
{
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Name, Status__c FROM Student__c WHERE Status__c = 'Dropped']);
    }

    public void execute(Database.BatchableContext bc, List<Student__c> scope) {
        List<Student__c> studentsToUpdate = new List<Student__c>();

        for(Student__c s : scope) {
            if(!s.Name.contains('[NGHỈ HỌC] - ')) {
                s.Name = '[NGHỈ HỌC] - ' + s.Name;
                studentsToUpdate.add(s);
            }
        }
        if(!studentsToUpdate.isEmpty()){
            update studentsToUpdate;
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('SUCCESS: Đã dọn dẹp xong dữ liệu học sinh nghỉ học viên mãn!');
    }
}