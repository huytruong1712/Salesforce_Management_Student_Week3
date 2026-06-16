import { LightningElement } from 'lwc';

export default class StudentAddLwc extends LightningElement {
    
    handleSave() {
        // 1. Dùng querySelector để lấy giá trị từ các ô input
        const nameVal = this.template.querySelector('.input-name').value;
        const emailVal = this.template.querySelector('.input-email').value;
        const dobVal = this.template.querySelector('.input-dob').value;

        // 2. Gom thành 1 Object chuẩn SObject của Salesforce
        const newStudent = {
            sobjectType: 'Student__c',
            Name: nameVal,
            Email__c: emailVal,
            Birthday__c: dobVal
        };

        // 3. Bắn event lên cho Cha với túi dữ liệu 'detail'
        this.dispatchEvent(new CustomEvent('addstudent', { detail: newStudent }));

        // 4. Xóa trắng form sau khi bấm Save
        this.template.querySelectorAll('lightning-input').forEach(input => {
            input.value = '';
        });
    }
}