/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonObject;
import com.mailjet.client.errors.MailjetException;
import rc.soop.db.Entity;
import rc.soop.domain.Comuni;
import rc.soop.domain.SoggettiAttuatori;
import rc.soop.domain.User;
import rc.soop.domain.Email;
import rc.soop.entity.Item;
import rc.soop.util.GoogleRecaptcha;
import rc.soop.util.SendMailJet;
import rc.soop.util.Utility;
import static rc.soop.util.Utility.redirect;
import static rc.soop.util.Utility.titlepro;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import org.json.JSONObject;

/**
 *
 * @author rcosco
 */
public class Login extends HttpServlet {

    protected void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("username");
        String password = request.getParameter("password");
        Entity e = new Entity();
        User us = e.getUser(user, password);
        if (request.getContextPath().contains("MCCAL")) {
            request.getSession().setAttribute("src", "../..");
        } else {
            request.getSession().setAttribute("src", e.getPath("dominio"));
        }

        if (us != null) {
            if (us.getStato() != 0) {
                request.getSession().setAttribute("user", us);
                e.insertTracking(us.getUsername(), "Log In");
                switch (us.getTipo()) {
                    case 1:
                    case 3:
                        request.getSession().setAttribute("t_user", "sa");
                        request.getSession().setAttribute("guida", e.getPath("guida_SA"));
                        redirect(request, response, "page/sa/indexSoggettoAttuatore.jsp");
                        break;
                    case 2:
                        request.getSession().setAttribute("guida", e.getPath("guida_MC"));
                        redirect(request, response, "page/mc/indexMicrocredito.jsp");
                        break;
                    case 4:
                        request.getSession().setAttribute("guida", "");
                        redirect(request, response, "page/ci/indexCi.jsp");
                        break;
                    default:
                        break;
                }
            } else {
                redirect(request, response, "redirect.jsp?page=login.jsp&esito=banned");
            }
        } else {
            redirect(request, response, "redirect.jsp?page=login.jsp&esito=KO");
        }
        e.close();
    }

    protected void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getSession().invalidate();
        redirect(request, response, "login.jsp");
    }

    protected void getProvincia(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        String regione = request.getParameter("regione");
        Entity e = new Entity();
        ArrayList<Item> provincie = e.listaProvince(regione);
        e.close();
        ObjectMapper mapper = new ObjectMapper();
        response.getWriter().write(mapper.writeValueAsString(provincie));
    }

    protected void getComune(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        String provincia = request.getParameter("provincia");
        Entity e = new Entity();
        ArrayList<Item> comuni = e.listaComuni(provincia);
        e.close();
        ObjectMapper mapper = new ObjectMapper();
        response.getWriter().write(mapper.writeValueAsString(comuni));
    }

    protected void checkPiva(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        String piva = request.getParameter("piva");
        Entity e = new Entity();
        SoggettiAttuatori sa = e.getUserPiva(piva);
        e.close();
        ObjectMapper mapper = new ObjectMapper();
        response.getWriter().write(mapper.writeValueAsString(sa));
    }

    protected void checkCF(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        String cf = request.getParameter("cf");
        Entity e = new Entity();
        SoggettiAttuatori sa = e.getUserCF(cf);
        e.close();
        ObjectMapper mapper = new ObjectMapper();
        response.getWriter().write(mapper.writeValueAsString(sa));
    }

    protected void checkEmail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        Entity e = new Entity();
        SoggettiAttuatori us = e.getUserEmail(email);
        e.close();
        ObjectMapper mapper = new ObjectMapper();
        response.getWriter().write(mapper.writeValueAsString(us));
    }

    protected void checkEmailUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        Entity e = new Entity();
        User us = e.getUserbyEmail(email);
        e.close();
        ObjectMapper mapper = new ObjectMapper();
        response.getWriter().write(mapper.writeValueAsString(us));
    }

    protected void saveSoggettoAttuatore(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

        JsonObject resp = new JsonObject();

        try {
            if (GoogleRecaptcha.isValid(request.getParameter("g-recaptcha-response"))) {
                boolean check_piva = e.getUserPiva(request.getParameter("piva")) == null && !request.getParameter("piva").equalsIgnoreCase("");
                boolean check_cf = e.getUserCF(request.getParameter("cf")) == null && !request.getParameter("cf").equalsIgnoreCase("");
                if (check_piva || check_cf) {
                    Part p = request.getPart("cartaid");
                    String ext = p.getSubmittedFileName().substring(p.getSubmittedFileName().lastIndexOf("."));
                    String path = e.getPath("pathDocSA").replace("@folder", Utility.correctName(request.getParameter("ragionesociale")));
                    HashMap<String, String> listusernames = e.getUsersSA();
                    File dir = new File(path);
                    dir.mkdirs();
                    path += Utility.correctName(request.getParameter("nome_ad") + "_" + request.getParameter("cognome_ad")) + ext;
                    p.write(path);

                    SoggettiAttuatori sa = new SoggettiAttuatori();
                    sa.setRagionesociale(request.getParameter("ragionesociale"));
                    if (check_piva) {
                        sa.setPiva(request.getParameter("piva"));
                    }
                    if (check_cf) {
                        sa.setCodicefiscale(request.getParameter("cf"));
                    }
                    sa.setEmail(request.getParameter("email"));
                    sa.setPec(request.getParameter("pec"));
                    sa.setTelefono_sa(request.getParameter("telefono_sa"));
                    sa.setCell_sa(request.getParameter("cell_sa"));
                    sa.setIndirizzo(request.getParameter("indirizzo"));
                    sa.setCap(request.getParameter("cap"));
                    sa.setComune((Comuni) e.getEm().find(Comuni.class, Long.valueOf(request.getParameter("comune"))));
                    sa.setNome(request.getParameter("nome_ad"));
                    sa.setCognome(request.getParameter("cognome_ad"));
//            sa.setTelefono_Ad(request.getParameter("telefono_ad"));
                    sa.setDatanascita(sdf.parse(request.getParameter("datanascita")));
                    sa.setScadenza(sdf.parse(request.getParameter("scadenza")));
                    sa.setNome_refente(request.getParameter("nome_ref"));
                    sa.setCognome_referente(request.getParameter("cognome_ref"));
                    sa.setTelefono_referente(request.getParameter("tel_ref"));
                    sa.setNro_documento(request.getParameter("nrodocumento"));
                    sa.setCartaid(path);

                    String pwd = Utility.getRandomString(8);
                    User u = new User();
                    u.setUsername(Utility.UniqueUser(listusernames, sa.getEmail().substring(0, sa.getEmail().lastIndexOf("@"))));
                    u.setPassword(Utility.convMd5(pwd));
                    u.setTipo(3);
                    u.setSoggettoAttuatore(sa);
                    u.setEmail(sa.getEmail());

                    e.begin();
//                e.persist(sa);
                    e.persist(u);
                    e.flush();
                    e.commit();
                    try {
                        Email email = (Email) e.getEmail("registration");
                        String email_txt = email.getTesto().replace("@username", u.getUsername())
                                .replace("@password", pwd)
                                .replace("@email_tec", e.getPath("emailtecnico"))
                                .replace("@email_am", e.getPath("emailamministrativo"));
                        SendMailJet.sendMail(titlepro, new String[]{sa.getEmail()}, email_txt, email.getOggetto());
                        resp.addProperty("result", true);
                    } catch (Exception ex) {
                        e.insertTracking(null, "forgotPwd Errore Invio Mail: " + Utility.estraiEccezione(ex));
                        resp.addProperty("result", false);
                        resp.addProperty("messagge", "Non è stato possibile inviare la mail, contattare l'assistenza per farsi inviare le credenziali.");
                    }

                    resp.addProperty("result", true);
                } else {
                    resp.addProperty("result", false);
                    if (!check_cf) {
                        resp.addProperty("message", "Errore: non &egrave; stato possibile registrarsi.<br>Codice Fiscale gi&agrave; presente");
                    } else if (!check_piva) {
                        resp.addProperty("message", "Errore: non &egrave; stato possibile registrarsi.<br>P.IVA gi&agrave; presente");
                    }
                    resp.addProperty("message", "Errore: non &egrave; stato possibile registrarsi.<br>CF o P.IVA gi&agrave; presente");
                }
            } else {
                resp.addProperty("result", false);
                resp.addProperty("message", "Ci dispiace ma Google ti ha rilevato come bot");
            }
        } catch (Exception ex) {
            e.insertTracking(null, "saveSoggettoAttuatore Errore: " + Utility.estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile registrarsi.<br>Riprovare, se l'errore persiste contattare l'assistenza");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void forgotPwd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        String username = request.getParameter("email");
        Entity e = new Entity();
        String pwd;
        User us = e.getUserbyUsername(username);

        us = us == null ? e.getUserbyEmail(username) : us;

        JsonObject resp = new JsonObject();
        try {
            if (us != null) {
                String email = us.getEmail();
                pwd = Utility.getRandomString(8);
                us.setPassword(Utility.convMd5(pwd));
                us.setStato(2);
                e.begin();
                e.merge(us);
                e.commit();
                try {
                    Email email_txt = (Email) e.getEmail("reset_password");
                    SendMailJet.sendMail(titlepro, new String[]{email}, email_txt.getTesto().replace("@username", us.getUsername())
                            .replace("@email_tec", e.getPath("emailtecnico"))
                            .replace("@email_am", e.getPath("emailamministrativo"))
                            .replace("@password", pwd), email_txt.getOggetto());
                    resp.addProperty("result", true);
                } catch (MailjetException ex) {
                    e.insertTracking(null, "forgotPwd Errore Invio Mail: " + Utility.estraiEccezione(ex));
                    resp.addProperty("result", false);
                    resp.addProperty("messagge", "Non è stato possibile inviare la mail, contattare l'assistenza per il reset password.");
                }
            } else {
                resp.addProperty("result", false);
                resp.addProperty("messagge", "<b>" + username + "</b><br/> non è associato a nessun account.");
            }
        } catch (Exception ex) {
            e.insertTracking(null, "forgotPwd Errore: " + Utility.estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("messagge", "Errore durante il recupero password. Se l'errore persiste contattare il servizio assistenza.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();

    }

    protected void changePwd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        User us = (User) request.getSession().getAttribute("user");

        String old_pwd = Utility.convMd5(request.getParameter("old_pwd"));
        String new_pwd = request.getParameter("new_pwd");
        String new_pwd_2 = request.getParameter("new_pwd_2");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        try {
            if (us.getPassword().equals(old_pwd) && new_pwd.equals(new_pwd_2)) {
                us.setPassword(Utility.convMd5(new_pwd));
                if (us.getSoggettoAttuatore() != null) {
                    us.setTipo(us.getSoggettoAttuatore().getProtocollo() == null ? 3 : 1);
                }
                us.setStato(1);
                e.begin();
                e.merge(us);
                e.commit();
                
                request.getSession().setAttribute("user", us);
                request.getSession().setAttribute("changePwd", "0");
                resp.addProperty("result", true);
            } else {
                resp.addProperty("result", false);
                if (!us.getPassword().equals(old_pwd)) {
                    resp.addProperty("messagge", "Vecchia password errata.");
                } else if (!new_pwd.equals(new_pwd_2)) {
                    resp.addProperty("messagge", "La password nuova non coincide.");
                }
            }
        } catch (Exception ex) {
            e.insertTracking(null, "changePwd Errore: " + Utility.estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("messagge", "Errore durante il cambio password. Se l'errore persiste contattare il servizio assistenza.");
        } finally {
            e.close();
        }

        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void botAreU(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JSONObject result = new JSONObject();
        try {
            result.put("result", GoogleRecaptcha.isValid(request.getParameter("g-recaptcha-response")));
        } catch (Exception ex) {
            result.put("result", false);
            Utility.log.severe(Utility.estraiEccezione(ex));
        }
        response.getWriter().write(result.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        response.setContentType("text/hend");tml;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        String type = request.getParameter("type");
        switch (type) {
            case "login":
                login(request, response);
                break;
            case "logout":
                logout(request, response);
                break;
            case "getProvincia":
                getProvincia(request, response);
                break;
            case "getComune":
                getComune(request, response);
                break;
            case "saveSoggettoAttuatore":
                saveSoggettoAttuatore(request, response);
                break;
            case "forgotPwd":
                forgotPwd(request, response);
                break;
            case "changePwd":
                changePwd(request, response);
                break;
            case "checkPiva":
                checkPiva(request, response);
                break;
            case "checkEmail":
                checkEmail(request, response);
                break;
            case "botAreU":
                botAreU(request, response);
                break;
            case "checkCF":
                checkCF(request, response);
                break;
            case "checkEmailUser":
                checkEmailUser(request, response);
                break;
            default:
                break;
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
