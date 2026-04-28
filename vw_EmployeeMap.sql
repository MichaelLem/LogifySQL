SELECT  
    e.EmployeeId,
    e.HourlyRate,
    e.DateHired,
    e.IsActive,

    p.PersonId,
    p.FirstName,
    p.LastName,
    p.Email,
    p.PhoneNumber,
    p.SSN,

    ua.UserAccountId,
    ua.Username,
    ua.PasswordHash,

    c.CompanyId,
    c.CompanyName,

    te.TimeEntryId,
    te.ClockIn,
    te.ClockOut,
    te.Notes,

    pp.PayPeriodId,
    pp.StartDate,
    pp.EndDate,

    r.RoleId,
    r.RoleName

FROM dbo.Employee e
INNER JOIN dbo.Company c 
    ON c.CompanyId = e.CompanyId

INNER JOIN dbo.Person p 
    ON p.EmployeeId = e.EmployeeId

INNER JOIN dbo.Role r 
    ON r.RoleId = e.RoleId

INNER JOIN dbo.TimeEntry te 
    ON te.EmployeeId = e.EmployeeId

INNER JOIN dbo.PayPeriod pp 
    ON pp.PayPeriodId = te.PayPeriodId

INNER JOIN dbo.UserAccount ua 
    ON ua.EmployeeId = e.EmployeeId;