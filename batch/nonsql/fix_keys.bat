REM fix tables that do not depend on other tables

python key_repair.py --main_file 01_POSITION.sql --main_file_pk_col 0 --main_file_no_fk --main_file_pk_generate --new_file_default_name

python key_repair.py --main_file 04_RECIPE.sql --main_file_pk_col 0 --main_file_no_fk --main_file_pk_generate --new_file_default_name

python key_repair.py --main_file 06_INGREDIENT_STOCK.sql --main_file_pk_col 0 --main_file_no_fk --main_file_pk_generate --new_file_default_name

python key_repair.py --main_file 07_SUPPLIER.sql --main_file_pk_col 0 --main_file_no_fk --main_file_pk_generate --new_file_default_name

python key_repair.py --main_file 11_RESOURCES.sql --main_file_pk_col 0 --main_file_no_fk --main_file_pk_generate --new_file_default_name

REM fix tables that depend on other tables. Foreign file is fixed file (with _new_)

python "c:/Users/Mike/Dysk Google/uczelnia/__2_sem1/advanced databases/AdvDBsA3/batch/key_repair.py" --main_file 02_EMPLOYEE.sql --main_file_pk_col 0 --main_file_fk_col 4 --foreign_file _new_01_POSITION.sql --foreign_file_pk_col 0 --main_file_pk_generate --new_file_default_name

python "c:/Users/Mike/Dysk Google/uczelnia/__2_sem1/advanced databases/AdvDBsA3/batch/key_repair.py" --main_file 03_SCHEDULE.sql --main_file_pk_col 0 --main_file_fk_col 2 --foreign_file _new_02_EMPLOYEE.sql --foreign_file_pk_col 0 --main_file_pk_generate --new_file_default_name

python "c:/Users/Mike/Dysk Google/uczelnia/__2_sem1/advanced databases/AdvDBsA3/batch/key_repair.py" --main_file 05_RECIPE_DUTY.sql --main_file_pk_col 0 --main_file_fk_col 1 --foreign_file _new_04_RECIPE.sql --foreign_file_pk_col 0 --main_file_pk_generate --new_file_default_name

python "c:/Users/Mike/Dysk Google/uczelnia/__2_sem1/advanced databases/AdvDBsA3/batch/key_repair.py" --main_file 09_SUPPLY_REQUEST.sql --main_file_pk_col 0 --main_file_fk_col 2 --foreign_file _new_06_INGREDIENT_STOCK.sql --foreign_file_pk_col 0 --main_file_pk_generate --new_file_default_name

python "c:/Users/Mike/Dysk Google/uczelnia/__2_sem1/advanced databases/AdvDBsA3/batch/key_repair.py" --main_file 12_COOK_LOG.sql --main_file_pk_col 0 --main_file_fk_col 3 --foreign_file _new_04_RECIPE.sql --foreign_file_pk_col 0 --main_file_pk_generate --new_file_default_name

REM fix junction tables (no pk). These tables need to be ran through script twice - both times without generating main file PK, each for one FK

python "c:/Users/Mike/Dysk Google/uczelnia/__2_sem1/advanced databases/AdvDBsA3/batch/key_repair.py" --main_file 08_SUPPLIER_STOCK.sql --main_file_pk_col 0 --main_file_fk_col 0 --foreign_file _new_07_SUPPLIER.sql --foreign_file_pk_col 0 --main_file_pk_ignore --new_file_default_name
python "c:/Users/Mike/Dysk Google/uczelnia/__2_sem1/advanced databases/AdvDBsA3/batch/key_repair.py" --main_file _new_08_SUPPLIER_STOCK.sql --main_file_pk_col 0 --main_file_fk_col 3 --foreign_file _new_06_INGREDIENT_STOCK.sql --foreign_file_pk_col 0 --main_file_pk_ignore --new_file_default_name

python "c:/Users/Mike/Dysk Google/uczelnia/__2_sem1/advanced databases/AdvDBsA3/batch/key_repair.py" --main_file 10_INGREDIENT.sql --main_file_pk_col 0 --main_file_fk_col 0 --foreign_file _new_06_INGREDIENT_STOCK.sql --foreign_file_pk_col 0 --main_file_pk_ignore --new_file_default_name
python "c:/Users/Mike/Dysk Google/uczelnia/__2_sem1/advanced databases/AdvDBsA3/batch/key_repair.py" --main_file _new_10_INGREDIENT.sql --main_file_pk_col 0 --main_file_fk_col 1 --foreign_file _new_04_RECIPE.sql --foreign_file_pk_col 0 --main_file_pk_ignore --new_file_default_name