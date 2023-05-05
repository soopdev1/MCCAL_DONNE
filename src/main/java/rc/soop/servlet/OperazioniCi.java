/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.servlet;

import com.google.gson.JsonObject;
import rc.soop.db.Entity;
import rc.soop.domain.Cad;
import rc.soop.domain.Email;
import rc.soop.domain.User;
import rc.soop.util.SendMailJet;
import rc.soop.util.Utility;
import static rc.soop.util.Utility.titlepro;
import java.io.IOException;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author rcosco
 */
public class OperazioniCi extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void creaCad(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        try {
            SimpleDateFormat sdf_h = new SimpleDateFormat("HH:mm");
            String pwd = Utility.getRandomString(8);

            e.begin();

            Cad c = new Cad();
            c.setNome(request.getParameter("nome").trim());
            c.setCognome(request.getParameter("cognome").trim());
            c.setEmail(request.getParameter("email").trim());
            c.setNumero(request.getParameter("numero"));
            c.setGiorno(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("giorno")));
            c.setOrariostart(sdf_h.parse(request.getParameter("start")));
            c.setOrarioend(sdf_h.parse(request.getParameter("end")));
            c.setPassword(pwd);
            c.setUser((User) request.getSession().getAttribute("user"));

            e.persist(c);
            e.flush();
            e.commit();
            String dominio = e.getPath("dominio");
            //manda mail
            Email email = e.getEmail("colloquio");
            email.setTesto(email.getTesto()
                    .replace("@redirect", dominio + "redirect_out.jsp")
                    .replace("@link", e.getPath("linkfad"))
                    .replace("@id", c.getId().toString())
                    .replace("@user", c.getEmail())
                    .replace("@pwd", pwd)
                    .replace("@nome", c.getNome())
                    .replace("@giorno", request.getParameter("giorno"))
                    .replace("@start", request.getParameter("start"))
                    .replace("@end", request.getParameter("end"))
                    .replace("@email_tec", e.getPath("emailtecnico"))
                    .replace("@email_am", e.getPath("emailamministrativo")));
            SendMailJet.sendMail(titlepro, new String[]{c.getEmail()},
                    email.getTesto(),
                    email.getOggetto());
            //MANCA USER-----------------------
            //manda sms

            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro creaCad: " + Utility.estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile rendicontare progetto.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void modifyCad(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        try {
            SimpleDateFormat sdf_h = new SimpleDateFormat("HH:mm");
            e.begin();

            Cad c = e.getEm().find(Cad.class, Long.valueOf(request.getParameter("idCad")));
            c.setNome(request.getParameter("nome").trim());
            c.setCognome(request.getParameter("cognome").trim());
            c.setEmail(request.getParameter("email").trim());
            c.setNumero(request.getParameter("numero"));
            c.setGiorno(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("giorno")));
            c.setOrariostart(sdf_h.parse(request.getParameter("start")));
            c.setOrarioend(sdf_h.parse(request.getParameter("end")));
            c.setUser((User) request.getSession().getAttribute("user"));

            e.merge(c);
            e.flush();
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro creaCad: " + Utility.estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile rendicontare progetto.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void changeStateCAD(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        try {
            e.begin();
            Cad c = e.getEm().find(Cad.class, Long.valueOf(request.getParameter("id")));
            c.setStato(Integer.parseInt(request.getParameter("stato")));
            e.merge(c);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro changeStateCAD: " + Utility.estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile modificare il CAD.");
        } finally {
            e.close();
        }

        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        User us = (User) request.getSession().getAttribute("user");
        if (us != null && (us.getTipo() == 2 || us.getTipo() == 4)) {
            String type = request.getParameter("type");
            switch (type) {
                case "creaCad":
                    creaCad(request, response);
                    break;
                case "modifyCad":
                    modifyCad(request, response);
                    break;
                case "changeStateCAD":
                    changeStateCAD(request, response);
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
