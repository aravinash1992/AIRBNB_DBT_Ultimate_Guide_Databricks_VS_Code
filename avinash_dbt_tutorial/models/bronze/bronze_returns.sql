{{
  config(
    materialized = 'view',
    )
}}
SELECT * FROM 
{{ source('source','fact_returns') }}