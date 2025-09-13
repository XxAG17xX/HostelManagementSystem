# 🏨 Hostel Management System (Oracle SQL / PL/SQL)

This project began as a **second-year DBMS project** built on **Oracle LiveSQL**, with a single SQL script and a report.  
I have now **refactored it into a structured, practical format** so that anyone can recreate and run the system easily.

---

## 📖 Project Overview
The Hostel Management System models a small hostel’s operations:
- Students, their phones, and room allocations
- Mess services and feedback
- Laundry services with tracking
- Complaint handling and restrictions

It includes **tables, constraints, PL/SQL procedures, triggers, sample data, and demo queries**.

---

## ✨ Features
- Student records (with phones & rooms)
- Mess management + feedback
- Laundry management with given/received dates
- Complaint registration + restrictions
- Stored procedures for inserting and updating data
- Triggers enforcing business rules (e.g., prevent deleting student with pending laundry)
- Demo cursor queries with `DBMS_OUTPUT`

---

## 📂 What’s inside
- `schema/01_tables.sql` → Table definitions (students, mess, laundry, complaints)
- `logic/procedures.sql` → All procedures (insert student, add complaint, add laundry, etc.)
- `logic/triggers.sql` → Triggers for business rules
- `data/seed.sql` → Inserts & procedure calls to populate sample data
- `queries/reports.sql` → `SELECT` queries to check system state
- `queries/demos.sql` → Cursor demo and transaction examples
- `run_all.sql` → Runs everything in order
- `Hostelsqlscript.sql` → **Original single SQL file** (college project version, unrefactored)
- `DBMS_PROJECT_final_copy.pdf` → **Original project report** (documentation submitted in college)

---

## ⚙️ How to Run

### Option 1: Oracle LiveSQL (easy path)
1. Copy the contents of `run_all.sql`.
2. Paste into LiveSQL script editor (or paste each file in order).
3. Run.  
   - Use `SET SERVEROUTPUT ON;` before running demos to see DBMS_OUTPUT results.

### Option 2: Local Oracle XE / SQL*Plus
```sql
@run_all.sql
```

---

## 🗒️ Notes
- This repo contains **both the old and the new**:
  - *Old*: `Hostelsqlscript.sql` + `DBMS_PROJECT_final_copy.pdf`
  - *New*: Organized files under `/schema`, `/logic`, `/data`, `/queries` with `run_all.sql`
- Old files show the **original work as submitted in college**.  
- New structure makes it **practical, reusable, and easier to maintain**.

---

## 🎯 Learning Outcomes
- Relational schema design with PK/FK  
- Writing PL/SQL procedures and triggers  
- Enforcing business rules with constraints  
- Working with Oracle LiveSQL & SQL*Plus  
- Refactoring a large script into a structured project
