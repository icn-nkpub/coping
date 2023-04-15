CREATE TABLE profiles (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID UNIQUE,
    first_name TEXT,
    second_name TEXT,
    email TEXT,
    breathing_time REAL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX user_id_idx ON profiles
    USING BRIN (user_id);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users" ON "public"."profiles"
    AS PERMISSIVE FOR ALL TO public
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);