/*=============================================================================
01: DATABASE INITIALIZATION
Project: Customer Churn & Revenue Retention Analytics
Author:  Pierre ML Deprez
Purpose: Establish an isolated environment for downstream schema creation.
=============================================================================*/

IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'customer_churn_retention_analytics')
BEGIN
    CREATE DATABASE customer_churn_retention_analytics;
END;
GO

USE customer_churn_retention_analytics;
GO