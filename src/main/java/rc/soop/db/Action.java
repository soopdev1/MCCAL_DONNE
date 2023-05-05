/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.db;

import rc.soop.domain.Allievi;
import rc.soop.domain.ProgettiFormativi;
import rc.soop.entity.FadCalendar;
import static rc.soop.util.Utility.pregresso;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.StringTokenizer;
import java.util.concurrent.atomic.AtomicInteger;
import javax.persistence.TypedQuery;

/**
 *
 * @author rcosco
 */
public class Action {

    public static boolean isVisibile(String gruppo, String page) {//(tipo, pagina)
        Entity e = new Entity();
        boolean out = e.isVisible(gruppo, page);
        e.close();
        return out;
    }

    public static boolean isModifiable(String modificabile, String stato) {//usato anche per la visualizzazione dei modelli
        if (modificabile != null) {
            StringTokenizer st = new StringTokenizer(modificabile, "-");
            while (st.hasMoreTokens()) {
                if (stato.equals(st.nextToken())) {
                    return true;
                }
            }
        }
        return false;
    }

    public static int countPregresso() {
        if (!pregresso) {
            return 0;
        }
        Database db = new Database();
        if (db.getC() == null) {
            return 0;
        }
        int c = db.countPregresso();
        db.closeDB();
        return c;
    }

    public static List<FadCalendar> calendarioFAD(String id) {
        List<FadCalendar> out = new ArrayList<>();
        Database db = new Database();
        if (db.getC() == null) {
            return out;
        }
        out = db.calendarioFAD(id);
        db.closeDB();
        return out;
    }

    public static String linkFAD() {
        Database db = new Database();
        if (db.getC() == null) {
            return "https://fad23.servizi.link/Login";
        }
        String out = db.getPathtemp("linkfad");
        db.closeDB();
        return out;
    }

    public static String[] contatoriHome() {
        String[] out = {
            "0", "0", "0", "0", "0", "0", "0", "0"
        };

        int pregresso = countPregresso();

        Entity e = new Entity();
        e.begin();

        TypedQuery<Allievi> q = e.getEm().createQuery("SELECT p FROM Allievi p", Allievi.class);
        List<Allievi> all_allievi = q.getResultList().isEmpty() ? new ArrayList() : q.getResultList();
        TypedQuery<ProgettiFormativi> q1 = e.getEm().createQuery("SELECT p FROM ProgettiFormativi p", ProgettiFormativi.class);
        List<ProgettiFormativi> all_pf = q1.getResultList().isEmpty() ? new ArrayList() : q1.getResultList();

        int totale_allievi = all_allievi.size() + pregresso;

        List<String> statiavvio = Arrays.asList(new String[]{"S", "S1"});
        List<String> staticoncluso = Arrays.asList(new String[]{"C", "C1", "CL", "AR"});

        AtomicInteger in_formazione = new AtomicInteger(0);
        AtomicInteger in_avvio = new AtomicInteger(0);
        AtomicInteger concluso = new AtomicInteger(0);
        all_allievi.forEach(a1 -> {
            if (a1.getProgetto() == null) {
                in_avvio.addAndGet(1);
            } else {
                if (a1.getStatopartecipazione().getId().equals("01")) {
                    if (statiavvio.contains(a1.getProgetto().getStato().getId())) {
                        in_formazione.addAndGet(1);
                    } else if (staticoncluso.contains(a1.getProgetto().getStato().getId())) {
                        concluso.addAndGet(1);
                    } else {
                        in_formazione.addAndGet(1);
                    }
                }
            }
        });

        List<String> statipfok = Arrays.asList(new String[]{"S", "S1", "A", "A1", "FA", "FA1", "FB"});
        List<String> staticheck = Arrays.asList(new String[]{"FB1", "C", "C1", "CL"});
        AtomicInteger pf_ok = new AtomicInteger(0);
        AtomicInteger pf_chiusi = new AtomicInteger(0);
        AtomicInteger pf_check = new AtomicInteger(0);
        AtomicInteger pf_annullati = new AtomicInteger(0);

        all_pf.forEach(a1 -> {
            if (a1.getStato().getId().equals("AR")) {
                pf_chiusi.addAndGet(1);
            } else if (a1.getStato().getId().equals("KO")) {
                pf_annullati.addAndGet(1);
            } else if (statipfok.contains(a1.getStato().getId())) {
                pf_ok.addAndGet(1);
            } else if (staticheck.contains(a1.getStato().getId())) {
                pf_check.addAndGet(1);
            }
        });

        out[0] = String.valueOf(totale_allievi);
        out[1] = String.valueOf(concluso.get() + pregresso);
        out[2] = String.valueOf(in_formazione.get());
        out[3] = String.valueOf(in_avvio.get());

        out[4] = String.valueOf(pf_ok.get());
        out[5] = String.valueOf(pf_chiusi.get());
        out[6] = String.valueOf(pf_check.get());
        out[7] = String.valueOf(pf_annullati.get());

        e.close();
        return out;
    }

    public static void creastanze_faseB(int idpr) {
        Database db1 = new Database();
        db1.creastanze_faseB(idpr);
        db1.closeDB();
    }

}
