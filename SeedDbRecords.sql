/* ============================================================
   Seed 100 fake records into Employee + Person
   - Uses CompanyId = 1
   - Assumes Role table already has RoleId values 1..N
   - Inserts 100 Employees, captures their EmployeeIds,
     then inserts 100 Persons (1:1) with unique emails
   ============================================================ */

SET NOCOUNT ON;

BEGIN TRAN;

-- Pick some RoleIds to rotate through (uses existing Role table)
DECLARE @RoleCount INT = (SELECT COUNT(*) FROM dbo.Role);
IF @RoleCount = 0
BEGIN
    ROLLBACK;
    THROW 50000, 'Role table has no rows. Insert roles first.', 1;
END;

-- Capture inserted EmployeeIds so we can insert matching Person rows
DECLARE @NewEmployees TABLE
(
    RowNum INT IDENTITY(1,1) NOT NULL,
    EmployeeId INT NOT NULL
);

;WITH N AS
(
    SELECT TOP (100)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Employee
(
    CompanyId,
    RoleId,
    IsActive,
    HourlyRate,
    DateHired,
    CreatedAt,
    UpdatedAt
)
OUTPUT inserted.EmployeeId INTO @NewEmployees(EmployeeId)
SELECT
    1 AS CompanyId,

    -- Rotate through existing RoleIds
    (SELECT RoleId
     FROM (
        SELECT RoleId, ROW_NUMBER() OVER (ORDER BY RoleId) AS rn
        FROM dbo.Role
     ) r
     WHERE r.rn = ((N.n - 1) % @RoleCount) + 1
    ) AS RoleId,

    -- ~85% active
    CASE WHEN N.n % 7 = 0 THEN 0 ELSE 1 END AS IsActive,

    -- HourlyRate: 18.00 to ~52.50
    CAST(18.00 + (N.n % 35) * 1.00 + (CASE WHEN N.n % 3 = 0 THEN 0.50 ELSE 0 END) AS DECIMAL(6,2)) AS HourlyRate,

    -- DateHired spread over last ~4 years
    DATEADD(DAY, -1 * (N.n * 13), CAST(GETDATE() AS date)) AS DateHired,

    -- CreatedAt: based on hire date + some hours
    DATEADD(HOUR, (N.n % 24), CAST(DATEADD(DAY, -1 * (N.n * 13), CAST(GETDATE() AS date)) AS datetime)) AS CreatedAt,

    -- UpdatedAt: NULL for some rows, otherwise later than CreatedAt
    CASE
        WHEN N.n % 5 = 0 THEN NULL
        ELSE DATEADD(DAY, (N.n % 60),
             DATEADD(HOUR, (N.n % 24), CAST(DATEADD(DAY, -1 * (N.n * 13), CAST(GETDATE() AS date)) AS datetime))
        )
    END AS UpdatedAt
FROM N;

-- Now insert matching Person rows (1 per employee)
;WITH NameSeed AS
(
    SELECT
        ne.RowNum,
        ne.EmployeeId,

        CHOOSE(((ne.RowNum - 1) % 20) + 1,
            'Alex','Maria','Sam','Jordan','Taylor','Chris','Jamie','Morgan','Casey','Riley',
            'Avery','Quinn','Drew','Parker','Cameron','Reese','Hayden','Payton','Rowan','Skyler'
        ) AS FirstName,

        CHOOSE(((ne.RowNum - 1) % 20) + 1,
            'Johnson','Chen','Patel','Garcia','Martinez','Nguyen','Brown','Davis','Lopez','Wilson',
            'Anderson','Thomas','Jackson','White','Harris','Martin','Thompson','Moore','Lee','Clark'
        ) AS LastName
    FROM @NewEmployees ne
)
INSERT INTO dbo.Person
(
    EmployeeId,
    FirstName,
    LastName,
    Email,
    PhoneNumber,
    CreatedAt,
    UpdatedAt
)
SELECT
    ns.EmployeeId,
    ns.FirstName,
    ns.LastName,

    -- Unique email guaranteed by EmployeeId
    LOWER(ns.FirstName) + '.' + LOWER(ns.LastName) + '+' + CAST(ns.EmployeeId AS varchar(12)) + '@logify.test' AS Email,

    -- Simple fake phone number
    '555-' + RIGHT('000' + CAST((100 + (ns.RowNum % 900)) AS varchar(3)), 3) + '-' +
           RIGHT('0000' + CAST((1000 + (ns.RowNum * 37) % 9000) AS varchar(4)), 4) AS PhoneNumber,

    GETDATE() AS CreatedAt,

    CASE
        WHEN ns.RowNum % 6 = 0 THEN NULL
        ELSE DATEADD(DAY, (ns.RowNum % 45), GETDATE())
    END AS UpdatedAt
FROM NameSeed ns;

COMMIT;

-- Quick verification
SELECT COUNT(*) AS EmployeeCount FROM dbo.Employee WHERE CompanyId = 1;
SELECT COUNT(*) AS PersonCount FROM dbo.Person;