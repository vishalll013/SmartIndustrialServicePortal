CREATE DATABASE IF NOT EXISTS smart_industrial_portal;

USE smart_industrial_portal;

CREATE TABLE IF NOT EXISTS employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    department VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    title VARCHAR(255),
    description TEXT,
    category VARCHAR(100),
    priority VARCHAR(50),
    status VARCHAR(50) DEFAULT 'Pending',
    image_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100),
    password VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT UNIQUE,
    assigned_to VARCHAR(100),
    assigned_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completion_date TIMESTAMP NULL,
    FOREIGN KEY (complaint_id) REFERENCES complaints(complaint_id) ON DELETE CASCADE
);

-- Seed Admin credentials (password: admin123)
INSERT INTO admin(username, password)
SELECT 'admin', 'scrypt:32768:8:1$UZPV0XlPPrRAamAO$251dcb5a20dfa8549d64a874becfaa07d13aefee1ccd71acfd0a4fed4f085b65e74194a7fdbb9c98cfa48f801b38867a800898df1cf3f1201d1d8b48123e9d3a'
WHERE NOT EXISTS (SELECT 1 FROM admin WHERE username = 'admin');

-- Seed Employee credentials (password for all: pwd123)
INSERT INTO employees(employee_id, full_name, department, email, password)
VALUES 
(1, 'Rajesh Kumar', 'IT Support', 'rajesh.k@nlc.com', 'scrypt:32768:8:1$Hjus5TNX7XVuyES9$8c98a91c2ca3cca56e178e12707ee123a23828c7c810a6adc332121a038f764f829c95c43680683aea9a861f8a2ff865c8412a99e67fb3da165cb39b553c4e97'),
(2, 'Amit Patel', 'Electrical', 'amit.p@nlc.com', 'scrypt:32768:8:1$Hjus5TNX7XVuyES9$8c98a91c2ca3cca56e178e12707ee123a23828c7c810a6adc332121a038f764f829c95c43680683aea9a861f8a2ff865c8412a99e67fb3da165cb39b553c4e97'),
(3, 'Suresh Sharma', 'Mining Infrastructure', 'suresh.s@nlc.com', 'scrypt:32768:8:1$Hjus5TNX7XVuyES9$8c98a91c2ca3cca56e178e12707ee123a23828c7c810a6adc332121a038f764f829c95c43680683aea9a861f8a2ff865c8412a99e67fb3da165cb39b553c4e97')
ON DUPLICATE KEY UPDATE employee_id=employee_id;

-- Seed Complaints
INSERT INTO complaints(complaint_id, employee_id, title, description, category, priority, status, image_path, created_at)
VALUES
(1, 1, 'Control Room Server Offline', 'The main control room database server is not responding to ping requests. Needs immediate IT attention.', 'IT Support', 'Critical', 'Assigned', '', '2026-06-15 08:30:00'),
(2, 2, 'Transformer Sparking near Gate 2', 'Substation transformer 3 has visible sparking and a humming sound. Safety concern.', 'Safety Issue', 'Critical', 'In Progress', '', '2026-06-18 10:15:00'),
(3, 1, 'Office Water Purifier Leaking', 'Drinking water filter on the second floor of the admin block is leaking continuously.', 'Water Supply', 'Low', 'Pending', '', '2026-06-25 14:00:00'),
(4, 3, 'Conveyor Belt Motor Failure', 'Conveyor belt C-4 motor has stopped functioning. Needs mechanical/electrical support.', 'Equipment Repair', 'High', 'Resolved', '', '2026-06-10 09:00:00'),
(5, 2, 'Corridor Lighting Broken', 'Multiple fluorescent tubes are blinking or completely fused in Corridor B.', 'Electrical', 'Medium', 'Resolved', '', '2026-06-12 11:30:00')
ON DUPLICATE KEY UPDATE complaint_id=complaint_id;

-- Seed Assignments
INSERT INTO assignments(assignment_id, complaint_id, assigned_to, assigned_date, completion_date)
VALUES
(1, 1, 'Technician Venkat (IT)', '2026-06-15 09:00:00', NULL),
(2, 2, 'Officer Ramesh (Safety)', '2026-06-18 10:30:00', NULL),
(3, 4, 'Tech Balaji (Mechanical)', '2026-06-10 09:30:00', '2026-06-10 13:00:00'),
(4, 5, 'Tech Karthik (Electrical)', '2026-06-12 12:00:00', '2026-06-12 15:30:00')
ON DUPLICATE KEY UPDATE assignment_id=assignment_id;


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

-- Seed initial feedback
INSERT INTO feedback (employee_id, employee_name, rating, feedback, is_reviewed)
VALUES 
(1, 'Rajesh Kumar', 5, 'Great portal! Submission was fast and intuitive.', 1),
(2, 'Amit Patel', 4, 'Very useful system, though electrical response times could be slightly faster.', 0)
ON DUPLICATE KEY UPDATE feedback_id = feedback_id;


