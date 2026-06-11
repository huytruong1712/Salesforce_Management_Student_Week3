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

    // HÀM MỚI ĐỂ HỨNG EVENT TỪ CON
    handleSearchFromChild : function(component, event, helper) {
        // 1. Bóc bức thư ra để lấy cái tham số 'keyword' mà thằng con gửi lên
        var searchKeyFromChild = event.getParam("keyword");
        
        // 2. Gửi cái keyword này sang cho Helper gọi Apex (Hàm helper này bạn đã viết ở bước trước rồi, giữ nguyên)
        helper.searchStudentsByKeyword(component, searchKeyFromChild);
    },

    handlePostStudentFromChild : function(component, event, helper) {
        // 1. Bóc thư lấy ra object học sinh mới
        var newStudentData = event.getParam("newStudent");
        
        // 2. Đẩy sang cho Helper xử lý gọi Apex
        helper.createNewStudent(component, newStudentData);
    },

    handleDeleteClick : function(component, event, helper) {
    // 1. Hỏi xác nhận người dùng trước khi xóa để tránh bấm nhầm
        if (confirm("Are you sure you want to delete this student?")) {
            
            // 2. Lấy ra Id của học sinh được lưu trong thuộc tính 'name' của nút bấm vừa click
            var studentId = event.getSource().get("v.name");
            
            // 3. Gọi Helper xử lý truyền ID này xuống Apex Backend
            helper.deleteStudentFromServer(component, studentId);
        }
    },

    // Hàm mở Modal và copy dữ liệu học sinh sang biến selectedStudent
    handleEditClick : function(component, event, helper) {
        var clickedStudent = event.getSource().get("v.name");
        
        // Tạo một bản sao (clone) object để tránh việc người dùng đang gõ trên form mà bảng ở dưới cũng bị nhảy chữ theo
        var studentClone = JSON.parse(JSON.stringify(clickedStudent));
        
        component.set("v.selectedStudent", studentClone);
        component.set("v.isOpenEditModal", true);
    },

    // Hàm đóng Modal khi bấm nút Cancel
    closeModal : function(component, event, helper) {
        component.set("v.isOpenEditModal", false);
    },

    // Hàm xử lý khi bấm nút "Save Changes" trên Modal
    handleUpdateSave : function(component, event, helper) {
        var updatedStudent = component.get("v.selectedStudent");
        
        // Giao việc cho Helper truyền dữ liệu sửa xuống Apex Backend
        helper.updateStudentOnServer(component, updatedStudent);
    }

})