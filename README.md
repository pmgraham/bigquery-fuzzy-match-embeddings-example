# BigQuery Fuzzy Matching with SQL and Vertex AI Embeddings

This repository provides a step-by-step guide to performing fuzzy matching on customer data using Google BigQuery and Vertex AI text embeddings. The process involves creating vector embeddings from customer records and then using vector search to find the most similar pairs between two tables, effectively overcoming minor differences in names, addresses, and contact information.

## Overview

Fuzzy matching is a technique used to find strings that are approximately equal to a given pattern. In this example, we use it to identify matching customer records across two different tables where the data isn't perfectly clean or consistent.

Instead of relying on traditional, often complex, string comparison functions, we leverage the power of AI. By converting textual data into high-dimensional vectors (embeddings), we can find matches based on semantic meaning and context rather than exact string equality. This approach is highly effective at handling variations like typos, abbreviations, and missing or extra information.

## Prerequisites

Before you begin, ensure you have the following:

1.  **A Google Cloud Platform (GCP) Project:** If you don't have one, create one [here](https://console.cloud.google.com/projectcreate).
2.  **Enabled APIs:** Make sure the **BigQuery API** and **Vertex AI API** are enabled for your project.
3.  **BigQuery Data Editor Role:** You need permissions to create tables, models, and run queries in BigQuery.
4.  **A BigQuery Connection:** You must create a [BigQuery cloud resource connection](https://cloud.google.com/bigquery/docs/create-cloud-resource-connection) to allow BigQuery to communicate with Vertex AI. Note the region and connection ID, as you will need them to run the scripts.

## How to Run the Scripts

The process is broken down into four main SQL scripts, which should be run in order. Before executing, you'll need to configure the variables at the top of each script.

### Step 1: Configure Your Environment

In each of the SQL scripts located in the `sql/` directory, you will find a "Configuration" section at the top. You must replace the placeholder values with your actual GCP project details.

```sql
-- ======================================================================================================================
-- Configuration
-- ======================================================================================================================
DECLARE project_id STRING DEFAULT 'your-gcp-project-id';
DECLARE dataset_id STRING DEFAULT 'your_bigquery_dataset';
DECLARE model_name STRING DEFAULT 'customer_text_embedder';
DECLARE connection_name STRING DEFAULT 'us.your-connection-name'; -- Or your specific region
-- ======================================================================================================================
```

-   **`project_id`**: Your Google Cloud project ID.
-   **`dataset_id`**: The BigQuery dataset where your tables and models will be stored.
-   **`model_name`**: The name you want to give your embedding model.
-   **`connection_name`**: The full connection ID for your BigQuery cloud resource connection (e.g., `us.my-connection`).

### Step 2: Run the SQL Scripts

Execute the following scripts in your BigQuery console in the specified order.

1.  **`sql/01_setup_tables.sql`**
    This script creates two tables, `customers_primary` and `customers_secondary`, and populates them with sample data. These represent the two lists of customers you want to match.

2.  **`sql/02_create_embedding_model.sql`**
    This script creates a remote model in BigQuery that connects to a Vertex AI text-embedding model (`text-embedding-005`). This model is what you'll use to generate the vector embeddings.

3.  **`sql/03_generate_embeddings.sql`**
    This script reads the data from your two customer tables, generates embeddings for each record using the model, and stores the results in two new tables: `customers_primary_embeddings` and `customers_secondary_embeddings`.

4.  **`sql/04_find_matches.sql`**
    This is the final step. The script uses the `VECTOR_SEARCH` function to compare the embeddings in the secondary table against the primary table. It identifies the single best match for each record and stores the final, cleaned-up results in a table named `customer_matches`.

## Final Result

After running all the scripts, the `customer_matches` table will contain the results, showing each customer from the secondary table paired with their closest match from the primary table. The `distance` column indicates the similarity, with smaller values representing a closer match.
