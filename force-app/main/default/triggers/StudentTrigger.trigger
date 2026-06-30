trigger StudentTrigger on Student__c (before insert, before update) {
    if(Trigger.isBefore && Trigger.isInsert) {
        StudentTriggerHandler.handleBeforeInsert(Trigger.new);
    }

    if(Trigger.isBefore && Trigger.isUpdate) {
        StudentTriggerHandler.handleBeforeUpdate(Trigger.new);
    }
}