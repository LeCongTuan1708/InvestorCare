package com.investorcare.service;

import com.investorcare.dao.AlertDAO;
import com.investorcare.dao.PortfolioHoldingDAO;
import com.investorcare.dao.PriceBarDAO;
import com.investorcare.dao.SignalDAO;
import com.investorcare.model.Alert;
import com.investorcare.model.PriceBar;
import com.investorcare.model.Signal;
import java.util.List;

public class SignalEngine {

    private SignalDAO signalDAO = new SignalDAO();
    private AlertDAO alertDAO = new AlertDAO();
    private PriceBarDAO priceBarDAO = new PriceBarDAO();
    private PortfolioHoldingDAO holdingDAO = new PortfolioHoldingDAO();

    public void checkVolatility(int assetId, int userId) throws Exception {

        // ===== LẤY 2 GIÁ GẦN NHẤT =====
        List<PriceBar> last2 = priceBarDAO.getLastN(assetId, 2);

        if (last2.size() < 2) {
            return; // chưa đủ dữ liệu
        }

        double today = last2.get(0).getClose();
        double yesterday = last2.get(1).getClose();

        // ===== TÍNH % THAY ĐỔI =====
        double changePercent = (today - yesterday) / yesterday;
        double absChange = Math.abs(changePercent);

        // ===== CHECK USER CÓ CỔ PHIẾU KHÔNG =====
        boolean userHasAsset = holdingDAO.userHasAsset(userId, assetId);

        // ===== XÁC ĐỊNH MỨC BIẾN ĐỘNG =====
        boolean mild = absChange > 0.00005 && absChange <= 0.0002;   // 0.5% - 2%
        boolean strong = absChange > 0.0002;                       // >2%
        boolean anomaly = mild || strong;

        // ===== TẠO SIGNAL =====
        Signal s = new Signal();
        s.setAssetId(assetId);
        s.setModelId(1);
        s.setRiskScore(absChange);
        s.setAnomalyFlag(anomaly);
        s.setTrendProb(changePercent > 0 ? 0.7 : 0.3);
        s.setExplanationText("Daily change: "
                + String.format("%.2f", changePercent * 100) + "%");

        signalDAO.insert(s);

        // ===== TẠO ALERT =====
        if (anomaly && userHasAsset) {

            Alert a = new Alert();
            a.setUserId(userId);
            a.setAssetId(assetId);
            a.setSignalId(s.getSignalId());

            String message;
            String severity;

            if (changePercent > 0) { // TĂNG

                if (strong) {
                    severity = "HIGH";
                    message = "? Price tăng mạnh "
                            + String.format("%.2f", changePercent * 100) + "%";
                } else {
                    severity = "MEDIUM";
                    message = " Price tăng nhẹ "
                            + String.format("%.2f", changePercent * 100) + "%";
                }

            } else {

                if (strong) {
                    severity = "HIGH";
                    message = " Price giảm mạnh "
                            + String.format("%.2f", changePercent * 100) + "%";
                } else {
                    severity = "MEDIUM";
                    message = " Price giảm nhẹ "
                            + String.format("%.2f", changePercent * 100) + "%";
                }

            }

            a.setSeverity(severity);
            a.setMessage(message);

            alertDAO.insert(a);
        }
    }
}
