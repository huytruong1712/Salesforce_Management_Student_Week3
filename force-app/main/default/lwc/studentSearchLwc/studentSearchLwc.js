import { LightningElement } from 'lwc';

export default class StudentSearchLwc extends LightningElement {
    
    handleKeyChange(event) {
        // 1. Lấy chữ người dùng vừa gõ
        const searchKeyword = event.target.value;
        
        // 2. Tạo một Event chuẩn JS, đặt tên sự kiện là 'search' 
        // Đút từ khóa vào cái túi tên là 'detail'
        const searchEvent = new CustomEvent('search', { 
            detail: searchKeyword 
        });
        
        // 3. Bắn event lên cho Cha! (Không cần file .evt)
        this.dispatchEvent(searchEvent);
    }
}