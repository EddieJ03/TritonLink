DO $$ DECLARE
    r RECORD;
    enum_name RECORD;

BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
    -- Drop all enums
    FOR enum_name IN (SELECT typname FROM pg_type WHERE typtype = 'e') LOOP
        EXECUTE 'DROP TYPE IF EXISTS ' || quote_ident(enum_name.typname) || ' CASCADE';
    END LOOP;
END $$ LANGUAGE plpgsql;
