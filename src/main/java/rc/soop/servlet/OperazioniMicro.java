/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.util.concurrent.AtomicDouble;
import com.google.gson.JsonObject;
import rc.soop.db.Database;
import rc.soop.db.Entity;
import rc.soop.domain.Allievi;
import rc.soop.domain.Allievi_Pregresso;
import rc.soop.domain.Attivita;
import rc.soop.domain.CPI;
import rc.soop.domain.Comuni;
import rc.soop.domain.CpiUser;
import rc.soop.domain.Docenti;
import rc.soop.domain.DocumentiPrg;
import rc.soop.domain.Documenti_Allievi;
import rc.soop.domain.Documenti_Allievi_Pregresso;
import rc.soop.domain.Email;
import rc.soop.domain.Estrazioni;
import rc.soop.domain.FadMicro;
import rc.soop.domain.Faq;
import rc.soop.domain.FasceDocenti;
import rc.soop.domain.ProgettiFormativi;
import rc.soop.domain.SediFormazione;
import rc.soop.domain.SoggettiAttuatori;
import rc.soop.domain.StatiPrg;
import rc.soop.domain.StatoPartecipazione;
import rc.soop.domain.Storico_ModificheInfo;
import rc.soop.domain.Storico_Prg;
import rc.soop.domain.TipoDoc;
import rc.soop.domain.TipoDoc_Allievi_Pregresso;
import rc.soop.domain.TipoFaq;
import rc.soop.domain.User;
import rc.soop.entity.Check2;
import rc.soop.entity.Check2.Fascicolo;
import rc.soop.entity.Check2.Gestione;
import rc.soop.entity.Check2.VerificheAllievo;
import rc.soop.entity.FadCalendar;
import rc.soop.entity.Presenti;
import rc.soop.util.CompilePdf;
import rc.soop.util.ExportExcel;
import static rc.soop.util.ExportExcel.lezioniDocente;
import static rc.soop.util.ExportExcel.oreFa;
import static rc.soop.util.ExportExcel.oreFb;
import rc.soop.util.ImportExcel;
import static rc.soop.util.MakeTarGz.createTarArchive;
import rc.soop.util.SendMailJet;
import static rc.soop.util.Utility.ctrlCheckbox;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import javax.persistence.PersistenceException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import rc.soop.util.Utility;
import static rc.soop.util.Utility.estraiEccezione;
import static rc.soop.util.Utility.patternITA;
import static rc.soop.util.Utility.patternSql;
import static rc.soop.util.Utility.redirect;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Statement;
import java.util.HashMap;
import org.apache.commons.io.Charsets;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;

/**
 *
 * @author rcosco
 */
public class OperazioniMicro extends HttpServlet {
    
    protected void setProtocollo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        try {
            e.begin();
            
            SoggettiAttuatori sa = e.getEm().find(SoggettiAttuatori.class, Long.valueOf(request.getParameter("id")));
            sa.setProtocollo(request.getParameter("protocollo"));
            sa.setDataprotocollo(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("data")));
            
