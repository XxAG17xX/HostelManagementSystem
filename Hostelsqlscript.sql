REM   Script: Hostel Management System
REM   Second Year DBMS Project


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

BEGIN  
    insert_data(102203930, 'kartik', 9863354456, 7753472422, 13);  
    insert_data(102203942, 'arul', 7696725530, 7234567877, 20);  
    insert_data(102213029, 'maneck', 1234567867, 8765432455, 21);  
    insert_data(102203086, 'aryan', 9876542343, 9875665537, 22);  
    insert_data(102203951, 'kashita', 7696725530, 4374623473, 23);  
    insert_data(102203947, 'simran', 7696725530, 1234567877, 24);  
    insert_data(102201005, 'deepak', 7696725530, 1234567890, 25);  
    insert_data(102204135, 'rahul', 7696725530, 1234567876, 26);  
    insert_data(102205151, 'chintu', 7696725530, 1234567855, 27);  
    insert_data(102207843, 'ramu', 7696725530, 1234567844, 28);  
    insert_data(102209971, 'kapil', 7696725530, 1234567833, 29);  
END;
/

select * from student_n;

select * from student_ph1;

select * from student_ph2;

select * from student_r;

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

BEGIN  
    add_complaint(1, 102203942, 'BAD service', 'mess');  
    add_complaint(2, 102203930, 'Avg', 'laundry');  
    add_complaint(3, 102213029, 'Untidy', 'mess');  
    add_complaint(4, 102203086, 'Late', 'laundry');  
END;
/

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

SELECT * FROM laundry_table;

SELECT * FROM laundry_info;

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

CREATE OR REPLACE TRIGGER restrict_delete_complaint 
BEFORE DELETE ON complaint_table 
FOR EACH ROW 
DECLARE 
    unresolved_complaint EXCEPTION; 
    complaint_count NUMBER; 
BEGIN 
    -- Check if there are any entries in the complaint_info table for the given complaint_no 
    SELECT COUNT(*) 
    INTO complaint_count 
    FROM complaint_info 
    WHERE complaint_no = :OLD.complaint_no; 
 
    -- If there are entries, raise an exception 
    IF complaint_count > 0 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Cannot delete complaint. Associated information exists.'); 
    END IF; 
 
EXCEPTION 
    WHEN unresolved_complaint THEN 
        -- Display a message indicating that deletion is restricted for unresolved complaints 
        DBMS_OUTPUT.PUT_LINE('Deletion of unresolved complaints is restricted.'); 
END; 
/

Select * from complaint_table;

Select * from complaint_table;

Select * from complaint_info;

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
  
    -- Insert into mess_info  
    INSERT INTO mess_info(sr_no, feedback) VALUES (review_id, feedback);  
      
    COMMIT;  
END add_mess_review; 
 
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

BEGIN  
    add_mess_review(1, 'Good food');  
    add_mess_review(2, 'Excellent service');  
    add_mess_review(3, 'Average quality');  
    add_mess_review(4, 'Poor hygiene');  
END;
/

Select sr_no,feedback FROM mess_info ORDER BY sr_no;

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
        WHERE NOT EXISTS ( 
            SELECT 1 FROM student_n WHERE roll_no = roll 
        ); 
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

DECLARE 
    sno NUMBER; 
BEGIN 
    SELECT NVL(MAX(sr_no), 0) + 1 INTO sno FROM laundry_table; 
    add_laundry(sno, 102203930, TO_DATE('12-08-2002', 'dd-mm-yyyy'), TO_DATE('12-07-2022', 'dd-mm-yyyy'), 'n'); 
    add_laundry(sno+1, 102203942, TO_DATE('05-08-2002', 'dd-mm-yyyy'), TO_DATE('12-02-2022', 'dd-mm-yyyy'), 'n'); 
    add_laundry(sno+2, 102213029, TO_DATE('08-08-2002', 'dd-mm-yyyy'), TO_DATE('12-09-2022', 'dd-mm-yyyy'), 'n'); 
    add_laundry(sno+3, 102207843, TO_DATE('16-08-2002', 'dd-mm-yyyy'), TO_DATE('12-12-2022', 'dd-mm-yyyy'), 'n'); 
    add_laundry(sno+4, 102209971, TO_DATE('25-08-2002', 'dd-mm-yyyy'), TO_DATE('12-01-2022', 'dd-mm-yyyy'), 'n'); 
