-- creates a stored procedure AddBonus
-- that adds a new correction for a student
DROP PROCEDURE IF EXISTS AddBonus;
DELIMITER $$

CREATE PROCEDURE AddBonus (
    IN user_id INT,
    IN project_name VARCHAR(255),
    IN score FLOAT
)
BEGIN
    DECLARE project_id INT;

    -- Start a transaction
    START TRANSACTION;

    -- Check if the project exists, and if not, create it
    SELECT id INTO project_id
    FROM projects
    WHERE name = project_name;

    IF project_id IS NULL THEN
        INSERT INTO projects (name) VALUES (project_name);
        SELECT LAST_INSERT_ID() INTO project_id;
    END IF;

    -- Add the new correction
    INSERT INTO corrections (user_id, project_id, score)
    VALUES (user_id, project_id, score);

    -- Commit the transaction
    COMMIT;
END $$

DELIMITER ;
