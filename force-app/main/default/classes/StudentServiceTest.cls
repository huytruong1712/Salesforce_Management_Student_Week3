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

    @isTest
    static void testControllerAddStudentSuccess() {
        // 1. Chuẩn bị 1 học sinh hợp lệ
        Student__c newStudent = new Student__c(
            Name = 'Test Controller Student', 
            Email__c = 'controller@test.com',
            Birthday__c = Date.newInstance(2000, 1, 1)
        );
        
        // 2. Thực thi gọi thẳng qua hàm của Controller giống như Aura đang gọi
        Test.startTest();
        StudentController.addStudent(newStudent);
        Test.stopTest();
        
        // 3. Kiểm chứng xem database đã có học sinh này chưa
        List<Student__c> result = [SELECT Id, Name FROM Student__c WHERE Email__c = 'controller@test.com'];
        System.assertEquals(1, result.size(), 'Hàm Controller phải thêm thành công 1 học sinh vào database');
    }

    @isTest
    static void testControllerDeleteStudentSuccess() {
        // 1. Chuẩn bị dữ liệu mẫu: Insert trước 1 học sinh vào database để có Id test
        Student__c testStudent = new Student__c(Name = 'Delete Target', Email__c = 'delete@test.com');
        insert testStudent;
        
        // 2. Thực thi gọi hàm xóa từ Controller bằng cái Id vừa tạo
        Test.startTest();
        StudentController.deleteStudent(testStudent.Id);
        Test.stopTest();
        
        // 3. Kiểm chứng (Assert) xem database còn học sinh này không
        List<Student__c> result = [SELECT Id FROM Student__c WHERE Id = :testStudent.Id];
        System.assertEquals(0, result.size(), 'Học sinh phải được xóa hoàn toàn khỏi database');
    }

    @isTest
    static void testControllerUpdateStudentSuccess() {
        // 1. Chuẩn bị dữ liệu mẫu gốc
        Student__c testStudent = new Student__c(Name = 'Original Name', Email__c = 'original@test.com');
        insert testStudent;
        
        // 2. Tạo một object chứa dữ liệu mới cần sửa (Nhớ gán Id của học sinh gốc vào)
        Student__c updatedRecord = new Student__c(
            Id = testStudent.Id,
            Name = 'Updated Name',
            Email__c = 'updated@test.com'
        );
        
        // 3. Thực thi gọi hàm sửa từ Controller
        Test.startTest();
        StudentController.updateStudent(updatedRecord);
        Test.stopTest();
        
        // 4. Kiểm chứng (Assert) xem dữ liệu trong database đã thay đổi đúng chưa
        Student__c result = [SELECT Name, Email__c FROM Student__c WHERE Id = :testStudent.Id LIMIT 1];
        System.assertEquals('Updated Name', result.Name, 'Tên học sinh phải được cập nhật thành tên mới');
        System.assertEquals('updated@test.com', result.Email__c, 'Email học sinh phải được cập nhật thành email mới');
    }
}