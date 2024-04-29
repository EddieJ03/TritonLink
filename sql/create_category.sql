-- Define the category table
CREATE TABLE category (
    category_id VARCHAR(20) PRIMARY KEY,
    category_name VARCHAR(100),
    min_gpa FLOAT,
    required_units INTEGER,
    is_concentration BOOLEAN
);