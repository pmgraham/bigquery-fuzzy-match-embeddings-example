-- ======================================================================================================================
-- 04_find_matches.sql
--
-- This script uses the VECTOR_SEARCH function to find the closest matches between the secondary and
-- primary customer tables based on the similarity of their text embeddings.
--
-- Before running, replace the placeholder values in the DECLARE statements below.
-- ======================================================================================================================

-- ======================================================================================================================
-- Configuration
-- ======================================================================================================================
DECLARE project_id STRING DEFAULT 'your-gcp-project-id';
DECLARE dataset_id STRING DEFAULT 'your_bigquery_dataset';
-- ======================================================================================================================

-- This query finds the single closest match in the primary customers table
-- for each customer in the secondary customers table based on embedding similarity.
CREATE OR REPLACE TABLE `${project_id}.${dataset_id}.customer_matches` AS
WITH best_match AS (
  SELECT
    query.record_id AS secondary_id,
    base.customer_id AS primary_id,
    query.name,
    base.full_name,
    query.street_address,
    base.address,
    query.contact,
    base.email,
    distance,
    ROW_NUMBER() OVER(PARTITION BY query.record_id ORDER BY distance ASC) AS row_num
  FROM
    VECTOR_SEARCH(
      TABLE `${project_id}.${dataset_id}.customers_primary_embeddings`,
      'text_embedding',
      TABLE `${project_id}.${dataset_id}.customers_secondary_embeddings`,
      'text_embedding',
      top_k => 1,
      distance_type => 'COSINE'
    )
)
SELECT * EXCEPT(row_num)
FROM best_match
WHERE row_num = 1;
