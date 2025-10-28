-- APPLICATION CONTROLLER

-- GLOBAL VARIABLES

-- {json} $t : translation texts
SET t = sqlpage.read_file_as_text('text.json');

-- {json} $c : application constants
SET c = sqlpage.read_file_as_text('constants.json');

-- {json} $p : parameters from database
SET p = SELECT 
    json_object(
        'report', report,
        'last_statement', last_statement,
        'search_area', search_area,
        'dark_theme', dark_theme
        ) FROM parameters;

-- GLOBAL URL PARAMETERS

-- {int} $no : number of the requested page
SET no = IFNULL($no, 0);
SET no = IIF($no < 0 OR $no >=
            (SELECT COUNT(*) FROM json_each($c->'pages')),
            0, $no);

-- {str|int} $id : record ID
SET id = IFNULL($id, '');

-- {str} $action : action to perform
SET action = IFNULL($action, '');

-- HEADER

SELECT 'dynamic' AS component,
    sqlpage.run_sql('header.sql') as properties;

-- REQUESTED PAGE

SELECT 'dynamic' AS component,
    sqlpage.run_sql($c->'pages'->>CAST($no AS INTEGER) || '.sql')as properties;
