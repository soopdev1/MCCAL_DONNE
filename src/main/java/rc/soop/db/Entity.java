/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.db;

import rc.soop.domain.Allievi;
import rc.soop.domain.Allievi_Pregresso;
import rc.soop.domain.Attivita;
import rc.soop.domain.CPI;
import rc.soop.domain.Cad;
import rc.soop.domain.Comuni;
import rc.soop.domain.Docenti;
import rc.soop.domain.DocumentiPrg;
import rc.soop.domain.Documenti_Allievi;
import rc.soop.domain.Documenti_Allievi_Pregresso;
import rc.soop.domain.Email;
import rc.soop.domain.Estrazioni;
import rc.soop.domain.FadMicro;
import rc.soop.domain.Faq;
import rc.soop.domain.TipoFaq;
import rc.soop.domain.FasceDocenti;
import rc.soop.domain.Pagina;
import rc.soop.domain.Path;
import rc.soop.domain.ProgettiFormativi;
import rc.soop.domain.SediFormazione;
import rc.soop.domain.Selfiemployment_Prestiti;
import rc.soop.domain.SoggettiAttuatori;
import rc.soop.domain.StatiPrg;
import rc.soop.domain.StatoPartecipazione;
import rc.soop.domain.Storico_ModificheInfo;
import rc.soop.domain.Storico_Prg;
import rc.soop.domain.TipoDoc;
import rc.soop.domain.TipoDoc_Allievi;
import rc.soop.domain.TitoliStudio;
import rc.soop.domain.Tracking;
import rc.soop.domain.User;
import rc.soop.entity.Item;
import static rc.soop.util.Utility.convMd5;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.StringTokenizer;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.TypedQuery;

/**
 *
 * @author rcosco
 */
public class Entity {

    EntityManagerFactory emf;
    EntityManager em;

    public Entity() {
        this.emf = Persistence.createEntityManagerFactory("microcredito");
        this.em = this.emf.createEntityManager();
        this.em.clear();
    }

    public EntityManager getEm() {
        return em;
    }

    public void begin() {
        this.em.getTransaction().begin();
    }

    public void persist(Object o) {
        this.em.persist(o);
    }

    public void merge(Object o) {
        this.em.merge(o);
    }

    public void commit() {
        this.em.getTransaction().commit();
    }

    public void rollBack() {
        if (this.em.getTransaction().isActive()) {
            this.em.getTransaction().rollback();
        }
    }

    public void flush() {
        this.em.flush();
    }

    public void close() {
        this.em.close();
        this.emf.close();
    }

    public List findAll(Class c) {
        return this.em.createQuery("Select a FROM " + c.getSimpleName() + " a", c).getResultList();
    }

    public boolean isVisible(String gruppo, String page) {
        Pagina p = this.em.find(Pagina.class, page);
        StringTokenizer st = new StringTokenizer(p == null ? "" : p.getPermessi(), "-");
        while (st.hasMoreTokens()) {
            if (gruppo.equals(st.nextToken())) {
                return true;
            }
        }
        return false;
    }

    public void insertTracking(String id_user, String action) {
        if (!this.em.getTransaction().isActive()) {
            this.begin();
        }

        if (id_user == null || id_user.equals("")) {
            id_user = "Service";
        }
        this.persist(new Tracking(id_user, action));
        this.commit();
    }

    public String getPath(String id) {
        try {
            return this.em.find(Path.class, id).getUrl();
        } catch (Exception e) {
        }
        return null;
    }

    public List<Item> listaRegioni() {
        List<String> regioni = this.em.createNamedQuery("comuni.Regione", String.class).getResultList();
        List<Item> out = new ArrayList<>();
        for (String r : regioni) {
            out.add(new Item(r, r, ""));
        }
        return out;

    }

    public ArrayList<Item> listaProvince(String regione) {
        TypedQuery<String> q = this.em.createNamedQuery("comuni.Provincia", String.class);
        q.setParameter("regione", regione);
        List<String> provincie = q.getResultList();
        ArrayList<Item> out = new ArrayList<>();
        for (String p : provincie) {
            out.add(new Item(p, p, ""));
        }
        return out;

    }

    public ArrayList<Item> listaComuni(String provincia) {
        TypedQuery<Comuni> q = this.em.createNamedQuery("comuni.Comune", Comuni.class);
        q.setParameter("provincia", provincia);
        List<Comuni> comuni = q.getResultList();
        ArrayList<Item> out = new ArrayList<>();
        for (Comuni c : comuni) {
            out.add(new Item(String.valueOf(c.getId()), c.getNome(), ""));
        }
        return out;
    }

    public List<Comuni> listaCittadinanza() {
        TypedQuery<Comuni> q = this.em.createNamedQuery("comuni.Cittadinanza", Comuni.class);
        return (List<Comuni>) q.getResultList();
    }

