/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import rc.soop.util.Utility;
import rc.soop.db.Entity;
import rc.soop.domain.User;
import static rc.soop.util.Utility.redirect;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;

/**
 *
 * @author rcosco
 */
public class ExternalLogin extends HttpServlet {

    protected void getToken(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String random = Utility.getRandomString(16);

        Entity e = new Entity();
        e.begin();
        User u = e.getUserbyUsername(request.getParameter("username"));
        u.setToken(random);
        u.setToken_timestamp(new Date());
        e.merge(u);
        e.commit();
        e.close();
        response.getWriter().write(random);
    }

    protected void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("username");
        Entity e = new Entity();
        User us_monitor = getUser(request);
        User us = e.getUserbyUsernameToken(user, us_monitor.getToken());
        if (us != null) {
            long diff = new Date().getTime() - us.getToken_timestamp().getTime();
            if (diff < 10000 && us_monitor.getToken().equals(us.getToken())) {
                if (request.getContextPath().contains("MCCAL")) {
                    request.getSession().setAttribute("src", "../..");
                } else {
                    request.getSession().setAttribute("src", e.getPath("dominio"));
                }
                if (us.getStato() != 0) {
                    request.getSession().setAttribute("user", us);
                    e.insertTracking(us.getUsername(), "Log In");
                    request.getSession().setAttribute("guida", e.getPath("guida_MC"));
                    redirect(request, response, "page/mc/indexMicrocredito.jsp");
                } else {
                    redirect(request, response, "redirect.jsp?page=login.jsp&esito=banned");
                }
            } else {
                redirect(request, response, "redirect.jsp?page=login.jsp&esito=KO");
            }
        } else {
            redirect(request, response, "redirect.jsp?page=login.jsp&esito=KO");
        }
        e.close();
    }

    private User getUser(HttpServletRequest request) {
        try {
            Entity e = new Entity();
            HttpClient httpclient = HttpClients.createDefault();
            HttpPost httppost = new HttpPost(e.getPath("monitoring"));
            e.close();
            
            // Request parameters and other properties.
            List<NameValuePair> params = new ArrayList<NameValuePair>(2);
            params.add(new BasicNameValuePair("type", "getUserToken"));
            params.add(new BasicNameValuePair("username", request.getParameter("username")));
            httppost.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));

            //Execute and get the response.
            HttpResponse resp = httpclient.execute(httppost);
            HttpEntity entity = resp.getEntity();

            if (entity != null) {
                try (InputStream instream = entity.getContent()) {
                    String line;
                    BufferedReader rd = new BufferedReader(new InputStreamReader(instream));
                    while ((line = rd.readLine()) != null) {
                        return (User) new ObjectMapper().readValue(line, User.class);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String type = request.getParameter("type");
        switch (type) {
            case "getToken":
                getToken(request, response);
                break;
            case "login":
                login(request, response);
                break;
            default:
                break;
        }
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
