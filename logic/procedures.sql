-- Procedures

CREATE OR REPLACE PROCEDURE insert_data (  
    roll student_n.roll_no%TYPE,   
    name student_n.student_name%TYPE,   
    phone1 student_ph1.student_phone1%TYPE,  
    phone2 student_ph2.student_phone2%TYPE,  
    room student_r.student_room_no%TYPE)  
IS  
BEGIN  
    INSERT INTO student_n (roll_no, student_name) VALUES (roll, name);  
    INSERT INTO student_ph1 (roll_no, student_phone1) VALUES (roll, phone1);  
    INSERT INTO student_ph2 (roll_no, student_phone2) VALUES (roll, phone2);  
    INSERT INTO student_r (roll_no, student_room_no) VALUES (roll, room);  
    COMMIT;  
END insert_data;
/

CREATE OR REPLACE PROCEDURE add_complaint(  
    c_no IN complaint_table.complaint_no%TYPE,  
    roll IN complaint_table.roll_no%TYPE,  
    disc IN complaint_info.description%TYPE,  
    c_type IN complaint_info.complaint_type%TYPE  
)  
IS  
BEGIN  
    INSERT INTO complaint_table(complaint_no, roll_no) VALUES (c_no, roll);  
    INSERT INTO complaint_info(complaint_no, description, complaint_type) VALUES (c_no, disc, c_type);  
    COMMIT;  
END add_complaint; 
/

CREATE OR REPLACE PROCEDURE show_mess_reviews  
IS  
BEGIN  
    FOR review IN (SELECT sr_no, feedback FROM mess_info ORDER BY sr_no)  
    LOOP  
        DBMS_OUTPUT.PUT_LINE('Review ID: ' || review.sr_no || ', Feedback: ' || review.feedback);  
    END LOOP;  
END show_mess_reviews; 
/

CREATE OR REPLACE PROCEDURE update_laundry( 
    sno IN laundry_table.sr_no%TYPE, 
    comp IN laundry_info.completed%TYPE) 
IS  
BEGIN  
    UPDATE laundry_info SET completed = comp WHERE sr_no = sno; 
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows updated.'); 
    COMMIT;  
END; 
/

CREATE OR REPLACE PROCEDURE add_mess_review(  
    review_id IN NUMBER,  
    feedback IN VARCHAR2  
)  
IS  
BEGIN  
    BEGIN  
        -- Attempt to insert into mess_table  
        INSERT INTO mess_table(sr_no, roll_no) VALUES (review_id, NULL);  
    EXCEPTION  
        WHEN DUP_VAL_ON_INDEX THEN  
            NULL; -- Ignore if sr_no already exists  
    END;  

    INSERT INTO mess_info(sr_no, feedback) VALUES (review_id, feedback);  
    COMMIT;  
END add_mess_review; 
/

CREATE OR REPLACE PROCEDURE add_laundry(  
    sno IN laundry_table.sr_no%TYPE,  
    roll IN laundry_table.roll_no%TYPE,  
    g_date IN laundry_info.given_on%TYPE,  
    r_date IN laundry_info.received_on%TYPE,  
    comp IN laundry_info.completed%TYPE  
)  
IS  
BEGIN  
    BEGIN 
        INSERT INTO student_n (roll_no, student_name) 
        SELECT roll, 'Student_' || roll 
        FROM dual 
        WHERE NOT EXISTS (SELECT 1 FROM student_n WHERE roll_no = roll); 
    END; 

    INSERT INTO laundry_table(sr_no, roll_no) VALUES(sno, roll);  
    INSERT INTO laundry_info(sr_no, given_on, received_on, completed)  
    VALUES(sno, g_date, r_date, comp);   
    COMMIT;  
EXCEPTION 
    WHEN OTHERS THEN 
        ROLLBACK; 
        RAISE; 
END add_laundry; 
/