    public List<Comuni> listaComunibyRegione(String regione) {
        TypedQuery<Comuni> q = this.em.createNamedQuery("comuni.byRegione", Comuni.class);
        q.setParameter("regione", regione);
        return (List<Comuni>) q.getResultList();
    }

    public List<Comuni> listaComunibyProvincia(String provincia) {
        TypedQuery<Comuni> q = this.em.createNamedQuery("comuni.Comune", Comuni.class);
        q.setParameter("provincia", provincia);
        return (List<Comuni>) q.getResultList();
    }

    public Comuni getComunibyIstat(String istat) {
        TypedQuery q = this.em.createNamedQuery("comuni.byIstat", Comuni.class);
        q.setParameter("istat", istat);
        return q.getResultList().isEmpty() ? null : (Comuni) q.getSingleResult();
    }

    public List<TitoliStudio> listaTitoliStudio() {
        TypedQuery<TitoliStudio> q = this.em.createNamedQuery("titoli_studio.Elenco", TitoliStudio.class);
        return q.getResultList().isEmpty() ? new ArrayList() : (List<TitoliStudio>) q.getResultList();
    }

    public List<CPI> listaCPI() {
        TypedQuery<CPI> q = this.em.createNamedQuery("cpi.Elenco", CPI.class);
        return q.getResultList().isEmpty() ? new ArrayList() : (List<CPI>) q.getResultList();
    }

    public User getUser(String user, String pwd) {
        TypedQuery q = em.createNamedQuery("user.UsernamePwd", User.class);
        q.setParameter("username", user);
        q.setParameter("password", convMd5(pwd));

        return q.getResultList().isEmpty() ? null : (User) q.getSingleResult();
    }

    public SoggettiAttuatori getUserPiva(String piva) {
        TypedQuery q = em.createNamedQuery("sa.byPiva", SoggettiAttuatori.class);
        q.setParameter("piva", piva);
        return q.getResultList().isEmpty() ? null : (SoggettiAttuatori) q.getSingleResult();
    }

    public SoggettiAttuatori getUserEmail(String email) {
        TypedQuery q = em.createNamedQuery("sa.byEmail", SoggettiAttuatori.class);
        q.setParameter("email", email);
        return q.getResultList().isEmpty() ? null : (SoggettiAttuatori) q.getSingleResult();
    }

    public SoggettiAttuatori getUserCF(String cf) {
        TypedQuery q = em.createNamedQuery("sa.byCF", SoggettiAttuatori.class);
        q.setParameter("codicefiscale", cf);
        return q.getResultList().isEmpty() ? null : (SoggettiAttuatori) q.getSingleResult();
    }

    public User getUserbyUsername(String username) {
        TypedQuery q = em.createNamedQuery("user.byUsername", User.class);
        q.setParameter("username", username);
        return !q.getResultList().isEmpty() ? (User) q.getSingleResult() : null;
    }

    public User getUserbyUsernameToken(String username, String token) {
        TypedQuery q = em.createNamedQuery("user.byUsernameToken", User.class);
        q.setParameter("username", username);
        q.setParameter("token", token);
        return !q.getResultList().isEmpty() ? (User) q.getSingleResult() : null;
    }

    public User getUserbyEmail(String email) {
        TypedQuery q = em.createNamedQuery("user.byEmail", User.class);
        q.setParameter("email", email);
        return !q.getResultList().isEmpty() ? (User) q.getSingleResult() : null;
    }

    public User getUserbySA(SoggettiAttuatori sa) {
        TypedQuery q = em.createNamedQuery("user.bySA", User.class);
        q.setParameter("sa", sa);
        return !q.getResultList().isEmpty() ? (User) q.getSingleResult() : null;
    }

    public Email getEmail(String chiave) {
        return this.em.find(Email.class, chiave);
    }

    public List<SoggettiAttuatori> getSoggettiAttuatori(String ragionesociale, String protocollo, String piva, String cf, String protocollare, String nome, String cognome) {
        HashMap<String, Object> param = new HashMap<>();
        String sql = "SELECT sa FROM SoggettiAttuatori sa ";

        if (!ragionesociale.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "sa.ragionesociale LIKE :ragionesociale";
            param.put("ragionesociale", ragionesociale + "%");
        }
        if (!piva.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "sa.piva=:piva";
            param.put("piva", piva);
        }
        if (!cf.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "sa.codicefiscale=:codicefiscale";
            param.put("codicefiscale", cf);
        }
        if (!protocollo.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "sa.protocollo=:protocollo";
            param.put("protocollo", protocollo);
        }
        if (!protocollare.equals("") && protocollo.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "sa.protocollo ";
            if (protocollare.equals("1")) {
                sql += "IS NULL";
            } else if (protocollare.equals("0")) {
                sql += "IS NOT NULL";
            }
        }
        if (!nome.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "sa.nome LIKE :nome";
            param.put("nome", nome + "%");
        }
        if (!cognome.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "sa.cognome LIKE :cognome";
            param.put("cognome", cognome + "%");
        }

        TypedQuery<SoggettiAttuatori> q = this.em.createQuery(sql, SoggettiAttuatori.class);

        if (param.isEmpty()) {
            q.setMaxResults(500);
        }

        param.entrySet().forEach(m -> {
            q.setParameter(m.getKey(), m.getValue());
        });

        return q.getResultList().isEmpty() ? new ArrayList() : (List<SoggettiAttuatori>) q.getResultList();
    }

