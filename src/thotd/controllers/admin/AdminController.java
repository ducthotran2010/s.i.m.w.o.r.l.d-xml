package thotd.controllers.admin;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AdminController extends HttpServlet {
    private static final String LOGIN_PAGE = "login.jsp";
    private static final String CRAWL_PAGE = "CrawlServlet";
    private static final String CRAWL_ORDER_PAGE = "CrawlOrderServlet";
    private static final String CRAWL_PHONGTHUY_PAGE = "CrawlPhongThuyServlet";
    private static final String ERROR_PAGE = "error.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGE;
        try {
            HttpSession session = request.getSession();
            if (session.getAttribute("USER") == null) {
                url = LOGIN_PAGE;
                return;
            }

            String btnAction = request.getParameter("btnAction");

            if ("Crawl".equals(btnAction)) {
                url = CRAWL_PAGE;
            } else if ("CrawlOrder".equals(btnAction)) {
                url = CRAWL_ORDER_PAGE;
            } else if ("CrawlPhongThuy".equals(btnAction)) {
                url = CRAWL_PHONGTHUY_PAGE;
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
