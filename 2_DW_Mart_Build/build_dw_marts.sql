
--Step 1: DW - Create star schema table.
.read '01_create_tables_dw.sql'

--Step 2: DW - Load date from .CSVs into recently created tables.
.read '02_load_schema_dw.sql'

--Step 3: Mart - Create flat mart
.read '03_create_flat_mart.sql'