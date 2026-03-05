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
public class Alert {
    private int alertId;
    private int userId;
    private int assetId;
    private int signalId;
    private String severity;
    private String message;
    private String status;
    private Timestamp timestamp;

    public Alert() {
    }

    public Alert(int alertId, int userId, int assetId, int signalId, String severity, String message, String status, Timestamp timestamp) {
        this.alertId = alertId;
        this.userId = userId;
        this.assetId = assetId;
        this.signalId = signalId;
        this.severity = severity;
        this.message = message;
        this.status = status;
        this.timestamp = timestamp;
    }
    
    

    public int getAlertId() {
        return alertId;
    }

    public void setAlertId(int alertId) {
        this.alertId = alertId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getAssetId() {
        return assetId;
    }

    public void setAssetId(int assetId) {
        this.assetId = assetId;
    }

    public int getSignalId() {
        return signalId;
    }

    public void setSignalId(int signalId) {
        this.signalId = signalId;
    }

    public String getSeverity() {
        return severity;
    }

    public void setSeverity(String severity) {
        this.severity = severity;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }
    
    
}
