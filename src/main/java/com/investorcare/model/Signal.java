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
public class Signal {
    private int signalId;
    private int assetId;
    private int modelId;
    private Timestamp ts;
    private double riskScore;
    private boolean anomalyFlag;
    private double trendProb;
    private String explanationText;

    public Signal() {
    }

    public Signal(int signalId, int assetId, int modelId, Timestamp ts, double riskScore, boolean anomalyFlag, double trendProb, String explanationText) {
        this.signalId = signalId;
        this.assetId = assetId;
        this.modelId = modelId;
        this.ts = ts;
        this.riskScore = riskScore;
        this.anomalyFlag = anomalyFlag;
        this.trendProb = trendProb;
        this.explanationText = explanationText;
    }

    public int getSignalId() {
        return signalId;
    }

    public void setSignalId(int signalId) {
        this.signalId = signalId;
    }

    public int getAssetId() {
        return assetId;
    }

    public void setAssetId(int assetId) {
        this.assetId = assetId;
    }

    public int getModelId() {
        return modelId;
    }

    public void setModelId(int modelId) {
        this.modelId = modelId;
    }

    public Timestamp getTs() {
        return ts;
    }

    public void setTs(Timestamp ts) {
        this.ts = ts;
    }

    public double getRiskScore() {
        return riskScore;
    }

    public void setRiskScore(double riskScore) {
        this.riskScore = riskScore;
    }

    public boolean isAnomalyFlag() {
        return anomalyFlag;
    }

    public void setAnomalyFlag(boolean anomalyFlag) {
        this.anomalyFlag = anomalyFlag;
    }

    public double getTrendProb() {
        return trendProb;
    }

    public void setTrendProb(double trendProb) {
        this.trendProb = trendProb;
    }

    public String getExplanationText() {
        return explanationText;
    }

    public void setExplanationText(String explanationText) {
        this.explanationText = explanationText;
    }
    
    
}
