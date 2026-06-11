({
    // Hàm phụ trách load toàn bộ danh sách ban đầu (dùng cho doInit)
    fetchStudents : function(component) {
        var action = component.get("c.getStudentList");
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.studentList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    // Hàm phụ trách gửi từ khóa xuống Apex và nhận lại danh sách đã lọc
    searchStudentsByKeyword : function(component, searchKey) {
        // 1. Gọi hàm selectStudentsByName từ Apex thông qua tầng StudentController của Apex
        var action = component.get("c.searchStudents");
        
        // 2. Truyền tham số (Attribute) từ JS xuống cho hàm Apex nhận
        action.setParams({
            "searchKey": searchKey
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // 3. Thay thế danh sách cũ (v.studentList) bằng danh sách mới đã được lọc từ database
                // Giao diện sẽ tự động làm mới (re-render) ngay lập tức tại thời điểm đó!
                component.set("v.studentList", response.getReturnValue());
            } else {
                console.error("Lỗi khi tìm kiếm: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    createNewStudent : function(component, studentRecord) {
        var action = component.get("c.addStudent");
        action.setParams({
            "studentRecord": studentRecord
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Hiển thị thông báo (Toast) thành công lên màn hình Salesforce
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Student created successfully.",
                    "type": "success"
                });
                toastEvent.fire();

                // RE-LOAD LẠI DANH SÁCH: Gọi lại hàm fetch danh sách để cập nhật bảng lập tức
                this.fetchStudents(component);
            } else {
                // Nếu Apex ném lỗi (Ví dụ: Tên trống), bóc lỗi ra hiển thị lên Toast đỏ
                var errors = response.getError();
                var message = 'Unknown error';
                if (errors && errors[0] && errors[0].message) {
                    message = errors[0].message;
                }
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": message,
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    deleteStudentFromServer : function(component, studentId) {
        // 1. Khai báo gọi hàm deleteStudent từ Apex Controller
        var action = component.get("c.deleteStudent");
        
        // 2. Truyền tham số studentId xuống cho Apex nhận
        action.setParams({
            "studentId": studentId
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // 3. Bắn thông báo Toast màu xanh bảo đã xóa thành công
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Deleted!",
                    "message": "The student record has been deleted.",
                    "type": "success"
                });
                toastEvent.fire();

                // 4. RE-LOAD LẠI BẢNG: Gọi hàm lấy danh sách để giao diện cập nhật ngay tại thời điểm đó
                this.fetchStudents(component);
            } else {
                // Hiển thị lỗi nếu xóa thất bại
                var errors = response.getError();
                var message = (errors && errors[0] && errors[0].message) ? errors[0].message : 'Error deleting student';
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": message,
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    updateStudentOnServer : function(component, studentRecord) {
        var action = component.get("c.updateStudent");
        action.setParams({
            "studentRecord": studentRecord
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // 1. Hiện Toast báo thành công
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Student updated successfully.",
                    "type": "success"
                });
                toastEvent.fire();

                // 2. Đóng Modal Popup lại
                component.set("v.isOpenEditModal", false);

                // 3. RE-LOAD LẠI BẢNG để cập nhật thông tin mới sửa lập tức
                this.fetchStudents(component);
            } else {
                // Hiển thị lỗi từ Apex ném lên (Ví dụ: Sửa tên thành rỗng)
                var errors = response.getError();
                var message = (errors && errors[0] && errors[0].message) ? errors[0].message : 'Error updating student';
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": message,
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }

})