-- ======================================================================================================================
-- 02_create_embedding_model.sql
--
-- This script creates a remote model in BigQuery that connects to a Vertex AI text-embedding model.
-- This model will be used to generate the embeddings for the customer data.
--
-- Before running, replace the placeholder values in the DECLARE statements below.
-- ======================================================================================================================

-- ======================================================================================================================
-- Configuration
-- ======================================================================================================================
DECLARE project_id STRING DEFAULT 'your-gcp-project-id';
DECLARE dataset_id STRING DEFAULT 'your_bigquery_dataset';
DECLARE model_name STRING DEFAULT 'customer_text_embedder';
DECLARE connection_name STRING DEFAULT 'us.your-connection-name'; -- Or your specific region
-- ======================================================================================================================

CREATE OR REPLACE MODEL `${project_id}.${dataset_id}.${model_name}`
  REMOTE WITH CONNECTION `${connection_name}`
  OPTIONS (
    endpoint = 'text-embedding-005' -- This is the latest embeddings model as of this writing.
  );
