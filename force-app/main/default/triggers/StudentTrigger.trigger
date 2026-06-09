trigger StudentTrigger on Student__c (before insert) {
    if(Trigger.isBefore && Trigger.isInsert) {
        StudentTriggerHandler.handleBeforeInsert(Trigger.new);
    }
}