package thotd.controllers.admin;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AdminController extends HttpServlet {
    private static final String LOGIN_PAGE = "LoginServlet";
    private static final String CRAWL_PAGE = "CrawlServlet";
    private static final String CRAWL_ORDER_PAGE = "CrawlOrderServlet";
    private static final String ERROR_PAGE = "error.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGE;
        try {
            String btnAction = request.getParameter("btnAction");

            if ("Login".equals(btnAction)) {
                url = LOGIN_PAGE;
            } else if ("Crawl".equals(btnAction)) {
                url = CRAWL_PAGE;
            } else if ("CrawlOrder".equals(btnAction)) {
                url = CRAWL_ORDER_PAGE;
            } else {
                request.setAttribute("Error", "Your action is not supported");
            }
        } catch (Exception e) {
            log("Error at AdminController", e);
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}
