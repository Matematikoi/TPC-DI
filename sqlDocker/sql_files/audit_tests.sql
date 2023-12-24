/* 
    Scripts obtained from TPC-DI test queries
*/

-- DimBroker test script
select 'DimBroker row count' as TestType, 1 as BatchNumber, case when
	(select count(*) from DimBroker) =
	(select Value from Audit where DataSet = 'DimBroker' and Attribute = 'HR_BROKERS')
then 'OK' else 'Mismatch' end, 'Actual row count matches Audit table'
union
select 'DimBroker distinct keys', 1, case when
	(select count(distinct SK_BrokerID) from DimBroker) =
	(select Value from Audit where DataSet = 'DimBroker' and Attribute = 'HR_BROKERS')
then 'OK' else 'Not unique' end, 'All SKs are distinct'
union
select 'DimBroker BatchID', 1, case when
	(select count(*) from DimBroker where BatchID <> 1) = 0
then 'OK' else 'Not batch 1' end, 'All rows report BatchID = 1'
union
select 'DimBroker IsCurrent', 1, case when
	(select count(*) from DimBroker where IsCurrent <> 1) = 0
then 'OK' else 'Not current' end, 'All rows have IsCurrent = 1'
union
select 'DimBroker EffectiveDate', 1, case when
	(select count(*) from DimBroker where EffectiveDate <> '1950-01-01') = 0
then 'OK' else 'Wrong date' end, 'All rows have Batch1 BatchDate as EffectiveDate'
union
select 'DimBroker EndDate', 1, case when
	(select count(*) from DimBroker where EndDate <> '9999-12-31') = 0
then 'OK' else 'Mismatch' end, 'All rows have end of time as EndDate'
-- DimCompany test scripts
union
select 'DimCompany distinct keys', 1, case when
	(select count(*) from DimCompany) =
	(select sum(Value) from Audit where DataSet = 'DimCompany' and Attribute = 'FW_CMP')
then 'OK' else 'Not unique' end, 'Actual row count matches Audit table'
union
select 'DimCompany distinct keys', 1, case when
	(select count(distinct SK_CompanyID) from DimCompany) =
	(select count(*) from DimCompany)
then 'OK' else 'Not unique' end, 'All SKs are distinct'
union
select 'DimCompany EndDate', 1, case when
	(select count(*) from DimCompany) =
	(select count(*) from DimCompany a join DimCompany b on a.CompanyID = b.CompanyID and a.EndDate = b.EffectiveDate) +
	(select count(*) from DimCompany where EndDate = '9999-12-31')
then 'OK' else 'Dates not aligned' end, 'EndDate of one record matches EffectiveDate of another, or the end of time'
union
select 'DimCompany Overlap', 1, case when (
	select count(*)
	from DimCompany a
	join DimCompany b on a.CompanyID = b.CompanyID and a.SK_CompanyID <> b.SK_CompanyID and a.EffectiveDate >= b.EffectiveDate and a.EffectiveDate < b.EndDate
) = 0
then 'OK' else 'Dates overlap' end, 'Date ranges do not overlap for a given company'
union
select 'DimCompany End of Time', 1, case when
	(select count(distinct CompanyID) from DimCompany) =
	(select count(*) from DimCompany where EndDate = '9999-12-31')
then 'OK' else 'End of tome not reached' end, 'Every company has one record with a date range reaching the end of time'
union
select 'DimCompany consolidation', 1, case when
	(select count(*) from DimCompany where EffectiveDate = EndDate) = 0
then 'OK' else 'Not consolidated' end, 'No records become effective and end on the same day'
union
select 'DimCompany batches', 1, case when
	(select count(distinct BatchID) from DimCompany) = 1 and
	(select max(BatchID) from DimCompany) = 1
then 'OK' else 'Mismatch' end, 'BatchID values must match Audit table'
union
select 'DimCompany EffectiveDate', BatchID, Result, 'All records from a batch have an EffectiveDate in the batch time window' from (
	select distinct BatchID, (
		case when (
			select count(*) from DimCompany
			where BatchID = a.BatchID and (
				EffectiveDate < (select Date from Audit where DataSet = 'Batch' and Attribute = 'FirstDay' and BatchID = a.BatchID) or
				EffectiveDate > (select Date from Audit where DataSet = 'Batch' and Attribute = 'LastDay' and BatchID = a.BatchID) )
		) = 0
		then 'OK' else 'Data out of range - see ticket #71' end
	) as Result
	from Audit a where BatchID in (1, 2, 3)
) o
union
select 'DimCompany Status', 1, case when
	(select count(*) from DimCompany where Status not in ('Active', 'Inactive')) = 0
then 'OK' else 'Bad value' end, 'All Status values are valid'
union
select 'DimCompany distinct names', 1, case when	(
	select count(*)
	from DimCompany a
	join DimCompany b on a.Name = b.Name and a.CompanyID <> b.CompanyID
) = 0
then 'OK' else 'Mismatch' end, 'Every company has a unique name'
union
select 'DimCompany Industry', 1, case when
	(select count(*) from DimCompany) =
	(select count(*) from DimCompany where Industry in (select distinct IN_NAME from Industry))
then 'OK' else 'Bad value' end, 'Industry values are from the Industry table'
union
select 'DimCompany SPrating', 1, case when (
	select count(*) from DimCompany
	where SPrating not in (	'AAA','AA','A','BBB','BB','B','CCC','CC','C','D','AA+','A+','BBB+','BB+','B+','CCC+','AA-','A-','BBB-','BB-','B-','CCC-' )
	  and SPrating is not null
) = 0
then 'OK' else 'Bad value' end, 'All SPrating values are valid'
union
select 'DimCompany Country', 1, case when (
	select count(*) from DimCompany
	where Country not in ( 'Canada', 'United States of America', '' )
	  and Country is not null
) = 0
then 'OK' else 'Bad value' end, 'All Country values are valid'


