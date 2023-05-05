/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import rc.soop.db.Entity;
import rc.soop.domain.Cad;
import rc.soop.domain.User;
import rc.soop.util.Utility;
import static rc.soop.util.Utility.estraiEccezione;
import java.io.IOException;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author rcosco
 */
public class QueryCi extends HttpServlet {

    protected void getCad(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setHeader("Content-Type", "application/json");
        Entity e = new Entity();
        try {
            Date giorno = request.getParameter("giorno") != null && !request.getParameter("giorno").trim().isEmpty()
                    ? new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("giorno"))
                    : null;
            List<Cad> d = e.getCad(giorno, (User) request.getSession().getAttribute("user"));
            String id = request.getParameter("id");
            if (id != null && !id.equals("")) {
                d.remove(e.getEm().find(Cad.class, Long.valueOf(id)));
            }

            ObjectMapper mapper = new ObjectMapper();
            response.getWriter().print(mapper.writeValueAsString(d));
            response.getWriter().close();
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void getMyCad(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        SimpleDateFormat sdf_h = new SimpleDateFormat("HH:mm");
        sdf.setTimeZone(TimeZone.getTimeZone("CET"));
        Entity e = new Entity();
        try {
            String data = request.getParameter("data");

            List<Cad> cad = e.getCadFromDate(new SimpleDateFormat("yyyy-MM-dd").parse(data), (User) request.getSession().getAttribute("user"));

            JsonArray j_array = new JsonArray();

            ArrayList<String> color = new ArrayList<>();
            color.add("fc-event-solid-success");
            color.add("fc-event-solid-danger");
            color.add("fc-event-solid-warning");
            color.add("fc-event-solid-brand");
            color.add("fc-event-solid-light");
            color.add("fc-event-solid-dark");
            color.add("fc-event-solid-primary");
            color.add("fc-event-solid-info");

            int i_color = 0;

            for (Cad c : cad) {

                JsonObject event = new JsonObject();
                event.addProperty("title", c.getNome() + " " + c.getCognome());
                event.addProperty("description", c.getNome() + " " + c.getCognome() + " dalle " + sdf_h.format(c.getOrariostart()) + " alle " + sdf_h.format(c.getOrarioend()));
                event.addProperty("className", color.get(i_color));
                event.addProperty("id", c.getId());
                event.addProperty("stato", c.getStato());
                event.addProperty("start", sdf.format(new Date(c.getGiorno().getTime() + c.getOrariostart().getTime() + (60 * 60 * 1000))));
                event.addProperty("end", sdf.format(new Date(c.getGiorno().getTime() + c.getOrarioend().getTime() + (60 * 60 * 1000))));
                j_array.add(event);
                if (i_color + 1 == color.size()) {
                    i_color = 0;
                } else {
                    i_color++;
                }
            }
            response.getWriter().write(j_array.toString());
            response.getWriter().flush();
            response.getWriter().close();
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void getSingleCad(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            Cad cad = e.getEm().find(Cad.class, Long.valueOf(request.getParameter("id")));
            //aggiungo 2 parametri al json
            StringWriter sw = new StringWriter();
            ObjectMapper mapper = new ObjectMapper();
            mapper.writeValue(sw, cad);
            JsonObject jMembers = new JsonParser().parse(sw.toString()).getAsJsonObject();
            jMembers.addProperty("link", e.getPath("linkfad"));
            response.setContentType("application/json");
            response.setHeader("Content-Type", "application/json");
            response.getWriter().print(jMembers.toString());
            response.getWriter().close();
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        User us = (User) request.getSession().getAttribute("user");
        if (us != null && (us.getTipo() == 2 || us.getTipo() == 4)) {
            String type = request.getParameter("type");
            switch (type) {
                case "getCad":
                    getCad(request, response);
                    break;
                case "getMyCad":
                    getMyCad(request, response);
                    break;
                case "getSingleCad":
                    getSingleCad(request, response);
                    break;
                default:
                    break;
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
        processRequest(request, response);
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
