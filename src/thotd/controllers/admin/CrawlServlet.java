package thotd.controllers.admin;

import thotd.constants.PathConstant;
import thotd.dao.NetworkOperatorDAO;
import thotd.dao.SimDAO;
import thotd.dao.TagDAO;
import thotd.generated.NetworkOperator;
import thotd.generated.NetworkOperators;
import thotd.generated.Sim;
import thotd.resolvers.Crawler;
import thotd.resolvers.DataResolver;
import thotd.utils.JAXBUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.*;
import java.util.ArrayList;


public class CrawlServlet extends HttpServlet {
    private static final String ADMIN_PAGE = "admin.jsp";
    private static final String ERROR_PAGE = "error.jsp";
    private static final int LIMIT_TOTAL_PAGE = 10;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGE;

        int totalPage = 1;
        String strTotalPage = request.getParameter("totalPage");
        try {
            totalPage = Integer.parseInt(strTotalPage);
        } catch (Exception e) {
            /* do nothing */
        }

        try {
            if (totalPage < 1 || LIMIT_TOTAL_PAGE < totalPage) {
                throw new OutOfMemoryError("Crawl too much pages can lead out of memory");
            }

            String path = request.getServletContext().getRealPath("/");
            String xmlPath = path + PathConstant.CONFIG_XML;
            String xlsPath = path + PathConstant.CONFIG_XSL_SODEPAMI;
            ArrayList<DOMResult> domResults = (ArrayList<DOMResult>) Crawler.doCrawlForPaginatedSite(xmlPath, xlsPath, totalPage);

            /**
             * Save to file in development stage
             */
            /*
             TransformerFactory transformerFactory = TransformerFactory.newInstance();
             Transformer transformer = transformerFactory.newTransformer();
             StreamResult streamResult = new StreamResult(new FileOutputStream("/Users/thotd/Desktop/crawled.xml"));
             transformer.transform(new DOMSource(domResults.get(0).getNode()), streamResult);
             */

            /**
             * Save to database
             */
            DataResolver dataResolver = new DataResolver();
            for (DOMResult domResult : domResults) {
                dataResolver.saveDomResultToDatabase(domResult);
            }

            url = ADMIN_PAGE;
        } catch (Exception e) {
            request.setAttribute("Error", "Could not crawl data");
            log("Error at CrawlServlet", e);
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
