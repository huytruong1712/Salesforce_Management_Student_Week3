public with sharing class StudentService {
    // public StudentService() {

    // }

    public static List<Student__c> selectAllStudents(){
        return [SELECT Id, Name, Email__c, Birthday__c
                FROM Student__c
                ORDER BY CreatedDate DESC];
    }

    public static List<Student__c> selectStudentsByName(String keyWord){
        String key = '%' + keyWord +'%';
        return [SELECT Id, Name, Email__c, Birthday__c
                FROM Student__c
                WHERE Name LIKE :key
                ORDER BY CreatedDate DESC];
    }

    public static void insertStudents(List<Student__c> newStudents){
        if(newStudents == null || newStudents.isEmpty()){
            throw new AuraHandledException('Student list cannot be null or empty');
        }

        for(Student__c newStudent : newStudents){
            if(newStudent == null || String.isBlank(newStudent.Name)){
                throw new AuraHandledException('Student name is required');
            }
        }
         
        try {
            insert newStudents;
        } catch(Exception ex){
            throw new AuraHandledException('Insert failed: ' + ex.getMessage());
        }
    }

    public static void deleteStudents(List<Student__c> studentsToDelete) {
        if (studentsToDelete == null || studentsToDelete.isEmpty()) {
            return;
        }
        
        try {
            delete studentsToDelete;
        } catch(Exception e) {
            throw new AuraHandledException('Error deleting students: ' + e.getMessage());
        }
    }

    public static void updateStudents(List<Student__c> studentsToUpdate) {
        if (studentsToUpdate == null || studentsToUpdate.isEmpty()) {
            return;
        }
        
        for (Student__c student : studentsToUpdate) {
            if (String.isBlank(student.Name)) {
                throw new AuraHandledException('Student Name cannot be blank when updating.');
            }
        }
        
        try {
            update studentsToUpdate;
        } catch(Exception e) {
            throw new AuraHandledException('Error updating students: ' + e.getMessage());
        }
    }
}