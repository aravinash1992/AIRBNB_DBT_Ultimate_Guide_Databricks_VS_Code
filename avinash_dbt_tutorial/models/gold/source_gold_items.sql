WITH dedup_query AS 
(
select 
    *,
    ROW_NUMBER() OVER (PARTITION BY id ORDER BY updateDate DESC) AS deduplication_id
from 
    {{ source('source', 'items') }}
)
SELECT 
    id,
    name,
    category,
    updateDate
FROM dedup_query
WHERE 
    deduplication_id = 1