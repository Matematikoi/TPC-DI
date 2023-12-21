with changing_dimensions as (
select 
	wp.W_C_ID ,
	wp.W_S_SYMB ,
	wp.W_DTS as DatePlaced,
	wn.W_DTS as DateRemoved
from
	raw.WatchHistory wp
left join raw.WatchHistory wn
on
	wp.W_C_ID = wn.W_C_ID
	and 
	wp.W_S_SYMB = wn.W_S_SYMB
	and
	wp.W_DTS < wn.W_DTS
	and
	not exists (
	select
		*
	from
		raw.WatchHistory w3
	where
		w3.W_DTS  > wn.W_DTS and
		wn.W_C_ID = w3.W_C_ID and
		wn.W_S_SYMB = w3.W_S_SYMB 
	)
) 
select 
	dc.SK_CustomerID,
	ds.SK_SecurityID,
	cd.DatePlaced,
	cd.DateRemoved,
	1 as BatchID
into
	FactWatches
from changing_dimensions cd
-- TODO: check if we should add a temporal join here, or this is enough
-- otherwise this can be a temporal join https://cs.ulb.ac.be/public/_media/teaching/infoh415/temporal_join_example.pdf
inner join DimCustomer dc on dc.CustomerID = cd.W_C_ID and cd.DatePlaced BETWEEN dc.EffectiveDate and dc.EndDate
left join DimSecurity ds on cd.W_S_SYMB = ds.Symbol and cd.DatePlaced BETWEEN ds.EffectiveDate and ds.EndDate;