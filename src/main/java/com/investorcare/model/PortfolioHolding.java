/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.investorcare.model;

/**
 *
 * @author khait
 */
public class PortfolioHolding {
    private int portfolioId;
    private int assetId;
    private double qty;        // DECIMAL trong DB → dùng double
    private double avgCost;
    private String symbol;
    private String name;
    private String exchange;
    private double currentPrice;

    public PortfolioHolding(int portfolioId, int assetId, double qty, double avgCost, String symbol, String name, String exchange, double currentPrice) {
        this.portfolioId = portfolioId;
        this.assetId = assetId;
        this.qty = qty;
        this.avgCost = avgCost;
        this.symbol = symbol;
        this.name = name;
        this.exchange = exchange;
        this.currentPrice = currentPrice;
    }

    public int getPortfolioId() {
        return portfolioId;
    }

    public void setPortfolioId(int portfolioId) {
        this.portfolioId = portfolioId;
    }

    public int getAssetId() {
        return assetId;
    }

    public void setAssetId(int assetId) {
        this.assetId = assetId;
    }

    public double getQty() {
        return qty;
    }

    public void setQty(double qty) {
        this.qty = qty;
    }

    public double getAvgCost() {
        return avgCost;
    }

    public void setAvgCost(double avgCost) {
        this.avgCost = avgCost;
    }

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getExchange() {
        return exchange;
    }

    public void setExchange(String exchange) {
        this.exchange = exchange;
    }

    public double getCurrentPrice() {
        return currentPrice;
    }

    public void setCurrentPrice(double currentPrice) {
        this.currentPrice = currentPrice;
    }

    
    public double getMarketValue() {
    return qty * currentPrice;
}

public double getPnl() {
    return (currentPrice - avgCost) * qty;
}

public double getPnlPercent() {
    if (avgCost == 0) return 0;
    return ((currentPrice - avgCost) / avgCost) * 100;
}
    
}
