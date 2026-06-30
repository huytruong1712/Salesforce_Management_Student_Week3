@RestResource(urlMapping='/Students/*')
global with sharing class StudentRestResource {

    /**
     * HÀM XỬ LÝ LỆNH GET (Dùng để lấy dữ liệu học sinh)
     * Đường link gọi API: [instance_url]/services/apexrest/Students/
     * Hoặc lọc theo tên: [instance_url]/services/apexrest/Students/?name=Leanne
     */
    @HttpGet
    global static List<Student__c> doGetStudents() {
        // 1. Lấy toàn bộ thông tin của Request gửi vào
        RestRequest req = RestContext.request;
        
        // 2. Thử bốc bộ lọc tham số "name" trên URL (ví dụ: ?name=Leanne)
        String searchParam = req.params.get('name');
        
        // 3. Logic xử lý: Nếu đối tác truyền tên vào thì lọc, không thì trả về hết
        if (String.isNotBlank(searchParam)) {
            return StudentController.searchStudents(searchParam);
        } else {
            return StudentSelector.selectAllStudents();
        }
    }
}