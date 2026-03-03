/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.investorcare.model;

import java.sql.Timestamp;

/**
 *
 * @author DELL
 */
public class Asset {

    private int assetId;
    private String type;
    private String symbol;
    private String exchange;
    private String name;
    private String status;
    private boolean visible;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Asset() {
    }

    public Asset(int assetId, String type, String symbol, String exchange, String name, String status, boolean visible) {
        this.assetId = assetId;
        this.type = type;
        this.symbol = symbol;
        this.exchange = exchange;
        this.name = name;
        this.status = status;
        this.visible = visible;
    }

    public Asset(int assetId, String type, String symbol, String exchange, String name, String status, boolean visible, Timestamp createdAt, Timestamp updatedAt) {
        this.assetId = assetId;
        this.type = type;
        this.symbol = symbol;
        this.exchange = exchange;
        this.name = name;
        this.status = status;
        this.visible = visible;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    

    public int getAssetId() {
        return assetId;
    }

    public void setAssetId(int assetId) {
        this.assetId = assetId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public String getExchange() {
        return exchange;
    }

    public void setExchange(String exchange) {
        this.exchange = exchange;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isVisible() {
        return visible;
    }

    public void setVisible(boolean visible) {
        this.visible = visible;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
        
}
