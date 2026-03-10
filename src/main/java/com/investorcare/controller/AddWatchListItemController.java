/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.investorcare.controller;

import com.investorcare.model.WatchListItem;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author quyt2
 */
public class AddWatchListItemController extends HttpServlet {

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

        String watchListIdStr = request.getParameter("watchListId");
        // Xui rủi mà lỗi thì đá về danh sách thư mục gốc
        String url = "MainController?action=watch-list";

        try {
            String assetIdStr = request.getParameter("assetId");

            if (watchListIdStr != null && assetIdStr != null) {
                int watchListId = Integer.parseInt(watchListIdStr);
                int assetId = Integer.parseInt(assetIdStr);

                com.investorcare.dao.WatchListItemDAO dao = new com.investorcare.dao.WatchListItemDAO();

                // KHÚC CHẶN CỬA: Kiểm tra xem mã này đã có trong thư mục chưa
                boolean isExist = dao.checkItemExists(watchListId, assetId);

                if (isExist) {
                    // NẾU BỊ TRÙNG: Quăng thông báo lỗi và bẻ lái về lại trang Thêm (Forward)
                    request.setAttribute("ERROR_MSG", "Mã tài sản này đã có trong thư mục theo dõi rồi!");

                    // Giữ lại ID thư mục để trang addWatchListItem.jsp không bị mồ côi
                    request.setAttribute("CURRENT_WATCHLIST_ID", watchListId);

                    // Lưu ý: Chỗ này m phải forward về cái Action chuyên hiển thị trang Add
                    // (Giả sử action của m tên là "show-add-item", m sửa lại cho đúng tên trong MainController nhé)
                    url = "MainController?action=show-add-item&watchListId=" + watchListId;
                    request.getRequestDispatcher(url).forward(request, response);

                    return; // Dừng luôn hàm, không cho chạy xuống đoạn Redirect bên dưới
                } else {
                    // NẾU CHƯA CÓ: Thực hiện code thêm mới như cũ
                    WatchListItem item = new WatchListItem();
                    item.setWatchListId(watchListId);
                    item.setAssetId(assetId);

                    boolean check = dao.insert(item);

                    if (check) {
                        // Thành công thì dùng Redirect đá về trang Chi Tiết Thư Mục
                        url = "MainController?action=watchlist-item&selectedId=" + watchListId;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Bẻ lái (PRG Pattern chống F5)
        response.sendRedirect(url);
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
