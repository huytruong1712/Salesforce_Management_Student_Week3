import { LightningElement, api } from 'lwc';

export default class StudentCard extends LightningElement {
    // 1. @api để hứng dữ liệu do thằng Cha truyền xuống
    @api student;

    // 2. Hàm xử lý khi bấm nút
    handleSelectClick() {
        // 3. Tạo Custom Event tên là "studentselect" (Tên event phải viết THƯỜNG toàn bộ)
        // Đóng gói Id của học sinh vào biến "detail" để gửi đi
        const selectEvent = new CustomEvent('studentselect', {
            detail: this.student.Id
        });

        // 4. Bắn sự kiện lên cho thằng Cha hứng
        this.dispatchEvent(selectEvent);
    }
}