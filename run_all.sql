-- Run everything in order
@schema/01_tables.sql
@logic/procedures.sql
@logic/triggers.sql
@data/seed.sql
@queries/reports.sql
@queries/demos.sql
