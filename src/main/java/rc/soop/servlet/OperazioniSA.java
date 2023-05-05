/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonObject;
import rc.soop.db.Action;
import rc.soop.db.Entity;
import rc.soop.domain.Allievi;
import rc.soop.domain.CPI;
import rc.soop.domain.Comuni;
import rc.soop.domain.Condizione_Lavorativa;
import rc.soop.domain.Condizione_Mercato;
import rc.soop.domain.Docenti;
import rc.soop.domain.DocumentiPrg;
import rc.soop.domain.Documenti_Allievi;
import rc.soop.domain.Faq;
import rc.soop.domain.NomiProgetto;
import rc.soop.domain.ProgettiFormativi;
import rc.soop.domain.SediFormazione;
import rc.soop.domain.Selfiemployment_Prestiti;
import rc.soop.domain.SoggettiAttuatori;
import rc.soop.domain.StatiPrg;
import rc.soop.domain.StatoPartecipazione;
import rc.soop.domain.Storico_Prg;
import rc.soop.domain.TipoDoc;
import rc.soop.domain.TipoDoc_Allievi;
import rc.soop.domain.TipoFaq;
import rc.soop.domain.TitoliStudio;
import rc.soop.domain.User;
import rc.soop.entity.Presenti;
import rc.soop.util.SendMailJet;
import rc.soop.util.Utility;
import static rc.soop.util.Utility.estraiEccezione;
import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.TimeZone;
import java.util.stream.Collectors;
import javax.persistence.PersistenceException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import org.apache.commons.io.Charsets;
import org.apache.commons.io.FileUtils;

/**
 *
 * @author rcosco
 */
public class OperazioniSA extends HttpServlet {

    protected void updtProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

