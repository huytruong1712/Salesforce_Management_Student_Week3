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
    }
})