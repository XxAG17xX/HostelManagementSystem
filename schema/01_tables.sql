-- Tables

CREATE TABLE student_n (  
    roll_no NUMBER PRIMARY KEY,  
    student_name VARCHAR(20)  
);

CREATE TABLE student_ph1 (  
    roll_no NUMBER PRIMARY KEY REFERENCES student_n(roll_no),  
    student_phone1 NUMBER  
);

CREATE TABLE student_ph2 (  
    roll_no NUMBER PRIMARY KEY REFERENCES student_n(roll_no),  
    student_phone2 NUMBER  
);

CREATE TABLE student_r(  
    roll_no NUMBER PRIMARY KEY REFERENCES student_n(roll_no),  
    student_room_no NUMBER  
);

CREATE TABLE mess_table (  
    sr_no NUMBER PRIMARY KEY,  
    roll_no NUMBER REFERENCES student_n(roll_no)  
);

CREATE TABLE mess_info (  
    sr_no NUMBER PRIMARY KEY REFERENCES mess_table(sr_no),  
    feedback VARCHAR(100)  
);

CREATE TABLE laundry_table(  
    sr_no NUMBER PRIMARY KEY,  
    roll_no NUMBER REFERENCES student_n(roll_no)  
);

CREATE TABLE laundry_info (  
    sr_no NUMBER PRIMARY KEY REFERENCES laundry_table(sr_no),  
    given_on DATE,  
    received_on DATE,  
    completed VARCHAR(1)  
);

CREATE TABLE complaint_table (  
    complaint_no NUMBER PRIMARY KEY,  
    roll_no NUMBER REFERENCES student_n(roll_no)  
);

CREATE TABLE complaint_info (  
    complaint_no NUMBER PRIMARY KEY REFERENCES complaint_table(complaint_no),  
    description VARCHAR(100),  
    complaint_type VARCHAR(20)  
);
