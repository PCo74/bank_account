-- CONTROLER

-- CONSTANTS

-- {json} $t : translation texts
SET t = sqlpage.read_file_as_text('text.json');

-- {json} $mc : money colors
SET mc = sqlpage.read_file_as_text('money_colors.json');

-- {json} $pages : pages list
SET pages = sqlpage.read_file_as_text('pages.json');

-- {json} $p : parameters from database
SET p = SELECT json_object(
            'report', report,
            'last_statement', last_statement,
            'dec_sep', dec_sep,
            'step', step,
            'money_format', money_format
        ) FROM parameters;

-- URL PARAMETERS

-- {int} $no : number of the requested page
SET no = IFNULL($no, 0);
SET no = IIF($no < 0 OR $no > (SELECT COUNT(*) FROM json_each($pages)),
         0,
         $no);

-- {str|int} $id : record ID
SET id = IFNULL($id, '');

-- {str} $action : action to perform
SET action = IFNULL($action, '');


--SET page = CONCAT($pages->>$no, '.sql');
--SET urlname = sqlpage.path();

-- HEADER
SELECT 'dynamic' AS component,
    sqlpage.run_sql('header.sql') as properties;

-- BALANCES & LAST STATEMENT
SELECT 'dynamic' AS component,
    sqlpage.run_sql('balance.sql') AS properties;

-- REQUESTED PAGE
SELECT 'dynamic' AS component,
    sqlpage.run_sql($pages->>$no || '.sql')as properties;