END;
/

SELECT * FROM laundry_table;

SELECT * FROM laundry_info;

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

BEGIN 
    update_laundry(5,'y');  
END;
/

SELECT * FROM laundry_info;

CREATE OR REPLACE TRIGGER Insert_at_12 
BEFORE INSERT ON student_n 
FOR EACH ROW 
WHEN (TO_CHAR(SYSDATE,'fmDAY') = 'MONDAY') 
DECLARE 
abcd EXCEPTION; 
BEGIN 
RAISE abcd; 
EXCEPTION 
WHEN abcd THEN 
DBMS_OUTPUT.PUT_LINE('Have a good start of the week.'); 
END;
/

INSERT INTO student_n values(102532452,'Chhillar');

DELETE FROM student_n WHERE roll_no = 102532452;

INSERT INTO student_n values(102532452,'Chhillar');

SELECT TO_CHAR(SYSDATE, 'fmDAY') AS CURRENT_DAY FROM DUAL;

DELETE FROM student_n WHERE roll_no = 102532452;

INSERT INTO student_n values(102532452,'Chhillar');

DELETE FROM student_n WHERE roll_no = 102532452;

CREATE OR REPLACE TRIGGER Insert_at_12 
BEFORE INSERT ON student_n 
FOR EACH ROW 
WHEN (TO_CHAR(SYSDATE,'fmDAY') = 'FRIDAY') 
DECLARE 
abcd EXCEPTION; 
BEGIN 
RAISE abcd; 
EXCEPTION 
WHEN abcd THEN 
DBMS_OUTPUT.PUT_LINE('Have a good start of the week.'); 
END; 

/

DELETE FROM student_n WHERE roll_no = 102532452;

INSERT INTO student_n values(102532452,'Chhillar');

SELECT * FROM STUDENT_N;

CREATE OR REPLACE TRIGGER prevent_delete_laundry 
BEFORE DELETE ON student_n 
FOR EACH ROW 
DECLARE 
    v_count NUMBER; 
BEGIN 
    -- Check if there are pending laundry tasks associated with the entry 
    SELECT COUNT(*) 
    INTO v_count 
    FROM laundry_table 
    WHERE roll_no = :OLD.roll_no; 
 
    IF v_count > 0 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Cannot delete student record. Pending laundry tasks exist.'); 
    END IF; 
END;
/

CREATE OR REPLACE TRIGGER restrict_delete_complaint 
BEFORE DELETE ON complaint_table 
FOR EACH ROW 
DECLARE 
    unresolved_complaint EXCEPTION; 
    complaint_count NUMBER; 
BEGIN 
    -- Check if there are any entries in the complaint_info table for the given complaint_no 
    SELECT COUNT(*) 
    INTO complaint_count 
    FROM complaint_info 
    WHERE complaint_no = :OLD.complaint_no; 
 
    -- If there are entries, raise an exception 
    IF complaint_count > 0 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Cannot delete complaint. Associated information exists.'); 
    END IF; 
 
EXCEPTION 
    WHEN unresolved_complaint THEN 
        -- Display a message indicating that deletion is restricted for unresolved complaints 
        DBMS_OUTPUT.PUT_LINE('Deletion of unresolved complaints is restricted.'); 
END;
/

CREATE OR REPLACE TRIGGER restrict_delete_complaint 
BEFORE DELETE ON complaint_table 
FOR EACH ROW 
DECLARE 
    unresolved_complaint EXCEPTION; 
    complaint_count NUMBER; 
