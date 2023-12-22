UPDATE dimCustomer
SET 
    dimCustomer.AgencyId=p.AgencyID , 
    dimCustomer.CreditRating=p.CreditRating ,
    dimCustomer.NetWorth =p.NetWorth ,
    dimCustomer.MarketingNameplate = p.MarketingNameplate
FROM dimCustomer c
INNER JOIN
Prospect p
ON UPPER(p.FirstName)  = UPPER(c.FirstName)
AND UPPER(p.LastName) = UPPER(c.LastName)
AND UPPER(p.PostalCode) = UPPER(c.PostalCode)
AND UPPER(p.AddressLine1) = UPPER(c.AddressLine1)
AND UPPER(p.AddressLine2) = UPPER(c.AddressLine2)
WHERE
c.IsCurrent =1;