            User us = e.getUserbySA(sa);
            if (us.getTipo() != 1) {
                if (e.updateuserTipo(1, sa)) {
                    Email email = (Email) e.getEmail("abilitate");
                    String email_txt = email.getTesto()
                            .replace("@email_tec", e.getPath("emailtecnico"))
                            .replace("@email_am", e.getPath("emailamministrativo"));
                    SendMailJet.sendMail("Microcredito", new String[]{sa.getEmail()}, email_txt, email.getOggetto());
                }
            }
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro setProtocollo: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile inserire il protocollo.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void addDocente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        try {
            e.begin();
            String nome = request.getParameter("nome");
            String cognome = request.getParameter("cognome");
            String cf = request.getParameter("cf");
            String email = request.getParameter("email");
            Date data_nascita = null;
            if (!request.getParameter("data").equals("")) {
                data_nascita = new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("data"));
            }
            Docenti d = new Docenti(nome, cognome, cf, data_nascita, email);
            d.setFascia(e.getEm().find(FasceDocenti.class, request.getParameter("fascia")));
            e.persist(d);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro addDocente: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile aggiungere il docente.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void addDocenteFile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JsonObject resp = new JsonObject();
        Part p = request.getPart("file");
        boolean out = false;
        Entity e = new Entity();
        User us = (User) request.getSession().getAttribute("user");
        try {
            if (p != null && p.getSubmittedFileName() != null && p.getSubmittedFileName().length() > 0) {
                out = ImportExcel.importSedi(p.getInputStream(), us.getId().toString());
            }
            resp.addProperty("result", out);
            if (!out) {
                resp.addProperty("message", "Errore: non &egrave; stato possibile caricare i docenti.");
            } else {
                resp.addProperty("message", "");
            }
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(us.getId()), "OperazioniMicro addDocenteFile: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile caricare i docenti.");
        } finally {
            e.close();
        }
        
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void addAuleFile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JsonObject resp = new JsonObject();
        resp.addProperty("result", false);
        resp.addProperty("message", "Errore: non &egrave; stato possibile aggiungere le aule.");
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void addAula(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        try {
            e.begin();
            
            String denominazione = request.getParameter("denom");
            String via = request.getParameter("via");
            String referente = request.getParameter("referente");
            String telefono = request.getParameter("phone").equals("") ? null : request.getParameter("phone");
            String cellulare = request.getParameter("cellulare").equals("") ? null : request.getParameter("cellulare");
            String email = request.getParameter("email").equals("") ? null : request.getParameter("email");
            
            Comuni c = e.getEm().find(Comuni.class, Long.valueOf(request.getParameter("comune")));
            SediFormazione s = new SediFormazione(denominazione, via, referente, telefono, cellulare, email, c);
            
            e.persist(s);
            e.commit();
            
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro addAula: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile aggiungere l'aula.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void validatePrg(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        boolean check = true;
        String fineFa = "";
        try {
            e.begin();
            ProgettiFormativi p = e.getEm().find(ProgettiFormativi.class, Long.valueOf(request.getParameter("id")));
            if (request.getParameter("cip") != null) {
                String cip_neet = request.getParameter("cip").trim().replaceAll("\\s", "");
                p.setCip(cip_neet);

                if (p.isMisto()) {
                    String cip_prof = request.getParameter("cip_misto").trim().replaceAll("\\s", "");
//                    Database d1 = new Database(true);
//                    int id_pro = d1.verificaCIP(cip_prof);
//                    d1.closeDB();
//                    if (id_pro > 0) {
                        p.setCip_misto(cip_prof);
//                        Database d2 = new Database(true);
//                        check = d2.updateCIPMisto(id_pro, cip_neet);
//                        d2.closeDB();
//                        if (!check) {
//                            resp.addProperty("message", "IL CIP INSERITO NON CORRISPONDE AD UN PROGETTO FORMATIVO VALIDO. RIPROVARE.");
//                        }
//                    } else {
//                        check = false;
//                        resp.addProperty("message", "IL CIP INSERITO NON CORRISPONDE AD UN PROGETTO FORMATIVO VALIDO. RIPROVARE.");
//                    }
                }
            }
            if (check) {
                
                if (p.getStato().getId().equals("FB1")) {//check registri songoli e aula
                    if (!checkValidateRegisterAllievo(e.getRegistriAllievi(e.getAllieviProgettiFormativi(p))) || !checkValidateRegister(e.getregisterPrg(p))) {
                        check = false;
                        resp.addProperty("message", "Ci sono ancora registri allievi o d'aula da controllare, il progetto non può essere validato.");
                    } else {
                        p.setStato(e.getStatiByOrdineProcesso(p.getStato().getOrdine_processo() + 1));//STATO fase successiva
                    }
                } else {
                    p.setStato(e.getStatiByOrdineProcesso(p.getStato().getOrdine_processo() + 1));//STATO fase successiva
                }
                
                if (check) {
                    e.persist(new Storico_Prg((p.getStato().getId().equals("AR") ? "Archiviato" : "Convalidato") + fineFa, new Date(), p, p.getStato()));//storico progetto
                    p.setControllable(0);
                    p.setArchiviabile(0);
                    p.setMotivo(null);
                    e.merge(p);
                    e.commit();

                    //INVIO MAIL
                    SendMailJet.notifica_cambiostato_SA(e, p);
                    
                }
                
                if (p.getStato().getId().equals("C")) {
                    ExportExcel.compileTabella1(p.getId());
                }
            }
            resp.addProperty("result", check);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro validatePrg: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile validare il progetto formativo.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
        
    }
    
    protected void eliminaDocente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        try {
            e.begin();
            Docenti p = e.getEm().find(Docenti.class, Long.valueOf(request.getParameter("id")));
            p.setStato("KO");
            e.merge(p);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro eliminaDocente: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile eliminare il docente");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void annullaPrg(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        try {
            e.begin();
            ProgettiFormativi p = e.getEm().find(ProgettiFormativi.class, Long.valueOf(request.getParameter("id")));
            p.setMotivo(request.getParameter("motivo"));
            e.persist(new Storico_Prg("Annullato: " + request.getParameter("motivo"), new Date(), p, p.getStato()));//storico progetto
            p.setStato(e.getEm().find(StatiPrg.class, "KO"));
            e.merge(p);

            //annullare allievi
            p.getAllievi().forEach(a1 -> {
                a1.setStatopartecipazione((StatoPartecipazione) e.getEm().find(StatoPartecipazione.class, "03"));
                e.merge(a1);
            });
            
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            ex.printStackTrace();
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro annullaPrg: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile annullare il progetto formativo.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void rejectPrg(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        try {
            e.begin();
            ProgettiFormativi p = e.getEm().find(ProgettiFormativi.class, Long.valueOf(request.getParameter("id")));
            p.setMotivo(request.getParameter("motivo"));
            e.persist(new Storico_Prg("Rigettato: " + request.getParameter("motivo"), new Date(), p, p.getStato()));//storico progetto
            p.setStato(e.getEm().find(StatiPrg.class, p.getStato().getId().replace("1", "") + "E"));
            e.merge(p);
            e.commit();
            //INVIO MAIL
            SendMailJet.notifica_cambiostato_SA(e, p);
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro rejectPrg: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile segnalare il progetto formativo.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void validateHourRegistroAula(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        try {
            e.begin();
            String[] hhmm = request.getParameter("ore_conv").split(":");
            double ore_ric = Double.parseDouble(hhmm[0]) + (Double.parseDouble(hhmm[1]) / 60);
            DocumentiPrg doc = e.getEm().find(DocumentiPrg.class, Long.valueOf(request.getParameter("id")));
            doc.setOre_convalidate(ore_ric);
            doc.setValidate(1);
            List<Presenti> presenti = doc.getPresenti_list();
            
            for (Presenti p : presenti) {
                hhmm = request.getParameter("ore_riconsciute_" + p.getId()).split(":");
                ore_ric = Double.parseDouble(hhmm[0]) + (Double.parseDouble(hhmm[1]) / 60);
                p.setOre_riconosciute(ore_ric);
            }
            ObjectMapper mapper = new ObjectMapper();
            doc.setPresenti(mapper.writeValueAsString(presenti));
            e.merge(doc);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniMicro validateHourRegistroAula: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile validare le ore del registro");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
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
    protected void setHoursRegistro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        try {
            String[] hhmm = request.getParameter("orericonosciute").split(":");
            double ore_ric = Double.parseDouble(hhmm[0]) + (Double.parseDouble(hhmm[1]) / 60);
            e.begin();
            Documenti_Allievi doc = e.getEm().find(Documenti_Allievi.class, Long.valueOf(request.getParameter("id")));
            doc.setOrericonosciute(ore_ric);
            e.merge(doc);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniMicro setHoursRegistro: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile validare le ore del registro");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void modifyDoc(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JsonObject resp = new JsonObject();
        
        Part p = request.getPart("file");
        Entity e = new Entity();
        try {
            e.begin();
            Date scadenza = request.getParameter("scadenza") != null ? new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("scadenza")) : null;
            DocumentiPrg d = e.getEm().find(DocumentiPrg.class, Long.valueOf(request.getParameter("id")));
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
            ProgettiFormativi prg = e.getEm().find(ProgettiFormativi.class, Long.valueOf(request.getParameter("idprogetto")));
            TipoDoc tipo = e.getEm().find(TipoDoc.class, Long.valueOf(request.getParameter("id_tipo")));
            List<TipoDoc> tipo_obb = e.getTipoDocObbl(prg.getStato());
            tipo_obb.remove(tipo);
            for (DocumentiPrg d : prg.getDocumenti()) {
                tipo_obb.remove(d.getTipo());
            }
            e.begin();
            //creao il path
            String path = e.getPath("pathDocSA_Prg").replace("@rssa", prg.getSoggetto().getId().toString()).replace("@folder", prg.getId().toString());
            String file_path;
            String today = new SimpleDateFormat("yyyyMMddHHssSSS").format(new Date());

            //scrivo il file su disco
            if (p != null
                    && p.getSubmittedFileName() != null
                    && p.getSubmittedFileName().length() > 0) {
                file_path = path + tipo.getDescrizione() + "_" + today + p.getSubmittedFileName().substring(p.getSubmittedFileName().lastIndexOf("."));
                p.write(file_path);
                DocumentiPrg doc = new DocumentiPrg();
                doc.setPath(file_path);
                doc.setTipo(tipo);
                doc.setProgetto(prg);
                e.persist(doc);
//                if (tipo.getId() == 25) {//se sta caricando la check2
                if (tipo.getId() == 26) { //se sta caricando la check3
                    CompilePdf.compileValutazione(prg);
                }
            }
            //se caricato tutti i doc obbligatori setto il progetto come idoneo per la prossima fase
            if (tipo_obb.isEmpty()) {
                prg.setArchiviabile(1);
                e.merge(prg);
                resp.addProperty("message", "Hai caricato tutti i documenti necessari per questa fase. Ora il progetto può essere archiviato.");
            } else {
                resp.addProperty("message", "");
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
    
    protected void compileCL2(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Check2 cl2 = new Check2();
        Gestione g = new Gestione();
        Fascicolo f = new Fascicolo();
        
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        try {
            e.begin();
            String idpr = request.getParameter("idprogetto");
            ProgettiFormativi prg = e.getEm().find(ProgettiFormativi.class, Long.valueOf(idpr));

            //14-10-2020 MODIFICA - TOGLIERE IMPORTO CHECKLIST
//            double ore_convalidate = 0;
//            for (DocumentiPrg d : prg.getDocumenti().stream().filter(p -> p.getGiorno() != null && p.getDeleted() == 0).collect(Collectors.toList())) {
//                ore_convalidate += d.getOre_convalidate();
//            }
//            for (Allievi a : prg.getAllievi()) {
//                for (Documenti_Allievi d : a.getDocumenti().stream().filter(p -> p.getGiorno() != null && p.getDeleted() == 0).collect(Collectors.toList())) {
//                    ore_convalidate += d.getOrericonosciute() == null ? 0 : d.getOrericonosciute();
//                }
//            }
//            double prezzo_ore = Double.parseDouble(e.getPath("euro_ore"));
//            prg.setImporto(ore_convalidate * prezzo_ore);
//            
//            e.merge(prg);
//            e.commit();
            cl2.setAllievi_tot(Integer.parseInt(request.getParameter("allievi_start")));
            cl2.setAllievi_ended(Integer.parseInt(request.getParameter("allievi_end")));
            cl2.setProgetto(prg);
            cl2.setNumero_min(ctrlCheckbox(request.getParameter("check_valid")));
            g.setSwat(ctrlCheckbox(request.getParameter("check_swot")));
            g.setM9(ctrlCheckbox(request.getParameter("check_m9_1")));
            g.setConseganto(request.getParameter("m9_input"));
            g.setCv(ctrlCheckbox(request.getParameter("check_cvdoc")));
            g.setM13(ctrlCheckbox(request.getParameter("check_m13")));
            g.setRegistro(ctrlCheckbox(request.getParameter("check_regdoc")));
            g.setStato(ctrlCheckbox(request.getParameter("check_chiuso")));
            
            cl2.setGestione(g);
            f.setNote(request.getParameter("note") == null ? "" : new String(request.getParameter("note").getBytes(Charsets.ISO_8859_1), Charsets.UTF_8));
            f.setNote_esito(request.getParameter("note_esito") == null ? "" : new String(request.getParameter("note_esito").getBytes(Charsets.ISO_8859_1), Charsets.UTF_8));
            f.setAllegati_fa(ctrlCheckbox(request.getParameter("check_m6_2")));
            f.setFa(ctrlCheckbox(request.getParameter("check_m6_1")));
            f.setAllegati_fb(ctrlCheckbox(request.getParameter("check_m7_2")));
            f.setFb(ctrlCheckbox(request.getParameter("check_m7_1")));
            f.setM2(ctrlCheckbox(request.getParameter("check_m2")));
            f.setM9(ctrlCheckbox(request.getParameter("check_m9_2")));
            cl2.setFascicolo(f);
            
            VerificheAllievo ver;
            List<VerificheAllievo> list_al = new ArrayList();
            for (String s : request.getParameterValues("allievi[]")) {
                ver = new VerificheAllievo();
                ver.setAllievo(e.getEm().find(Allievi.class, Long.valueOf(s)));
                ver.setM1(ctrlCheckbox(request.getParameter("m1_" + s)));
                ver.setM8(ctrlCheckbox(request.getParameter("m8_" + s)));
                ver.setPi(ctrlCheckbox(request.getParameter("idim_" + s)));
                ver.setRegistro(ctrlCheckbox(request.getParameter("reg_" + s)));
                ver.setSe(ctrlCheckbox(request.getParameter("se_" + s)));
                list_al.add(ver);
            }
            cl2.setVerifiche_allievi(list_al);
            
            File checklist = ExportExcel.compileCL2(cl2);
            if (checklist != null) {
                resp.addProperty("message", "Checklist compilata con successo.");
                resp.addProperty("result", true);
                resp.addProperty("filedl", checklist.getAbsolutePath().replaceAll("\\\\", "/"));
            } else {
                resp.addProperty("result", false);
                resp.addProperty("message", "Errore: non &egrave; stato possibile compilare la checklist.");
            }
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniSA compileCL2: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile compilare la checklist.");
        } finally {
            e.close();
        }
        
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void downloadExcelDocente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        Docenti d = e.getEm().find(Docenti.class, Long.valueOf(request.getParameter("id")));
        e.close();
        
        ByteArrayOutputStream out = lezioniDocente(d);
        
        byte[] encoded = Base64.getEncoder().encode(out.toByteArray());
        out.close();
        
        response.getWriter().write(new String(encoded));
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void downloadTarGz_only(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        ProgettiFormativi p = e.getEm().find(ProgettiFormativi.class, Long.valueOf(request.getParameter("id")));
        e.close();
        
        List<ProgettiFormativi> prgs = new ArrayList<>();
        prgs.add(p);
        
        ByteArrayOutputStream out = createTarArchive(prgs);
        
        byte[] encoded = Base64.getEncoder().encode(out.toByteArray());
        out.close();
        
        response.getWriter().write(new String(encoded));
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void downloadTarGz(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        e.begin();
        JsonObject resp = new JsonObject();
        try {
            Date today = new Date();
            String[] progetti = request.getParameterValues("progetti[]");
            List<ProgettiFormativi> prgs = new ArrayList<>();
            ArrayList<String> cip = new ArrayList<>();
            ProgettiFormativi prg;
            for (String s : progetti) {
                prg = e.getEm().find(ProgettiFormativi.class, Long.valueOf(s));
                prgs.add(prg);
                cip.add(prg.getCip());
            }
            String path = e.getPath("output_excel_archive") + new SimpleDateFormat("yyyyMMdd_HHmmss").format(today) + ".tar.gz";
            createTarArchive(prgs, path);
            
            ObjectMapper mapper = new ObjectMapper();
            e.persist(new Estrazioni(today, mapper.writeValueAsString(cip), path));
            
            for (ProgettiFormativi p : prgs) {
                p.setExtract(1);
                e.merge(p);
            }
            e.commit();
            resp.addProperty("result", true);
            resp.addProperty("path", path);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniSA downloadTarGz: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile creare il file.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
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
    
    protected void uploadPec(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        JsonObject resp = new JsonObject();
        
        Entity e = new Entity();
        try {
            SoggettiAttuatori sa = e.getEm().find(SoggettiAttuatori.class, Long.valueOf(request.getParameter("idsa")));
            String today = new SimpleDateFormat("yyyyMMddHHssSSS").format(new Date());
            e.begin();
            String piva = request.getParameter("piva_sa");
            String cf = request.getParameter("cf_sa");
            boolean check_piva = e.getUserPiva(piva) == null || piva.equalsIgnoreCase(sa.getPiva() == null ? "" : sa.getPiva());
            boolean check_cf = e.getUserCF(cf) == null || cf.equalsIgnoreCase(sa.getCodicefiscale() == null ? "" : sa.getCodicefiscale());
            String rs_nota = !request.getParameter("rs_sa").equalsIgnoreCase(sa.getRagionesociale()) ? "Rag. Sociale: " + request.getParameter("rs_sa") + " (" + sa.getRagionesociale() + "); " : "";
            String cf_nota = !cf.equalsIgnoreCase(sa.getCodicefiscale() == null ? "" : sa.getCodicefiscale()) ? ("C.F.: " + (cf == null || cf.equals("") ? "-" : cf) + " (" + (sa.getCodicefiscale() == null ? "-" : sa.getCodicefiscale()) + "); ") : "";
            String piva_nota = !piva.equalsIgnoreCase(sa.getPiva() == null ? "" : sa.getPiva()) ? ("P.IVA: " + (piva == null || piva.equals("") ? "-" : piva) + " (" + (sa.getPiva() == null ? "-" : sa.getPiva()) + "); ") : "";
            if (check_cf || check_piva) {
                Part p = request.getPart("file");
                if (p != null && p.getSubmittedFileName() != null && p.getSubmittedFileName().length() > 0) {
                    String ext = p.getSubmittedFileName().substring(p.getSubmittedFileName().lastIndexOf("."));
                    String path = e.getPath("pathDocSA").replace("@folder", String.valueOf(sa.getId()));
                    File dir = new File(path);
                    dir.mkdirs();
                    path += Utility.correctName("pec_" + today) + ext;
                    p.write(path);
                    Storico_ModificheInfo st = new Storico_ModificheInfo();
                    st.setPath(path);
                    st.setSoggetto(sa);
                    st.setData(new Date());
                    st.setOperazione(rs_nota + cf_nota + piva_nota);
                    e.persist(st);
                }
                sa.setRagionesociale(request.getParameter("rs_sa"));
                sa.setPiva(!piva.equalsIgnoreCase("") ? piva : null);
                sa.setCodicefiscale(!cf.equalsIgnoreCase("") ? cf : null);
                e.merge(sa);
                e.flush();
                e.commit();
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
            e.rollBack();
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro uploadPec: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile caricare il documento.");
        } finally {
            e.close();
        }
        
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void uploadDocPregresso(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        try {
            Part p = request.getPart("file");
            e.begin();
            Allievi_Pregresso a = e.getEm().find(Allievi_Pregresso.class, Long.valueOf(request.getParameter("idallievo")));
            TipoDoc_Allievi_Pregresso tipo = e.getEm().find(TipoDoc_Allievi_Pregresso.class, Long.valueOf(request.getParameter("id_tipo")));
            //creao il path
            String path = e.getPath("pathDoc_pregresso").replace("@cf", a.getCodice_fiscale());
            String file_path;
            String today = new SimpleDateFormat("yyyyMMddHHssSSS").format(new Date());
            new File(path).mkdirs();
            //scrivo il file su disco
            if (p != null && p.getSubmittedFileName() != null && p.getSubmittedFileName().length() > 0) {
                file_path = path + tipo.getDescrizione() + "_" + today + p.getSubmittedFileName().substring(p.getSubmittedFileName().lastIndexOf("."));
                p.write(file_path);
                Documenti_Allievi_Pregresso doc = new Documenti_Allievi_Pregresso();
                doc.setPath(file_path);
                doc.setTipo(tipo);
                doc.setAllievo(a);
                e.persist(doc);
            }
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.rollBack();
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniMicro uploadDocPregresso: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile caricare il documento.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void modifyDocPregresso(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        try {
            Part p = request.getPart("file");
            Documenti_Allievi_Pregresso d = e.getEm().find(Documenti_Allievi_Pregresso.class, Long.valueOf(request.getParameter("id")));
            if (p != null && p.getSubmittedFileName() != null && p.getSubmittedFileName().length() > 0) {
                p.write(d.getPath());
            }
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.rollBack();
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniMicro modifyDocPregresso: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile modificare il documento.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void modifyDocIdPregresso(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        try {
            
            Part p = request.getPart("file");
            Allievi_Pregresso a = e.getEm().find(Allievi_Pregresso.class, Long.valueOf(request.getParameter("id")));
            //creao il path
            String path = e.getPath("pathDoc_pregresso").replace("@cf", a.getCodice_fiscale());
            new File(path).mkdirs();
            String file_path;
            String today = new SimpleDateFormat("yyyyMMddHHssSSS").format(new Date());

            //scrivo il file su disco
            if (p != null && p.getSubmittedFileName() != null && p.getSubmittedFileName().length() > 0) {
                file_path = a.getDocid() == null ? (path + "DocId_" + today + p.getSubmittedFileName().substring(p.getSubmittedFileName().lastIndexOf("."))) : a.getDocid();
                p.write(file_path);
                if (a.getDocid() == null) {//se path è null
                    e.begin();
                    a.setDocid(file_path);
                    e.persist(a);
                    e.commit();
                }
            }
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.rollBack();
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniMicro modifyDocIdPregresso: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile modificare il documento.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void sendAnswer(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        
        try {
            String answer = request.getParameter("text");
            e.begin();
            Faq f = e.getLastFaqSoggetto(e.getEm().find(SoggettiAttuatori.class, Long.valueOf(request.getParameter("idsoggetto"))));
            f.setRisposta(answer);
            f.setDate_answer(new Date());
            e.merge(f);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniMicro sendAnswer: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile inviare il messaggio.");
        } finally {
            e.close();
        }
        
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void setTipoFaq(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        try {
            e.begin();
            Faq f = e.getEm().find(Faq.class, Long.valueOf(request.getParameter("id")));
            f.setTipo(e.getEm().find(TipoFaq.class, Long.valueOf(request.getParameter("tipo"))));
            e.merge(f);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniMicro setTipoFaq: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile inviare il messaggio.");
        } finally {
            e.close();
        }
        
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void modifyFaq(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        try {
            e.begin();
            Faq f = e.getEm().find(Faq.class, Long.valueOf(request.getParameter("id")));
            f.setDomanda_mod(request.getParameter("domanda"));
            f.setRisposta(request.getParameter("risposta"));
            e.merge(f);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniMicro modifyFaq: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile moodificare la FAQ.");
        } finally {
            e.close();
        }
        
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void creaFAD(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        try {
            String nome_fad = request.getParameter("name_fad").trim();//.replaceAll("\\s+", "_");rimuove tutti gli spazi
            String pwd = Utility.getRandomString(8);
            String[] emails = request.getParameterValues("email[]");
            String[] date = request.getParameter("range").split("-");
            String note = request.getParameter("note") == null || request.getParameter("note").trim().isEmpty()
                    ? ""
                    : request.getParameter("note").trim();
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            
            ObjectMapper mapper = new ObjectMapper();
            String pathtemp = e.getPath("pathTemp");
            String mailjet_api = e.getPath("mailjet_api");
            String mailjet_secret = e.getPath("mailjet_secret");
            String link = e.getPath("linkfad");
            String dominio = e.getPath("dominio");
            
            e.begin();
            FadMicro f = new FadMicro();
            f.setNomestanza(nome_fad);
            f.setPassword(pwd);
            f.setPartecipanti(mapper.writeValueAsString(emails));
            f.setUser((User) request.getSession().getAttribute("user"));
            f.setDatacreazione(new Date());
            f.setInizio(sdf.parse(date[0].trim()));
            f.setFine(sdf.parse(date[1].trim()));
            f.setNote(note);
            e.persist(f);
            e.flush();
            e.commit();
            
            Email email = e.getEmail("new_conferenza");
            email.setTesto(email.getTesto()
                    .replace("@redirect", dominio + "redirect_out.jsp")
                    .replace("@link", link)
                    .replace("@id", f.getId().toString())
                    .replace("@pwd", pwd)
                    .replace("@start", date[0].trim())
                    .replace("@end", date[1].trim())
                    .replace("@note", note)
                    .replace("@email_tec", e.getPath("emailtecnico"))
                    .replace("@email_am", e.getPath("emailamministrativo")));
            
            for (String s : emails) {
                SendMailJet.sendMailEvento("Microcredito",
                        new String[]{s},
                        null,
                        email.getTesto().replace("@user", s),
                        email.getOggetto(),
                        SendMailJet.createEVENT(Utility.sdmysql.format(f.getInizio()), Utility.sdmysql.format(f.getFine()), email.getOggetto(), pathtemp),
                        mailjet_api, mailjet_secret);
            }
            
            resp.addProperty("result", true);
            resp.addProperty("pwd", pwd);
            resp.addProperty("id", f.getId());
            resp.addProperty("email", ((User) request.getSession().getAttribute("user")).getEmail());
            resp.addProperty("link", link);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro creaFAD: " + ex.getMessage());
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile creare il convegno.");
        } finally {
            e.close();
        }
        
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void modifyFAD(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        try {
            String nome_fad = request.getParameter("name_fad").trim();//.replaceAll("\\s+", "_");rimuove tutti gli spazi
            String[] emails = request.getParameterValues("email[]");
            String[] date = request.getParameter("range").split("-");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            
            ObjectMapper mapper = new ObjectMapper();
            e.begin();
            
            FadMicro f = e.getEm().find(FadMicro.class, Long.valueOf(request.getParameter("idFad")));
            f.setNomestanza(nome_fad);
            f.setPartecipanti(mapper.writeValueAsString(emails));
            f.setInizio(sdf.parse(date[0].trim()));
            f.setFine(sdf.parse(date[1].trim()));
            
            e.merge(f);
            e.flush();
            e.commit();
            
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro creaFAD: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile modificare il convegno.");
        } finally {
            e.close();
        }
        
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void closeFAd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        try {
            e.begin();
            FadMicro f = e.getEm().find(FadMicro.class, Long.valueOf(request.getParameter("id")));
            f.setStato(Integer.parseInt(request.getParameter("stato")));
            e.merge(f);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro closeFAd: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile modificare la stanza.");
        } finally {
            e.close();
        }
        
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void addActivity(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        try {
            e.begin();
            Attivita a = new Attivita();
            a.setName(request.getParameter("nome"));
            a.setComune(e.getEm().find(Comuni.class, Long.valueOf(request.getParameter("comune"))));
            if (a.getComune().getCoordinate() != null) {
                a.setLatitutdine(a.getComune().getCoordinate().getLatitudine() + (getRandomNumber(-30, 30) / 10000));
                a.setLongitudine(a.getComune().getCoordinate().getLongitudine() + (getRandomNumber(-30, 30) / 10000));
            }
            e.persist(a);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro addActivity: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile aggiungere l'attività.");
        } finally {
            e.close();
        }
        
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void deleteActivity(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        try {
            e.begin();
            Attivita a = e.getEm().find(Attivita.class, Long.valueOf(request.getParameter("id")));
            e.getEm().remove(a);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro deteleActivity: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile eliminare l'attività.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void modifyDocente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        try {
            e.begin();
            Docenti d = e.getEm().find(Docenti.class, Long.valueOf(request.getParameter("id")));
            d.setNome(request.getParameter("nome"));
            d.setCognome(request.getParameter("cognome"));
            d.setCodicefiscale(request.getParameter("cf"));
            d.setEmail(request.getParameter("email"));
            d.setDatanascita(new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("data")));
            d.setFascia(e.getEm().find(FasceDocenti.class, request.getParameter("fascia")));
            e.getEm().merge(d);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro deteleActivity: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile eliminare l'attività.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void updateDateProgetto(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setHeader("Content-Type", "application/json");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        String[] date = request.getParameter("date").split("-");
        try {
            e.begin();
            ProgettiFormativi p = e.getEm().find(ProgettiFormativi.class, Long.valueOf(request.getParameter("id")));
            p.setStart(sdf.parse(date[0].trim()));
            p.setEnd(sdf.parse(date[1].trim()));
            
            if (p.getEnd_fb() != null) {
                p.setEnd_fb(p.getEnd());
            }
            
            if (request.getParameter("fb") != null) {
                Date fb = sdf.parse(request.getParameter("fb"));
                p.setStart_fb(fb);
                p.setEnd_fa(fb);
            }
            e.getEm().merge(p);
            e.persist(new Storico_Prg("Date del progetto modificate", new Date(), p, p.getStato()));
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), "OperazioniMicro deteleActivity: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile eliminare l'attività.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void rendicontaProgetto(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setHeader("Content-Type", "application/json");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        try {
            e.begin();
            ProgettiFormativi prg = e.getEm().find(ProgettiFormativi.class, Long.valueOf(request.getParameter("id")));
            prg.setRendicontato(1);
            double euro_ore = Double.parseDouble(e.getPath("euro_ore"));

//            List<DocumentiPrg> registri = prg.getDocumenti().stream().filter(p -> p.getGiorno() != null && p.getDeleted() == 0).collect(Collectors.toList());
//            for (Allievi a : prg.getAllievi()) {
//                double ore_convalidate = 0;
//                for (Documenti_Allievi d : a.getDocumenti().stream().filter(p -> p.getGiorno() != null && p.getDeleted() == 0).collect(Collectors.toList())) {
//                    ore_convalidate += d.getOrericonosciute();
//                }
//                for (DocumentiPrg r : registri) {
//                    ore_convalidate += r.getPresenti_list().stream().filter(x -> x.getId() == a.getId()).findFirst().orElse(new Presenti()).getOre_riconosciute();
//                }
//                a.setImporto(ore_convalidate * euro_ore);
//                e.merge(a);
//            }
            try {
                AtomicDouble importoente = new AtomicDouble(0.0);
                prg.getAllievi().stream()
                        .filter(a -> a.getStatopartecipazione().getId().equals("01")).forEach(a -> {
                    double ore_a = oreFa(prg.getDocumenti(), a.getId());
                    double ore_b = a.getEsito().equals("Fase B") ? oreFb(a.getDocumenti()) : 0;
                    double ore_tot = ore_a + ore_b;
                    int ore_tot_int = Double.valueOf(ore_tot).intValue();
                    BigDecimal bd = new BigDecimal(Double.parseDouble(String.valueOf(ore_tot_int)) * euro_ore);
                    bd.setScale(2, RoundingMode.HALF_EVEN);
                    a.setImporto(bd.doubleValue());
                    e.merge(a);
                    importoente.addAndGet(bd.doubleValue());
                });
                prg.setImporto_ente(importoente.get());
                e.merge(prg);
            } catch (Exception ex2) {
                Utility.log.severe(estraiEccezione(ex2));
            }
            
            e.persist(new Storico_Prg("Progetto Rendicontato", new Date(), prg, prg.getStato()));
            e.commit();
            resp.addProperty("result", true);
            
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniMicro rendicontaProgetto: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile rendicontare progetto.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void addCpiUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        try {
            HashMap<String, String> listusernames = e.getUsersSA();
            String em = request.getParameter("email");
            e.begin();
            String pwd = Utility.getRandomString(8);
            User u = new User();
            u.setUsername(Utility.UniqueUser(listusernames, em.substring(0, em.lastIndexOf("@"))));
            u.setPassword(Utility.convMd5(pwd));
            u.setTipo(4);
            u.setEmail(em);
            
            e.persist(u);
            e.flush();
            
            CpiUser cu = new CpiUser();
            cu.setId(u);
            cu.setNome(request.getParameter("nome"));
            cu.setCognome(request.getParameter("cognome"));
            cu.setEmail(em);
            cu.setCpi(e.getEm().find(CPI.class, request.getParameter("cpi")));
            
            e.persist(cu);
            e.flush();
            e.commit();
            try {
                Email email = (Email) e.getEmail("registration_cpi");
                String email_txt = email.getTesto().replace("@username", u.getUsername())
                        .replace("@password", pwd)
                        .replace("@email_tec", e.getPath("emailtecnico"))
                        .replace("@email_am", e.getPath("emailamministrativo"));
                SendMailJet.sendMail("Microcredito", new String[]{em}, email_txt, email.getOggetto());
                resp.addProperty("result", true);
            } catch (Exception ex) {
                e.insertTracking(null, "forgotPwd Errore Invio Mail: " + estraiEccezione(ex));
                resp.addProperty("result", false);
                resp.addProperty("messagge", "Non è stato possibile inviare la mail, contattare l'assistenza per farsi inviare le credenziali.");
            }
            
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniMicro addCpiUser: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile creare utente CPI.");
        } finally {
            e.close();
        }
        
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void addlez(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String idpr1 = request.getParameter("idpr1");
        String corso = request.getParameter("corso");
        String orainizio = request.getParameter("orainizio");
        if (orainizio.length() == 4) {
            orainizio = "0" + orainizio;
        }
        String orafine = request.getParameter("orafine");
        if (orafine.length() == 4) {
            orafine = "0" + orafine;
        }
        String datalezione = Utility.formatStringtoStringDate(request.getParameter("datalezione"), patternITA, patternSql, false);
        
        Database db = new Database();
        db.insertcalendarioFAD(idpr1, corso, datalezione, orainizio, orafine);
        db.closeDB();
        Utility.redirect(request, response, "page/mc/fad_calendar.jsp?id=" + idpr1);
        
    }
    
    protected void removelez(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String idpr1 = request.getParameter("idpr1");
        String corso1 = request.getParameter("corso1");
        String inizio1 = request.getParameter("inizio1");
        String data1 = Utility.formatStringtoStringDate(request.getParameter("data1"), patternITA, patternSql, false);
        Database db = new Database();
        db.removecalendarioFAD(idpr1, corso1, inizio1, data1);
        db.closeDB();
        
        Utility.redirect(request, response, "page/mc/fad_calendar.jsp?id=" + idpr1);
        
    }
    
    protected void salvaNoteAllievo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        Entity e = new Entity();
        JsonObject resp = new JsonObject();
        boolean check = true;
        
        try {
            e.begin();
            Allievi a = e.getEm().find(Allievi.class, Long.valueOf(request.getParameter("idallievo")));
            if (request.getParameter("notes") != null) {
                a.setNote(new String(request.getParameter("notes").getBytes(Charsets.ISO_8859_1), Charsets.UTF_8).trim());
            }
            e.merge(a);
            e.commit();
            resp.addProperty("result", check);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), 
                    "OperazioniMicro salvaNoteAllievo: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile salvare le note allievo.");
        } finally {
            e.close();
        }
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
        
    }
    
    protected void cambiaDocReportFad(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        String idpr = request.getParameter("idpr");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        try {
            Part part = request.getPart("file");
            if (part != null && part.getSubmittedFileName() != null && part.getSubmittedFileName().length() > 0) {
                ProgettiFormativi pf = e.getEm().find(ProgettiFormativi.class, Long.valueOf(idpr));
                List<DocumentiPrg> list_doc_pr = e.getDocPrg(pf);
                List<Documenti_Allievi> list_doc_al = e.getDocAllieviPR(pf);
                DocumentiPrg registroFADtemp = pf.getDocumenti().stream().filter(d1 -> d1.getTipo().getId() == 30L).findAny().orElse(null);
                if (registroFADtemp != null) {
                    
                    String destpath = registroFADtemp.getPath() + RandomStringUtils.randomAlphabetic(10)
                            + part.getSubmittedFileName().substring(part.getSubmittedFileName().lastIndexOf("."));
                    part.write(destpath);
                    String base64 = org.apache.commons.codec.binary.Base64.encodeBase64String(FileUtils.readFileToByteArray(new File(destpath)));
                    
                    if (base64 != null) {
                        Database db1 = new Database();
                        String base64or = db1.getBase64Report(Integer.parseInt(idpr));
                        if (base64or == null) {
                            String insert = "INSERT INTO fad_report (idprogetti_formativi,base64,definitivo) VALUES (" + idpr + ",'" + base64 + "','Y')";
                            try ( Statement st = db1.getC().createStatement()) {
                                st.execute(insert);
                            }
                        } else {
                            String update = "UPDATE fad_report SET base64='" + base64 + "' WHERE idprogetti_formativi=" + idpr;
                            try ( Statement st = db1.getC().createStatement()) {
                                st.executeUpdate(update);
                            }
                        }
                        List<FadCalendar> calendarioFAD = db1.calendarioFAD(idpr);
                        db1.closeDB();

                        //leggifile e impostaregistro
                        ExportExcel.impostaregistri(base64, pf.getAllievi(), calendarioFAD, list_doc_pr, list_doc_al);
                        
                        resp.addProperty("result", true);
                    } else {
                        resp.addProperty("result", false);
                        resp.addProperty("message", "Errore: file corrotto o non conforme.");
                    }
                    
                } else {
                    resp.addProperty("result", false);
                    resp.addProperty("message", "Errore: registro temporaneo non trovato.");
                }
                
            } else {
                resp.addProperty("result", false);
                resp.addProperty("message", "Errore: file corrotto o non conforme.");
            }
            
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()), 
                    "OperazioniMicro caricaregistroFAD: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile caricare il registro FAD.");
        }
        
        response.getWriter().write(resp.toString());
        response.getWriter().flush();
        response.getWriter().close();
    }
    
    protected void compilaeimporto(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //29-04-2020 MODIFICA - TOGLIERE IMPORTO CHECKLIST
        Entity e = new Entity();
        e.begin();
        String idpr = request.getParameter("idprogetto");
        try {
            
            String prezzo = request.getParameter("kt_inputmask_7");
            while (prezzo.length() < 2) {
                prezzo = "0" + prezzo;
            }
            if (prezzo.length() > 2) {
                String integer = StringUtils.substring(prezzo, 0, prezzo.length() - 2);
                String decimal = StringUtils.substring(prezzo, prezzo.length() - 2);
                prezzo = integer + "." + decimal;
            } else {
                prezzo = "0." + prezzo;
            }
            
            ProgettiFormativi prg = e.getEm().find(ProgettiFormativi.class, Long.valueOf(idpr));
            prg.setImporto(Double.parseDouble(prezzo));
            e.merge(prg);
            e.commit();
            redirect(request, response, "page/mc/uploadCL.jsp?id=" + idpr);
        } catch (Exception ex) {
            e.rollBack();
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniMicro caricaregistroFAD: " + estraiEccezione(ex));
            redirect(request, response, "page/mc/uploadCL.jsp?id=" + idpr);
        }
        
    }
    
    protected void liquidaPrg(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        JsonObject resp = new JsonObject();
        Entity e = new Entity();
        try {
//            double importo = Double.parseDouble(request.getParameter("importo")
//                    .substring(request.getParameter("importo").lastIndexOf("_"))
//                    .replaceAll("[._]", "")
//                    .replace(",", ".").trim());
            e.begin();
            ProgettiFormativi prg = e.getEm().find(ProgettiFormativi.class, Long.valueOf(request.getParameter("id")));
            prg.setRendicontato(2);
//            prg.setImporto_ente(importo);
            e.merge(prg);
            e.commit();
            resp.addProperty("result", true);
        } catch (Exception ex) {
            e.insertTracking(String.valueOf(((User) request.getSession().getAttribute("user")).getId()),
                    "OperazioniMicro liquidaPrg: " + estraiEccezione(ex));
            resp.addProperty("result", false);
            resp.addProperty("message", "Errore: non &egrave; stato possibile liquidare il progettto.");
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
        if (us != null && us.getTipo() == 2) {
            String type = request.getParameter("type");
            switch (type) {
                case "addlez":
                    addlez(request, response);
                    break;
                case "removelez":
                    removelez(request, response);
                    break;
                case "setProtocollo":
                    setProtocollo(request, response);
                    break;
                case "addDocente":
                    addDocente(request, response);
                    break;
                case "addDocenteFile":
                    addDocenteFile(request, response);
                    break;
                case "addAuleFile":
                    addAuleFile(request, response);
                    break;
                case "addAula":
                    addAula(request, response);
                    break;
                case "validatePrg":
                    validatePrg(request, response);
                    break;
                case "rejectPrg":
                    rejectPrg(request, response);
                    break;
                case "annullaPrg":
                    annullaPrg(request, response);
                    break;
                case "eliminaDocente":
                    eliminaDocente(request, response);
                    break;
                case "validateHourRegistroAula":
                    validateHourRegistroAula(request, response);
                    break;
                case "setHoursRegistro":
                    setHoursRegistro(request, response);
                    break;
                case "modifyDoc":
                    modifyDoc(request, response);
                    break;
                case "uploadDocPrg":
                    uploadDocPrg(request, response);
                    break;
                case "compileCL2":
                    compileCL2(request, response);
                    break;
                case "downloadExcelDocente":
                    downloadExcelDocente(request, response);
                    break;
                case "downloadTarGz_only":
                    downloadTarGz_only(request, response);
                    break;
                case "downloadTarGz":
                    downloadTarGz(request, response);
                    break;
                case "checkPiva":
                    checkPiva(request, response);
                    break;
                case "checkCF":
                    checkCF(request, response);
                    break;
                case "uploadPec":
                    uploadPec(request, response);
                    break;
                case "uploadDocPregresso":
                    uploadDocPregresso(request, response);
                    break;
                case "modifyDocPregresso":
                    modifyDocPregresso(request, response);
                    break;
                case "modifyDocIdPregresso":
                    modifyDocIdPregresso(request, response);
                    break;
                case "sendAnswer":
                    sendAnswer(request, response);
                    break;
                case "setTipoFaq":
                    setTipoFaq(request, response);
                    break;
                case "modifyFaq":
                    modifyFaq(request, response);
                    break;
                case "creaFAD":
                    creaFAD(request, response);
                    break;
                case "closeFAd":
                    closeFAd(request, response);
                    break;
                case "addActivity":
                    addActivity(request, response);
                    break;
                case "deleteActivity":
                    deleteActivity(request, response);
                    break;
                case "modifyDocente":
                    modifyDocente(request, response);
                    break;
                case "updateDateProgetto":
                    updateDateProgetto(request, response);
                    break;
                case "rendicontaProgetto":
                    rendicontaProgetto(request, response);
                    break;
                case "modifyFAD":
                    modifyFAD(request, response);
                    break;
                case "addCpiUser":
                    addCpiUser(request, response);
                    break;
                case "liquidaPrg":
                    liquidaPrg(request, response);
                    break;
                case "salvaNoteAllievo":
                    salvaNoteAllievo(request, response);
                    break;
                case "cambiaDocReportFad":
                    cambiaDocReportFad(request, response);
                    break;
                case "compilaeimporto":
                    compilaeimporto(request, response);
                    break;
                default:
                    break;
            }
        }
    }

    /* metodi */
    private boolean checkValidateRegister(List<DocumentiPrg> doc) {
        for (DocumentiPrg d : doc) {
            if (d.getValidate() != 1) {
                return false;
            }
        }
        return true;
    }
    
    private boolean checkValidateRegisterAllievo(List<Documenti_Allievi> doc) {
        for (Documenti_Allievi d : doc) {
            if (d.getOrericonosciute() == null) {
                return false;
            }
        }
        return true;
    }
    
    private double getRandomNumber(int min, int max) {
        return ((Math.random() * (max - min)) + min);
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
