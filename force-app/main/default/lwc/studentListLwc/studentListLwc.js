import { LightningElement, wire } from 'lwc';
import getStudentListForLwc from '@salesforce/apex/StudentController.getStudentListForLwc';

export default class StudentListLwc extends LightningElement {
    @wire(getStudentListForLwc)
    students;
    /* Lưu ý: Biến 'students' lúc này sẽ chứa 2 thứ:
       - students.data : Chứa danh sách học sinh (nếu thành công)
       - students.error : Chứa lỗi (nếu gọi Apex thất bại)
    */
}