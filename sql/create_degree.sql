CREATE TYPE degree_enum AS ENUM ('Bachelor', 'BS/MS', 'MS', 'PhD');

CREATE TABLE degree (
    degree_id VARCHAR(30) PRIMARY KEY,
    degree_type degree_enum,
    university VARCHAR(100),
    total_units INTEGER NOT NULL CHECK (total_units > 0)
);