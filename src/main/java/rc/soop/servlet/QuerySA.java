/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import rc.soop.db.Database;
import rc.soop.db.Entity;
import rc.soop.domain.Allievi;
import rc.soop.domain.CPI;
import rc.soop.domain.Docenti;
import rc.soop.domain.DocumentiPrg;
import rc.soop.domain.Documenti_Allievi;
import rc.soop.domain.Faq;
import rc.soop.domain.ProgettiFormativi;
import rc.soop.domain.Selfiemployment_Prestiti;
import rc.soop.domain.StatiPrg;
import rc.soop.domain.StatoPartecipazione;
import rc.soop.domain.User;
import rc.soop.entity.Item;
import rc.soop.util.Fadroom;
import static rc.soop.util.Utility.estraiEccezione;
import static rc.soop.util.Utility.log;
import static rc.soop.util.Utility.writeJsonResponseR;
import java.io.IOException;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author rcosco
 */
public class QuerySA extends HttpServlet {

    protected void searchAllievi(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            User us = (User) request.getSession().getAttribute("user");
            String nome = request.getParameter("nome") == null ? "" : request.getParameter("nome");
            String cognome = request.getParameter("cognome") == null ? "" : request.getParameter("cognome");
            String cf = request.getParameter("cf") == null ? "" : request.getParameter("cf");
            CPI c = request.getParameter("cpi").equals("-") ? null : e.getEm().find(CPI.class, request.getParameter("cpi"));
            String stato = request.getParameter("stato");

            List<Allievi> list = e.getAllieviSA(nome, cognome, cf, stato, c, us.getSoggettoAttuatore());
            writeJsonResponse(response, list);

        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void searchDocenti(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {

            String nome = request.getParameter("nome") == null ? "" : request.getParameter("nome");
            String cognome = request.getParameter("cognome") == null ? "" : request.getParameter("cognome");
            String cf = request.getParameter("cf") == null ? "" : request.getParameter("cf");

            List<Docenti> list = e.getDocenti(nome, cognome, cf);

            list.forEach(d1 -> {
                if (d1.getProgetti().isEmpty()) {
                    d1.setAssegnato(false);
                } else {
                    d1.setAssegnato(true);
                }
            });

            writeJsonResponse(response, list);

        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void searchProgetti(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            User us = (User) request.getSession().getAttribute("user");
            String stato = request.getParameter("stato").equals("-") ? "" : request.getParameter("stato");
            String cip = request.getParameter("cip") == null ? "" : request.getParameter("cip");

            List<StatiPrg> sp = null;
            if (!stato.equals("")) {
                if (stato.equals("errore") || stato.equals("controllare")) {
                    sp = e.getStatibyTipo(stato);
                } else {
                    sp = e.getStatibyDescrizione(stato);
                }
            }
            List<ProgettiFormativi> list = e.getProgettiFormativi(((User) request.getSession().getAttribute("user")).getSoggettoAttuatore(), sp, cip);

            Database db1 = new Database();
            String linkfad = db1.getPathtemp("linkfad");
            List<Fadroom> lst = db1.listStanze();
            List<Item> rep = db1.listReport();
            db1.closeDB();

            list.forEach((ProgettiFormativi prog) -> {
                prog.setUsermc(us.getUsername());
                prog.setFadroom(null);
                prog.setFadlink(linkfad);
                try {
                    List<Fadroom> lst2 = lst.stream().filter(ite -> String.valueOf(ite.getIdpr()).equals(String.valueOf(prog.getId()))).collect(Collectors.toList());
                    if (!lst2.isEmpty()) {
                        prog.setFadroom(lst2);
                        prog.setFadreport(rep.stream().anyMatch(r1 -> r1.getValue().equals(String.valueOf(prog.getId()))));
                    }
                } catch (Exception ex) {
                    log.severe(estraiEccezione(ex));
                    prog.setFadroom(null);
                }
            });

            writeJsonResponseR(response, list);

        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void searchAllieviProgetti(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            ProgettiFormativi p = e.getEm().find(ProgettiFormativi.class, Long.valueOf(request.getParameter("idprogetto")));
            writeJsonResponse(response, p.getAllievi());

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            e.close();
        }
    }

    protected void searchDocentiProgetti(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            List<Docenti> list = e.getDocentiPrg(e.getEm().find(ProgettiFormativi.class, Long.valueOf(request.getParameter("idprogetto"))));
            writeJsonResponse(response, list);
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void getDocPrg(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            List<DocumentiPrg> docuemti = e.getDocPrg(e.getEm().find(ProgettiFormativi.class, Long.valueOf(request.getParameter("idprogetto"))));
            ObjectMapper mapper = new ObjectMapper();
            response.getWriter().write(mapper.writeValueAsString(docuemti));
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void getDocAllievo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            List<Documenti_Allievi> docuemti = e.getDocAllievo(e.getEm().find(Allievi.class, Long.valueOf(request.getParameter("idallievo"))));
            ObjectMapper mapper = new ObjectMapper();
            response.getWriter().write(mapper.writeValueAsString(docuemti));
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void getDocentiByPrg(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            List<Docenti> docenti = e.getDocentiPrg(e.getEm().find(ProgettiFormativi.class, Long.valueOf(request.getParameter("idprogetto"))));
            ObjectMapper mapper = new ObjectMapper();
            response.getWriter().write(mapper.writeValueAsString(docenti));
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void getDocAllievoById(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            Documenti_Allievi doc = e.getEm().find(Documenti_Allievi.class, Long.valueOf(request.getParameter("iddocumento")));
            ObjectMapper mapper = new ObjectMapper();
            response.getWriter().write(mapper.writeValueAsString(doc));
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void getSE_Prestiti(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            List<Selfiemployment_Prestiti> se_p = e.listaSE_P();
            ObjectMapper mapper = new ObjectMapper();
            response.getWriter().write(mapper.writeValueAsString(se_p));
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void getSIGMA(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            List<StatoPartecipazione> sp = e.lista_StatoPartecipazione();
            ObjectMapper mapper = new ObjectMapper();
            response.getWriter().write(mapper.writeValueAsString(sp));
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void searchProgettiDocente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            Docenti d = e.getEm().find(Docenti.class, Long.valueOf(request.getParameter("iddocente")));
            List<ProgettiFormativi> list = d.getProgetti().stream().sorted((x, y) -> x.getEnd().compareTo(y.getEnd())).limit(50).collect(Collectors.toList());
            writeJsonResponse(response, list);
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void getRegistriDay(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            List<DocumentiPrg> list = e.getRegistriDay(e.getEm()
                    .find(ProgettiFormativi.class, Long.valueOf(request.getParameter("idprogetto"))),
                    new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("giorno")));
            ObjectMapper mapper = new ObjectMapper();
            response.getWriter().write(mapper.writeValueAsString(list));
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void checkRegistroAlievoExist(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            Documenti_Allievi registro = e.registriByAllievoAndDay(e.getEm().find(Allievi.class, Long.valueOf(request.getParameter("idallievo"))),
                    new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("giorno")));
            ObjectMapper mapper = new ObjectMapper();
            response.getWriter().write(mapper.writeValueAsString(registro));
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void getConversationSA(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            List<Faq> list = e.getFaqSoggetto(((User) request.getSession().getAttribute("user")).getSoggettoAttuatore());
            ObjectMapper mapper = new ObjectMapper();
            response.getWriter().write(mapper.writeValueAsString(list));
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        User us = (User) request.getSession().getAttribute("user");
        if (us != null && (us.getTipo() == 1 || us.getTipo() == 3)) {
            String type = request.getParameter("type");
            switch (type) {
                case "searchAllievi":
                    searchAllievi(request, response);
                    break;
                case "searchDocenti":
                    searchDocenti(request, response);
                    break;
                case "searchProgetti":
                    searchProgetti(request, response);
                    break;
                case "searchAllieviProgetti":
                    searchAllieviProgetti(request, response);
                    break;
                case "getDocPrg":
                    getDocPrg(request, response);
                    break;
                case "searchDocentiProgetti":
                    searchDocentiProgetti(request, response);
                    break;
                case "getDocAllievo":
                    getDocAllievo(request, response);
                    break;
                case "searchProgettiDocente":
                    searchProgettiDocente(request, response);
                    break;
                case "getDocentiByPrg":
                    getDocentiByPrg(request, response);
                    break;
                case "getDocAllievoById":
                    getDocAllievoById(request, response);
                    break;
                case "getSE_Prestiti":
                    getSE_Prestiti(request, response);
                    break;
                case "getSIGMA":
                    getSIGMA(request, response);
                    break;
                case "getRegistriDay":
                    getRegistriDay(request, response);
                    break;
                case "checkRegistroAlievoExist":
                    checkRegistroAlievoExist(request, response);
                    break;
                case "getConversationSA":
                    getConversationSA(request, response);
                    break;
                default:
                    break;
            }
        }
    }

    /*  metodi  */
    private void writeJsonResponse(HttpServletResponse response, Object list)
            throws ServletException, IOException {
        JsonObject jMembers = new JsonObject();
        StringWriter sw = new StringWriter();
        ObjectMapper mapper = new ObjectMapper();
        mapper.writeValue(sw, list);
        String json_s = sw.toString();
        JsonParser parser = new JsonParser();
        JsonElement tradeElement = parser.parse(json_s);
        jMembers.add("aaData", tradeElement.getAsJsonArray());
        response.setContentType("application/json");
        response.setHeader("Content-Type", "application/json");
        response.getWriter().print(jMembers.toString());
        response.getWriter().close();
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
