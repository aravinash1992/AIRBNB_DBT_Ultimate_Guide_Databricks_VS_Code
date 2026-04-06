{% set inc_flag= 1 %}
{% set last_load= 3 %}

{% set col_list = ["sales_id","date_sk","gross_amount"] %}

select
    
    {% for i in col_list %}
          {{ i }}
          {% if not loop.last %} , {% endif %}
    {% endfor %}

from
    {{ ref('bronze_sales') }}

{% if inc_flag == 1 %}

    where date_sk > {{ last_load }}

{% endif %}