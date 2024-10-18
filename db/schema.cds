namespace com.hemanth.satinfotech;
using { managed, cuid } from '@sap/cds/common';

entity Branch: managed, cuid {
    
    @title:'Name'
    name:String(20);
    @title:'Address 1'
    add1:String(20);
    @title:'Address 2'
    add2:String(20);
    @title:'City'
    city:String(20);
    @title:'pin code'
    pinCode:String(10);
    @title:'State'
    state:String(20);
    @title:'Branch Phone Number'
    ph_no:String(10);
}

entity Staff : cuid, managed {
    @title: 'Staff ID'
    staff_id : String(10);
    @title: 'Staff Name'
    staff_name: String(20);
    @title: 'Staff Image'
    staff_img: String default 'https://imgur.com/djS2boy.jpg';
    @title: 'Designation'
    staff_des: String(30);
    @title: 'Salary'
    staff_sal: Integer;
    @title: 'Staff Age'
    staff_age: Integer;
}

entity ProductLocal: managed {
    key Product: String(40);
    ProductType: String(4);
    BaseUnit: String(3);
    ProductGroup: String(18);
    ProductDescription: String(40);
}