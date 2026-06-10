({
    // Hàm này tự động chạy khi load trang nhờ khai báo aura:handler init
    doInit : function(component, event, helper) {
        // 1. Khai báo gọi hàm 'getStudentList' từ Apex Controller
        var action = component.get("c.getStudentList");
        
        // 2. Định nghĩa hàm nhận kết quả trả về từ Apex (Callback)
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Nếu gọi thành công, lấy dữ liệu và gán vào attribute studentList ở file .cmp
                component.set("v.studentList", response.getReturnValue());
            } else {
                console.error("Lỗi khi lấy danh sách học sinh: " + state);
            }
        });
        
        // 3. Đưa hành động này vào hàng đợi để Salesforce thực thi
        $A.enqueueAction(action);
        helper.fetchStudents(component);
    },

    handleSearch : function(component, event, helper) {
        // 1. Lấy giá trị chữ mà người dùng đang gõ trong ô Input
        var searchKey = event.getParam("value");
        
        // 2. Giao việc cho Helper xử lý gọi Apex để lọc danh sách
        helper.searchStudentsByKeyword(component, searchKey);
    }
})