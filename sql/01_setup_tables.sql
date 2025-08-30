-- ======================================================================================================================
-- 01_setup_tables.sql
--
-- This script creates and populates the two sample customer tables for the fuzzy matching example.
--
-- Before running, replace the placeholder values in the DECLARE statements below.
-- ======================================================================================================================

-- ======================================================================================================================
-- Configuration
-- ======================================================================================================================
DECLARE project_id STRING DEFAULT 'your-gcp-project-id';
DECLARE dataset_id STRING DEFAULT 'your_bigquery_dataset';
-- ======================================================================================================================

-- Create the primary customers table
CREATE OR REPLACE TABLE `${project_id}.${dataset_id}.customers_primary`
(
  customer_id INT64,
  full_name STRING,
  address STRING,
  email STRING
);

-- Create the secondary customers table
CREATE OR REPLACE TABLE `${project_id}.${dataset_id}.customers_secondary`
(
  record_id INT64,
  name STRING,
  street_address STRING,
  contact STRING
);

-- Insert sample data into the primary customers table
INSERT INTO `${project_id}.${dataset_id}.customers_primary` (customer_id, full_name, address, email)
VALUES
  (4, 'Samantha "Sam" Jones', '101 Maple Avenue, Greenfield, OH 45123', 'samantha.jones@example.com'),
  (2, 'Robert "Rob" Patterson', '456 Sunken Meadow Pkwy, Suite 3B, Meadowlands, NY 10001', 'rob.patterson@example.com'),
  (3, 'Jonathan Harker', '789 Carpathian Dr, Apt 12, Whitby, TX 78701', 'j.harker@example.com'),
  (5, 'William "Bill" Anderson', '212 Baker Street, London, WA 98004', 'bill.a@example.com'),
  (1, 'Dr. Eleanor Vance', '123 Shadow Creek Ln, Hill Dale, CA 90210', 'evance@example.com')
;

-- Insert sample data into the secondary customers table
INSERT INTO `${project_id}.${dataset_id}.customers_secondary` (record_id, name, street_address, contact)
VALUES
  (106, 'Bill Anderson', '212 Baker St, London, WA', 'contact@billing.com'),
  (103, 'Robbie Patterson', '456 Sunken Meadow Parkway, Ste 3B, Meadowlands NY', '555-123-4567'),
  (101, 'Eleanor Vance, PhD', '123 Shadow Creek Lane, Hill Dale, California', 'evance@email.com'),
  (102, 'Mr. Jonathan Harker', '789 Carpathian Drive #12, Whitby', 'jonathan.harker@email.com'),
  (104, 'Chris Peterson', '300 River Road, Riverside, CA 92501', 'chris.p@email.com'),
  (105, 'Sam Jones', '101 Maple Ave, Greenfield Ohio', 'samjones@email.com')
;
