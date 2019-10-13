package thotd.controllers.general;

import thotd.dao.NetworkOperatorDAO;
import thotd.dao.OrderDAO;
import thotd.dao.SimDAO;
import thotd.generated.Sim;
import thotd.generated.SupplierType;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class LookUpServlet extends HttpServlet {
    private static final String LOOK_UP_PAGE = "look-up.jsp";
    private static final String ERROR_PAGE = "error.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGE;
        try {
            String phoneNumber = request.getParameter("phoneNumber");

            OrderDAO orderDAO = new OrderDAO();
            String result = orderDAO.search(phoneNumber);

            request.setAttribute("Result", result);
            url = LOOK_UP_PAGE;
        } catch (Exception e ) {
            log("Error at LookUpServlet", e);
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
