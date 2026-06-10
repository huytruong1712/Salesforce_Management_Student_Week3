({
    fireSearchEvent : function(component, event, helper) {
        // 1. Lấy chữ người dùng vừa gõ
        var searchKey = event.getParam("value");
        
        // 2. Lấy cái Event đã đăng ký ở file .cmp thông qua tên 'searchEvt'
        var compEvent = component.find("searchEvt") || component.getEvent("searchEvt");
        
        // 3. Đặt chữ đó vào tham số 'keyword' của bức thư
        compEvent.setParams({
            "keyword" : searchKey
        });
        
        // 4. Bắn bức thư đi!
        compEvent.fire();
    }
})