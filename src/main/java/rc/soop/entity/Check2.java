/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.entity;

import rc.soop.domain.Allievi;
import rc.soop.domain.ProgettiFormativi;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author rcosco
 */
public class Check2 {

    ProgettiFormativi progetto;
    int allievi_tot, allievi_ended;
    String numero_min;
    List<VerificheAllievo> verifiche_allievi = new ArrayList<>();
    Gestione gestione;
    Fascicolo fascicolo;

    @Override
    public String toString() {
        return "Check2{"  + " allievi_tot=" + allievi_tot + ", allievi_ended=" + allievi_ended + ", numero_min=" + numero_min + ", verifiche_allievi=" + verifiche_allievi + ", gestione=" + gestione + ", fascicolo=" + fascicolo + '}';
    }

    public Check2() {
    }

    public ProgettiFormativi getProgetto() {
        return progetto;
    }

    public void setProgetto(ProgettiFormativi progetto) {
        this.progetto = progetto;
    }

    public int getAllievi_tot() {
        return allievi_tot;
    }

    public void setAllievi_tot(int allievi_tot) {
        this.allievi_tot = allievi_tot;
    }

    public int getAllievi_ended() {
        return allievi_ended;
    }

    public void setAllievi_ended(int allievi_ended) {
        this.allievi_ended = allievi_ended;
    }

    public List<VerificheAllievo> getVerifiche_allievi() {
        return verifiche_allievi;
    }

    public void setVerifiche_allievi(List<VerificheAllievo> verifiche_allievi) {
        this.verifiche_allievi = verifiche_allievi;
    }

    public Gestione getGestione() {
        return gestione;
    }

    public void setGestione(Gestione gestione) {
        this.gestione = gestione;
    }

    public Fascicolo getFascicolo() {
        return fascicolo;
    }

    public void setFascicolo(Fascicolo fascicolo) {
        this.fascicolo = fascicolo;
    }

    public String getNumero_min() {
        return numero_min;
    }

    public void setNumero_min(String numero_min) {
        this.numero_min = numero_min;
    }

    public static class VerificheAllievo {

        @Override
        public String toString() {
            return "VerificheAllievo{" + "m1=" + m1 + ", m8=" + m8 + ", se=" + se + ", pi=" + pi + ", registro=" + registro + '}';
        }

        Allievi allievo;
        String m1, m8, se, pi, registro;

        public VerificheAllievo() {
        }

        public VerificheAllievo(Allievi allievo, String m1, String m8, String se, String pi, String registro) {
            this.allievo = allievo;
            this.m1 = m1;
            this.m8 = m8;
            this.se = se;
            this.pi = pi;
            this.registro = registro;
        }

        public Allievi getAllievo() {
            return allievo;
        }

        public void setAllievo(Allievi allievo) {
            this.allievo = allievo;
        }

        public String getM1() {
            return m1;
        }

        public void setM1(String m1) {
            this.m1 = m1;
        }

        public String getM8() {
            return m8;
        }

        public void setM8(String m8) {
            this.m8 = m8;
        }

        public String getSe() {
            return se;
        }

        public void setSe(String se) {
            this.se = se;
        }

        public String getPi() {
            return pi;
        }

        public void setPi(String pi) {
            this.pi = pi;
        }

        public String getRegistro() {
            return registro;
        }

        public void setRegistro(String registro) {
            this.registro = registro;
        }

    }

    public static class Gestione {

        @Override
        public String toString() {
            return "Gestione{" + "swat=" + swat + ", m13=" + m13 + ", conseganto=" + conseganto + ", m9=" + m9 + ", cv=" + cv + ", registro=" + registro + ", stato=" + stato + '}';
        }

        String swat, m13, conseganto, m9, cv, registro, stato;

        public Gestione() {
        }

        public Gestione(String swat, String m13, String conseganto, String m9, String cv, String registro, String stato) {
            this.swat = swat;
            this.m13 = m13;
            this.conseganto = conseganto;
            this.m9 = m9;
            this.cv = cv;
            this.registro = registro;
            this.stato = stato;
        }

        public String getSwat() {
            return swat;
        }

        public void setSwat(String swat) {
            this.swat = swat;
        }

        public String getM13() {
            return m13;
        }

        public void setM13(String m13) {
            this.m13 = m13;
        }

        public String getConseganto() {
            return conseganto;
        }

        public void setConseganto(String conseganto) {
            this.conseganto = conseganto;
        }

        public String getM9() {
            return m9;
        }

        public void setM9(String m9) {
            this.m9 = m9;
        }

        public String getCv() {
            return cv;
        }

        public void setCv(String cv) {
            this.cv = cv;
        }

        public String getRegistro() {
            return registro;
        }

        public void setRegistro(String registro) {
            this.registro = registro;
        }

        public String getStato() {
            return stato;
        }

        public void setStato(String stato) {
            this.stato = stato;
        }

    }

    public static class Fascicolo {

        @Override
        public String toString() {
            return "Fascicolo{" + "m2=" + m2 + ", fa=" + fa + ", allegati_fa=" + allegati_fa + ", fb=" + fb + ", allegati_fb=" + allegati_fb + ", m9=" + m9 + ", note=" + note + '}';
        }

        String m2, fa, allegati_fa, fb, allegati_fb, m9, note, note_esito;

        public Fascicolo() {
        }

        public Fascicolo(String m2, String fa, String allegati_fa, String fb, String allegati_fb, String m9, String note, String note_esito) {
            this.m2 = m2;
            this.fa = fa;
            this.allegati_fa = allegati_fa;
            this.fb = fb;
            this.allegati_fb = allegati_fb;
            this.m9 = m9;
            this.note = "Note: " + note;
            this.note_esito = "Note: " + note_esito;
        }

        public String getM2() {
            return m2;
        }

        public void setM2(String m2) {
            this.m2 = m2;
        }

        public String getFa() {
            return fa;
        }

        public void setFa(String fa) {
            this.fa = fa;
        }

        public String getAllegati_fa() {
            return allegati_fa;
        }

        public void setAllegati_fa(String allegati_fa) {
            this.allegati_fa = allegati_fa;
        }

        public String getFb() {
            return fb;
        }

        public void setFb(String fb) {
            this.fb = fb;
        }

        public String getAllegati_fb() {
            return allegati_fb;
        }

        public void setAllegati_fb(String allegati_fb) {
            this.allegati_fb = allegati_fb;
        }

        public String getM9() {
            return m9;
        }

        public void setM9(String m9) {
            this.m9 = m9;
        }

        public String getNote() {
            return note;
        }

        public void setNote(String note) {
            this.note = "Note: " + note;
        }

        public String getNote_esito() {
            return note_esito;
        }

        public void setNote_esito(String note_esito) {
            this.note_esito = note_esito;
        }
        
    }
}
