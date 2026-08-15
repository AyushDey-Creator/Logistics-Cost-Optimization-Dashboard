-- ============================================================
-- Project 2: Freight Cost & Logistics Spend Optimization
-- Description: Financial transformations, carrier spend aggregation,
--              and budget variance queries for Power BI modeling.
-- Database: LogisticsDB
-- ============================================================

USE [LogisticsDB];
GO

-- 1. Multi-Modal Freight Spend & Route Unit Cost Analysis
SELECT 
    OriginPort,
    DestinationPort,
    COUNT(ShipmentID) AS TotalShipments,
    ROUND(SUM(EstimatedFreightCost), 2) AS TotalFreightSpend,
    ROUND(AVG(EstimatedFreightCost), 2) AS AvgCostPerShipment
FROM dbo.Fact_Shipments_audit
GROUP BY 
    OriginPort, 
    DestinationPort
ORDER BY 
    TotalFreightSpend DESC;
GO

-- 2. Freight Invoice Cost Overrun & Variance Detection
SELECT 
    s.ShipmentID,
    c.CarrierName,
    s.EstimatedFreightCost,
    i.ActualInvoiceAmount,
    ROUND(i.ActualInvoiceAmount - s.EstimatedFreightCost, 2) AS CostOverrun
FROM dbo.Fact_Shipments_audit s
JOIN dbo.Fact_FreightInvoices i 
    ON s.ShipmentID = i.ShipmentID
JOIN dbo.Dim_Carriers c 
    ON s.CarrierID = c.CarrierID
WHERE 
    (i.ActualInvoiceAmount - s.EstimatedFreightCost) > 0
ORDER BY 
    CostOverrun DESC;
GO