    public Allievi getAllievoCF(String cf) {
        TypedQuery q = this.em.createNamedQuery("a.byCF", Allievi.class);
        q.setParameter("codicefiscale", cf);
        return q.getResultList().isEmpty() ? null : (Allievi) q.getSingleResult();
    }

    public boolean updateuserTipo(int tipo, SoggettiAttuatori sa) {
        return this.em.createNamedQuery("user.updateTipo")
                .setParameter("tipo", tipo)
                .setParameter("soggettoattuatore", sa).executeUpdate() > 0;
    }

    public List<Allievi> getAllieviSoggetto(SoggettiAttuatori sa) {
        TypedQuery<Allievi> q = em.createNamedQuery("a.bySoggettoAttuatore", Allievi.class)
                .setParameter("soggetto", sa);
        return q.getResultList().isEmpty() ? new ArrayList() : (List<Allievi>) q.getResultList();
    }

    public List<Allievi> getAllieviSoggettoNoPrg(SoggettiAttuatori sa) {
        TypedQuery<Allievi> q = em.createNamedQuery("a.bySoggettoAttuatoreNoProgetto", Allievi.class)
                .setParameter("soggetto", sa);
        return q.getResultList().isEmpty() ? new ArrayList() : (List<Allievi>) q.getResultList();
    }

