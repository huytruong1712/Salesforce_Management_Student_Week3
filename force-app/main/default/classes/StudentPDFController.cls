public with sharing class StudentPDFController {
    public List<Student__c> studentList { get; set; }

    public StudentPDFController() {
        studentList = StudentSelector.selectAllStudents();
    }
}