package thotd.controllers.general;

import thotd.constants.LoginConstant;
import thotd.dao.AccountDAO;
import thotd.dto.AccountDTO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    private static final String ADMIN_PAGE = "admin.jsp";
    private static final String ERROR_PAGE = "error.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGE;

        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            AccountDAO dao = new AccountDAO();
            String result = dao.checkLogin(username, password);
            switch (result) {
                case LoginConstant.LOGIN_SUCCESS:
                    AccountDTO dto = dao.getAccountByUsername(username);
                    HttpSession session = request.getSession();
                    session.setAttribute("USER", dto);
                    url = ADMIN_PAGE;

                case LoginConstant.LOGIN_INVALID:
                    request.setAttribute("Error", "Your account is removed");

                default:
                case LoginConstant.LOGIN_FAIL:
                    request.setAttribute("Error", "Your username or password is invalid");
            }

        } catch (Exception e) {
            log("Error at LoginServlet", e);
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
