package service;

import com.investorcare.model.AssetQuote;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONObject;

public class StockAPIService {

    private static final String API_KEY = "d6i6v41r01ql9cif5ujgd6i6v41r01ql9cif5uk0";

    /**
     * Trả về Map<symbol, AssetQuote> chứa đầy đủ thông tin giá từ Finnhub.
     */
    public static Map<String, AssetQuote> getBatchQuotes(List<String> symbols) {
        Map<String, AssetQuote> quoteMap = new HashMap<>();

        for (String symbol : symbols) {
            try {
                String urlString = "https://finnhub.io/api/v1/quote?symbol="
                        + symbol + "&token=" + API_KEY;

                URL url = new URL(urlString);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.setConnectTimeout(5000);

                if (conn.getResponseCode() == 200) {
                    BufferedReader in = new BufferedReader(
                            new InputStreamReader(conn.getInputStream()));
                    StringBuilder content = new StringBuilder();
                    String line;
                    while ((line = in.readLine()) != null) content.append(line);
                    in.close();

                    JSONObject json = new JSONObject(content.toString());

                    if (json.has("c") && json.getDouble("c") > 0) {
                        AssetQuote q = new AssetQuote();
                        q.setCurrentPrice(json.getDouble("c"));   // Current price
                        q.setChange(json.getDouble("d"));          // Change $
                        q.setChangePercent(json.getDouble("dp"));  // Change %
                        q.setDayHigh(json.getDouble("h"));         // Day High
                        q.setDayLow(json.getDouble("l"));          // Day Low
                        q.setOpen(json.getDouble("o"));            // Open
                        q.setPrevClose(json.getDouble("pc"));      // Prev Close
                        quoteMap.put(symbol, q);
                    } else {
                        quoteMap.put(symbol, new AssetQuote()); // giá 0, không crash
                    }
                } else {
                    System.err.println("Finnhub error for " + symbol
                            + ": HTTP " + conn.getResponseCode());
                    quoteMap.put(symbol, new AssetQuote());
                }

                Thread.sleep(100); // 60 req/min free tier

            } catch (Exception e) {
                System.err.println("Error fetching " + symbol + ": " + e.getMessage());
                quoteMap.put(symbol, new AssetQuote());
            }
        }
        return quoteMap;
    }

    /**
     * Giữ lại getBatchPrices để không break code cũ (nếu còn dùng ở chỗ khác).
     * @deprecated Dùng getBatchQuotes thay thế.
     */
    @Deprecated
    public static Map<String, Double> getBatchPrices(List<String> symbols) {
        Map<String, Double> priceMap = new HashMap<>();
        Map<String, AssetQuote> quotes = getBatchQuotes(symbols);
        quotes.forEach((sym, q) -> priceMap.put(sym, q.getCurrentPrice()));
        return priceMap;
    }

    // Test nhanh
    public static void main(String[] args) {
        java.util.List<String> test = java.util.Arrays.asList("AAPL", "MSFT", "TSLA");
        Map<String, AssetQuote> result = getBatchQuotes(test);
        result.forEach((k, q) -> System.out.printf(
                "%s => price=%.2f  change=%.2f (%.2f%%)  H=%.2f  L=%.2f%n",
                k, q.getCurrentPrice(), q.getChange(), q.getChangePercent(),
                q.getDayHigh(), q.getDayLow()));
    }
}