        JsonObject resp = new JsonObject();
        User us = (User) request.getSession().getAttribute("user");
        try {
            e.begin();
            String piva = request.getParameter("piva");
            String cf = request.getParameter("cf");
            boolean check_piva = e.getUserPiva(piva) == null || piva.equalsIgnoreCase(us.getSoggettoAttuatore().getPiva() == null ? "" : us.getSoggettoAttuatore().getPiva());
            boolean check_cf = e.getUserCF(cf) == null || cf.equalsIgnoreCase(us.getSoggettoAttuatore().getCodicefiscale() == null ? "" : us.getSoggettoAttuatore().getCodicefiscale());
            if (check_cf || check_piva) {
                Part p = request.getPart("cartaid");
                String path = request.getParameter("cartaidpath");
                if (p != null && p.getSubmittedFileName() != null && p.getSubmittedFileName().length() > 0) {
                    String ext = p.getSubmittedFileName().substring(p.getSubmittedFileName().lastIndexOf("."));
                    path = e.getPath("pathDocSA").replace("@folder", Utility.correctName(request.getParameter("ragionesociale")));
                    File dir = new File(path);
                    dir.mkdirs();
                    path += Utility.correctName(request.getParameter("nome_ad") + "_" + request.getParameter("cognome_ad")) + ext;
                    p.write(path);
                }
                us.getSoggettoAttuatore().setCartaid(path);
                us.getSoggettoAttuatore().setRagionesociale(request.getParameter("ragionesociale"));
                us.getSoggettoAttuatore().setPiva(!piva.equalsIgnoreCase("") ? piva : null);
                us.getSoggettoAttuatore().setCodicefiscale(!cf.equalsIgnoreCase("") ? cf : null);
                us.getSoggettoAttuatore().setEmail(request.getParameter("email"));
                us.getSoggettoAttuatore().setPec(request.getParameter("pec"));
                us.getSoggettoAttuatore().setTelefono_sa(request.getParameter("telefono_sa"));
                us.getSoggettoAttuatore().setCell_sa(request.getParameter("cell_sa"));
                us.getSoggettoAttuatore().setIndirizzo(request.getParameter("indirizzo"));
                us.getSoggettoAttuatore().setCap(request.getParameter("cap"));
                us.getSoggettoAttuatore().setComune((Comuni) e.getEm().find(Comuni.class, Long.valueOf(request.getParameter("comune"))));
                us.getSoggettoAttuatore().setNome(request.getParameter("nome"));
                us.getSoggettoAttuatore().setCognome(request.getParameter("cognome"));
                us.getSoggettoAttuatore().setNro_documento(request.getParameter("nrodocumento"));
                us.getSoggettoAttuatore().setDatanascita(sdf.parse(request.getParameter("datanascita")));
                us.getSoggettoAttuatore().setNome_refente(request.getParameter("nome_ref"));
                us.getSoggettoAttuatore().setCognome_referente(request.getParameter("cognome_ref"));
                us.getSoggettoAttuatore().setTelefono_referente(request.getParameter("tel_ref"));
                us.getSoggettoAttuatore().setScadenza(sdf.parse(request.getParameter("scadenza")));
                us.setEmail(us.getSoggettoAttuatore().getEmail());
                e.merge(us);
                e.flush();
                e.commit();
                request.getSession().setAttribute("user", us);
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
        } catch (Exception ex) {
            e.insertTracking(null, "saveSoggettoAttuatore Errore: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile aggiornare le informazioni del profilo.<br>Riprovare, se l'errore persiste contattare l'assistenza");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void checkCF(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        String cf = request.getParameter("cf");
        Entity e = new Entity();
        Allievi a = e.getAllievoCF(cf);
        e.close();
        ObjectMapper mapper = new ObjectMapper();
        response.getWriter().write(mapper.writeValueAsString(a));
    }

    protected void getCodiceCatastaleComune(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        String idcomune = request.getParameter("idcomune");
        String cod;
        Entity e = new Entity();
        Comuni comune = e.getComune(Long.valueOf(idcomune));
        e.close();
        if (comune != null) {
            cod = comune.getIstat();
            cod += comune.getCodicicatastali_altri() != null ? ("-" + comune.getCodicicatastali_altri()) : "";
        } else {
            cod = "-";
        }
        response.getWriter().write(cod);
    }

    protected void newAllievo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

        JsonObject resp = new JsonObject();
        User us = (User) request.getSession().getAttribute("user");
        try {

            List<Documenti_Allievi> documenti = new ArrayList<>();
            List<TipoDoc_Allievi> tipo_doc = e.getTipoDocAllievi(e.getEm().find(StatiPrg.class, "S"));

            String codicefiscale = request.getParameter("codicefiscale");
            if (e.getAllievoCF(codicefiscale) == null) {
                String path = e.getPath("pathDocSA_Allievi")
                        .replace("@rssa", Utility.correctName(us.getSoggettoAttuatore().getId() + ""))
                        .replace("@folder", Utility.correctName(request.getParameter("codicefiscale")));
                File dir = new File(path);
                dir.mkdirs();
                Date d_today = new Date();
                SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd");
                String today = sdf2.format(d_today);

                Part p = request.getPart("docid");
                String ext = p.getSubmittedFileName().substring(p.getSubmittedFileName().lastIndexOf("."));
                String pathid = path + "docId_" + today + "_" + request.getParameter("codicefiscale") + ext;
                p.write(pathid);

                Allievi a = new Allievi();

                if (request.getParameter("stato").equals("000")) {
                    a.setComune_nascita((Comuni) e.getEm().find(Comuni.class, Long.valueOf(request.getParameter("comunenascita"))));
                } else {
                    a.setComune_nascita((Comuni) e.getComunibyIstat(request.getParameter("stato")));
                }
                a.setCittadinanza((Comuni) e.getComunibyIstat(request.getParameter("cittadinanza")));
                a.setNome(new String(request.getParameter("nome").getBytes(Charsets.ISO_8859_1), Charsets.UTF_8));
                a.setCognome(new String(request.getParameter("cognome").getBytes(Charsets.ISO_8859_1), Charsets.UTF_8));
                a.setCodicefiscale(request.getParameter("codicefiscale"));
                a.setTelefono(request.getParameter("telefono"));
                a.setDatanascita(sdf.parse(request.getParameter("datanascita")));
                a.setIndirizzoresidenza(new String(request.getParameter("indirizzores").getBytes(Charsets.ISO_8859_1), Charsets.UTF_8));
                a.setCivicoresidenza(request.getParameter("civicores"));
                a.setCapresidenza(request.getParameter("capres"));
                a.setComune_residenza((Comuni) e.getEm().find(Comuni.class, Long.valueOf(request.getParameter("comuneres"))));
                if (request.getParameter("checkind") != null) {
                    a.setIndirizzodomicilio(new String(request.getParameter("indirizzores").getBytes(Charsets.ISO_8859_1), Charsets.UTF_8));
                    a.setCivicodomicilio(request.getParameter("civicores"));
                    a.setCapdomicilio(request.getParameter("capres"));
                    a.setComune_domicilio((Comuni) e.getEm().find(Comuni.class, Long.valueOf(request.getParameter("comuneres"))));
                } else {
                    a.setCapdomicilio(request.getParameter("capdom"));
                    a.setIndirizzodomicilio(new String(request.getParameter("indirizzodom").getBytes(Charsets.ISO_8859_1), Charsets.UTF_8));
                    a.setCivicodomicilio(request.getParameter("civicodom"));
                    a.setComune_domicilio((Comuni) e.getEm().find(Comuni.class, Long.valueOf(request.getParameter("comunedom"))));
                }
                a.setDocid(pathid);
                a.setScadenzadocid(sdf.parse(request.getParameter("scadenzadoc")));
                a.setIscrizionegg(sdf.parse(request.getParameter("iscrizionegg")));
                a.setStato("A");
                a.setTitoloStudio((TitoliStudio) e.getEm().find(TitoliStudio.class, request.getParameter("titolo_studio")));
                a.setSoggetto((SoggettiAttuatori) us.getSoggettoAttuatore());
                a.setCpi((CPI) e.getEm().find(CPI.class, request.getParameter("cpi")));
                a.setCondizione_mercato((Condizione_Mercato) e.getEm().find(Condizione_Mercato.class, request.getParameter("condizione")));
                a.setDatacpi(sdf.parse(request.getParameter("datacpi")));
                //29-04-2020 MODIFICA - CONDIZIONE LAVORATIVA PRECEDENTE
                a.setCondizione_lavorativa((Condizione_Lavorativa) e.getEm().find(Condizione_Lavorativa.class, Integer.valueOf(request.getParameter("condizione_lavorativa"))));
                a.setNeet(e.getEm().find(Condizione_Lavorativa.class, Integer.valueOf(request.getParameter("condizione_lavorativa"))).getDescrizione());
                a.setStatopartecipazione((StatoPartecipazione) e.getEm().find(StatoPartecipazione.class, "01"));
                a.setEmail(request.getParameter("email"));
                a.setSesso(Integer.parseInt(request.getParameter("codicefiscale").substring(9, 11)) > 40 ? "F" : "M");
                a.setData_up(d_today);

                e.begin();
                e.persist(a);
                for (TipoDoc_Allievi t : tipo_doc) {
                    p = request.getPart("doc_" + t.getId());
                    ext = p.getSubmittedFileName().substring(p.getSubmittedFileName().lastIndexOf("."));
                    p.write(path + t.getDescrizione() + today + "_" + request.getParameter("codicefiscale") + ext);
                    documenti.add(new Documenti_Allievi(path + t.getDescrizione() + today + "_" + request.getParameter("codicefiscale") + ext, t, null, a));
                }
                a.setDocumenti(documenti);
                e.merge(a);
                e.commit();

                resp.addProperty("result", true);
            } else {
                resp.addProperty("result", false);
                resp.addProperty("message", "Errore: non &egrave; stato possibile aggiungere l'allievo.<br>Il seguente codice fiscale gi&agrave; presente");
            }
        } catch (Exception ex) {
            e.insertTracking(null, "newAllievo Errore: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile aggiungere l'allievo.<br>Riprovare, se l'errore persiste contattare l'assistenza");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void updtAllievo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        JsonObject resp = new JsonObject();
        try {
            e.begin();

            Allievi a = e.getEm().find(Allievi.class, Long.valueOf(request.getParameter("id")));
            String codicefiscale = request.getParameter("codicefiscale");
            if (e.getAllievoCF(codicefiscale) == null || codicefiscale.equals(a.getCodicefiscale())) {

                Part p = request.getPart("cartaid");
                String path = request.getParameter("cartaidpath");
                if (p != null && p.getSubmittedFileName() != null && p.getSubmittedFileName().length() > 0) {
                    path = a.getDocid();
                    p.write(path);
                }

                if (request.getParameter("stato").equals("000")) {
                    a.setComune_nascita((Comuni) e.getEm().find(Comuni.class, Long.valueOf(request.getParameter("comunenascita"))));
                } else {
                    a.setComune_nascita((Comuni) e.getComunibyIstat(request.getParameter("stato")));
                }
                a.setCittadinanza((Comuni) e.getComunibyIstat(request.getParameter("cittadinanza")));

                a.setNome(new String(request.getParameter("nome").getBytes(Charsets.ISO_8859_1), Charsets.UTF_8));
                a.setCognome(new String(request.getParameter("cognome").getBytes(Charsets.ISO_8859_1), Charsets.UTF_8));
                a.setCodicefiscale(request.getParameter("codicefiscale"));
                a.setDatanascita(sdf.parse(request.getParameter("datanascita")));
                a.setTelefono(request.getParameter("telefono"));
                a.setIndirizzoresidenza(new String(request.getParameter("indirizzores").getBytes(Charsets.ISO_8859_1), Charsets.UTF_8));
                a.setCapresidenza(request.getParameter("capres"));
                a.setComune_residenza((Comuni) e.getEm().find(Comuni.class, Long.valueOf(request.getParameter("comuneres"))));

                if (request.getParameter("checkind") != null) {
                    a.setIndirizzodomicilio(new String(request.getParameter("indirizzores").getBytes(Charsets.ISO_8859_1), Charsets.UTF_8));
                    a.setCivicodomicilio(request.getParameter("civicores"));
                    a.setCapdomicilio(request.getParameter("capres"));
                    a.setComune_domicilio((Comuni) e.getEm().find(Comuni.class, Long.valueOf(request.getParameter("comuneres"))));
                } else {
                    a.setCapdomicilio(request.getParameter("capdom"));
                    a.setIndirizzodomicilio(new String(request.getParameter("indirizzodom").getBytes(Charsets.ISO_8859_1), Charsets.UTF_8));
                    a.setCivicodomicilio(request.getParameter("civicodom"));
                    a.setComune_domicilio((Comuni) e.getEm().find(Comuni.class, Long.valueOf(request.getParameter("comunedom"))));
                }

                a.setDocid(path);
                a.setScadenzadocid(sdf.parse(request.getParameter("scadenzadoc")));
                a.setIscrizionegg(sdf.parse(request.getParameter("iscrizionegg")));
                a.setTitoloStudio((TitoliStudio) e.getEm().find(TitoliStudio.class, request.getParameter("titolo_studio")));
                a.setCpi((CPI) e.getEm().find(CPI.class, request.getParameter("cpi")));
                a.setCondizione_mercato((Condizione_Mercato) e.getEm().find(Condizione_Mercato.class, request.getParameter("condizione")));
                a.setDatacpi(sdf.parse(request.getParameter("datacpi")));
                //29-04-2020 MODIFICA - CONDIZIONE LAVORATIVA PRECEDENTE
                a.setCondizione_lavorativa((Condizione_Lavorativa) e.getEm().find(Condizione_Lavorativa.class, Integer.valueOf(request.getParameter("condizione_lavorativa"))));
                a.setNeet(e.getEm().find(Condizione_Lavorativa.class, Integer.valueOf(request.getParameter("condizione_lavorativa"))).getDescrizione());
                a.setEmail(request.getParameter("email"));
                a.setSesso(Integer.parseInt(request.getParameter("codicefiscale").substring(9, 11)) > 40 ? "F" : "M");

                e.merge(a);
                e.flush();
                e.commit();

                resp.addProperty("result", true);
            } else {
                resp.addProperty("result", false);
                resp.addProperty("message", "Errore: non &egrave; stato possibile aggiornare le informazioni dell'allievo.<br>Il seguente codice fiscale gi&agrave; già presente");
            }

        } catch (Exception ex) {
            e.insertTracking(null, "saveSoggettoAttuatore Errore: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile aggiornare le informazioni dell'allievo.<br>Riprovare, se l'errore persiste contattare l'assistenza");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void updtCartaID(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        try {
            e.begin();

            Allievi a = e.getEm().find(Allievi.class, Long.valueOf(request.getParameter("id")));
            Part p = request.getPart("cartaid");
            String path = a.getDocid();
            File dir = new File(path);
            dir.mkdirs();
            p.write(path);

            a.setScadenzadocid(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("datascadenza")));
            e.commit();

            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniSA updtCartaId: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile aggiornare il documento d'identità.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void updtCartaIDAD(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        User us = (User) request.getSession().getAttribute("user");
        try {
            e.begin();
            Part p = request.getPart("cartaid");
            us.getSoggettoAttuatore().setScadenza(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("datascadenza")));
            us.getSoggettoAttuatore().setNro_documento(request.getParameter("numerodoc"));
            e.merge(us);
            p.write(us.getSoggettoAttuatore().getCartaid());
            e.commit();
            resp.addProperty("result", true);
            resp.addProperty("message", "Operazione effettuata con successo.");
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(us.getId()), "OperazioniSA updtCartaIdAd: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile aggiornare il documento d'identità.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void uploadDocIdDocente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JsonObject resp = new JsonObject();

        String scadenza = request.getParameter("scadenza");
        Part p = request.getPart("file");
        Entity e = new Entity();
        try {
            e.begin();
            Docenti d = e.getEm().find(Docenti.class, Long.valueOf(request.getParameter("id")));
            d.setScadenza_doc(new SimpleDateFormat("dd/MM/yyyy").parse(scadenza));

            String path = e.getPath("pathDoc_Docenti").replace("@docente", d.getCodicefiscale());
            new File(path).mkdirs();//create folder

            String ext = p.getSubmittedFileName().substring(p.getSubmittedFileName().lastIndexOf("."));
            path += "Doc_id_" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + "_" + d.getCodicefiscale() + ext;

            p.write(path);
            d.setDocId(path);

            e.commit();
            resp.addProperty("result", true);
            resp.addProperty("path", path);
            resp.addProperty("scadenza", d.getScadenza_doc().getTime());
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniSA uploadDocIdDocente: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile aggiornare il documento d'identità.");
        } finally {
            e.close();
        }

        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void uploadCurriculumDocente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JsonObject resp = new JsonObject();

        Part p = request.getPart("file");
        Entity e = new Entity();
        try {
            e.begin();
            Docenti d = e.getEm().find(Docenti.class, Long.valueOf(request.getParameter("id")));

            String path = e.getPath("pathDoc_Docenti").replace("@docente", d.getCodicefiscale());
            new File(path).mkdirs();//create folder

            String ext = p.getSubmittedFileName().substring(p.getSubmittedFileName().lastIndexOf("."));
            path += "Curriculum_" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + "_" + d.getCodicefiscale() + ext;

            p.write(path);
            d.setCurriculum(path);

            e.commit();
            resp.addProperty("result", true);
            resp.addProperty("path", path);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniSA uploadCurriculumDocente: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile aggiornare il documento d'identità.");
        } finally {
            e.close();
        }

        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void newProgettoFormativo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        e.begin();
        String[] date = request.getParameter("date").split("-");
        ArrayList<Docenti> docenti_list = new ArrayList<>();
        User us = (User) request.getSession().getAttribute("user");
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

            ProgettiFormativi p = new ProgettiFormativi();
            p.setNome(e.getEm().find(NomiProgetto.class, Long.valueOf(request.getParameter("nome_pf"))));
            p.setDescrizione(new String(request.getParameter("descrizione_pf").getBytes(Charsets.ISO_8859_1), Charsets.UTF_8));
            p.setStart(sdf.parse(date[0].trim()));
            p.setEnd(sdf.parse(date[1].trim()));
            p.setSede(e.getEm().find(SediFormazione.class, Long.valueOf(request.getParameter("sede"))));
            p.setSoggetto(us.getSoggettoAttuatore());
            p.setStato(e.getEm().find(StatiPrg.class, "S1"));
            p.setControllable(1);
            p.setData_up(new Date());
            
            boolean misto = false;
            try {
                if (request.getParameter("misto").equalsIgnoreCase("SI")) {
                    misto = true;
                }
            } catch (Exception ex1) {
            }
            p.setMisto(misto);

            e.persist(p);
            e.flush();

            //setto allievi
            for (String s : request.getParameterValues("allievi[]")) {
                Allievi a = e.getEm().find(Allievi.class, Long.valueOf(s));
                a.setCanaleconoscenza(request.getParameter("knowledge_" + s + "_input"));
                a.setProgetto(p);
                e.merge(a);
            }
            //setto ai documenti
            List<TipoDoc> tipo_doc = e.getTipoDoc(e.getEm().find(StatiPrg.class, "S"));
            ArrayList<DocumentiPrg> documenti = new ArrayList<>();
            DocumentiPrg doc;
            String path = e.getPath("pathDocSA_Prg").replace("@rssa", us.getSoggettoAttuatore().getId().toString()).replace("@folder", p.getId().toString());
            String file_path;
            String today = new SimpleDateFormat("yyyyMMddHHssSSS").format(new Date());
            new File(path).mkdirs();
            Part part;
            for (TipoDoc t : tipo_doc) {
                part = request.getPart("doc_" + t.getId());
                if (part != null && part.getSubmittedFileName() != null && part.getSubmittedFileName().length() > 0) {
                    file_path = path + t.getDescrizione() + "_" + today + part.getSubmittedFileName().substring(part.getSubmittedFileName().lastIndexOf("."));
                    part.write(file_path);
                    doc = new DocumentiPrg();
                    doc.setPath(file_path);
                    doc.setTipo(t);
                    doc.setProgetto(p);
                    documenti.add(doc);
                }
            }
            //setto doceti e documenti docenti
            Docenti d;
            for (String s : request.getParameterValues("docenti[]")) {
                d = e.getEm().find(Docenti.class, Long.valueOf(s));
                docenti_list.add(d);

                doc = new DocumentiPrg();
                file_path = path + "DocId_" + today + "_" + d.getId() + d.getDocId().substring(d.getDocId().lastIndexOf("."));
                FileUtils.copyFile(new File(d.getDocId()), new File(file_path));
                doc.setPath(file_path);
                doc.setTipo(e.getEm().find(TipoDoc.class, 20L));//docId
                doc.setDocente(d);
                doc.setScadenza(d.getScadenza_doc());
                doc.setProgetto(p);
                documenti.add(doc);
                doc = new DocumentiPrg();
                file_path = path + "Curriculum_" + today + "_" + d.getId() + d.getCurriculum().substring(d.getCurriculum().lastIndexOf("."));
                FileUtils.copyFile(new File(d.getCurriculum()), new File(file_path));
                doc.setPath(file_path);
                doc.setTipo(e.getEm().find(TipoDoc.class, 21L));//curriculum
                doc.setDocente(d);
                doc.setProgetto(p);
                documenti.add(doc);
            }

            p.setDocenti(docenti_list);
            p.setDocumenti(documenti);
            e.merge(p);
            e.persist(new Storico_Prg("Creato", new Date(), p, p.getStato()));//storico progetto
            e.commit();
            
            //INVIO MAIL
            SendMailJet.notifica_Controllo_MC(e, p);
            
            resp.addProperty("result", true);
        } catch (PersistenceException | ParseException ex) {
            e.rollBack();
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniSA newProgettoFormativo: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile salvare il progetto formativo.");
        } finally {
            e.close();
        }

        response.getWriter()
                .write(resp.toString());
        response.getWriter()
                .flush();
        response.getWriter()
                .close();
    }

    protected void modifyDoc(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JsonObject resp = new JsonObject();

        Part p = request.getPart("file");
        Entity e = new Entity();
        try {
            e.begin();
            Date scadenza = request.getParameter("scadenza") != null ? new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("scadenza")) : null;
            DocumentiPrg d = e.getEm().find(DocumentiPrg.class,
                    Long.valueOf(request.getParameter("id")));
            p.write(d.getPath());
            d.setScadenza(scadenza);

            if (scadenza != null) {
                List<DocumentiPrg> doc_mod = e.getDocIdModifiableDocente(((User) request.getSession().getAttribute("user")).getSoggettoAttuatore(), d.getDocente());
                doc_mod.remove(d);
                for (DocumentiPrg doc : doc_mod) {//aggiorna id doc. a progetti modificabili
                    p.write(doc.getPath());
                    doc.setScadenza(scadenza);
                }
            }

            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniSA uploadCurriculumDocente: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile aggiornare il documento d'identità.");
        } finally {
            e.close();
        }

        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void uploadDocPrg(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JsonObject resp = new JsonObject();

        Part p = request.getPart("file");
        Entity e = new Entity();
        try {
            ProgettiFormativi prg = e.getEm().find(ProgettiFormativi.class,
                    Long.valueOf(request.getParameter("idprogetto")));
            TipoDoc tipo = e.getEm().find(TipoDoc.class,
                    Long.valueOf(request.getParameter("id_tipo")));
            List<TipoDoc> tipo_obb = e.getTipoDocObbl(prg.getStato());
            List<DocumentiPrg> doc_list = e.getDocPrg(prg);
            User us = (User) request.getSession().getAttribute("user");

            tipo_obb.remove(tipo);

            doc_list.forEach(d -> {
                tipo_obb.remove(d.getTipo());
            });

            e.begin();
            //creao il path
            String path = e.getPath("pathDocSA_Prg").replace("@rssa", us.getSoggettoAttuatore().getId().toString()).replace("@folder", prg.getId().toString());
            String file_path;
            String today = new SimpleDateFormat("yyyyMMddHHssSSS").format(new Date());

            //scrivo il file su disco
            if (p != null && p.getSubmittedFileName() != null && p.getSubmittedFileName().length() > 0) {
                file_path = path + tipo.getDescrizione() + "_" + today + p.getSubmittedFileName().substring(p.getSubmittedFileName().lastIndexOf("."));
                p.write(file_path);
                DocumentiPrg doc = new DocumentiPrg();
                doc.setPath(file_path);
                doc.setTipo(tipo);
                doc.setProgetto(prg);
                e.persist(doc);
            }
            //se caricato tutti i doc obbligatori setto il progetto come idoneo per la prossima fase
            if (prg.getStato().getId().equals("FB")) {
                List<TipoDoc_Allievi> tipo_obb_all = e.getTipoDocAllieviObbl(prg.getStato());
                List<TipoDoc_Allievi> doc_allievo;
                StringBuilder msg = new StringBuilder();
                StringBuilder warning = new StringBuilder();
                boolean checkdocs = true, checkregistri = true;
                msg.append("Sono stati caricati tutti i documenti necessari per questa fase. Ora il progetto può essere inviato al Microcredito per essere controllato.<br>");
                warning.append("Tuttavia, i seguenti allievi non hanno effettuato le ore necessarie per la Fase B:<br>");

                for (Allievi allievo : prg.getAllievi().stream().filter(all -> all.getStatopartecipazione().getId().equals("01")).collect(Collectors.toList())) {//solo allievi regolarmente iscritti
                    doc_allievo = new ArrayList<>();
                    doc_allievo.addAll(tipo_obb_all);
                    double totale = 0;
                    for (Documenti_Allievi doc : allievo.getDocumenti()) {
                        if (allievo.getEsito().equalsIgnoreCase("Fase B")) {
                            if (doc.getTipo().getId() == 5 && doc.getDeleted() == 0) {
                                double hh = (double) (doc.getOrarioend_mattina().getTime() - doc.getOrariostart_mattina().getTime());
                                if (doc.getOrariostart_pom() != null && doc.getOrarioend_pom() != null) {
                                    hh += (double) (doc.getOrarioend_pom().getTime() - doc.getOrariostart_pom().getTime());
                                }
                                totale += hh / 3600000;
                            }
                        }
                        doc_allievo.remove(doc.getTipo());
                    }
                    if (!doc_allievo.isEmpty()) {
                        checkdocs = false;
                    }
                    if (allievo.getEsito().equalsIgnoreCase("Fase B")) {
                        if (totale < 20) {
                            checkregistri = false;
                            warning.append("• ").append(allievo.getCognome()).append(" ").append(allievo.getNome()).append(" (").append(String.valueOf(totale).replace(".0", "")).append("/20h)<br>");
                        }
                    }
                }
                prg.getDocumenti().forEach(dprg -> {
                    tipo_obb.remove(dprg.getTipo());
                });
                //se sono stati caricati tutti i doc obbligatori per il progetto e per gli alunni, setto il progetto come idoneo per la prossima fase
                if (tipo_obb.isEmpty() && checkdocs) {
                    prg.setControllable(1);
                    e.merge(prg);
                    if (checkregistri) {
                        resp.addProperty("message", msg.toString());
                    } else {
                        resp.addProperty("message", msg.append(warning).toString());
                    }
                } else {
                    resp.addProperty("message", "");
                }
            } else {
                if (tipo_obb.isEmpty()) {
                    prg.setControllable(1);
                    e.merge(prg);
                    resp.addProperty("message", "Hai caricato tutti i documenti necessari per questa fase. Ora il progetto può essere inviato al Microcredito per essere controllato.");
                } else {
                    resp.addProperty("message", "");
                }
            }

            e.commit();
            resp.addProperty("result", true);

        } catch (Exception ex) {
            e.rollBack();
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniSA uploadDocPrg: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile caricare il documento.");
        } finally {
            e.close();
        }

        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void modifyPrg(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        e.begin();

        try {
            ProgettiFormativi p = e.getEm().find(ProgettiFormativi.class,
                    Long.valueOf(request.getParameter("id_progetto")));

            if (p.getStato().getModifiche().getNome() == 1) {
                p.setNome(e.getEm().find(NomiProgetto.class,
                        Long.valueOf(request.getParameter("nome_pf"))));
            }
            if (p.getStato().getModifiche().getDescrizione() == 1) {
                p.setDescrizione(request.getParameter("descrizione_pf"));
            }
            if (p.getStato().getModifiche().getDate() == 1) {
                String[] date = request.getParameter("date").split("-");
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                p.setStart(sdf.parse(date[0].trim()));
                p.setEnd(sdf.parse(date[1].trim()));
            }
            if (p.getStato().getModifiche().getSede() == 1) {
                p.setSede(e.getEm().find(SediFormazione.class,
                        Long.valueOf(request.getParameter("sede"))));
            }
            if (p.getStato().getModifiche().getAllievi() == 1) {
                List<Allievi> allievi_old = e.getAllieviProgettiFormativi(p);
                for (String s : request.getParameterValues("allievi[]")) {
                    Allievi a = e.getEm().find(Allievi.class,
                            Long.valueOf(s));
                    a.setCanaleconoscenza(request.getParameter("knowledge_" + s + "_input"));
                    a.setProgetto(p);
                    allievi_old.remove(a);
                    e.merge(a);
                }
                allievi_old.stream().map(al -> {
                    al.setProgetto(null);
                    return al;
                }).map(al -> {
                    al.setCanaleconoscenza(null);
                    return al;
                }).forEachOrdered(al -> {
                    e.merge(al);
                });
            }

            e.merge(p);
            e.commit();

            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.rollBack();
            ex.printStackTrace();
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniSA modifyPrg: " + ex.getMessage());
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile modificare il progetto formativo.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void modifyDocenti(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();

        User us = (User) request.getSession().getAttribute("user");
        Entity e = new Entity();
        e.begin();

        try {
            ProgettiFormativi p = e.getEm().find(ProgettiFormativi.class,
                    Long.valueOf(request.getParameter("id_progetto")));
            List<Docenti> docenti_old = e.getDocentiPrg(p);
            List<Docenti> docenti_list = new ArrayList<>();
            ArrayList<DocumentiPrg> documenti = new ArrayList<>();

            String path = e.getPath("pathDocSA_Prg").replace("@rssa", us.getSoggettoAttuatore().getId().toString()).replace("@folder", p.getId().toString());
            String file_path;
            String today = new SimpleDateFormat("yyyyMMddHHssSSS").format(new Date());

            Docenti d;
            DocumentiPrg doc;

            for (String s : request.getParameterValues("docenti[]")) {
                d = e.getEm().find(Docenti.class,
                        Long.valueOf(s));
                docenti_list.add(d);
                if (!docenti_old.contains(d)) {
                    doc = new DocumentiPrg();
                    file_path = path + "DocId_" + today + "_" + d.getId() + d.getDocId().substring(d.getDocId().lastIndexOf("."));
                    FileUtils.copyFile(new File(d.getDocId()), new File(file_path));
                    doc.setPath(file_path);
                    doc.setTipo(e.getEm().find(TipoDoc.class,
                            20L));//docId
                    doc.setDocente(d);
                    doc.setScadenza(d.getScadenza_doc());
                    doc.setProgetto(p);
                    documenti.add(doc);
                    doc = new DocumentiPrg();
                    file_path = path + "Curriculum_" + today + "_" + d.getId() + d.getCurriculum().substring(d.getCurriculum().lastIndexOf("."));
                    FileUtils.copyFile(new File(d.getCurriculum()), new File(file_path));
                    doc.setPath(file_path);
                    doc.setTipo(e.getEm().find(TipoDoc.class,
                            21L));//curriculum
                    doc.setDocente(d);
                    doc.setProgetto(p);
                    documenti.add(doc);
                } else {
                    docenti_old.remove(d);
                }
            }

            for (Docenti old : docenti_old) {//setto i doc dei docenti eliminati come deleted
                e.deleteDocPrg(p, old);
            }

            p.setDocenti(docenti_list);
            p.getDocumenti().addAll(documenti);
            e.merge(p);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.rollBack();
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniSA modifyDocenti: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato modificare i docenti del progetto formativo.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void goNext(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        e.begin();
        try {
            ProgettiFormativi p = e.getEm().find(ProgettiFormativi.class, Long.valueOf(request.getParameter("id")));
            Date today = new Date();
            checkResult check = checkScadenze(p);
            if (p.getStato().getId().equals("FA") || check.result) {
                String stato = p.getStato().getId().replace("E", "");
                boolean to_fb = false;
                if (p.getStato().getId().equals("FA")) {
                    p.setEnd_fa(today);//fine fa
                    p.setStart_fb(today);//inizio fb
                    to_fb = true;
                    p.setStato(e.getEm().find(StatiPrg.class,
                            "FB"));
                    p.setControllable(0);
                    e.persist(new Storico_Prg("Avviata Fase B", new Date(), p, p.getStato()));//storico progetto
                    if (!checkFaseAllievi(p.getAllievi())) {
                        p.setEnd_fb(today);//se fb non parte setta fine fb alla stessa data di FA
                    }

                    //crea stanze fad
                    Action.creastanze_faseB(Integer.parseInt(request.getParameter("id")));

                } else if (p.getStato().getId().equals("FB") && p.getEnd_fb() == null) {
                    p.setEnd_fb(today);//setta data fine fase FB solo se non precedentemente settata
                }
                if (!to_fb) {
                    p.setStato(e.getEm().find(StatiPrg.class,
                            stato + "1"));
                    e.persist(new Storico_Prg("Inviato a controllo", new Date(), p, p.getStato()));//storico progetto
                }
                e.merge(p);
                e.commit();
                
                
                //INVIO MAIL
                SendMailJet.notifica_Controllo_MC(e, p);
                
                
                resp.addProperty("result", true);
            } else {
                resp.addProperty("result", false);
                resp.addProperty("message", "<h5>" + check.message + "</h5>");
            }
        } catch (Exception ex) {
            e.rollBack();
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniSA goNext: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato modificare i docenti del progetto formativo.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void setEsitoAllievo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        e.begin();

        try {
            Allievi a = e.getEm().find(Allievi.class,
                    Long.valueOf(request.getParameter("id")));
            //String stato = p.getStato().getId().replace("E", "");
            a.setEsito(request.getParameter("esito"));
            e.merge(a);
            //e.persist(new Storico_Prg("Inviato a controllo", new Date(), p, p.getStato()));//storico progetto
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.rollBack();
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniSA setEsitoAllievo: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile modificare l'esito dell'allievo.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void uploadRegistro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JsonObject resp = new JsonObject();
        Part p = request.getPart("file");
        Entity e = new Entity();
        try {
            Allievi a = e.getEm().find(Allievi.class,
                    Long.valueOf(request.getParameter("idallievo")));
            TipoDoc_Allievi tipo = e.getEm().find(TipoDoc_Allievi.class,
                    Long.valueOf("5"));
            List<TipoDoc_Allievi> tipo_obb = e.getTipoDocAllieviObbl(a.getProgetto().getStato());
            List<TipoDoc> tipo_obb_prg = e.getTipoDocObbl(a.getProgetto().getStato());
            Documenti_Allievi doc_a = new Documenti_Allievi();

            Date giorno = request.getParameter("giorno") != null ? new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("giorno")) : null;
            Date orariostart_mattina = request.getParameter("orario1_start") != null ? new SimpleDateFormat("HH:mm").parse(request.getParameter("orario1_start")) : null;
            Date orarioend_mattina = request.getParameter("orario1_end") != null ? new SimpleDateFormat("HH:mm").parse(request.getParameter("orario1_end")) : null;
            Date orariostart_pomeriggio = request.getParameter("orario2_start") != null && Boolean.parseBoolean(request.getParameter("check")) ? new SimpleDateFormat("HH:mm").parse(request.getParameter("orario2_start")) : null;
            Date orarioend_pomeriggio = request.getParameter("orario2_end") != null && Boolean.parseBoolean(request.getParameter("check")) ? new SimpleDateFormat("HH:mm").parse(request.getParameter("orario2_end")) : null;
            Docenti docente = e.getEm().find(Docenti.class,
                    Long.valueOf(request.getParameter("docente")));

            User us = (User) request.getSession().getAttribute("user");

            e.begin();
            //creao il path
            String path = e.getPath("pathDocSA_Prg_RegistriIndividuali").replace("@rssa", us.getSoggettoAttuatore().getId().toString()).replace("@folder", a.getProgetto().getId().toString());
            String file_path;
            new File(path).mkdirs();
            String today = new SimpleDateFormat("yyyyMMddHHssSSS").format(new Date());

            //scrivo il file su disco
            if (p != null && p.getSubmittedFileName() != null && p.getSubmittedFileName().length() > 0) {
                file_path = path + tipo.getDescrizione() + "_" + today + "_" + a.getCodicefiscale() + p.getSubmittedFileName().substring(p.getSubmittedFileName().lastIndexOf("."));
                p.write(file_path);
                doc_a.setPath(file_path);
            }

            doc_a.setTipo(tipo);
            doc_a.setGiorno(giorno);
            doc_a.setDocente(docente);
            doc_a.setOrariostart_mattina(orariostart_mattina);
            doc_a.setOrarioend_mattina(orarioend_mattina);
            doc_a.setOrariostart_pom(orariostart_pomeriggio);
            doc_a.setOrarioend_pom(orarioend_pomeriggio);
            doc_a.setAllievo(a);
            e.persist(doc_a);

            e.commit();

            e.begin();
            double hh, totale;
            boolean checkregistri = true;
            boolean checkdocs = true;

            List<TipoDoc_Allievi> doc_allievo;
            StringBuilder msg = new StringBuilder();
            StringBuilder warning = new StringBuilder();
            msg.append("Sono stati caricati tutti i documenti necessari per questa fase. Ora il progetto può essere inviato al Microcredito per essere controllato.<br>");
            warning.append("Tuttavia, i seguenti allievi non hanno effettuato le ore necessarie per la Fase B:<br>");
            for (Allievi allievo : a.getProgetto().getAllievi()) {
                doc_allievo = new ArrayList<>();
                doc_allievo.addAll(tipo_obb);
                totale = 0;
                if (allievo.getEsito().equalsIgnoreCase("Fase B")) {
                    for (Documenti_Allievi doc : allievo.getDocumenti()) {
                        if (doc.getTipo().getId() == 5 && doc.getDeleted() == 0) {
                            hh = (double) (doc.getOrarioend_mattina().getTime() - doc.getOrariostart_mattina().getTime());
                            if (doc.getOrariostart_pom() != null && doc.getOrarioend_pom() != null) {
                                hh += (double) (doc.getOrarioend_pom().getTime() - doc.getOrariostart_pom().getTime());
                            }
                            totale += hh / 3600000;
                        }
                        doc_allievo.remove(doc.getTipo());
                    }
                }
                if (!doc_allievo.isEmpty()) {
                    checkdocs = false;
                }
                if (allievo.getEsito().equalsIgnoreCase("Fase B")) {
                    if (totale < 20) {
                        checkregistri = false;
                        warning.append("• ").append(allievo.getCognome()).append(" ").append(allievo.getNome()).append(" (").append(String.valueOf(totale).replace(".0", "")).append("/20h)<br>");
                    }
                }
            }
            for (DocumentiPrg dprg : a.getProgetto().getDocumenti()) {
                tipo_obb_prg.remove(dprg.getTipo());
            }
            //se sono stati caricati tutti i doc obbligatori per il progetto e per gli alunni, setto il progetto come idoneo per la prossima fase
            if (tipo_obb_prg.isEmpty() && checkdocs) {
                a.getProgetto().setControllable(1);
                e.merge(a.getProgetto());
                if (checkregistri) {
                    resp.addProperty("message", msg.toString());
                } else {
                    resp.addProperty("message", msg.append(warning).toString());
                }
            } else {
                resp.addProperty("message", "");
            }
            e.commit();
            resp.addProperty("result", true);

        } catch (Exception ex) {
            e.rollBack();
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniSA uploadRegistro: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile caricare il registro.");
        } finally {
            e.close();
        }

        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void modifyRegistro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JsonObject resp = new JsonObject();
        Part p = request.getPart("file");
        Entity e = new Entity();
        try {
            Date giorno = request.getParameter("giorno") != null ? new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("giorno")) : null;
            Date orariostart_mattina = request.getParameter("orario1_start") != null ? new SimpleDateFormat("HH:mm").parse(request.getParameter("orario1_start")) : null;
            Date orarioend_mattina = request.getParameter("orario1_end") != null ? new SimpleDateFormat("HH:mm").parse(request.getParameter("orario1_end")) : null;

            Date orariostart_pomeriggio = request.getParameter("orario2_start") != null && Boolean.parseBoolean(request.getParameter("check")) ? new SimpleDateFormat("HH:mm").parse(request.getParameter("orario2_start")) : null;
            Date orarioend_pomeriggio = request.getParameter("orario2_end") != null && Boolean.parseBoolean(request.getParameter("check")) ? new SimpleDateFormat("HH:mm").parse(request.getParameter("orario2_end")) : null;
            Docenti docente = e.getEm().find(Docenti.class,
                    Long.valueOf(request.getParameter("docente")));

            e.begin();
            Documenti_Allievi doc = e.getEm().find(Documenti_Allievi.class,
                    Long.valueOf(request.getParameter("iddocumento")));
            List<Allievi> allieviprg = e.getAllieviProgettiFormativi(doc.getAllievo().getProgetto());
            List<TipoDoc> tipo_obb_prg = e.getTipoDocObbl(doc.getAllievo().getProgetto().getStato());
            //se è cambiato, scrivo il file su disco
            if (p != null && p.getSubmittedFileName() != null && p.getSubmittedFileName().length() > 0) {
                p.write(doc.getPath());
            }
            doc.setGiorno(giorno);
            doc.setDocente(docente);
            doc.setOrariostart_mattina(orariostart_mattina);
            doc.setOrarioend_mattina(orarioend_mattina);
            doc.setOrariostart_pom(orariostart_pomeriggio);
            doc.setOrarioend_pom(orarioend_pomeriggio);
            e.merge(doc);
            e.commit();

            e.begin();
            double hh, totale;
            boolean checkregistri = true;
            boolean checkdocs = true;

            List<TipoDoc_Allievi> doc_allievo;
            StringBuilder msg = new StringBuilder();
            StringBuilder warning = new StringBuilder();
            msg.append("Sono stati caricati tutti i documenti necessari per questa fase. Ora il progetto può essere inviato al Microcredito per essere controllato.<br>");
            warning.append("Tuttavia, i seguenti allievi non hanno effettuato le ore necessarie per la Fase B:<br>");
            for (Allievi allievo : allieviprg) {
                if (allievo.getEsito().equalsIgnoreCase("Fase B")) {
                    doc_allievo = e.getTipoDocAllievi(allievo.getProgetto().getStato());
                    //List<TipoDoc_Allievi> tipo_obb = e.getTipoDocAllieviObbl(a.getProgetto().getStato());
                    totale = 0;
                    for (Documenti_Allievi doc_a : allievo.getDocumenti()) {
                        if (doc_a.getTipo().getId() == 5 && doc_a.getDeleted() == 0) {
                            hh = (double) (doc_a.getOrarioend_mattina().getTime() - doc_a.getOrariostart_mattina().getTime());
                            if (doc_a.getOrariostart_pom() != null && doc_a.getOrarioend_pom() != null) {
                                hh += (double) (doc_a.getOrarioend_pom().getTime() - doc_a.getOrariostart_pom().getTime());
                            }
                            totale += hh / 3600000;
                        }
                        doc_allievo.remove(doc_a.getTipo());
                    }
                    if (!doc_allievo.isEmpty()) {
                        checkdocs = false;
                    }
                    if (totale < 20) {
                        checkregistri = false;
                        warning.append("• ").append(allievo.getCognome()).append(" ").append(allievo.getNome()).append(" (").append(String.valueOf(totale).replace(".0", "")).append("/20h)<br>");
                    }
                }
            }
            doc.getAllievo().getProgetto().getDocumenti().forEach(dprg -> {
                tipo_obb_prg.remove(dprg.getTipo());
            });
            //se sono stati caricati tutti i doc obbligatori per il progetto e per gli alunni, setto il progetto come idoneo per la prossima fase
            if (tipo_obb_prg.isEmpty() && checkdocs) {
                doc.getAllievo().getProgetto().setControllable(1);
                e.merge(doc.getAllievo().getProgetto());
                if (checkregistri) {
                    resp.addProperty("message", msg.toString());
                } else {
                    resp.addProperty("message", msg.append(warning).toString());
                }
            } else {
                resp.addProperty("message", "");
            }
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.rollBack();
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniSA modifyRegistro: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile modificare il registro.");
        } finally {
            e.close();
        }

        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void uploadDocPrg_FaseB(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JsonObject resp = new JsonObject();

        Part p = request.getPart("file");
        Entity e = new Entity();
        try {
            Allievi a = e.getEm().find(Allievi.class,
                    Long.valueOf(request.getParameter("idallievo")));
            //ProgettiFormativi prg = a.getProgetto();
            TipoDoc_Allievi tipo = e.getEm().find(TipoDoc_Allievi.class,
                    Long.valueOf(request.getParameter("id_tipo")));
            List<TipoDoc_Allievi> tipo_obb = e.getTipoDocAllieviObbl(a.getProgetto().getStato());
            List<TipoDoc> tipo_obb_prg = e.getTipoDocObbl(a.getProgetto().getStato());
            User us = (User) request.getSession().getAttribute("user");

            e.begin();
            //creao il path
            String path = e.getPath("pathDocSA_Allievi").replace("@rssa", Utility.correctName(us.getSoggettoAttuatore().getId().toString() + "")).replace("@folder", Utility.correctName(a.getCodicefiscale()));
            String file_path;
            new File(path).mkdirs();
            String today = new SimpleDateFormat("yyyyMMddHHssSSS").format(new Date());

            //scrivo il file su disco
            if (p != null && p.getSubmittedFileName() != null && p.getSubmittedFileName().length() > 0) {
                file_path = path + tipo.getDescrizione() + "_" + today + p.getSubmittedFileName().substring(p.getSubmittedFileName().lastIndexOf("."));
                p.write(file_path);
                Documenti_Allievi doc = new Documenti_Allievi();
                doc.setPath(file_path);
                doc.setTipo(tipo);
                doc.setAllievo(a);
                e.persist(doc);
            }
            //se carico il MODELLO SE setto il valore in Allievo
            if (request.getParameter("prestiti") != null && request.getParameter("protocollo") != null) {
                a.setProtocollo(request.getParameter("protocollo"));
                a.setSelfiemployement((Selfiemployment_Prestiti) e.getEm().find(Selfiemployment_Prestiti.class,
                        Long.valueOf(request.getParameter("prestiti"))));
                e.merge(a);
            }
            //se carico il MODELLO 8 setto il valore in Allievo
            if (request.getParameter("idea") != null) {
                a.setIdea_impresa(request.getParameter("idea"));
                e.merge(a);
            }
            e.commit();

            e.begin();
            double hh, totale;
            boolean checkregistri = true;
            boolean checkdocs = true;

            StringBuilder msg = new StringBuilder();
            StringBuilder warning = new StringBuilder();
            msg.append("Sono stati caricati tutti i documenti necessari per questa fase. Ora il progetto può essere inviato al Microcredito per essere controllato.<br>");
            warning.append("Tuttavia, i seguenti allievi non hanno effettuato le ore necessarie per la Fase B:<br>");
            for (Allievi allievo : a.getProgetto().getAllievi().stream().filter(all -> all.getStatopartecipazione().getId().equals("01")).collect(Collectors.toList())) {//solo allievi regolarmente iscritti
                List<TipoDoc_Allievi> doc_allievo = new ArrayList<>();
                doc_allievo.addAll(tipo_obb);
                totale = 0;
                for (Documenti_Allievi doc : allievo.getDocumenti()) {
                    if (allievo.getEsito().equalsIgnoreCase("Fase B")) {
                        if (doc.getTipo().getId() == 5 && doc.getDeleted() == 0) {
                            hh = (double) (doc.getOrarioend_mattina().getTime() - doc.getOrariostart_mattina().getTime());
                            if (doc.getOrariostart_pom() != null && doc.getOrarioend_pom() != null) {
                                hh += (double) (doc.getOrarioend_pom().getTime() - doc.getOrariostart_pom().getTime());
                            }
                            totale += hh / 3600000;
                        }
                    }
                    doc_allievo.remove(doc.getTipo());
                }
                if (!doc_allievo.isEmpty()) {
                    checkdocs = false;
                }
                if (allievo.getEsito().equalsIgnoreCase("Fase B")) {
                    if (totale < 20) {
                        checkregistri = false;
                        warning.append("• ").append(allievo.getCognome()).append(" ").append(allievo.getNome()).append(" (").append(String.valueOf(totale).replace(".0", "")).append("/20h)<br>");
                    }
                }
            }

            for (DocumentiPrg dprg : a.getProgetto().getDocumenti()) {
                tipo_obb_prg.remove(dprg.getTipo());
            }
            //se sono stati caricati tutti i doc obbligatori per il progetto e per gli alunni, setto il progetto come idoneo per la prossima fase
            if (tipo_obb_prg.isEmpty() && checkdocs) {
                a.getProgetto().setControllable(1);
                e.merge(a.getProgetto());
                if (checkregistri) {
                    resp.addProperty("message", msg.toString());
                } else {
                    resp.addProperty("message", msg.append(warning).toString());
                }
            } else {
                resp.addProperty("message", "");
            }
            e.commit();
            resp.addProperty("result", true);

        } catch (Exception ex) {
            e.rollBack();
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniSA uploadDocPrg_FaseB: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile caricare il documento.");
        } finally {
            e.close();
        }

        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void modifyDocPrg_FaseB(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JsonObject resp = new JsonObject();

        Part p = request.getPart("file");
        Entity e = new Entity();
        try {

            e.begin();
            //se carico il MODELLO SE setto il valore in Allievo
            Documenti_Allievi d = e.getEm().find(Documenti_Allievi.class,
                    Long.valueOf(request.getParameter("id")));
            Allievi a = e.getEm().find(Allievi.class,
                    d.getAllievo().getId());
            if (request.getParameter("prestiti") != null && request.getParameter("protocollo") != null) {
                a.setSelfiemployement((Selfiemployment_Prestiti) e.getEm().find(Selfiemployment_Prestiti.class,
                        Long.valueOf(request.getParameter("prestiti"))));
                a.setProtocollo(request.getParameter("protocollo"));
                e.merge(a);
            }
            //se carico il MODELLO 8 setto il valore in Allievo
            if (request.getParameter("idea") != null) {
                a.setIdea_impresa(request.getParameter("idea"));
                e.merge(a);
            }
            p.write(d.getPath());

            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniSA modifyDocPrg_FaseB: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile aggiornare il documento.");
        } finally {
            e.close();
        }

        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void getTotalHoursRegistriByAllievo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        double totale = 0;
        double hh;
        JsonObject resp = new JsonObject();
        boolean today = false;
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        try {
            List<Documenti_Allievi> docs = e.getDocAllievo(e.getEm().find(Allievi.class,
                    Long.valueOf(request.getParameter("idallievo"))));
            for (Documenti_Allievi registro : docs) {
                if (registro.getTipo().getId() == 5 && registro.getDeleted() == 0) {
                    if (sdf.format(registro.getGiorno()).equals(sdf.format(new Date()))) {
                        today = true;
                    }
                    hh = (double) (registro.getOrarioend_mattina().getTime() - registro.getOrariostart_mattina().getTime());
                    if (registro.getOrariostart_pom() != null && registro.getOrarioend_pom() != null) {
                        hh += (double) (registro.getOrarioend_pom().getTime() - registro.getOrariostart_pom().getTime());
                    }
                    totale += hh / 3600000;
                }
            }
            resp.addProperty("today", today);
            resp.addProperty("totale", totale);
            response.getWriter().write(resp.toString());
        } catch (Exception ex) {
            Utility.log.severe(estraiEccezione(ex));
        } finally {
            e.close();
        }
    }

    protected void uploadRegistrioAula(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
//        dsadsdsa
//        
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        User us = (User) request.getSession().getAttribute("user");
        try {
            e.begin();

            TipoDoc t = e.getEm().find(TipoDoc.class,
                    10L);//10 id tipo registro aula.
            ProgettiFormativi prg = e.getEm().find(ProgettiFormativi.class,
                    Long.valueOf(request.getParameter("idprogetto")));
            Docenti docente = e.getEm().find(Docenti.class,
                    Long.valueOf(request.getParameter("docente")));
            String[] date = request.getParameter("range").split("-");

            SimpleDateFormat sdf_time = new SimpleDateFormat("HH:mm");
            SimpleDateFormat sdf_date = new SimpleDateFormat("dd/MM/yyyy");

            DocumentiPrg doc = new DocumentiPrg();

            doc.setProgetto(prg);
            doc.setDocente(docente);

            if (date.length == 3) {
                doc.setOrariostart(sdf_time.parse(date[1].trim()));
                doc.setOrarioend(sdf_time.parse(date[2].trim()));
                doc.setGiorno(sdf_date.parse(date[0].trim()));
            } else {
                doc.setOrariostart(sdf_time.parse(date[0].trim()));
                doc.setOrarioend(sdf_time.parse(date[1].trim()));
                doc.setGiorno(sdf_date.parse(request.getParameter("giorno")));
            }

            doc.setValidate(0);
            doc.setOre((double) (doc.getOrarioend().getTime() - doc.getOrariostart().getTime()) / 3600000);//calcolo ore
            prg.setOre(prg.getOre() + doc.getOre());
            doc.setTipo(t);

            Part p = request.getPart("registro");

            if (p != null && p.getSubmittedFileName() != null && p.getSubmittedFileName().length() > 0) {
                String path = e.getPath("pathDocSA_Prg").replace("@rssa", us.getSoggettoAttuatore().getId().toString()).replace("@folder", prg.getId().toString());
                new File(path).mkdirs();
                String file_path = path + t.getDescrizione() + "_" + new SimpleDateFormat("yyyyMMddHHssSSS").format(new Date()) + p.getSubmittedFileName().substring(p.getSubmittedFileName().lastIndexOf("."));
                p.write(file_path);
                doc.setPath(file_path);
            }

            List<Presenti> presenti = new ArrayList<>();
            Allievi a;
            Date in, out;
            sdf_time.setTimeZone(TimeZone.getTimeZone("CET"));//per fixare l'ora dei presenti
            for (String s : request.getParameterValues("allievi[]")) {
                a = e.getEm().find(Allievi.class,
                        Long.valueOf(s));
                in = sdf_time.parse(request.getParameter("time_start_" + a.getId()));
                out = sdf_time.parse(request.getParameter("time_end_" + a.getId()));
                presenti.add(new Presenti(a.getId(), a.getNome(), a.getCognome(), in, out, getHour(in, out)));
            }
            ObjectMapper mapper = new ObjectMapper();
            doc.setPresenti(mapper.writeValueAsString(presenti));
            e.persist(doc);
            e.merge(prg);
            /* controllo se tutti i documenti sono stati caricati per poter mandare il progetto avanti */
            List<TipoDoc> tipo_obb = e.getTipoDocObbl(prg.getStato());
            List<DocumentiPrg> doc_list = e.getDocPrg(prg);

            for (DocumentiPrg doc_prg : doc_list) {
                tipo_obb.remove(doc_prg.getTipo());
            }
            if (tipo_obb.isEmpty()) {
                prg.setControllable(1);
                e.merge(prg);
                resp.addProperty("message", "Hai caricato tutti i documenti necessari per questa fase. Ora il progetto può essere inviato al Microcredito per essere controllato.");
            } else {
                resp.addProperty("message", "");
            }

            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniSA uploadRegistrioAula: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile caricare il registro.");
        } finally {
            e.close();
        }

        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void setSIGMA(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        e.begin();

        try {
            Allievi a = e.getEm().find(Allievi.class,
                    Long.valueOf(request.getParameter("id")));
            if (request.getParameter("sigma") != null) {
                a.setStatopartecipazione((StatoPartecipazione) e.getEm().find(StatoPartecipazione.class,
                        request.getParameter("sigma")));
                e.merge(a);
            }
            e.commit();
            resp.addProperty("result", true);
        } catch (PersistenceException ex) {
            e.rollBack();
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniSA setSIGMA: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile impostare lo stato di partecipazione dell'allievo.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void modifyRegistrioAula(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        try {
            e.begin();
            Docenti docente = e.getEm().find(Docenti.class,
                    Long.valueOf(request.getParameter("docente")));
            String[] date = request.getParameter("range").split("-");

            SimpleDateFormat sdf_time = new SimpleDateFormat("HH:mm");
            SimpleDateFormat sdf_date = new SimpleDateFormat("dd/MM/yyyy");

            DocumentiPrg doc = e.getEm().find(DocumentiPrg.class,
                    Long.valueOf(request.getParameter("iddoc")));

            doc.setDocente(docente);
            doc.setOrariostart(sdf_time.parse(date[1].trim()));
            doc.setOrarioend(sdf_time.parse(date[2].trim()));
            doc.setGiorno(sdf_date.parse(date[0].trim()));
            doc.setValidate(0);
            ProgettiFormativi prg = doc.getProgetto();
            prg.setOre(prg.getOre() - doc.getOre());
            doc.setOre((double) (doc.getOrarioend().getTime() - doc.getOrariostart().getTime()) / 3600000);//calcolo ore
            prg.setOre(prg.getOre() + doc.getOre());
            Part p = request.getPart("registro");

            if (p != null && p.getSubmittedFileName() != null && p.getSubmittedFileName().length() > 0) {
                p.write(doc.getPath());
            }

            List<Presenti> presenti = new ArrayList<>();
            sdf_time.setTimeZone(TimeZone.getTimeZone("CET"));//per fixare l'ora dei presenti
            Allievi a;
            Date in, out;
            for (String s : request.getParameterValues("allievi[]")) {
                a = e.getEm().find(Allievi.class,
                        Long.valueOf(s));
                in = sdf_time.parse(request.getParameter("time_start_" + a.getId()));
                out = sdf_time.parse(request.getParameter("time_end_" + a.getId()));
                presenti.add(new Presenti(a.getId(), a.getNome(), a.getCognome(), in, out, getHour(in, out)));
            }
            ObjectMapper mapper = new ObjectMapper();
            doc.setPresenti(mapper.writeValueAsString(presenti));
            e.merge(doc);
            e.merge(prg);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), 
                    "OperazioniSA modifyRegistrioAula: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile modificare il registro.");
        } finally {
            e.close();
        }

        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void checkEmail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        Entity e = new Entity();
        Allievi a = e.getAllievoEmail(email);
        e.close();
        ObjectMapper mapper = new ObjectMapper();
        response.getWriter().write(mapper.writeValueAsString(a));
    }

    protected void deleteRegister(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();

        Entity e = new Entity();

        try {
            e.begin();
            ProgettiFormativi p;
            DocumentiPrg registro = e.getEm().find(DocumentiPrg.class,
                    Long.valueOf(request.getParameter("id")));
            p = registro.getProgetto();

            p.setOre(p.getOre() - registro.getOre());
            registro.setDeleted(1);
            registro.setOre(0);

            registro.setOrarioend(registro.getOrariostart());
            List<DocumentiPrg> registri_day = e.getRegisterProgetto_by_Day(registro.getGiorno(), registro.getProgetto());

            registri_day.stream().filter(r -> !Objects.equals(r.getId(), registro.getId())).forEach(d -> {
                p.setOre(p.getOre() - d.getOre());
                d.setDeleted(1);
                d.setOre(0);
                d.setOrarioend(d.getOrariostart());
                e.persist(d);
            });
            e.persist(registro);
            e.persist(p);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniSA modifyRegistrioAula: "
                    + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile modificare il registro.");
        } finally {
            e.close();
        }

        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void sendAsk(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();

        try {
            String ask = request.getParameter("ask");
            e.begin();
            Faq f = new Faq();
            f.setDomanda(ask);
            f.setDomanda_mod(ask);
            f.setDate_ask(new Date());
            f.setTipo(e.getEm().find(TipoFaq.class,
                    1L));
            f.setSoggetto(((User) request.getSession().getAttribute("user")).getSoggettoAttuatore());
            e.persist(f);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniSA sendAsk: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile inviare il messaggio.");
        } finally {
            e.close();
        }

        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User us = (User) request.getSession().getAttribute("user");
        if (us != null && (us.getTipo() == 1 || us.getTipo() == 3)) {
            String type = request.getParameter("type");
            response.setContentType("text/html;charset=UTF-8");
            switch (type) {
                case "updtProfile":
                    updtProfile(request, response);
                    break;
                case "checkCF":
                    checkCF(request, response);
                    break;
                case "newAllievo":
                    newAllievo(request, response);
                    break;
                case "updtCartaID":
                    updtCartaID(request, response);
                    break;
                case "updtAllievo":
                    updtAllievo(request, response);
                    break;
                case "uploadDocIdDocente":
                    uploadDocIdDocente(request, response);
                    break;
                case "uploadCurriculumDocente":
                    uploadCurriculumDocente(request, response);
                    break;
                case "newProgettoFormativo":
                    newProgettoFormativo(request, response);
                    break;
                case "modifyDoc":
                    modifyDoc(request, response);
                    break;
                case "uploadDocPrg":
                    uploadDocPrg(request, response);
                    break;
                case "modifyPrg":
                    modifyPrg(request, response);
                    break;
                case "modifyDocenti":
                    modifyDocenti(request, response);
                    break;
                case "goNext":
                    goNext(request, response);
                    break;
                case "setEsitoAllievo":
                    setEsitoAllievo(request, response);
                    break;
                case "uploadRegistro":
                    uploadRegistro(request, response);
                    break;
                case "modifyRegistro":
                    modifyRegistro(request, response);
                    break;
                case "getTotalHoursRegistriByAllievo":
                    getTotalHoursRegistriByAllievo(request, response);
                    break;
                case "uploadDocPrg_FaseB":
                    uploadDocPrg_FaseB(request, response);
                    break;
                case "modifyDocPrg_FaseB":
                    modifyDocPrg_FaseB(request, response);
                    break;
                case "uploadRegistrioAula":
                    uploadRegistrioAula(request, response);
                    break;
                case "setSIGMA":
                    setSIGMA(request, response);
                    break;
                case "modifyRegistrioAula":
                    modifyRegistrioAula(request, response);
                    break;
                case "checkEmail":
                    checkEmail(request, response);
                    break;
                case "updtCartaIDAD":
                    updtCartaIDAD(request, response);
                    break;
                case "getCodiceCatastaleComune":
                    getCodiceCatastaleComune(request, response);
                    break;
                case "deleteRegister":
                    deleteRegister(request, response);
                    break;
                case "sendAsk":
                    sendAsk(request, response);
                    break;
                default:
                    break;

            }
        }
    }

    private class checkResult {

        boolean result;
        String message = "";

        public boolean isResult() {
            return result;
        }

        public void setResult(boolean result) {
            this.result = result;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }
    }

    private double getHour(Date in, Date out) {
        return ((double) (out.getTime() - in.getTime()) / 3600000);
    }

    private boolean checkFaseAllievi(List<Allievi> allievi) {
        return allievi.stream().anyMatch(a -> (a.getEsito().equals("Fase B")));
    }

    private checkResult checkScadenze(ProgettiFormativi prg) {
        checkResult out = new checkResult();
        Date today = new Date();
        out.result = true;
        prg.getDocumenti().stream().filter(d -> d.getScadenza() != null && d.getDeleted() == 0).forEach(d -> {
            if (d.getScadenza().before(today)) {
                out.result = false;
                out.setMessage(out.getMessage() + d.getDocente().getCognome() + ", ");
            }
        });

        if (!out.getMessage().equals("")) {
            out.message = "Docenti col documento scaduto:<br>" + out.message.substring(0, out.getMessage().lastIndexOf(","));
        }
        String allievi = "";
        for (Allievi a : prg.getAllievi()) {
            if (a.getScadenzadocid().before(today)) {
                out.result = false;
                allievi += a.getCognome() + ", ";
            }
        }

        if (!allievi.equals("")) {
            out.message = out.message + "<br><br>Allievi col documento scaduto:<br>" + allievi.substring(0, allievi.lastIndexOf(","));
        }

        return out;
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
