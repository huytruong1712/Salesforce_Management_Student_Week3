public with sharing class StudentService {
    // public StudentService() {

    // }

    public static void insertStudents(List<Student__c> newStudents){
        if(newStudents == null || newStudents.isEmpty()){
            throw new AuraHandledException('Student list cannot be null or empty');
        }

        for(Student__c newStudent : newStudents){
            if(newStudent == null || String.isBlank(newStudent.Name)){
                throw new AuraHandledException('Student can\'t be blank or student\'s name is required');
            }
        }
         
        try {
            insert newStudents;
        } catch(Exception ex){
            throw new AuraHandledException('Insert failed: ' + ex.getMessage());
        }
    }
}