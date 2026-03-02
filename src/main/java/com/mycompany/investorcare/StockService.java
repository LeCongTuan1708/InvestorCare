package com.mycompany.investorcare;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
// Import thư viện org.json (Cần Clean and Build nếu thấy báo đỏ)
import org.json.JSONArray;
import org.json.JSONObject;

public class StockService {

    // Cấu hình Database
    private final String url = "jdbc:sqlserver://localhost:1433;databaseName=INVESTORCARE;encrypt=true;trustServerCertificate=true;";
    private final String user = "sa";
    private final String pass = "12345";

    /**
     * Lấy danh sách các mã cổ phiếu đang Active từ DB
     */
    public List<String> getAllActiveSymbols() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT SYMBOL FROM ASSET WHERE STATUS = 'Active' AND TYPE = 'STOCK'";
        
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getString("SYMBOL"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * HÀM QUAN TRỌNG: Lấy giá từ Yahoo qua API Chart (v8)
     * API này ít bị chặn (401/429) hơn API Quote thông thường.
     */
    private double getPriceFromYahooStealth(String symbol) throws Exception {
        // Sử dụng v8/finance/chart thay vì quote
        String apiUrl = "https://query1.finance.yahoo.com/v8/finance/chart/" + symbol + "?interval=1d&range=1d";
        
        URL urlObj = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) urlObj.openConnection();
        
        // --- GIẢ LẬP TRÌNH DUYỆT (BẮT BUỘC) ---
        conn.setRequestMethod("GET");
        conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36");
        conn.setRequestProperty("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8");
        conn.setRequestProperty("Connection", "keep-alive");
        conn.setConnectTimeout(10000); // 10 giây timeout
        conn.setReadTimeout(10000);

        int responseCode = conn.getResponseCode();
        if (responseCode != 200) {
            throw new RuntimeException("Yahoo chặn hoặc lỗi mạng (HTTP " + responseCode + ") - URL: " + apiUrl);
        }

        // Đọc dữ liệu trả về
        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder content = new StringBuilder();
        String inputLine;
        while ((inputLine = in.readLine()) != null) {
            content.append(inputLine);
        }
        in.close();

        // --- PHÂN TÍCH JSON (Cấu trúc của Chart API) ---
        // Cấu trúc: { "chart": { "result": [ { "meta": { "regularMarketPrice": 185.5, ... } } ] } }
        JSONObject root = new JSONObject(content.toString());
        
        if (!root.has("chart")) {
            throw new RuntimeException("Dữ liệu Yahoo trả về không đúng định dạng (Thiếu 'chart')");
        }

        JSONObject chart = root.getJSONObject("chart");
        
        if (chart.isNull("result")) {
             // Trường hợp mã sai hoặc Yahoo trả về null result
             throw new RuntimeException("Yahoo không trả về dữ liệu cho mã: " + symbol);
        }

        JSONArray result = chart.getJSONArray("result");
        if (result.length() > 0) {
            JSONObject data = result.getJSONObject(0);
            JSONObject meta = data.getJSONObject("meta");
            
            if (meta.has("regularMarketPrice")) {
                return meta.getDouble("regularMarketPrice");
            } else {
                 throw new RuntimeException("Không tìm thấy trường 'regularMarketPrice' trong JSON");
            }
        } else {
            throw new RuntimeException("Mảng 'result' rỗng");
        }
    }

    /**
     * Cập nhật giá cho 1 mã cụ thể
     */
    public boolean updatePrice(String symbol) {
        try {
            // 1. Gọi hàm lấy giá (Stealth Mode)
            double currentPrice = getPriceFromYahooStealth(symbol);

            // 2. Lưu vào DB
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            try (Connection conn = DriverManager.getConnection(url, user, pass)) {
                
                // Tìm ID của mã chứng khoán
                int assetId = -1;
                PreparedStatement ps1 = conn.prepareStatement("SELECT ASSET_ID FROM ASSET WHERE SYMBOL = ?");
                ps1.setString(1, symbol);
                ResultSet rs = ps1.executeQuery();
                if (rs.next()) {
                    assetId = rs.getInt("ASSET_ID");
                }

                if (assetId != -1) {
                    // Insert giá mới vào bảng PRICE_BAR
                    // Lưu ý: Dùng [CLOSE] để tránh lỗi keyword
                    String insertSql = "INSERT INTO PRICE_BAR (ASSET_ID, TS, [CLOSE], SOURCE) VALUES (?, GETDATE(), ?, 'Yahoo API v8')";
                    
                    PreparedStatement ps2 = conn.prepareStatement(insertSql);
                    ps2.setInt(1, assetId);
                    ps2.setDouble(2, currentPrice);
                    ps2.executeUpdate();
                    
                    System.out.println(">> SUCCESS: " + symbol + " | Giá: " + currentPrice);
                    return true;
                } else {
                    System.out.println(">> SKIP: Không tìm thấy mã " + symbol + " trong bảng ASSET");
                }
            }
        } catch (Exception e) {
            // In lỗi ngắn gọn để dễ debug
            System.out.println(">> ERROR " + symbol + ": " + e.getMessage());
        }
        return false;
    }

    /**
     * Chạy cập nhật cho toàn bộ danh sách (Có thời gian nghỉ để tránh bị chặn)
     */
    public void runBatchUpdate() {
        List<String> symbols = getAllActiveSymbols();
        System.out.println("=== BẮT ĐẦU CẬP NHẬT (SL: " + symbols.size() + ") ===");

        for (String sym : symbols) {
            updatePrice(sym);
            
            // Nghỉ 3 giây giữa các lần gọi để an toàn
            try { 
                Thread.sleep(3000); 
            } catch (InterruptedException ex) {
                Thread.currentThread().interrupt();
            }
        }
        System.out.println("=== HOÀN TẤT ===");
    }
}