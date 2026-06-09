@isTest
private class StudentServiceTest {

    @isTest
    static void testInsertBulkStudentsSuccess() {
        // 1. Chuẩn bị dữ liệu: Tạo một mảng gồm 3 học sinh hợp lệ
        List<Student__c> testStudents = new List<Student__c>();
        
        testStudents.add(new Student__c(Name = ' Nguyen Van A ', Email__c = 'a@gmail.com'));
        testStudents.add(new Student__c(Name = 'Tran Thi B', Email__c = 'b@gmail.com'));
        testStudents.add(new Student__c(Name = 'Le Van C', Email__c = 'c@gmail.com'));
        
        // 2. Thực thi code cần test
        Test.startTest();
        StudentService.insertStudents(testStudents);
        Test.stopTest();
        
        // 3. Kiểm chứng kết quả (Assert)
        // Kiểm tra xem database đã thực sự có 3 bản ghi chưa
        List<Student__c> insertedStudents = [SELECT Id, Name FROM Student__c];
        System.assertEquals(3, insertedStudents.size(), 'Hệ thống phải lưu thành công 3 học sinh');
        
        // Kiểm tra xem Trigger xóa khoảng trắng thừa của ' Nguyen Van A ' hoạt động đúng không
        Student__c studentA = [SELECT Name FROM Student__c WHERE Email__c = 'a@gmail.com' LIMIT 1];
        System.assertEquals('Nguyen Van A', studentA.Name, 'Trigger phải tự động trim() khoảng trắng thừa');
    }

    @isTest
    static void testInsertStudentBlankNameFail() {
        // 1. Chuẩn bị dữ liệu lỗi (Tên trống)
        List<Student__c> testStudents = new List<Student__c>();
        testStudents.add(new Student__c(Name = '', Email__c = 'error@gmail.com'));
        
        // 2. Thực thi và dùng Try-Catch để bắt lỗi
        Boolean hasError = false;
        String errorMessage = '';
        
        Test.startTest();
        try {
            StudentService.insertStudents(testStudents);
        } catch (AuraHandledException e) {
            hasError = true;
            errorMessage = e.getMessage();
        }
        Test.stopTest();
        
        // 3. Kiểm chứng (Assert)
        // Xác nhận là HỆ THỐNG PHẢI NÉM RA LỖI (hasError phải bằng true)
        System.assertEquals(true, hasError, 'Hệ thống bắt buộc phải chặn lại và ném ra lỗi khi tên trống');
    }
}