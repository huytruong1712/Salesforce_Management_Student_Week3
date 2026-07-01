public with sharing class StudentController {
    // public StudentController() {

    // }

    @AuraEnabled(cacheable=true)
    public static List<Student__c> get5LastestStudents() {
        return StudentService.select5LatestStudents();
    }

    @AuraEnabled(cacheable=false)
    public static List<Student__c> getStudentList() {
        return StudentService.selectAllStudents();
    }

    @AuraEnabled
    public static void addStudents(List<Student__c> studentRecords) {
        StudentService.insertStudents(studentRecords);
    }

    @AuraEnabled
    public static void addStudent(Student__c studentRecord) {
        List<Student__c> studentsToInsert = new List<Student__c>();
        if (studentRecord != null) {
            studentsToInsert.add(studentRecord);
        }

        StudentService.insertStudents(studentsToInsert);
    }

    @AuraEnabled(cacheable=false)
    public static List<Student__c> searchStudents(String searchKey){
        if(String.isBlank(searchKey)){
            return StudentService.selectAllStudents();
        } else {
            return StudentService.selectStudentsByName(searchKey);
        }
    }

    @AuraEnabled
    public static void deleteStudent(String studentId) {
        if (String.isBlank(studentId)) {
            throw new AuraHandledException('Student ID cannot be blank.');
        }
        
        Student__c studentToDelete = new Student__c(Id = studentId);
        
        StudentService.deleteStudents(new List<Student__c>{ studentToDelete });
    }

    @AuraEnabled
    public static void updateStudent(Student__c studentRecord) {
        if (studentRecord == null || String.isBlank(studentRecord.Id)) {
            throw new AuraHandledException('Missing Student Record or Student ID.');
        }
        
        // Tái sử dụng hàm updateStudents bằng cách bọc vào một List
        StudentService.updateStudents(new List<Student__c>{ studentRecord });
    }

    @AuraEnabled(cacheable=true)
    public static List<Student__c> getStudentListForLwc() {
        return StudentSelector.selectAllStudents();
    }

    
}