    public List<Allievi> getAllieviSA(String nome, String cognome, String cf, String stato, CPI cpi, SoggettiAttuatori sa) {
        HashMap<String, Object> param = new HashMap<>();

        String sql = "SELECT a FROM Allievi a ";

        if (!nome.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.nome LIKE :nome";
            param.put("nome", nome + "%");
        }
        if (!cognome.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.cognome LIKE :cognome";
            param.put("cognome", cognome + "%");
        }
        if (!cf.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.codicefiscale=:codicefiscale";
            param.put("codicefiscale", cf);
        }
        if (!stato.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.stato=:stato";
            param.put("stato", stato);
        }
        if (cpi != null) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.cpi=:cpi";
            param.put("cpi", cpi);
        }
        if (sa != null) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.soggetto=:soggetto";
            param.put("soggetto", sa);
        }

        TypedQuery<Allievi> q = this.em.createQuery(sql, Allievi.class);

        if (param.isEmpty()) {
            q.setMaxResults(500);
        }

        for (HashMap.Entry<String, Object> m : param.entrySet()) {
            q.setParameter(m.getKey(), m.getValue());
        }

        return q.getResultList().isEmpty() ? new ArrayList() : (List<Allievi>) q.getResultList();
    }

    public List<Docenti> getDocenti(String nome, String cognome, String cf) {
        HashMap<String, Object> param = new HashMap<>();

        String sql = "SELECT a FROM Docenti a WHERE a.stato='A' ";

        if (!nome.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.nome LIKE :nome";
            param.put("nome", nome + "%");
        }
        if (!cognome.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.cognome LIKE :cognome";
            param.put("cognome", cognome + "%");
        }
        if (!cf.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.codicefiscale=:codicefiscale";
            param.put("codicefiscale", cf);
        }

        TypedQuery<Docenti> q = this.em.createQuery(sql, Docenti.class);

        if (param.isEmpty()) {
            q.setMaxResults(500);
        }

        for (HashMap.Entry<String, Object> m : param.entrySet()) {
            q.setParameter(m.getKey(), m.getValue());
        }
        return q.getResultList().isEmpty() ? new ArrayList() : (List<Docenti>) q.getResultList();
    }

    public List<Allievi> getAllievi(SoggettiAttuatori sa, CPI cpi, String nome, String cognome, String cf) {
        HashMap<String, Object> param = new HashMap<>();

        String sql = "SELECT a FROM Allievi a ";

        if (sa != null) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.soggetto = :soggetto";
            param.put("soggetto", sa);
        }
        if (cpi != null) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.cpi=:cpi";
            param.put("cpi", cpi);
        }
        if (!nome.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.nome LIKE :nome";
            param.put("nome", nome + "%");
        }
        if (!cognome.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.cognome LIKE :cognome";
            param.put("cognome", cognome + "%");
        }
        if (!cf.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.codicefiscale = :codicefiscale";
            param.put("codicefiscale", cf);
        }

        TypedQuery<Allievi> q = this.em.createQuery(sql, Allievi.class);

        if (param.isEmpty()) {
            q.setMaxResults(500);
        }

        for (HashMap.Entry<String, Object> m : param.entrySet()) {
            q.setParameter(m.getKey(), m.getValue());
        }

        return q.getResultList().isEmpty() ? new ArrayList() : (List<Allievi>) q.getResultList();
    }

    public List<ProgettiFormativi> getProgettiFormativi(SoggettiAttuatori sa, List<StatiPrg> stati, String cip) {
        return getProgettiFormativi(sa, stati, cip, "");
    }

    public List<ProgettiFormativi> getProgettiFormativi(SoggettiAttuatori sa, List<StatiPrg> stati, String cip, String rendicontato) {
        HashMap<String, Object> param = new HashMap<>();

        String sql = "SELECT a FROM ProgettiFormativi a ";

        if (sa != null) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.soggetto = :soggetto";
            param.put("soggetto", sa);
        }
        if (stati != null) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.stato IN :stati";
            param.put("stati", stati);
        }
        if (!cip.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.cip LIKE :cip";
            param.put("cip", cip + "%");
        }
        if (!rendicontato.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.rendicontato = :rendicontato";
            param.put("rendicontato", Integer.valueOf(rendicontato));
        }

        sql += " ORDER BY a.timestamp DESC";//ordina per ultima modifica al progetto

        TypedQuery<ProgettiFormativi> q = this.em.createQuery(sql, ProgettiFormativi.class);
        if (param.isEmpty()) {
            q.setMaxResults(500);
        }

        for (HashMap.Entry<String, Object> m : param.entrySet()) {
            q.setParameter(m.getKey(), m.getValue());
        }
        return q.getResultList().isEmpty() ? new ArrayList() : (List<ProgettiFormativi>) q.getResultList();
    }

    public List<ProgettiFormativi> getProgettiFormativiDocenti(Docenti d) {
        TypedQuery q = em.createNamedQuery("progetti.ProgettiDocente", ProgettiFormativi.class);
        q.setParameter("docente", d);
        return !q.getResultList().isEmpty() ? (List<ProgettiFormativi>) q.getResultList() : new ArrayList();
    }

    public List<Allievi> getAllieviProgettiFormativi(ProgettiFormativi p) {
        TypedQuery q = em.createNamedQuery("a.byProgetto", Allievi.class);
        q.setParameter("progetto", p);
        return !q.getResultList().isEmpty() ? (List<Allievi>) q.getResultList() : new ArrayList();
    }

    public List<StatiPrg> getStatiPrg() {
        return (List<StatiPrg>) this.em.createNamedQuery("statiPrg.Tipo").getResultList();
    }

    public List<StatiPrg> getStatibyTipo(String tipo) {
        return this.em.createNamedQuery("statiPrg.ByTipo", StatiPrg.class)
                .setParameter("tipo", tipo)
                .getResultList();
    }

    public List<StatiPrg> getStatibyDescrizione(String descrizione) {
        return this.em.createNamedQuery("statiPrg.ByDescrizione", StatiPrg.class)
                .setParameter("descrizione", descrizione)
                .getResultList();
    }

    public List<SediFormazione> getSediFormazione(String referente, List<Comuni> comuni) {
        HashMap<String, Object> param = new HashMap<>();

        String sql = "SELECT a FROM SediFormazione a ";

        if (!comuni.isEmpty()) {
            if (comuni.size() == 1) {
                sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
                sql += "a.comune =:comune";
                param.put("comune", comuni.get(0));
            } else {
                sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
                sql += "a.comune IN :comune";
                param.put("comune", comuni);
            }
        }

        if (!referente.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.referente LIKE :referente";
            param.put("referente", "%" + referente + "%");
        }

        TypedQuery<SediFormazione> q = this.em.createQuery(sql, SediFormazione.class);

        if (param.isEmpty()) {
            q.setMaxResults(500);
        }

        for (HashMap.Entry<String, Object> m : param.entrySet()) {
            q.setParameter(m.getKey(), m.getValue());
        }
        return q.getResultList().isEmpty() ? new ArrayList() : (List<SediFormazione>) q.getResultList();
    }

    public List<Docenti> getActiveDocenti() {
        TypedQuery q = this.em.createNamedQuery("d.Active", Docenti.class);
        return !q.getResultList().isEmpty() ? (List<Docenti>) q.getResultList() : new ArrayList();
    }

    public List<TipoDoc> getTipoDoc(StatiPrg stato) {
        TypedQuery q = this.em.createNamedQuery("t.byStato", TipoDoc.class)
                .setParameter("stato", stato);
        return !q.getResultList().isEmpty() ? (List<TipoDoc>) q.getResultList() : new ArrayList();
    }

    public List<TipoDoc> getTipoDocObbl(StatiPrg stato) {
        TypedQuery q = this.em.createNamedQuery("t.byStatoObbligatori", TipoDoc.class)
                .setParameter("stato", stato);
        return !q.getResultList().isEmpty() ? (List<TipoDoc>) q.getResultList() : new ArrayList();
    }

    public List<DocumentiPrg> getDocPrg(ProgettiFormativi progetto) {
        TypedQuery q = this.em.createNamedQuery("d.byPrg", DocumentiPrg.class)
                .setParameter("progetto", progetto);
        return !q.getResultList().isEmpty() ? (List<DocumentiPrg>) q.getResultList() : new ArrayList();
    }

    public List<DocumentiPrg> getregisterPrg(ProgettiFormativi progetto) {
        TypedQuery q = this.em.createNamedQuery("d.registriByPrg", DocumentiPrg.class)
                .setParameter("progetto", progetto);
        return !q.getResultList().isEmpty() ? (List<DocumentiPrg>) q.getResultList() : new ArrayList();
    }

    public List<DocumentiPrg> getregisterPrgDay(ProgettiFormativi progetto, Date giorno) {
        TypedQuery q = this.em.createNamedQuery("d.registriByPrgAndDay", DocumentiPrg.class)
                .setParameter("progetto", progetto)
                .setParameter("giorno", giorno);
        return !q.getResultList().isEmpty() ? (List<DocumentiPrg>) q.getResultList() : new ArrayList();
    }

    public List<DocumentiPrg> getDocIdModifiableDocente(SoggettiAttuatori soggetto, Docenti docente) {
        TypedQuery q = this.em.createNamedQuery("d.getDocIdModifiableDocente", DocumentiPrg.class)
                .setParameter("soggetto", soggetto)
                .setParameter("docente", docente);
        return !q.getResultList().isEmpty() ? (List<DocumentiPrg>) q.getResultList() : new ArrayList();
    }

    public List<Docenti> getDocentiPrg(ProgettiFormativi p) {
        TypedQuery q = em.createNamedQuery("d.byProgetto", Docenti.class);
        q.setParameter("progetto", p);
        return !q.getResultList().isEmpty() ? (List<Docenti>) q.getResultList() : new ArrayList();
    }

    public boolean deleteDocPrg(ProgettiFormativi p, Docenti d) {
        return this.em.createNamedQuery("d.deleteDocDocente")
                .setParameter("progetto", p)
                .setParameter("docente", d).executeUpdate() > 0;
    }

    public List<Storico_Prg> getStoryPrg(ProgettiFormativi p) {
        TypedQuery q = em.createNamedQuery("storico.byPrg", Storico_Prg.class);
        q.setParameter("progetto", p);
        return !q.getResultList().isEmpty() ? (List<Storico_Prg>) q.getResultList() : new ArrayList();
    }

    public StatiPrg getStatiByOrdineProcesso(int ordine) {
        TypedQuery q = em.createNamedQuery("statiPrg.ByOrdinePocesso", StatiPrg.class);
        q.setParameter("ordine", ordine);
        return !q.getResultList().isEmpty() ? (StatiPrg) q.getSingleResult() : null;
    }

    public List<TipoDoc_Allievi> getTipoDocAllievi(StatiPrg stato) {
        TypedQuery q = this.em.createNamedQuery("tipo_doc_a.byStato", TipoDoc_Allievi.class)
                .setParameter("stato", stato);
        return !q.getResultList().isEmpty() ? (List<TipoDoc_Allievi>) q.getResultList() : new ArrayList();
    }

    public List<Documenti_Allievi> getDocAllievo(Allievi a) {
        TypedQuery q = this.em.createNamedQuery("da.byAllievo", Documenti_Allievi.class)
                .setParameter("allievo", a);
        return !q.getResultList().isEmpty() ? (List<Documenti_Allievi>) q.getResultList() : new ArrayList();
    }

    public List<Documenti_Allievi> getDocAllieviPR(ProgettiFormativi a) {

        List<Documenti_Allievi> result = new ArrayList<>();

        List<Allievi> al = getAllieviProgettiFormativi(a);
        al.forEach(allievo -> {
            TypedQuery q = this.em.createNamedQuery("da.byAllievo", Documenti_Allievi.class)
                    .setParameter("allievo", allievo);
            if (!q.getResultList().isEmpty()) {
                result.addAll(q.getResultList());
            }
        });

        return result;
    }

    public List<TipoDoc_Allievi> getTipoDocAllieviObbl(StatiPrg stato) {
        TypedQuery q = this.em.createNamedQuery("tipo_doc_a.byStatoObbligatori", TipoDoc_Allievi.class)
                .setParameter("stato", stato);
        return !q.getResultList().isEmpty() ? (List<TipoDoc_Allievi>) q.getResultList() : new ArrayList();
    }

    public List<DocumentiPrg> getRegistriDay(ProgettiFormativi p, Date d) {
        TypedQuery q = this.em.createNamedQuery("d.getRegisterToday", DocumentiPrg.class)
                .setParameter("progetto", p)
                .setParameter("date", d);
        return !q.getResultList().isEmpty() ? (List<DocumentiPrg>) q.getResultList() : new ArrayList();
    }

    public List<Selfiemployment_Prestiti> listaSE_P() {
        TypedQuery<Selfiemployment_Prestiti> q = this.em.createNamedQuery("se_p.Elenco", Selfiemployment_Prestiti.class);
        return q.getResultList().isEmpty() ? new ArrayList() : (List<Selfiemployment_Prestiti>) q.getResultList();
    }

    public List<StatoPartecipazione> lista_StatoPartecipazione() {
        TypedQuery<StatoPartecipazione> q = this.em.createNamedQuery("sp.Elenco", StatoPartecipazione.class);
        return q.getResultList().isEmpty() ? new ArrayList() : (List<StatoPartecipazione>) q.getResultList();
    }

    public Allievi getAllievoEmail(String email) {
        TypedQuery q = this.em.createNamedQuery("a.byEmail", Allievi.class);
        q.setParameter("email", email);
        return q.getResultList().isEmpty() ? null : (Allievi) q.getSingleResult();
    }

    public List<ProgettiFormativi> ProgettiSAOrdered(SoggettiAttuatori soggetto) {
        TypedQuery q = em.createNamedQuery("progetti.ProgettiSAOrdered", ProgettiFormativi.class)
                .setParameter("soggetto", soggetto);
        return !q.getResultList().isEmpty() ? (List<ProgettiFormativi>) q.getResultList() : new ArrayList();
    }

    public List<ProgettiFormativi> ProgettiSA_Fa(SoggettiAttuatori soggetto) {
        TypedQuery q = em.createNamedQuery("progetti.ProgettiSA_Fa", ProgettiFormativi.class)
                .setParameter("soggetto", soggetto);
        return !q.getResultList().isEmpty() ? (List<ProgettiFormativi>) q.getResultList() : new ArrayList();
    }

    public List<Documenti_Allievi> getRegistriAllievi(List<Allievi> allievi) {
        TypedQuery q = em.createNamedQuery("da.registriByAllievi", Documenti_Allievi.class)
                .setParameter("allievi", allievi);
        return !q.getResultList().isEmpty() ? (List<Documenti_Allievi>) q.getResultList() : new ArrayList();
    }

    public List<SoggettiAttuatori> getSoggettiAttuatori() {
        TypedQuery<SoggettiAttuatori> q = em.createNamedQuery("sa.listaSA", SoggettiAttuatori.class);
        return !q.getResultList().isEmpty() ? (List<SoggettiAttuatori>) q.getResultList() : new ArrayList();
    }

    public List<ProgettiFormativi> getProgettiToExtract() {
        TypedQuery<ProgettiFormativi> q = em.createNamedQuery("progetti.toExtaxt", ProgettiFormativi.class);
        return !q.getResultList().isEmpty() ? (List<ProgettiFormativi>) q.getResultList() : new ArrayList();
    }

    public List<Estrazioni> getEstazioniDesc() {
        TypedQuery<Estrazioni> q = em.createNamedQuery("estrazioni.timestampDesc", Estrazioni.class).setMaxResults(50);
        return !q.getResultList().isEmpty() ? (List<Estrazioni>) q.getResultList() : new ArrayList();
    }

    public Docenti getDocenteByCf(String cf) {
        TypedQuery q = this.em.createNamedQuery("d.byCf", Docenti.class);
        q.setParameter("cf", cf);
        return q.getResultList().isEmpty() ? null : (Docenti) q.getSingleResult();
    }

    public HashMap<String, FasceDocenti> getFasceMap() {
        List<FasceDocenti> fasce = this.findAll(FasceDocenti.class);
        HashMap<String, FasceDocenti> out = new HashMap<>();
        fasce.forEach(f -> {
            out.put(f.getId(), f);
        });
        return out;
    }

    public HashMap<String, String> getUsersSA() {
        List<User> users = this.findAll(User.class);
        HashMap<String, String> out = new HashMap();
        users.forEach(f -> {
            out.put(f.getUsername(), f.getUsername());
        });
        return out;
    }

    public String getCodiceCatastaleComune(Long idcomune) {
        String code = this.em.find(Comuni.class, idcomune) == null ? "-" : this.em.find(Comuni.class, idcomune).getIstat();
        return code;
    }

    public Comuni getComune(Long idcomune) {
        return this.em.find(Comuni.class, idcomune);
    }

    public TipoDoc getsingleTipoDoc(Long iddoc) {
        return this.em.find(TipoDoc.class, iddoc);
    }

    public List<Storico_ModificheInfo> getPec(SoggettiAttuatori sa) {
        TypedQuery<Storico_ModificheInfo> q = em.createNamedQuery("storicomodifiche.bySA", Storico_ModificheInfo.class);
        q.setParameter("soggetto", sa);
        return !q.getResultList().isEmpty() ? (List<Storico_ModificheInfo>) q.getResultList() : new ArrayList();
    }

    public List<DocumentiPrg> getRegisterProgetto_by_Day(Date date, ProgettiFormativi p) {
        TypedQuery<DocumentiPrg> q = em.createNamedQuery("d.getRegisterByDayAndSA", DocumentiPrg.class)
                .setParameter("progetto", p)
                .setParameter("date", date);
        return !q.getResultList().isEmpty() ? (List<DocumentiPrg>) q.getResultList() : new ArrayList();
    }

    public Documenti_Allievi registriByAllievoAndDay(Allievi a, Date giorno) {
        TypedQuery q = this.em.createNamedQuery("da.registriByAllievoAndDay", Documenti_Allievi.class)
                .setParameter("allievo", a)
                .setParameter("giorno", giorno);
        return q.getResultList().isEmpty() ? null : (Documenti_Allievi) q.getSingleResult();
    }

    public Long countProgettiConclusi() {
        TypedQuery q = this.em.createNamedQuery("progetti.countConclusi", Long.class);
        return q.getResultList().isEmpty() ? 0 : (Long) q.getSingleResult();
    }

    public List<Documenti_Allievi_Pregresso> getDoc_Pregresso(Allievi_Pregresso a) {
        TypedQuery<Documenti_Allievi_Pregresso> q = em.createNamedQuery("docP.byAllievo", Documenti_Allievi_Pregresso.class)
                .setParameter("allievo", a);
        return !q.getResultList().isEmpty() ? (List<Documenti_Allievi_Pregresso>) q.getResultList() : new ArrayList();
    }

    public List<Faq> getFaqSoggetto(SoggettiAttuatori s) {
        TypedQuery<Faq> q = em.createNamedQuery("faq.BySoggetto", Faq.class)
                .setParameter("soggetto", s)
                .setMaxResults(40);
        return !q.getResultList().isEmpty() ? (List<Faq>) q.getResultList() : new ArrayList();
    }

    public List<Faq> getFaqSoggetto(SoggettiAttuatori s, int offset, int limit) {
        TypedQuery<Faq> q = em.createNamedQuery("faq.BySoggetto", Faq.class)
                .setParameter("soggetto", s)
                .setMaxResults(limit)//limit
                .setFirstResult(offset);//offset
        return !q.getResultList().isEmpty() ? (List<Faq>) q.getResultList() : new ArrayList();
    }

    public List<Faq> getFaqSoggetti() {
        TypedQuery<Faq> q = em.createNamedQuery("faq.SA", Faq.class);//offset
        return !q.getResultList().isEmpty() ? (List<Faq>) q.getResultList() : new ArrayList();
    }

    public List<Faq> getFaqPublic() {
        TypedQuery<Faq> q = em.createNamedQuery("faq.Public", Faq.class);//offset
        return !q.getResultList().isEmpty() ? (List<Faq>) q.getResultList() : new ArrayList();
    }

    public List<Faq> faqNoAnswer() {
        TypedQuery<Faq> q = em.createNamedQuery("faq.NoAnswer", Faq.class);//offset
        return !q.getResultList().isEmpty() ? (List<Faq>) q.getResultList() : new ArrayList();
    }

    public Faq getLastFaqSoggetto(SoggettiAttuatori s) {
        TypedQuery<Faq> q = em.createNamedQuery("faq.LastBySoggetto", Faq.class)
                .setParameter("soggetto", s)
                .setMaxResults(1);//offset
        return q.getResultList().isEmpty() ? null : (Faq) q.getSingleResult();
    }

    public List<Faq> faqAnswer(SoggettiAttuatori s, TipoFaq tipo) {

        HashMap<String, Object> param = new HashMap<>();

        String sql = "SELECT f FROM Faq f WHERE f.risposta IS NOT NULL ";

        if (s != null) {
            sql += "AND f.soggetto =:soggetto ";
            param.put("soggetto", s);
        }

        if (tipo != null) {
            sql += "AND f.tipo=:tipo ";
            param.put("tipo", tipo);
        }

        sql += "ORDER BY f.timestamp DESC";

        TypedQuery<Faq> q = this.em.createQuery(sql, Faq.class);

        if (param.isEmpty()) {
            q.setMaxResults(500);
        }

        for (HashMap.Entry<String, Object> m : param.entrySet()) {
            q.setParameter(m.getKey(), m.getValue());
        }

        return !q.getResultList().isEmpty() ? (List<Faq>) q.getResultList() : new ArrayList();
    }

    public List<FadMicro> getMyConference(User u, String nomestanza, String stato) {

        HashMap<String, Object> param = new HashMap<>();

        String sql = "SELECT f FROM FadMicro f WHERE f.user=:user AND f.stato<>2 ";
        if (!stato.trim().isEmpty()) {
            sql = "SELECT f FROM FadMicro f WHERE f.user=:user AND f.stato=:stato ";
            param.put("stato", Integer.valueOf(stato));
        }
        param.put("user", u);

        if (nomestanza != null) {
            sql += "AND f.nomestanza LIKE :nomestanza ";
            param.put("nomestanza", "%" + nomestanza + "%");
        }

        sql += "ORDER BY f.datacreazione DESC";

        TypedQuery<FadMicro> q = this.em.createQuery(sql, FadMicro.class);

        for (HashMap.Entry<String, Object> m : param.entrySet()) {
            q.setParameter(m.getKey(), m.getValue());
        }

        return !q.getResultList().isEmpty() ? (List<FadMicro>) q.getResultList() : new ArrayList();
    }

    public Long countFAQ() {
        TypedQuery q = this.em.createNamedQuery("faq.count", Long.class);
        return q.getResultList().isEmpty() ? 0 : (Long) q.getSingleResult();
    }

    public HashMap<String, Comuni> getComuniCalabria() {

        HashMap<String, Comuni> out = new HashMap<>();

        String sql = "SELECT c FROM Comuni c WHERE c.regione='calabria'";
        TypedQuery<Comuni> q = this.em.createQuery(sql, Comuni.class);
        List<Comuni> comuni = (List<Comuni>) q.getResultList();

        comuni.forEach(c -> {
            out.put(c.getNome().toLowerCase(), c);
        });

        return out;
    }

    public List<Attivita> getAttivitaValide() {
        TypedQuery<Attivita> q = em.createNamedQuery("attivita.Valide", Attivita.class);//offset
        return !q.getResultList().isEmpty() ? (List<Attivita>) q.getResultList() : new ArrayList();
    }

    public List<Attivita> getAttivita(String nome, List<Comuni> comuni) {
        HashMap<String, Object> param = new HashMap<>();

        String sql = "SELECT a FROM Attivita a ";

        if (!comuni.isEmpty()) {
            if (comuni.size() == 1) {
                sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
                sql += "a.comune =:comune";
                param.put("comune", comuni.get(0));
            } else {
                sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
                sql += "a.comune IN :comune";
                param.put("comune", comuni);
            }
        }

        if (!nome.equals("")) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "a.name LIKE :nome";
            param.put("nome", "%" + nome + "%");
        }

        TypedQuery<Attivita> q = this.em.createQuery(sql, Attivita.class);

        if (param.isEmpty()) {
            q.setMaxResults(500);
        }

        for (HashMap.Entry<String, Object> m : param.entrySet()) {
            q.setParameter(m.getKey(), m.getValue());
        }
        return q.getResultList().isEmpty() ? new ArrayList() : (List<Attivita>) q.getResultList();
    }

    public List<Cad> getCad(Date giorno, User u) {
        HashMap<String, Object> param = new HashMap<>();

        String sql = "SELECT c FROM Cad c WHERE c.stato<>2";

        if (giorno != null) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "c.giorno=:giorno";
            param.put("giorno", giorno);
        }
        if (u != null) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "c.user=:user";
            param.put("user", u);
        }

        TypedQuery<Cad> q = this.em.createQuery(sql, Cad.class);

        if (param.isEmpty()) {
            q.setMaxResults(500);
        }
        for (HashMap.Entry<String, Object> m : param.entrySet()) {
            q.setParameter(m.getKey(), m.getValue());
        }
        return q.getResultList().isEmpty() ? new ArrayList() : (List<Cad>) q.getResultList();
    }

    public List<Cad> getCadFromDate(Date giorno, User u) {
        HashMap<String, Object> param = new HashMap<>();

        String sql = "SELECT c FROM Cad c WHERE c.stato<>2";//stato 0 Aperto 1 Chiusa 2 Eliminata

        if (giorno != null) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "c.giorno>=:giorno";
            param.put("giorno", giorno);
        }
        if (u != null) {
            sql += !sql.toUpperCase().contains("WHERE") ? "WHERE " : " AND ";
            sql += "c.user=:user";
            param.put("user", u);
        }

        TypedQuery<Cad> q = this.em.createQuery(sql, Cad.class);

        if (param.isEmpty()) {
            q.setMaxResults(500);
        }
        for (HashMap.Entry<String, Object> m : param.entrySet()) {
            q.setParameter(m.getKey(), m.getValue());
        }
        return q.getResultList().isEmpty() ? new ArrayList() : (List<Cad>) q.getResultList();
    }

}
