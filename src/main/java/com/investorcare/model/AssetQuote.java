package com.investorcare.model;

public class AssetQuote {
    private double currentPrice;
    private double change;
    private double changePercent;
    private double dayHigh;
    private double dayLow;
    private double open;
    private double prevClose;

    public AssetQuote() {}

    public AssetQuote(double currentPrice, double change, double changePercent,
                      double dayHigh, double dayLow, double open, double prevClose) {
        this.currentPrice   = currentPrice;
        this.change         = change;
        this.changePercent  = changePercent;
        this.dayHigh        = dayHigh;
        this.dayLow         = dayLow;
        this.open           = open;
        this.prevClose      = prevClose;
    }

    public double getCurrentPrice()  { return currentPrice; }
    public double getChange()        { return change; }
    public double getChangePercent() { return changePercent; }
    public double getDayHigh()       { return dayHigh; }
    public double getDayLow()        { return dayLow; }
    public double getOpen()          { return open; }
    public double getPrevClose()     { return prevClose; }

    public void setCurrentPrice(double v)  { this.currentPrice = v; }
    public void setChange(double v)        { this.change = v; }
    public void setChangePercent(double v) { this.changePercent = v; }
    public void setDayHigh(double v)       { this.dayHigh = v; }
    public void setDayLow(double v)        { this.dayLow = v; }
    public void setOpen(double v)          { this.open = v; }
    public void setPrevClose(double v)     { this.prevClose = v; }

    /** Tiện dùng trong JSP */
    public boolean isUp() { return change >= 0; }
}