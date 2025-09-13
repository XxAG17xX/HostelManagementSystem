-- Enable DBMS_OUTPUT to see messages from procedures/triggers
SET SERVEROUTPUT ON

-- Cursor demo (one copy)
DECLARE 
    v_roll_no number := 102203930; 
    v_room_no number; 
    CURSOR student_cursor IS 
        SELECT student_room_no FROM student_r WHERE roll_no = v_roll_no; 
BEGIN 
    OPEN student_cursor; 
    FETCH student_cursor INTO v_room_no; 
    IF student_cursor%FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Room number of student with roll number ' || v_roll_no || ' is ' || v_room_no); 
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Student with roll number ' || v_roll_no || ' not found.'); 
    END IF; 
    CLOSE student_cursor; 
EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM); 
END;
/
