-- Creates a stored procedure ComputeAverageWeightedScoreForUsers that
-- computes and store the average weighted score for all students.
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;
DELIMITER $$

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers ()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE user_id INT;
    DECLARE total_weighted_score DECIMAL(10, 2);
    DECLARE total_weight DECIMAL(10, 2);
    DECLARE cur CURSOR FOR SELECT id FROM users;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open the cursor
    OPEN cur;

    -- Loop through all users
    read_loop: LOOP
        FETCH cur INTO user_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Calculate total weighted score for the current user
        SELECT SUM(corrections.score * projects.weight)
        INTO total_weighted_score
        FROM corrections
        INNER JOIN projects ON corrections.project_id = projects.id
        WHERE corrections.user_id = user_id;

        -- Calculate total weight for the current user
        SELECT SUM(projects.weight)
        INTO total_weight
        FROM corrections
        INNER JOIN projects ON corrections.project_id = projects.id
        WHERE corrections.user_id = user_id;

        -- Compute and update the average weighted score for the current user
        IF total_weight IS NULL OR total_weight = 0 THEN
            UPDATE users
            SET average_score = 0
            WHERE id = user_id;
        ELSE
            UPDATE users
            SET average_score = total_weighted_score / total_weight
            WHERE id = user_id;
        END IF;
    END LOOP;

    -- Close the cursor
    CLOSE cur;
END $$

DELIMITER ;
