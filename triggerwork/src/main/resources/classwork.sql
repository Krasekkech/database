CREATE TABLE IF NOT EXISTS public.person
(
    id bigint NOT NULL,
    name character varying(255) ,
    CONSTRAINT person_pkey PRIMARY KEY (id)
);


CREATE OR REPLACE FUNCTION prevent_specific_person_delete()
    RETURNS TRIGGER AS $$
BEGIN
    IF OLD.id = '1' THEN
        RAISE EXCEPTION 'You cannot delete this id';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_specific_person_delete_trigger
    BEFORE DELETE ON public.person
    FOR EACH ROW
EXECUTE FUNCTION prevent_specific_person_delete();

delete from person where id = 2;


------------------------------------------------------------------------------------------------


create table log_table(
    id bigint,
    operation varchar,
    edit_date timestamp
);

CREATE OR REPLACE FUNCTION log_update_delete()
    RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        insert into log_table (id, operation, edit_date) values
            (OLD.id, 'UPDATE', now());
    return new;
    ELSIF TG_OP = 'DELETE' THEN
        insert into log_table (id, operation, edit_date) values
            (OLD.id, 'DELETE', now());
    return old;
    END IF;
    return null;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_trigger
    AFTER UPDATE OR DELETE ON public.person
    FOR EACH ROW
EXECUTE FUNCTION log_update_delete();

select * from log_table;


--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION check_insert_data()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.name IS NULL THEN
        RAISE EXCEPTION 'empname cannot be null';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_insert_data_trigger
    BEFORE INSERT ON public.person
    FOR EACH ROW
EXECUTE FUNCTION check_insert_data();

insert into person(id, name) values (2, 'admin');
update person set id=3 where id = 2

