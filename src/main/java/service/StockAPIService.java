package service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONObject;

public class StockAPIService {
    // Dán API Key bạn vừa lấy vào đây
    private static final String API_KEY = "d6i6v41r01ql9cif5ujgd6i6v41r01ql9cif5uk0"; 

    public static Map<String, Double> getBatchPrices(List<String> symbols) {
        Map<String, Double> priceMap = new HashMap<>();
        
        for (String symbol : symbols) {
            try {
                // Finnhub dùng format symbol chuẩn (AAPL, MSFT, BTC-USD) giống Yahoo
                String urlString = "https://finnhub.io/api/v1/quote?symbol=" + symbol + "&token=" + API_KEY;
                
                URL url = new URL(urlString);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.setConnectTimeout(5000); // Đợi tối đa 5s

                if (conn.getResponseCode() == 200) {
                    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                    StringBuilder content = new StringBuilder();
                    String line;
                    while ((line = in.readLine()) != null) content.append(line);
                    in.close();

                    JSONObject json = new JSONObject(content.toString());
                    
                    // "c" trong JSON của Finnhub là Current Price (Giá hiện tại)
                    if (json.has("c")) {
                        double price = json.getDouble("c");
                        priceMap.put(symbol, price);
                    }
                } else {
                    System.err.println("Lỗi kết nối Finnhub cho mã " + symbol + ": " + conn.getResponseCode());
                    priceMap.put(symbol, 0.0);
                }
                
                // Finnhub Free cho phép 60 req/phút, nên mỗi mã nghỉ 100ms cho an toàn
                Thread.sleep(100); 

            } catch (Exception e) {
                System.err.println("Lỗi xử lý mã " + symbol + ": " + e.getMessage());
                priceMap.put(symbol, 0.0);
            }
        }
        return priceMap;
    }

    // Hàm main để bạn nhấn Shift + F6 test nhanh không cần chạy Server
    public static void main(String[] args) {
        java.util.List<String> test = java.util.Arrays.asList("AAPL", "MSFT", "TSLA", "BTC-USD");
        Map<String, Double> result = getBatchPrices(test);
        result.forEach((k, v) -> System.out.println(k + " : " + v));
    }
}