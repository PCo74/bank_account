-- UPDATE

UPDATE parameters
SET
    report = :report,
    last_statement = :last_statement,
    dec_sep = :dec_sep,
    dec_nb = :dec_nb,
    currency = :currency
WHERE $action = 'update'
RETURNING 'redirect' AS component, 'parameters' AS link

select 
    'alert'              as component,
    'Erreur'              as title,
    '«**' || $action || '**» : action inconnue !' as description_md,
    'alert-circle'       as icon,
    'red'                as color;
select 
    'mvts'       as link,
    'Retourner aux mouvements' as title;