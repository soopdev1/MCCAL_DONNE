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
import rc.soop.domain.Attivita;
import rc.soop.domain.TipoFaq;
import rc.soop.domain.CPI;
import rc.soop.domain.Comuni;
import rc.soop.domain.CpiUser;
import rc.soop.domain.Docenti;
import rc.soop.domain.DocumentiPrg;
import rc.soop.domain.Documenti_Allievi;
import rc.soop.domain.Estrazioni;
import rc.soop.domain.FadMicro;
import rc.soop.domain.Faq;
import rc.soop.domain.ProgettiFormativi;
import rc.soop.domain.SediFormazione;
import rc.soop.domain.SoggettiAttuatori;
import rc.soop.domain.StatiPrg;
import rc.soop.domain.Storico_ModificheInfo;
import rc.soop.domain.Storico_Prg;
import rc.soop.domain.User;
import rc.soop.entity.Item;
import rc.soop.util.Fadroom;
import rc.soop.util.Utility;
import static rc.soop.util.Utility.estraiEccezione;
import static rc.soop.util.Utility.pregresso;
import static rc.soop.util.Utility.writeJsonResponseR;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
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
public class QueryMicro extends HttpServlet {

    protected void searchSA(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            String ragionesociale = request.getParameter("ragionesociale") == null ? "" : request.getParameter("ragionesociale");
            String protocollo = request.getParameter("protocollo") == null ? "" : request.getParameter("protocollo");
            String piva = request.getParameter("piva") == null ? "" : request.getParameter("piva");
            String cf = request.getParameter("cf") == null ? "" : request.getParameter("cf");
            String protocollare = request.getParameter("protocollare");
            String nome = request.getParameter("nome") == null ? "" : request.getParameter("nome");
            String cognome = request.getParameter("cognome") == null ? "" : request.getParameter("cognome");
            List<SoggettiAttuatori> list = e.getSoggettiAttuatori(ragionesociale, protocollo, piva, cf, protocollare, nome, cognome);
            writeJsonResponse(response, list);
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void searchAllievo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            SoggettiAttuatori sa = request.getParameter("soggettoattuatore").equals("-") ? null : e.getEm().find(SoggettiAttuatori.class, Long.valueOf(request.getParameter("soggettoattuatore")));
            CPI c = request.getParameter("cpi").equals("-") ? null : e.getEm().find(CPI.class, request.getParameter("cpi"));
            String nome = request.getParameter("nome") == null ? "" : request.getParameter("nome");
            String cognome = request.getParameter("cognome") == null ? "" : request.getParameter("cognome");
            String cf = request.getParameter("cf") == null ? "" : request.getParameter("cf");
            String flag_pregresso = request.getParameter("pregresso");
            List<Allievi> list = new ArrayList();

            if (flag_pregresso.equals("0") || flag_pregresso.equals("")) {
                list = e.getAllievi(sa, c, nome, cognome, cf);
                list.stream().forEach((l) -> {
                    Utility.setOreLezioni(l);
                });
            }

            if (pregresso && (flag_pregresso.equals("1") || flag_pregresso.equals(""))) {
                try {
                    // ADD PREGRESSO - RAF
                    Database db = new Database();
                    List<Allievi> list_pr = db.getAllievi(sa, c, nome, cognome, cf);
                    db.closeDB();
                    list.addAll(list_pr);
                    // END PREGRESSO - RAF
                } catch (Exception ex) {
                    Utility.log.severe(estraiEccezione(ex));
                }
            }

            writeJsonResponse(response, list);

        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));
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
            Utility.log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void searchProgetti(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User us = (User) request.getSession().getAttribute("user");

        Entity e = new Entity();
        try {
            SoggettiAttuatori sa = request.getParameter("soggettoattuatore").equals("-") ? null : e.getEm().find(SoggettiAttuatori.class, Long.valueOf(request.getParameter("soggettoattuatore")));
            String stato = request.getParameter("stato").equals("-") ? "" : request.getParameter("stato");
            String cip = request.getParameter("cip") == null ? "" : request.getParameter("cip");
            String rendicontato = request.getParameter("rendicontato").equals("-") ? "" : request.getParameter("rendicontato");
            List<StatiPrg> sp = null;
            if (!stato.equals("")) {
                if (stato.equals("errore") || stato.equals("controllare")) {
                    sp = e.getStatibyTipo(stato);
                } else {
                    sp = e.getStatibyDescrizione(stato);
                }
            }
            List<ProgettiFormativi> list = e.getProgettiFormativi(sa, sp, cip, rendicontato);

            Database db1 = new Database();
            String linkfad = db1.getPathtemp("linkfad");
            List<Fadroom> lst = db1.listStanze();
            List<Item> rep = db1.listReport();
            db1.closeDB();

            list.forEach(prog -> {
                prog.setFadtemp(false);
                prog.setUsermc(us.getUsername());
                prog.setFadlink(linkfad);
                prog.setFadroom(null);
                try {
                    List<Fadroom> lst2 = lst.stream().filter(ite -> String.valueOf(ite.getIdpr()).equals(String.valueOf(prog.getId()))).collect(Collectors.toList());
                    if (!lst2.isEmpty()) {
                        prog.setFadroom(lst2);
                        prog.setFadreport(rep.stream().anyMatch(r1 -> r1.getValue().equals(String.valueOf(prog.getId()))));
                    }
                    DocumentiPrg dp = prog.getDocumenti().stream().filter(d1 -> d1.getTipo().getId() == 30L).findAny().orElse(null);
                    if (dp != null) {
                        prog.setFadtemp(true);
                    }
                } catch (Exception ex) {
                    prog.setFadroom(null);
                    prog.setFadtemp(false);
                }
            });
            writeJsonResponseR(response, list);
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));

        } finally {
            e.close();
        }
    }

    protected void searchProgettiDocente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            Docenti d = e.getEm().find(Docenti.class, Long.valueOf(request.getParameter("iddocente")));
            List<ProgettiFormativi> list = e.getProgettiFormativiDocenti(d);
            writeJsonResponse(response, list);
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));

        } finally {
            e.close();
        }
    }

    protected void searchAllieviProgetti(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            ProgettiFormativi p = e.getEm().find(ProgettiFormativi.class, Long.valueOf(request.getParameter("idprogetto")));
            List<Allievi> list = e.getAllieviProgettiFormativi(p);
            writeJsonResponse(response, list);

        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));

        } finally {
            e.close();
        }
    }

    protected void searchSedi(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            List<Comuni> comuni = new ArrayList<>();

            if (!request.getParameter("regione").equals("-")) {
                if (!request.getParameter("provincia").equals("-")) {
                    if (!request.getParameter("comune").equals("-")) {//singolo comune
                        comuni.add((Comuni) e.getEm().find(Comuni.class, Long.valueOf(request.getParameter("comune"))));
                    } else {//lista comuni provincia
                        comuni = e.listaComunibyProvincia(request.getParameter("provincia"));
                    }
                } else {// lista comuni regione
                    comuni = e.listaComunibyRegione(request.getParameter("regione"));
                }
            }

            List<SediFormazione> list = e.getSediFormazione(request.getParameter("referente"), comuni);
            writeJsonResponse(response, list);
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));

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
            Utility.log.severe(estraiEccezione(ex));

        } finally {
            e.close();
        }
    }

    protected void getStoryPrg(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            ProgettiFormativi p = e.getEm().find(ProgettiFormativi.class, Long.valueOf(request.getParameter("idprogetto")));
            List<Storico_Prg> list = e.getStoryPrg(p);
            writeJsonResponse(response, list);
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));

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
            Utility.log.severe(estraiEccezione(ex));

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
            Utility.log.severe(estraiEccezione(ex));

        } finally {
            e.close();
        }
    }

    protected void getEstrazioni(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            List<Estrazioni> list = e.getEstazioniDesc();
            writeJsonResponse(response, list);
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));

        } finally {
            e.close();
        }
    }

    protected void getPec(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            SoggettiAttuatori sa = e.getEm().find(SoggettiAttuatori.class, Long.valueOf(request.getParameter("id")));
            List<Storico_ModificheInfo> list = e.getPec(sa);
            writeJsonResponse(response, list);
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));

        } finally {
            e.close();
        }
    }

    protected void getConversationSA(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            List<Faq> list = e.getFaqSoggetto(e.getEm().find(SoggettiAttuatori.class, Long.valueOf(request.getParameter("idsoggetto"))));
            ObjectMapper mapper = new ObjectMapper();
            response.getWriter().write(mapper.writeValueAsString(list));
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));

        } finally {
            e.close();
        }
    }

    protected void geFaqAnswer(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            SoggettiAttuatori sa = request.getParameter("soggettoattuatore").equals("-") ? null : e.getEm().find(SoggettiAttuatori.class, Long.valueOf(request.getParameter("soggettoattuatore")));
            TipoFaq tipo = request.getParameter("tipo").equals("-") ? null : e.getEm().find(TipoFaq.class, Long.valueOf(request.getParameter("tipo")));
            List<Faq> list = e.faqAnswer(sa, tipo);
            writeJsonResponse(response, list);
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));

        } finally {
            e.close();
        }
    }

    protected void getTipoFaq(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            List<TipoFaq> list = e.findAll(TipoFaq.class);
            ObjectMapper mapper = new ObjectMapper();
            response.getWriter().write(mapper.writeValueAsString(list));
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));

        } finally {
            e.close();
        }
    }

    protected void getFaq(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            Faq faq = e.getEm().find(Faq.class, Long.valueOf(request.getParameter("id")));
            ObjectMapper mapper = new ObjectMapper();
            response.getWriter().write(mapper.writeValueAsString(faq));
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));

        } finally {
            e.close();
        }
    }

    protected void getMyConference(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            String nomestanza = request.getParameter("nome") == null ? "" : request.getParameter("nome");
            String stato = request.getParameter("stato");
            List<FadMicro> list = e.getMyConference((User) request.getSession().getAttribute("user"), nomestanza, stato);
            writeJsonResponse(response, list);
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));

        } finally {
            e.close();
        }
    }

    protected void getFAD(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            FadMicro faq = e.getEm().find(FadMicro.class, Long.valueOf(request.getParameter("id")));
            //aggiungo 2 parametri al json
            StringWriter sw = new StringWriter();
            ObjectMapper mapper = new ObjectMapper();
            mapper.writeValue(sw, faq);
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

    protected void searchActivity(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            List<Comuni> comuni = new ArrayList<>();

            if (!request.getParameter("regione").equals("-")) {
                if (!request.getParameter("provincia").equals("-")) {
                    if (!request.getParameter("comune").equals("-")) {//singolo comune
                        comuni.add((Comuni) e.getEm().find(Comuni.class, Long.valueOf(request.getParameter("comune"))));
                    } else {//lista comuni provincia
                        comuni = e.listaComunibyProvincia(request.getParameter("provincia"));
                    }
                } else {// lista comuni regione
                    comuni = e.listaComunibyRegione(request.getParameter("regione"));
                }
            }

            List<Attivita> list = e.getAttivita(request.getParameter("nome"), comuni);
            writeJsonResponse(response, list);
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));

        } finally {
            e.close();
        }
    }

    protected void getDocente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setHeader("Content-Type", "application/json");
        Entity e = new Entity();
        try {
            Docenti d = e.getEm().find(Docenti.class, Long.valueOf(request.getParameter("id")));
            ObjectMapper mapper = new ObjectMapper();
            response.getWriter().print(mapper.writeValueAsString(d));
            response.getWriter().close();
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));

        } finally {
            e.close();
        }
    }

    protected void searchNoteAllievo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        Entity e = new Entity();
        try {
            Allievi a = e.getEm().find(Allievi.class, Long.valueOf(request.getParameter("idallievo")));

            try ( PrintWriter out = response.getWriter();) {
                if (a.getNote() == null) {
                    out.print("");
                } else {
                    out.print(a.getNote());
                }

            }

        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));

        } finally {
            e.close();
        }

    }

    protected void searchCpiUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        try {
            List<CpiUser> list = e.findAll(CpiUser.class);
            writeJsonResponse(response, list);
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
        if (us != null && us.getTipo() == 2) {
            String type = request.getParameter("type");
            switch (type) {
                case "searchSA":
                    searchSA(request, response);
                    break;
                case "searchAllievo":
                    searchAllievo(request, response);
                    break;
                case "searchDocenti":
                    searchDocenti(request, response);
                    break;
                case "searchProgetti":
                    searchProgetti(request, response);
                    break;
                case "searchProgettiDocente":
                    searchProgettiDocente(request, response);
                    break;
                case "searchAllieviProgetti":
                    searchAllieviProgetti(request, response);
                    break;
                case "searchSedi":
                    searchSedi(request, response);
                    break;
                case "getDocPrg":
                    getDocPrg(request, response);
                    break;
                case "getStoryPrg":
                    getStoryPrg(request, response);
                    break;
                case "getDocAllievo":
                    getDocAllievo(request, response);
                    break;
                case "searchDocentiProgetti":
                    searchDocentiProgetti(request, response);
                    break;
                case "getEstrazioni":
                    getEstrazioni(request, response);
                    break;
                case "getPec":
                    getPec(request, response);
                    break;
                case "getConversationSA":
                    getConversationSA(request, response);
                    break;
                case "geFaqAnswer":
                    geFaqAnswer(request, response);
                    break;
                case "getTipoFaq":
                    getTipoFaq(request, response);
                    break;
                case "getFaq":
                    getFaq(request, response);
                    break;
                case "getMyConference":
                    getMyConference(request, response);
                    break;
                case "getFAD":
                    getFAD(request, response);
                    break;
                case "searchActivity":
                    searchActivity(request, response);
                    break;
                case "getDocente":
                    getDocente(request, response);
                    break;
                case "searchCpiUser":
                    searchCpiUser(request, response);
                    break;
                case "searchNoteAllievo":
                    searchNoteAllievo(request, response);
                    break;
                default:
                    break;
            }
        }
    }

    /* metodi */
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
