({
    handleSave : function(component, event, helper) {
        // 1. Lấy dữ liệu học sinh từ Form
        var studentData = component.get("v.studentObj");
        
        // 2. Gọi Event đã đăng ký
        var compEvent = component.getEvent("addEvt");
        
        // 3. Đút dữ liệu vào tham số 'newStudent' của Event
        compEvent.setParams({
            "newStudent" : studentData
        });
        
        // 4. Bắn lên cho Cha xử lý
        compEvent.fire();
        
        // 5. Reset Form về trống để người dùng nhập ca tiếp theo
        component.set("v.studentObj", {
            'sobjectType': 'Student__c',
            'Name': '',
            'Email__c': '',
            'Birthday__c': ''
        });
    }
})