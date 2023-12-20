CREATE FUNCTION  dbo.get_marketing_template(
    @net_worth DECIMAL,
    @income DECIMAL,
    @number_credit_cards INT,
    @number_children INT,
    @age INT,
    @credit_rating INT,
    @number_cars INT
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @marketing_template VARCHAR(100) = '';

    IF (@net_worth > 1000000 OR @income > 200000)
        SET @marketing_template = @marketing_template + 'HighValue';

    IF (@number_children > 3 OR @number_credit_cards > 5)
        SET @marketing_template = @marketing_template + 'Expenses';

    IF (@age > 45)
        SET @marketing_template = @marketing_template + 'Boomer';

    IF (@income < 5000 OR @credit_rating < 600 OR @net_worth < 100000)
        SET @marketing_template = @marketing_template + 'MoneyAlert';

    IF (@number_cars > 3 OR @number_credit_cards > 7)
        SET @marketing_template = @marketing_template + 'Spender';

    IF (@age < 25 OR @net_worth > 1000000)
        SET @marketing_template = @marketing_template + 'Inherited';

    RETURN SUBSTRING(@marketing_template, 1, LEN(@marketing_template));
END;

WITH ProspectTransformation as (
	SELECT P.AgencyID
		, ( SELECT SK_DateID 
			FROM [dwh].[dbo].[DimDate]
			WHERE DateValue = (SELECT BatchDate FROM [dwh].[raw].[BatchDate]) ) AS SK_RecordDateID
		, ( SELECT SK_DateID 
			FROM [dwh].[dbo].[DimDate]
			WHERE DateValue = (SELECT BatchDate FROM [dwh].[raw].[BatchDate]) ) AS SK_UpdateDateID
		, (  
			SELECT count(*)
			FROM [dwh].[dbo].[DimCustomer] DC 
			WHERE UPPER( DC.FirstName ) = UPPER( P.FirstName )	
				AND UPPER( DC.LastName ) = UPPER( P.LastName )
				AND UPPER( DC.AddressLine1 ) = UPPER( P.AddressLine1 )
				AND UPPER( DC.AddressLine2 ) = UPPER( P.AddressLine2 )
				AND UPPER( DC.PostalCode ) = UPPER( P.PostalCode )
				AND DC.Status='Active'
		) AS checkstatus
		, P.LastName
		, P.FirstName
		, P.MiddleInitial
		, P.Gender
		, P.AddressLine1
		, P.AddressLine2
		, P.PostalCode
		, P.City
		, P.State
		, P.Country
		, P.Phone
		, P.Income
		, P.NumberCars
		, P.NumberChildren
		, P.MaritalStatus
		, P.Age
		, P.CreditRating
		, P.OwnOrRentFlag
		, P.Employer
		, P.NumberCreditCards
		, P.NetWorth
		,dbo.get_marketing_template(P.NetWorth, P.Income, P.NumberCreditCards, P.NumberChildren, P.AGE, P.CreditRating, P.NumberCars) as MarketingNameplate 
	FROM raw.Prospect P)
Select AgencyID
      ,SK_RecordDateID
	  ,SK_UpdateDateID
	  ,1 as BatchID
	  ,case 
	   when checkstatus=0 then 'False' 
	   when checkstatus=1 then 'True' end as IsCustomer
	  ,LastName
	  ,FirstName
	  ,MiddleInitial
	  ,Gender
	  ,AddressLine1
	  ,AddressLine2
	  ,PostalCode
	  ,City
	  ,State
	  ,Country
	  ,Phone
	  ,Income
	  ,NumberCars
	  ,NumberChildren
	  ,MaritalStatus
	  ,Age
	  ,CreditRating
	  ,OwnOrRentFlag
	  ,Employer
	  ,NumberCreditCards
	  ,NetWorth
	  ,MarketingNameplate
into Prospect
from ProspectTransformation

