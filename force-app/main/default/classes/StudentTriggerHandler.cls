public with sharing class StudentTriggerHandler {
    // public StudentTriggerHandler() {

    // }
    public static void handleBeforeInsert(List<Student__c> triggerNew){
        for(Student__c s : triggerNew){
            if(s.Name != null){
                s.Name = s.Name.trim();
            }
        }
    }
}