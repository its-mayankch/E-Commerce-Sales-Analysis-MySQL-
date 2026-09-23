-- ===========================================================================================================================================================
-- E-Commerce Sales Analysis Project
-- Author: Priya Rathod
-- Description: Business analysis using normalized schema
-- ==========================================================================================================================================================

-- =========================================create database==========================================================================================
create database if not exists project;
use project;

-- rename table name
rename table `e-commerce_shopping_dataset_cleaned`to raw_orders;