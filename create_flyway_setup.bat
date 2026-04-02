@echo off
REM Create flyway migration folder and move the SQL into place (run from repo root)
mkdir "src\main\resources\db\migration"
move "create_brands_migration.sql" "src\main\resources\db\migration\V2__create_brands.sql"
echo Migration file moved to src\main\resources\db\migration\V2__create_brands.sql
echo You can now run your migration tool or rebuild the project.
pause