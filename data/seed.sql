-- Seed data using your procedures

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

BEGIN  
    add_complaint(1, 102203942, 'BAD service', 'mess');  
    add_complaint(2, 102203930, 'Avg', 'laundry');  
    add_complaint(3, 102213029, 'Untidy', 'mess');  
    add_complaint(4, 102203086, 'Late', 'laundry');  
END;
/

BEGIN  
    add_mess_review(1, 'Good food');  
    add_mess_review(2, 'Excellent service');  
    add_mess_review(3, 'Average quality');  
    add_mess_review(4, 'Poor hygiene');  
END;
/

-- Add laundry with computed sr_no sequence logic like in your script
DECLARE 
    sno NUMBER; 
BEGIN 
    SELECT NVL(MAX(sr_no), 0) + 1 INTO sno FROM laundry_table; 
    add_laundry(sno,   102203930, TO_DATE('12-08-2002', 'dd-mm-yyyy'), TO_DATE('12-07-2022', 'dd-mm-yyyy'), 'n'); 
    add_laundry(sno+1, 102203942, TO_DATE('05-08-2002', 'dd-mm-yyyy'), TO_DATE('12-02-2022', 'dd-mm-yyyy'), 'n'); 
    add_laundry(sno+2, 102213029, TO_DATE('08-08-2002', 'dd-mm-yyyy'), TO_DATE('12-09-2022', 'dd-mm-yyyy'), 'n'); 
    add_laundry(sno+3, 102207843, TO_DATE('16-08-2002', 'dd-mm-yyyy'), TO_DATE('12-12-2022', 'dd-mm-yyyy'), 'n'); 
    add_laundry(sno+4, 102209971, TO_DATE('25-08-2002', 'dd-mm-yyyy'), TO_DATE('12-01-2022', 'dd-mm-yyyy'), 'n'); 
END;
/

BEGIN 
    update_laundry(5,'y');  
END;
/
