USE cloudera;

DROP TABLE IF EXISTS partitioned_trans;
CREATE EXTERNAL TABLE partitioned_trans (
	--id,chain,dept,category,company,brand,date,productsize,productmeasure,purchasequantity,purchaseamount
	id BIGINT,
	chain INT,
	dept INT,
	category INT,
	company BIGINT,
	brand BIGINT,
	productsize DOUBLE,
	productmeasure STRING,
	purchasequantity INT,
	purchaseamount DOUBLE
)
PARTITIONED BY(tdate String)
STORED AS TEXTFILE
LOCATION '/user/cloudera/rec_data/transformed_trans'
AS
SELECT id, chain, dept, category, company, brand, productsize, productmeasure, purchasequantity, purchaseamount, tdate FROM transactions;