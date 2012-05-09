package ru.spbstu.servlets;

import com.thoughtworks.xstream.XStream;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import ru.spbstu.apicore.ActionActivator;
import ru.spbstu.apicore.actions.IServerAction;
import ru.spbstu.utils.StringUtils;

/**
 *
 * @author igofed
 */
public class ApiServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {

            try {
                XStream xStream = new XStream();
                
                //todo: id to cookie
                //read parameters from get data
                String actionName = request.getParameter("action");
                String id = request.getParameter("id");
                
                //deserialize xml from post data
                String requestXml = StringUtils.stringFromInputStream(request.getInputStream());
                Object requestObject = xStream.fromXML(requestXml);

                //new action by it's name
                IServerAction serverAction = ActionActivator.getAction(actionName);

                //processing request               
                Object responseObject = serverAction.process(Long.parseLong(id), requestObject);
                String responseXml = xStream.toXML(responseObject);
                
                //sending xml to client
                out.print(responseXml);
            } catch (Exception ex) {
               //all is bad =((( 
               //internal error to client
               response.sendError(500);
            }

        } finally {
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
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
     * Handles the HTTP
     * <code>POST</code> method.
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
