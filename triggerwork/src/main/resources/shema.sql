create table loginfo(
                        id bigserial,
                        edit_date timestamp,
                        username varchar(50),
                        tablename varchar(50),
                        datainfo text,
                        pk varchar
);

CREATE OR REPLACE FUNCTION add_to_log() RETURNS trigger AS $$
BEGIN
    if TG_OP = 'INSERT' THEN
    insert into loginfo (edit_date, tablename, datainfo, pk) values
        (now(), TG_TABLE_NAME,
         coalesce(NEW.account, ' - '), NEW.id);
    return NEW;
    ELSEIF TG_OP = 'UPDATE' THEN
        insert into loginfo (edit_date, tablename, datainfo, pk) values
            (now(), TG_TABLE_NAME,
             coalesce(NEW.account, ' - '), NEW.id);
        return NEW;
    ELSEIF TG_OP = 'DELETE' THEN
        insert into loginfo (edit_date, tablename, datainfo, pk) values
            (now(), TG_TABLE_NAME,
             coalesce(NEW.account, ' - '), NEW.id);
        return OLD;

    END IF;
    return null;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_ { время наступления BEFORE | AFTER  } { событие INSERT | UPDATE | DELETE }
    ON имя_таблицы
    FOR EACH { ROW | STATEMENT}
EXECUTE { FUNCTION | PROCEDURE } имя_триггерной_функции ( аргументы )