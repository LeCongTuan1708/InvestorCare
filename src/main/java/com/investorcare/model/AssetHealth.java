/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.investorcare.model;

import java.time.LocalDate;

/**
 *
 * @author DELL
 */
public class AssetHealth {

    private int totalPriceRecords;
    private LocalDate latestPriceDate;
    private int totalNewsRecords;
    private LocalDate latestNewsDate;
    private String status;

    public AssetHealth() {
    }
    

    public AssetHealth(int totalPriceRecords, LocalDate latestPriceDate, int totalNewsRecords, LocalDate latestNewsDate, String status) {
        this.totalPriceRecords = totalPriceRecords;
        this.latestPriceDate = latestPriceDate;
        this.totalNewsRecords = totalNewsRecords;
        this.latestNewsDate = latestNewsDate;
        this.status = status;
    }

    public int getTotalPriceRecords() {
        return totalPriceRecords;
    }

    public void setTotalPriceRecords(int totalPriceRecords) {
        this.totalPriceRecords = totalPriceRecords;
    }

    public LocalDate getLatestPriceDate() {
        return latestPriceDate;
    }

    public void setLatestPriceDate(LocalDate latestPriceDate) {
        this.latestPriceDate = latestPriceDate;
    }

    public int getTotalNewsRecords() {
        return totalNewsRecords;
    }

    public void setTotalNewsRecords(int totalNewsRecords) {
        this.totalNewsRecords = totalNewsRecords;
    }

    public LocalDate getLatestNewsDate() {
        return latestNewsDate;
    }

    public void setLatestNewsDate(LocalDate latestNewsDate) {
        this.latestNewsDate = latestNewsDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    
}
