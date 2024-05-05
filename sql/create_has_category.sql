CREATE TABLE has_category (
    degree_id VARCHAR(20),
    category_id VARCHAR(20),
    FOREIGN KEY (degree_id) REFERENCES degree(degree_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES category(category_id) ON DELETE CASCADE
);