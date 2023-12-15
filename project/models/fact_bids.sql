   select BID_ID, 
    {{dbt_utils.generate_surrogate_key(['VB_BIDS.BID_ITEM_ID'])}} as ITEM_KEY,
    {{dbt_utils.generate_surrogate_key(['VB_BIDS.BID_USER_ID'])}} as USER_KEY,
    replace(to_date(VB_BIDS.BID_DATETIME)::varchar,'-','')::int as DATETIME_KEY,
    VB_BIDS.BID_AMOUNT,
    VB_BIDS.BID_STATUS,
    case when  lower(VB_BIDS.BID_STATUS) = 'ok' then 'Y' else 'N' end as OK_BID
    from {{source('VBAY', 'VB_BIDS')}}