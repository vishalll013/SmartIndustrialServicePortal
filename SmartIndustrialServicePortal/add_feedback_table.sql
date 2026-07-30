CREATE TABLE IF NOT EXISTS feedback (
  feedback_id INT AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  employee_name VARCHAR(100) NOT NULL,
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  feedback TEXT NOT NULL,
  is_reviewed TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- Seed initial feedback for testing
INSERT INTO feedback (employee_id, employee_name, rating, feedback, is_reviewed)
VALUES 
(1, 'Rajesh Kumar', 5, 'Great portal! Submission was fast and intuitive.', 1),
(2, 'Amit Patel', 4, 'Very useful system, though electrical response times could be slightly faster.', 0)
ON DUPLICATE KEY UPDATE feedback_id = feedback_id;
