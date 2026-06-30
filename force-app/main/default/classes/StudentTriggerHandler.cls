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

    public static void handleBeforeUpdate(List<Student__c> triggerNew){
        for(Student__c s : triggerNew){
            if(s.Status__c == 'Graduated' && String.isBlank(s.Email__c)){
                s.addError('Email is required for Graduated students.');
            }
        }
    }
}