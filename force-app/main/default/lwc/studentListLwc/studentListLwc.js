import { LightningElement, track } from 'lwc';
import searchStudents from '@salesforce/apex/StudentController.searchStudents';
// Import thêm 2 hàm Thêm và Sửa từ Apex
import addStudent from '@salesforce/apex/StudentController.addStudent';
import updateStudent from '@salesforce/apex/StudentController.updateStudent';
import deleteStudent from '@salesforce/apex/StudentController.deleteStudent';
// Import thư viện Toast của LWC
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class StudentListLwc extends LightningElement {
    @track students; 
    error;

    // Các biến dùng cho Modal Edit
    @track isEditModalOpen = false;
    @track selectedStudent = {};

    connectedCallback() {
        this.loadStudents('');
    }

    handleSearch(event) {
        this.loadStudents(event.detail);
    }

    loadStudents(searchKey) {
        searchStudents({ searchKey: searchKey })
            .then(result => { this.students = result; })
            .catch(error => { this.error = error; });
    }

    // --- TÍNH NĂNG THÊM ---
    handleAddStudent(event) {
        const newStudentData = event.detail; // Lấy object con bắn lên
        
        addStudent({ studentRecord: newStudentData })
            .then(() => {
                this.showToast('Success', 'Student added successfully!', 'success');
                this.loadStudents(''); // Load lại bảng
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    // --- TÍNH NĂNG SỬA ---
    handleEditClick(event) {
        // Lấy Id được gài trong nút bấm (thuộc tính data-id trên HTML)
        const stuId = event.target.dataset.id;
        
        // Tìm học sinh đó trong mảng hiện tại và clone ra để tránh sửa trực tiếp
        const studentToEdit = this.students.find(s => s.Id === stuId);
        this.selectedStudent = { ...studentToEdit }; 
        
        this.isEditModalOpen = true; // Mở Modal
    }

    closeModal() {
        this.isEditModalOpen = false;
    }

    // Bắt sự kiện khi người dùng gõ vào Modal để cập nhật biến selectedStudent
    handleFieldChange(event) {
        const fieldName = event.target.dataset.field; // Lấy tên trường
        this.selectedStudent[fieldName] = event.target.value; // Ghi đè giá trị mới
    }

    handleUpdateSave() {
        updateStudent({ studentRecord: this.selectedStudent })
            .then(() => {
                this.showToast('Success', 'Student updated successfully!', 'success');
                this.isEditModalOpen = false; // Đóng Modal
                this.loadStudents(''); // Load lại bảng
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    handleDeleteClick(event) {
        // Lấy Id của học sinh từ data-id của nút bấm
        const stuId = event.target.dataset.id;

        // Bật hộp thoại hỏi xác nhận chuẩn trình duyệt
        if (confirm("Are you sure you want to delete this student?")) {
            
            // Gọi Apex thực hiện xóa
            deleteStudent({ studentId: stuId })
                .then(() => {
                    // Nếu thành công: Báo Toast và load lại bảng
                    this.showToast('Deleted!', 'The student record has been deleted.', 'success');
                    this.loadStudents('');
                })
                .catch(error => {
                    // Nếu lỗi: Báo Toast đỏ
                    this.showToast('Error', error.body.message, 'error');
                });
        }
    }

    // Hàm mở trang Visualforce Page ở tab mới
    handleExportPDF() {
        // Đường dẫn chuẩn của mọi trang Visualforce là /apex/Ten_Trang
        const pdfUrl = '/apex/StudentPdfPage';
        window.open(pdfUrl, '_blank');
    }

    // --- HÀM TIỆN ÍCH ---
    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}