BEGIN 
    -- Check if there are any entries in the complaint_info table for the given complaint_no 
    SELECT COUNT(*) 
    INTO complaint_count 
    FROM complaint_info 
    WHERE complaint_no = :OLD.complaint_no; 
 
    -- If there are entries, raise an exception 
    IF complaint_count > 0 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Cannot delete complaint. Associated information exists.'); 
    END IF; 
 
EXCEPTION 
    WHEN unresolved_complaint THEN 
        -- Display a message indicating that deletion is restricted for unresolved complaints 
        DBMS_OUTPUT.PUT_LINE('Deletion of unresolved complaints is restricted.'); 
END; 
/

CREATE OR REPLACE TRIGGER restrict_delete_complaint 
BEFORE DELETE ON complaint_table 
FOR EACH ROW 
DECLARE 
    unresolved_complaint EXCEPTION; 
    complaint_count NUMBER; 
BEGIN 
    -- Check if there are any entries in the complaint_info table for the given complaint_no 
    SELECT COUNT(*) 
    INTO complaint_count 
    FROM complaint_info 
    WHERE complaint_no = :OLD.complaint_no; 
 
    -- If there are entries, raise an exception 
    IF complaint_count > 0 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Cannot delete complaint. Associated information exists.'); 
    END IF; 
 
EXCEPTION 
    WHEN unresolved_complaint THEN 
        -- Display a message indicating that deletion is restricted for unresolved complaints 
        DBMS_OUTPUT.PUT_LINE('Deletion of unresolved complaints is restricted.'); 
END;
/

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

CREATE OR REPLACE TRIGGER restrict_delete_complaint 
BEFORE DELETE ON complaint_table 
FOR EACH ROW 
DECLARE 
    unresolved_complaint EXCEPTION; 
    complaint_count NUMBER; 
BEGIN 
    -- Check if there are any entries in the complaint_info table for the given complaint_no 
    SELECT COUNT(*) 
    INTO complaint_count 
    FROM complaint_info 
    WHERE complaint_no = :OLD.complaint_no; 
 
    -- If there are entries, raise an exception 
    IF complaint_count > 0 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Cannot delete complaint. Associated information exists.'); 
    END IF; 
 
EXCEPTION 
    WHEN unresolved_complaint THEN 
        -- Display a message indicating that deletion is restricted for unresolved complaints 
        DBMS_OUTPUT.PUT_LINE('Deletion of unresolved complaints is restricted.'); 
END; 
/

SELECT * FROM student_r;

DECLARE 
v_roll_no number := 102203930; 
v_room_no number; 
 
CURSOR student_cursor IS 
SELECT student_room_no 
FROM student_r 
WHERE roll_no = v_roll_no; 
BEGIN 
 
OPEN student_cursor; 
 
FETCH student_cursor INTO v_room_no; 
IF student_cursor%FOUND THEN 
DBMS_OUTPUT.PUT_LINE('Room number of student with roll number' || v_roll_no || ' is ' || v_room_no); 
ELSE 
DBMS_OUTPUT.PUT_LINE('Student with roll number ' || v_roll_no || ' not found.'); 
 
END IF; 
CLOSE student_cursor; 
EXCEPTION 
WHEN OTHERS THEN 
DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM); 
END;
/

SELECT * FROM student_r;

DECLARE 
v_roll_no number := 102203930; 
v_room_no number; 
 
CURSOR student_cursor IS 
SELECT student_room_no 
FROM student_r 
WHERE roll_no = v_roll_no; 
BEGIN 
 
OPEN student_cursor; 
 
FETCH student_cursor INTO v_room_no; 
IF student_cursor%FOUND THEN 
DBMS_OUTPUT.PUT_LINE('Room number of student with roll number' || v_roll_no || ' is ' || v_room_no); 
ELSE 
DBMS_OUTPUT.PUT_LINE('Student with roll number ' || v_roll_no || ' not found.'); 
 
END IF; 
CLOSE student_cursor; 
EXCEPTION 
WHEN OTHERS THEN 
DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM); 
END;
/

