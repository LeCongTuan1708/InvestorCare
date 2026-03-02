/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.investorcare.controller;

import com.mycompany.investorcare.StockService;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author DELL
 */
@WebServlet(name = "TestPriceServlet", urlPatterns = {"/test-price"})
public class TestPriceServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

    StockService service = new StockService();
    
    out.println("<h2>Đang tiến hành cập nhật dữ liệu...</h2>");
    out.println("<p>Vui lòng kiên nhẫn đợi, không tắt trình duyệt.</p>");
    out.println("<ul>");
    
    // Lấy danh sách để hiển thị cho người dùng biết sẽ update cái gì
    List<String> symbols = service.getAllActiveSymbols();
    for(String sym : symbols) {
        out.println("<li>Đã tìm thấy mã: " + sym + "</li>");
    }
    out.println("</ul>");
    
    // Gọi hàm chạy chậm (Batch Update)
    // Lưu ý: Việc gọi hàm này sẽ làm treo trình duyệt cho đến khi chạy xong
    // Trong thực tế người ta dùng Thread riêng, nhưng để test thì gọi trực tiếp cũng được.
    service.runBatchUpdate();

    out.println("<h3>✅ CẬP NHẬT HOÀN TẤT! Kiểm tra Database ngay.</h3>");

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
