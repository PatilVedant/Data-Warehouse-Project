with stg_bids_count as (
    select BID_ITEM_ID, count(BID_ID) as ITEM_BIDS_COUNT from {{source('VBAY', 'VB_BIDS')}} group by BID_ITEM_ID
),
stg_item_first_bid as (
    select BID_ITEM_ID, min(BID_DATETIME) as ITEM_FIRST_BID_DATE from {{source('VBAY', 'VB_BIDS')}} group by BID_ITEM_ID
),
stg_items as (
    select * from {{source('VBAY','VB_ITEMS')}}
)

select stg_items.ITEM_ID,
 {{dbt_utils.generate_surrogate_key(['stg_items.ITEM_ID'])}} as ITEM_KEY,
 {{dbt_utils.generate_surrogate_key(['stg_items.ITEM_SELLER_USER_ID'])}} as ITEM_SELLER_USER_KEY,
 {{dbt_utils.generate_surrogate_key(['stg_items.ITEM_BUYER_USER_ID'])}} as ITEM_BUYER_USER_KEY,
 stg_items.ITEM_RESERVE,
 stg_items.ITEM_SOLD,
 stg_items.ITEM_SOLDAMOUNT,
replace(to_date(stg_items.ITEM_ENDDATE)::varchar,'-','')::int as ITEM_ENDDATE_KEY, /*Not sure how does this change date? lol*/
replace(to_date(stg_item_first_bid.ITEM_FIRST_BID_DATE)::varchar,'-','')::int as ITEM_FIRST_BID_DATE_KEY,
 stg_bids_count.ITEM_BIDS_COUNT,
 (stg_items.ITEM_SOLDAMOUNT - stg_items.ITEM_RESERVE) as ITEM_SALES_SURPLUS,
 datediff(day,stg_item_first_bid.ITEM_FIRST_BID_DATE, stg_items.ITEM_ENDDATE) as item_duration_in_days

 from stg_items left join stg_bids_count on stg_items.ITEM_ID = stg_bids_count.BID_ITEM_ID
 left join stg_item_first_bid on  stg_items.ITEM_ID = stg_item_first_bid.BID_ITEM_ID 
 

