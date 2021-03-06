package thotd.controllers.admin;

import thotd.constants.PathConstant;
import thotd.resolvers.Crawler;
import thotd.resolvers.DataResolver;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;


public class CrawlPhongThuyServlet extends HttpServlet {
    private static final String ADMIN_PAGE = "admin.jsp";
    private static final String ERROR_PAGE = "error.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGE;

        try {
            String realPath = request.getServletContext().getRealPath("/");
            String xmlPath = realPath + PathConstant.CONFIG_PHONGTHUY_XML;
            String xslPath = realPath + PathConstant.CONFIG_PHONGTHUY_XSL;
            DOMResult domResult = Crawler.doCrawlForSingleSite(xmlPath, xslPath);

           /**
            * Save to file in development stage
            */
           /*
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            StreamResult streamResult = new StreamResult("/Users/thotd/Desktop/crawled.xml");
            transformer.transform(new DOMSource(domResult.getNode()), streamResult);
            */

           /**
            * Save to database
            */
            DataResolver dataResolver = new DataResolver();
            dataResolver.savePhongThuyDomResultToDatebase(domResult);

            url = ADMIN_PAGE;
        } catch (Exception e) {
            request.setAttribute("Error", "Could not crawl data");
            log("Error at CrawlPhongThuyServlet", e);
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
