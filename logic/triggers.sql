-- Triggers

-- Prevent deleting complaint when complaint_info exists
CREATE OR REPLACE TRIGGER restrict_delete_complaint 
BEFORE DELETE ON complaint_table 
FOR EACH ROW 
DECLARE 
    complaint_count NUMBER; 
BEGIN 
    SELECT COUNT(*) INTO complaint_count 
    FROM complaint_info 
    WHERE complaint_no = :OLD.complaint_no; 

    IF complaint_count > 0 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Cannot delete complaint. Associated information exists.'); 
    END IF; 
END; 
/

-- Prevent deleting a student if related laundry exists
CREATE OR REPLACE TRIGGER prevent_delete_laundry 
BEFORE DELETE ON student_n 
FOR EACH ROW 
DECLARE 
    v_count NUMBER; 
BEGIN 
    SELECT COUNT(*) INTO v_count 
    FROM laundry_table 
    WHERE roll_no = :OLD.roll_no; 

    IF v_count > 0 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Cannot delete student record. Pending laundry tasks exist.'); 
    END IF; 
END;
/

-- Optional: demo trigger that prints a message on FRIDAY inserts
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
