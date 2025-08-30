-- ======================================================================================================================
-- 03_generate_embeddings.sql
--
-- This script uses the text-embedding model to generate embeddings for both the primary and secondary
-- customer tables. The results, including the embedding vectors, are stored in new tables.
--
-- Before running, replace the placeholder values in the DECLARE statements below.
-- ======================================================================================================================

-- ======================================================================================================================
-- Configuration
-- ======================================================================================================================
DECLARE project_id STRING DEFAULT 'your-gcp-project-id';
DECLARE dataset_id STRING DEFAULT 'your_bigquery_dataset';
DECLARE model_name STRING DEFAULT 'customer_text_embedder';
-- ======================================================================================================================

-- Generate embeddings for the primary customers table
CREATE OR REPLACE TABLE `${project_id}.${dataset_id}.customers_primary_embeddings` AS
SELECT
  * EXCEPT(content),
  ml_generate_text_embedding_result AS text_embedding
FROM
  ML.GENERATE_TEXT_EMBEDDING(
    MODEL `${project_id}.${dataset_id}.${model_name}`,
    (
      SELECT
        *,
        CONCAT(full_name, ",", address, ",", email) AS content
      FROM
        `${project_id}.${dataset_id}.customers_primary`
    ),
    STRUCT(TRUE AS flatten_json_output)
  );

-- Generate embeddings for the secondary customers table
CREATE OR REPLACE TABLE `${project_id}.${dataset_id}.customers_secondary_embeddings` AS
SELECT
  * EXCEPT(content),
  ml_generate_text_embedding_result AS text_embedding
FROM
  ML.GENERATE_TEXT_EMBEDDING(
    MODEL `${project_id}.${dataset_id}.${model_name}`,
    (
      SELECT
        *,
        CONCAT(name, ",", street_address, ",", contact) AS content
      FROM
        `${project_id}.${dataset_id}.customers_secondary`
    ),
    STRUCT(TRUE AS flatten_json_output)
  );
