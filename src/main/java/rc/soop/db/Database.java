/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.db;

import com.google.common.base.Splitter;
import rc.soop.domain.Allievi;
import rc.soop.domain.CPI;
import rc.soop.domain.Comuni;
import rc.soop.domain.SoggettiAttuatori;
import rc.soop.domain.TitoliStudio;
import rc.soop.entity.FadCalendar;
import rc.soop.entity.Item;
import rc.soop.util.Fadroom;
import static rc.soop.util.Utility.conf;
import static rc.soop.util.Utility.estraiEccezione;
import static rc.soop.util.Utility.formatStringtoStringDate;
import static rc.soop.util.Utility.getUtilDate;
import static rc.soop.util.Utility.log;
import static rc.soop.util.Utility.patternITA;
import static rc.soop.util.Utility.patternSql;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;
import org.apache.commons.lang3.exception.ExceptionUtils;

/**
 *
 * @author rcosco
 */
public class Database {

    public Connection c = null;

    public Database() {

        String user = conf.getString("db.user");
        String password = conf.getString("db.pass");
        String host = conf.getString("db.host") + ":3306/gest_over35";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            Properties p = new Properties();
            p.put("user", user);
            p.put("password", password);
            p.put("characterEncoding", "UTF-8");
            p.put("passwordCharacterEncoding", "UTF-8");
            p.put("useSSL", "false");
            p.put("connectTimeout", "1000");
            p.put("useUnicode", "true");
            p.put("serverTimezone", "Europe/Rome");
            p.put("zeroDateTimeBehavior", "convertToNull");
            this.c = DriverManager.getConnection("jdbc:mysql://" + host, p);
        } catch (Exception ex) {
            ex.printStackTrace();
            if (this.c != null) {
                try {
                    this.c.close();
                } catch (SQLException ex1) {
                }
            }
            this.c = null;
        }
    }

    public void closeDB() {
        try {
            if (c != null) {
                this.c.close();
            }
        } catch (SQLException ex) {
            System.err.println("METHOD: " + new Object() {
            }
                    .getClass()
                    .getEnclosingMethod()
                    .getName());
            System.err.println("ERROR: " + ExceptionUtils.getStackTrace(ex));
        }
    }

    public Connection getC() {
        return c;
    }

    public void setC(Connection c) {
        this.c = c;
    }

    public int countPregresso() {
        int count = 0;
        String sql = "SELECT COUNT(idallievi_pregresso) FROM allievi_pregresso";
        try {
            try ( Statement st = this.c.createStatement();  ResultSet rs = st.executeQuery(sql)) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (Exception ex) {
            count = 0;
            log.severe(estraiEccezione(ex));
        }
        return count;
    }

    public List<Allievi> getAllievi(SoggettiAttuatori sa, CPI cpi, String nome, String cognome, String cf) {
        List<Allievi> out = new ArrayList<>();
        String sql = "SELECT * FROM allievi_pregresso a WHERE cf_sa IN (SELECT DISTINCT(piva) FROM soggetti_attuatori s) ";
        if (sa != null) {
            sql += " AND a.cf_sa = '" + sa.getPiva() + "' ";
        }
        if (cpi != null) {
            sql += " AND a.cpi_di_competenza= '" + cpi.getId() + "' ";
        }
        if (!nome.equals("")) {
            sql += " AND a.nome LIKE \"" + nome + "\"";
        }
        if (!cognome.equals("")) {
            sql += " AND a.cognome LIKE \"" + cognome + "\"";
        }
        if (!cf.equals("")) {
            sql += " AND a.codice_fiscale = \"" + cf + "\"";
        }
        try {
            Entity e = new Entity();
            List<TitoliStudio> tit = e.listaTitoliStudio();
            List<CPI> cpi_list = e.listaCPI();
            List<Comuni> com = e.listaComunibyRegione("CALABRIA");
            try ( Statement st = this.c.createStatement();  ResultSet rs = st.executeQuery(sql)) {
                while (rs.next()) {
                    Allievi a = new Allievi(true);
                    a.setId(rs.getLong("idallievi_pregresso"));
                    a.setNome(rs.getString("a.nome"));
                    a.setCognome(rs.getString("a.cognome"));
                    a.setCodicefiscale(rs.getString("a.codice_fiscale"));
                    a.setDatanascita(getUtilDate(rs.getString("data_di_nascita"), "yyyy-MM-dd"));
                    String cod_studio = rs.getString("a.cod_studio");
                    TitoliStudio ts = tit.stream().filter(t -> t.getCodice().equals(cod_studio)).findAny().orElse(new TitoliStudio());
                    if (ts.getDescrizione() == null) {
                        ts.setDescrizione(rs.getString("a.titolo_di_studio"));
                    }
                    a.setTitoloStudio(ts);
                    String comune_di_residenza = rs.getString("a.comune_di_residenza");
                    a.setComune_residenza(com.stream().filter(com1 -> com1.getNome().equalsIgnoreCase(comune_di_residenza)).findAny().orElse(new Comuni()));
                    a.setComune_domicilio(a.getComune_residenza());
                    a.setIndirizzoresidenza(rs.getString("a.indirizzo_residenza"));
                    a.setIndirizzodomicilio(rs.getString("a.indirizzo_residenza"));
                    String setCpi = rs.getString("a.cpi_di_competenza");
                    CPI cpdc = cpi_list.stream().filter(cp -> cp.getId().equalsIgnoreCase(setCpi)).findAny().orElse(new CPI());
                    if (cpdc.getDescrizione() == null) {
                        cpdc.setDescrizione("NON INDICATO");
                    }
                    a.setCpi(cpdc);
                    a.setDocid(rs.getString("a.docid"));
//                a.setIscrizionegg(null);

                    out.add(a);
                }
            }
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        }
        return out;
    }

    public List<Fadroom> listStanze() {
        List<Fadroom> out = new ArrayList<>();
        try {
            String sql = "SELECT * FROM fad_multi a WHERE stato='0'";
            try ( Statement st = this.c.createStatement();  ResultSet rs = st.executeQuery(sql)) {
                while (rs.next()) {
                    out.add(new Fadroom(rs.getString(1), String.valueOf(rs.getInt(2)), rs.getString(3), rs.getString(5)));
                }
            }
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        }

        return out;
    }

    public List<Item> listReport() {
        List<Item> out = new ArrayList<>();
        try {
            String sql = "SELECT * FROM fad_report";
            try ( Statement st = this.c.createStatement();  ResultSet rs = st.executeQuery(sql)) {
                while (rs.next()) {
                    out.add(new Item(rs.getString(1), rs.getString(2), ""));
                }
            }
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        }

        return out;
    }

    public String getBase64Report(int idpr) {
        String out = null;
        try {
            String sql = "SELECT base64 FROM fad_report WHERE idprogetti_formativi = " + idpr;
            try ( Statement st = this.c.createStatement();  ResultSet rs = st.executeQuery(sql)) {
                while (rs.next()) {
                    out = rs.getString(1);
                }
            }
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
            out = null;
        }
        return out;
    }

    public List<Item> listStanza() {
        List<Item> out = new ArrayList<>();
        try {
            String sql = "SELECT idprogetti_formativi,nomestanza FROM fad a WHERE stato='0'";
            try ( Statement st = this.c.createStatement();  ResultSet rs = st.executeQuery(sql)) {
                while (rs.next()) {
                    out.add(new Item(String.valueOf(rs.getInt(1)), rs.getString(2), rs.getString(2)));
                }
            }
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        }
        return out;
    }

    public String getPathtemp(String id) {
        String p1 = "/mnt/mcalabria/over/gest/temp/";
        try {
            String sql = "SELECT url FROM path WHERE id = ?";
            try ( PreparedStatement ps = this.c.prepareStatement(sql)) {
                ps.setString(1, id);
                try ( ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        p1 = rs.getString(1);
                    }
                }
            }
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        }
        return p1;
    }

    public String getNomePR_F(String id) {
        String p1 = "Progetto Formativo";
        try {
            String sql = "SELECT descrizione FROM progetti_formativi WHERE idprogetti_formativi = ?";
            try ( PreparedStatement ps = this.c.prepareStatement(sql)) {
                ps.setString(1, id);
                try ( ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        p1 = rs.getString(1);
                    }
                }
            }
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        }
        return p1;
    }

    public List<FadCalendar> calendarioFAD(String id) {
        List<FadCalendar> out = new ArrayList<>();
        try {
            String sql = "SELECT * FROM fad_calendar f WHERE f.idprogetti_formativi = ? ORDER BY numerocorso,DATA";
            try ( PreparedStatement ps = this.c.prepareStatement(sql)) {
                ps.setString(1, id);
                try ( ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        if (rs.getString("orainizio").contains(";")) {
                            List<String> orainizio = Splitter.on(";").splitToList(rs.getString("orainizio"));
                            List<String> orafine = Splitter.on(";").splitToList(rs.getString("orafine"));
                            for (int x = 0; x < orainizio.size(); x++) {
                                out.add(new FadCalendar(
                                        id,
                                        rs.getString("numerocorso"),
                                        formatStringtoStringDate(rs.getString("data"), patternSql, patternITA, false),
                                        orainizio.get(x),
                                        orafine.get(x))
                                );
                            }
                        } else {
                            out.add(new FadCalendar(id, rs.getString("numerocorso"), formatStringtoStringDate(rs.getString("data"), patternSql, patternITA, false),
                                    rs.getString("orainizio"), rs.getString("orafine")));
                        }
                    }
                }
            }
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        }
        return out;
    }

    public boolean insertcalendarioFAD(String idpr, String corso, String data, String orainizio, String orafine) {
        boolean out;
        try {
            String sql = "SELECT * FROM fad_calendar WHERE idprogetti_formativi = ? AND numerocorso = ? AND data = ?";
            try ( PreparedStatement ps = this.c.prepareStatement(sql)) {
                ps.setString(1, idpr);
                ps.setString(2, corso);
                ps.setString(3, data);
                try ( ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String orainizio_old = rs.getString("orainizio");
                        String orafine_old = rs.getString("orafine");
                        String orainizio_new = orainizio_old + ";" + orainizio;
                        String orafine_new = orafine_old + ";" + orafine;
                        String update = "UPDATE fad_calendar SET orainizio = ?, orafine = ? "
                                + "WHERE idprogetti_formativi = ? AND numerocorso = ? AND data = ? AND orainizio = ? AND orafine = ?";
                        try ( PreparedStatement ps1 = this.c.prepareStatement(update)) {
                            ps1.setString(1, orainizio_new);
                            ps1.setString(2, orafine_new);
                            ps1.setString(3, idpr);
                            ps1.setString(4, corso);
                            ps1.setString(5, data);
                            ps1.setString(6, orainizio_old);
                            ps1.setString(7, orafine_old);
                            ps1.executeUpdate();
                            out = true;
                        }

                    } else {
                        String del = "INSERT INTO fad_calendar VALUES (?,?,?,?,?)";
                        try ( PreparedStatement ps1 = this.c.prepareStatement(del)) {
                            ps1.setString(1, idpr);
                            ps1.setString(2, corso);
                            ps1.setString(3, data);
                            ps1.setString(4, orainizio);
                            ps1.setString(5, orafine);
                            ps1.execute();
                            out = true;
                        }
                    }
                }
            }
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
            out = false;
        }

        return out;
    }

    public boolean removecalendarioFAD(String idpr, String corso, String inizio, String data) {
        boolean out = false;
        try {
            String sql = "SELECT * FROM fad_calendar WHERE idprogetti_formativi = ? AND numerocorso = ? AND data = ? AND orainizio LIKE ?";
            try ( PreparedStatement ps = this.c.prepareStatement(sql)) {
                ps.setString(1, idpr);
                ps.setString(2, corso);
                ps.setString(3, data);
                ps.setString(4, "%" + inizio + "%");
                try ( ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String orainizio = rs.getString("orainizio");
                        String orafine = rs.getString("orafine");
                        if (orainizio.contains(";")) {
                            LinkedList<String> orainizio_list = new LinkedList<>();
                            orainizio_list.addAll(Splitter.on(";").splitToList(orainizio));
                            LinkedList<String> orafine_list = new LinkedList<>();
                            orafine_list.addAll(Splitter.on(";").splitToList(orafine));
                            int indice = orainizio_list.indexOf(inizio);
                            if (indice >= 0) {
                                orainizio_list.remove(indice);
                                orafine_list.remove(indice);
                                String orainizio_new = String.join(";", orainizio_list);
                                String orafine_new = String.join(";", orafine_list);
                                String update = "UPDATE fad_calendar SET orainizio = ?, orafine = ? "
                                        + "WHERE idprogetti_formativi = ? AND numerocorso = ? AND data = ? AND orainizio = ? AND orafine = ?";
                                try ( PreparedStatement ps1 = this.c.prepareStatement(update)) {
                                    ps1.setString(1, orainizio_new);
                                    ps1.setString(2, orafine_new);
                                    ps1.setString(3, idpr);
                                    ps1.setString(4, corso);
                                    ps1.setString(5, data);
                                    ps1.setString(6, orainizio);
                                    ps1.setString(7, orafine);
                                    ps1.executeUpdate();
                                    out = true;
                                }
                            }
                        } else {
                            String del = "DELETE FROM fad_calendar WHERE idprogetti_formativi = ? AND numerocorso = ? AND data = ? AND orainizio = ? AND orafine = ?";
                            try ( PreparedStatement ps1 = this.c.prepareStatement(del)) {
                                ps1.setString(1, idpr);
                                ps1.setString(2, corso);
                                ps1.setString(3, data);
                                ps1.setString(4, orainizio);
                                ps1.setString(5, orafine);
                                ps1.execute();
                                out = true;
                            }
                        }
                    }
                }
            }
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
            out = false;
        }
        return out;
    }

    public boolean creastanze_faseB(int idpr) {
        try {
            for (int i = 2; i < 5; i++) {
                String ins = "INSERT INTO fad_multi (nomestanza,idprogetti_formativi,numerocorso) VALUES ('FAD_" + idpr + "_" + i + "'," + idpr + ",'" + i + "')";
                try ( Statement st = this.c.createStatement();) {
                    try {
                        st.executeUpdate(ins);
                    } catch (Exception e) {
                        log.severe(estraiEccezione(e));
                    }
                }
            }
            return true;
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        }
        return false;
    }

    //cip misto 20-08-2021
    public int verificaCIP(String cip_prof) {
        int out = -1;
        try {
            String sql = "SELECT idprogetti_formativi FROM progetti_formativi WHERE cip='" + cip_prof + "' AND misto=1 AND cip_misto IS NULL;";

            try ( Statement st = this.c.createStatement();  ResultSet rs = st.executeQuery(sql)) {
                if (rs.next()) {
                    out = rs.getInt(1);
                }
            }
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        }

        return out;
    }

    public boolean updateCIPMisto(int idpr, String cip_neet) {
        boolean out = false;
        try {
            String upd = "UPDATE progetti_formativi SET cip_misto='" + cip_neet + "' WHERE idprogetti_formativi = " + idpr;
            try ( Statement st = this.c.createStatement()) {
                out = st.executeUpdate(upd) > 0;
            }
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        }
        return out;
    }

}
