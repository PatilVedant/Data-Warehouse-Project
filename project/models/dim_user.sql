with stg_user as (
select * from {{source('VBAY', 'VB_USERS')}}
),

stg_zip_codes as (
select * from {{source('VBAY', 'VB_ZIP_CODES')}}
)

select {{dbt_utils.generate_surrogate_key(['stg_user.USER_ID'])}} as USER_KEY,
stg_user.USER_ID,
stg_user.USER_EMAIL,
CONCAT(stg_user.USER_LASTNAME, ',', stg_user.USER_FIRSTNAME) as USERNAME_LAST_FIRST,
CONCAT(stg_user.USER_FIRSTNAME, ' ', stg_user.USER_LASTNAME) as USERNAME_FIRST_LAST,
stg_user.USER_ZIP_CODE,
stg_zip_codes.ZIP_CITY as USER_CITY,
stg_zip_codes.ZIP_STATE as USER_STATE,
stg_zip_codes.ZIP_LAT as USER_LAT,
stg_zip_codes.ZIP_LNG as USER_LNG

from stg_user left join stg_zip_codes on stg_user.USER_ZIP_CODE = stg_zip_codes.ZIP_CODE
