create database nikhil;
use nikhil;

select CustomerId, max(PurchaseDate) as LastPurchaseDate,
datediff(current_date, max(PurchaseDate)) as Recency
from rfm_data
group by customerid;

select customerid, count(*) as frequency
from rfm_data
group by customerid;

select customerid, sum(transactionamount) as monetary
from rfm_data
group by customerid;


SELECT
    r.customerid,
    r.recency,
    f.frequency,
    m.monetary,
    CASE
        WHEN r.recency <= 30 AND f.frequency >= 10 AND m.monetary >= 500 THEN 'High Value'
        WHEN r.recency between 31 and 60 AND f.frequency between 5 and 9 AND m.monetary between 200 and 499 THEN 'Mid Value'
	    ELSE 'Low Value'
    END AS rfm_segment
FROM 
(SELECT
        CustomerId,
        MAX(PurchaseDate) AS LastPurchaseDate,
        DATEDIFF(CURRENT_DATE, MAX(PurchaseDate)) AS Recency
    FROM rfm_data
    GROUP BY customerid) r
JOIN 
(SELECT
        customerid,
        COUNT(*) AS frequency
    FROM rfm_data
    GROUP BY customerid) f ON r.customerid = f.customerid
JOIN 
(SELECT
        customerid,
        SUM(transactionamount) AS monetary
    FROM rfm_data
    GROUP BY customerid) m ON r.customerid = m.customerid;



