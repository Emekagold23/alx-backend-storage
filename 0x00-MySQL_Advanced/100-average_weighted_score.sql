-- creates a stored procedure ComputeAverageWeightedScoreForUser that
-- computes and stores the average weighted score for a student.
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;
DELIMITER $$

CREATE PROCEDURE ComputeAverageWeightedScoreForUser (IN user_id INT)
BEGIN
    DECLARE total_weighted_score DECIMAL(10, 2) DEFAULT 0;
    DECLARE total_weight DECIMAL(10, 2) DEFAULT 0;
    DECLARE average_score DECIMAL(10, 2) DEFAULT 0;

    -- Calculate total weighted score
    SELECT SUM(corrections.score * projects.weight)
    INTO total_weighted_score
    FROM corrections
    INNER JOIN projects ON corrections.project_id = projects.id
    WHERE corrections.user_id = user_id;

    -- Calculate total weight
    SELECT SUM(projects.weight)
    INTO total_weight
    FROM corrections
    INNER JOIN projects ON corrections.project_id = projects.id
    WHERE corrections.user_id = user_id;

    -- Compute the average weighted score
    IF total_weight = 0 THEN
        SET average_score = 0;
    ELSE
        SET average_score = total_weighted_score / total_weight;
    END IF;

    -- Update the user's average score
    UPDATE users
    SET average_score = average_score
    WHERE id = user_id;
END $$

DELIMITER ;
