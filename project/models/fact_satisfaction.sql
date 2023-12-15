   /*select Rating_ID, 
    {{dbt_utils.generate_surrogate_key(['VB_USER_RATINGS.RATING_BY_USER_ID'])}} as RATING_BY_USER_KEY,
    {{dbt_utils.generate_surrogate_key(['VB_USER_RATINGS.RATING_FOR_USER_ID'])}} as RATING_FOR_USER_KEY,
    RATING_ASTYPE,
    RATING_VALUE
    from {{source('VBAY', 'VB_USER_RATINGS')}}
*/


with stg_user_ratings as(
select rating_by_user_id, rating_for_user_id, rating_astype, sum(rating_value) as OVERALL_RATING , count(rating_value) as NO_OF_RATINGS from {{source('VBAY','VB_USER_RATINGS')}} 
group by rating_by_user_id, rating_for_user_id, rating_astype ),

stg_items as (
    select * from {{source('VBAY','VB_ITEMS')}}
)

select 
{{dbt_utils.generate_surrogate_key(['stg_user_ratings.RATING_BY_USER_ID'])}} as RATING_BY_USER_KEY,
{{dbt_utils.generate_surrogate_key(['stg_user_ratings.RATING_FOR_USER_ID'])}} as RATING_FOR_USER_KEY,
 RATING_ASTYPE,
 OVERALL_RATING,
 NO_OF_RATINGS,
 {{dbt_utils.generate_surrogate_key(['stg_items.ITEM_ID'])}} as ITEM_KEY,
 stg_items.ITEM_ID
from stg_user_ratings left join stg_items on (stg_user_ratings.rating_by_user_id = stg_items.item_seller_user_id and
stg_user_ratings.rating_for_user_id = stg_items.item_buyer_user_id) OR
(stg_user_ratings.rating_by_user_id = stg_items.item_buyer_user_id and
stg_user_ratings.rating_for_user_id = stg_items.item_seller_user_id) 