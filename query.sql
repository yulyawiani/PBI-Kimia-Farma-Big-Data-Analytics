CREATE TABLE dataset_kimia_farma.base_table AS
SELECT 
DISTINCT
  ft.transaction_id,
  ft.date,
  ft.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating as rating_cabang,
  ft.customer_name,
  ft.product_id,
  pd.product_name,
  ft.price as actual_price,
  ft.discount_percentage,
  ft.rating as rating_transaksi,


FROM dataset_kimia_farma.kf_final_transaction as ft
LEFT JOIN dataset_kimia_farma.kf_kantor_cabang as kc
  on ft.branch_id = kc.branch_id
LEFT JOIN dataset_kimia_farma.kf_inventory as inv
  on ft.branch_id = inv.branch_id and ft.product_id = inv.product_id
LEFT JOIN dataset_kimia_farma.kf_product as pd
  on ft.product_id = pd.product_id and ft.price = pd.price

;

CREATE TABLE dataset_kimia_farma.table1 AS
SELECT
DISTINCT
  b.transaction_id,
  b.actual_price,
  b.discount_percentage,
  b.actual_price - (b.actual_price * b.discount_percentage) as nett_sales,
  CASE
    WHEN b.actual_price >= 50000 AND b.actual_price <= 100000 THEN 0.15
    WHEN b.actual_price > 100000 AND b.actual_price <= 300000 THEN 0.20
    WHEN b.actual_price > 300000 AND b.actual_price <= 500000 THEN 0.25
    WHEN b.actual_price > 50000 THEN 0.30
    ELSE 0.10
  END AS persentase_gross_laba
FROM dataset_kimia_farma.base_table as b

;

CREATE TABLE dataset_kimia_farma.table2 AS
SELECT
DISTINCT
  *,
  t1.nett_sales * t1.persentase_gross_laba as nett_profit,
FROM dataset_kimia_farma.table1 as t1
;