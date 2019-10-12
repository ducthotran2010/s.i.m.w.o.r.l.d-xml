package thotd.controllers.general;

import thotd.dao.NetworkOperatorDAO;
import thotd.dao.SimDAO;
import thotd.generated.Sim;
import thotd.generated.SupplierType;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;

public class SearchSimServlet extends HttpServlet {
    private static final String DESTINATION = "index.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/xml;charset=UTF-8");
        String url = DESTINATION;
        try {
            /**
             * need optimize for dom
             */

            String phone = (String) request.getParameter("phone");
            String priceLimit = (String) request.getParameter("priceLimit");
            String[] startWiths = (String[]) request.getParameterValues("startWith");
            String[] notIncludes = (String[]) request.getParameterValues("notInclude");
            String[] networkOperators = (String[]) request.getParameterValues("networkOperator");


            System.out.println("Params");
            System.out.println(phone);
            System.out.println(priceLimit);
            System.out.println(startWiths);
            System.out.println(notIncludes);
            System.out.println(networkOperators);
            System.out.println("-----------");

            SimDAO simDAO = new SimDAO();
            String result = simDAO.search(phone, priceLimit, startWiths, notIncludes, networkOperators);
            response.setStatus(200);
            response.getWriter().print(result);
        } catch (Exception e ) {
            response.setStatus(400);
            log("Error at SearchSimController", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}
