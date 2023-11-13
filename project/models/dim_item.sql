with stg_items as (
    select * from {{ source('VBAY','VB_ITEMS')}}
)
select  {{ dbt_utils.generate_surrogate_key(['stg_items.ITEM_ID']) }} as ITEM_KEY, 
    stg_items.ITEM_ID,
    stg_items.ITEM_NAME,
    stg_items.ITEM_TYPE,
    stg_items.ITEM_DESCRIPTION

from stg_items
