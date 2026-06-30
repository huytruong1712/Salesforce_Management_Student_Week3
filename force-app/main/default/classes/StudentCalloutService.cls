public with sharing class StudentCalloutService {
    
    /**
     * Hàm gọi API bên ngoài để lấy dữ liệu User và chuyển thành Student__c
     */
    public static void fetchAndCreateStudentsFromAPI() {
        // 1. Khởi tạo công cụ HTTP
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        // 2. Gắn Endpoint bằng Named Credential (Cú pháp: callout:Tên_Named_Credential/Đường_dẫn_phụ)
        request.setEndpoint('callout:JSONPlaceholder/users');
        request.setMethod('GET'); // Lấy dữ liệu nên dùng GET
        
        try {
            // 3. Gửi Request và hứng Response trả về
            HttpResponse response = http.send(request);
            
            // 4. Kiểm tra xem gọi API có thành công không (Mã 200 là OK)
            if (response.getStatusCode() == 200) {
                // Ép chuỗi JSON trả về thành một danh sách (List) các Object
                List<Object> apiResults = (List<Object>) JSON.deserializeUntyped(response.getBody());
                List<Student__c> newStudents = new List<Student__c>();
                
                // 5. Duyệt qua từng bản ghi API trả về để tạo Học sinh tương ứng
                for (Object obj : apiResults) {
                    Map<String, Object> userMap = (Map<String, Object>) obj;
                    
                    Student__c student = new Student__c();
                    student.Name = (String) userMap.get('name') + ' (API)'; // Đánh dấu chữ API để dễ nhận biết
                    student.Email__c = (String) userMap.get('email');
                    
                    newStudents.add(student);
                }
                
                // 6. Insert vào Database nếu danh sách không rỗng
                if (!newStudents.isEmpty()) {
                    insert newStudents;
                    System.debug('SUCCESS: Đã kéo thành công ' + newStudents.size() + ' học sinh từ API vào Org!');
                }
            } else {
                System.debug('ERROR: Gọi API thất bại. Mã lỗi: ' + response.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('EXCEPTION: Có lỗi xảy ra trong quá trình Callout - ' + e.getMessage());
        }
    }
}