with f_items_popularity as (

select * from {{ref('fact_items_popularity')}}

), 

d_item as (

select * from {{ref('dim_item')}}    
),

d_user as (

select * from {{ref('dim_user')}}     
),

d_date as (
select * from {{ref('dim_date')}}
)


select d_item.* ,  

f_items_popularity.ITEM_ID,
f_items_popularity.ITEM_SELLER_USER_KEY, u1.* , 
f_items_popularity.ITEM_BUYER_USER_KEY,u2.*,

f_items_popularity.ITEM_RESERVE, f_items_popularity.ITEM_SOLD,
f_items_popularity.ITEM_BIDS_COUNT,
f_items_popularity.ITEM_SALES_SURPLUS,
f_items_popularity.ITEM_DURATION_IN_DAYS,

f_items_popularity.ITEM_SOLDAMOUNT, f_items_popularity.ITEM_ENDDATE_KEY,d2.*,
f_items_popularity.ITEM_FIRST_BID_DATE_KEY,  d1.*


from f_items_popularity left join d_item on f_items_popularity.ITEM_KEY = d_item.ITEM_KEY
 left join d_user u1 on u1.USER_KEY =  f_items_popularity.ITEM_SELLER_USER_KEY 
  left join d_user u2 on u2.USER_KEY =  f_items_popularity.ITEM_BUYER_USER_KEY 
  left join d_date d1 on d1.datekey = f_items_popularity.ITEM_FIRST_BID_DATE_KEY
  left join d_date d2 on d2.datekey = f_items_popularity.ITEM_ENDDATE_KEY