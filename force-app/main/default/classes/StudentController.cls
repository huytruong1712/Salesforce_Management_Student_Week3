public with sharing class StudentController {
    // public StudentController() {

    // }

    @AuraEnabled(cacheable=false)
    public static List<Student__c> getStudentList() {
        return StudentSelector.selectAllStudents();
    }

    @AuraEnabled
    public static void addStudents(List<Student__c> studentRecords) {
        StudentService.insertStudents(studentRecords);
    }
}