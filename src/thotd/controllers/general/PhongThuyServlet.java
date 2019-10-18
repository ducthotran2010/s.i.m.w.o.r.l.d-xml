package thotd.controllers.general;

import thotd.dao.NetworkOperatorDAO;
import thotd.dao.PhongThuyDAO;
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

public class PhongThuyServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/xml;charset=UTF-8");
        try {
            PhongThuyDAO phongThuyDAO = new PhongThuyDAO();
            String result = phongThuyDAO.getAll();
            response.setStatus(200);
            response.getWriter().print(result);
        } catch (Exception e ) {
            response.setStatus(500);
            log("Error at PhongThuyServlet", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}
