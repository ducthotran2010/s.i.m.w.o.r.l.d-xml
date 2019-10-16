package thotd.controllers.general;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginRoute extends HttpServlet {
    private static final String LOGIN_PAGE = "login.jsp";
    private static final String ADMIN_DASHBOARD = "admin.jsp";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("USER") != null) {
            request.getRequestDispatcher(ADMIN_DASHBOARD).forward(request, response);
        } else {
            request.getRequestDispatcher(LOGIN_PAGE).forward(request, response);
        }
    }
}