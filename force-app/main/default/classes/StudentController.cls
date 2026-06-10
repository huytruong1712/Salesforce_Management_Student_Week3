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

    @AuraEnabled(cacheable=false)
    public static List<Student__c> searchStudents(String searchKey){
        if(String.isBlank(searchKey)){
            return StudentSelector.selectAllStudents();
        } else {
            return StudentSelector.selectStudentsByName(searchKey);
        }
    }
}