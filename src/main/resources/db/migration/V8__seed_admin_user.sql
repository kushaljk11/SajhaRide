INSERT INTO users
    (fullName, email, password, phoneNumber, address, profileImagePath, role, trustScore, accountStatus)
SELECT
    'Admin User',
    'admin@gmail.com',
    '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',
    NULL,
    NULL,
    NULL,
    'ADMIN',
    0,
    'ACTIVE'
WHERE NOT EXISTS (
    SELECT 1
    FROM users
    WHERE email = 'admin@gmail.com'
);



