INSERT INTO Prospect
	SELECT AgencyID
		, ( SELECT SK_DateID 
			FROM DimDate
			WHERE DateValue = (SELECT BatchDate FROM raw.BatchDate) ) AS SK_RecordDateID
		, ( SELECT SK_DateID 
			FROM DimDate
			WHERE DateValue = (SELECT BatchDate FROM raw.BatchDate) ) AS SK_UpdateDateID
		, 1 AS BatchID
		, (  
			SELECT COUNT(*)
			FROM DimCustomer DC 
			WHERE UPPER( DC.FirstName ) = UPPER( P.FirstName )	
				AND UPPER( DC.LastName ) = UPPER( P.LastName )
				AND UPPER( DC.AddressLine1 ) = UPPER( P.AddressLine1 )
				AND UPPER( DC.AddressLine2 ) = UPPER( P.AddressLine2 )
				AND UPPER( DC.PostalCode ) = UPPER( P.PostalCode )
				AND DC.Status = 'ACTIVE'
		) AS IsCustomer
		, LastName
		, FirstName
		, MiddleInitial
		, Gender
		, AddressLine1
		, AddressLine2
		, PostalCode
		, City
		, State
		, Country
		, Phone
		, Income
		, numberCars
		, numberChildren
		, MaritalStatus
		, Age
		, CreditRating
		, OwnOrRentFlag
		, Employer
		, numberCreditCards
		, NetWorth
		, CASE 
			WHEN NetWorth > 1000000 OR Income > 200000 THEN 'HighValue'
			WHEN NumberChildren > 3 OR NumberCreditCards > 5 THEN 'Expenses'
			WHEN Age > 45 THEN 'Boomer'
			WHEN Income < 50000 OR CreditRating < 600 OR NetWorth < 100000 THEN 'MoneyAlert'
			WHEN NumberCars > 3 OR NumberCreditCards > 7 THEN 'Spender'
			WHEN Age < 25 AND NetWorth > 1000000 THEN 'Inherited'
		END AS MarketingNameplate 
	FROM raw.Prospect P
