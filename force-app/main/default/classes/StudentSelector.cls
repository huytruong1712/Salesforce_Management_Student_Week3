public with sharing class StudentSelector {
    // public StudentSelector() {

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
}