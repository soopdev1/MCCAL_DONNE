/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.domain;

import com.fasterxml.jackson.databind.ObjectMapper;
import rc.soop.entity.Presenti;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

/**
 *
 * @author rcosco
 */
@Entity
@Table(name = "documenti_progetti")
@NamedQueries(value = {
    @NamedQuery(name = "d.byPrg", query = "SELECT d FROM DocumentiPrg d WHERE d.progetto=:progetto AND d.deleted=0")
    ,
    @NamedQuery(name = "d.registriByPrg", query = "SELECT d FROM DocumentiPrg d WHERE d.progetto=:progetto AND d.deleted=0 AND d.giorno IS NOT NULL")
    ,
    @NamedQuery(name = "d.registriByPrgAndDay", query = "SELECT d FROM DocumentiPrg d WHERE d.progetto=:progetto AND d.deleted=0 AND d.giorno=:giorno")
    ,
    @NamedQuery(name = "d.deleteDocDocente", query = "UPDATE DocumentiPrg d SET d.deleted=1 WHERE d.progetto=:progetto AND d.docente=:docente")
    ,
    @NamedQuery(name = "d.getRegisterToday", query = "SELECT d FROM DocumentiPrg d WHERE d.giorno =:date AND d.progetto=:progetto AND d.deleted=0")
    ,
    @NamedQuery(name = "d.getRegisterByDayAndSA", query = "SELECT d FROM DocumentiPrg d WHERE d.giorno =:date AND d.progetto=:progetto")
    ,
    @NamedQuery(name = "d.deleteDoc", query = "UPDATE DocumentiPrg d SET d.deleted=1 WHERE d.progetto=:progetto")
    ,
    @NamedQuery(name = "d.getDocIdModifiableDocente", query = "SELECT d FROM DocumentiPrg d WHERE d.progetto IN (SELECT p FROM ProgettiFormativi p WHERE p.stato.modificabile=1 AND p.soggetto=:soggetto) "
            + "AND d.scadenza IS NOT NULL "
            + "AND d.docente=:docente AND d.deleted=0"),})

public class DocumentiPrg implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "iddocumenti_progetti")
    private Long id;
    @Column(name = "path")
    private String path;
    @Column(name = "scadenza")
    @Temporal(TemporalType.DATE)
    private Date scadenza;
    @Column(name = "deleted", columnDefinition = "INT(1) DEFAULT 0")
    private int deleted;
    @ManyToOne
    @JoinColumn(name = "tipo")
    TipoDoc tipo;
    @Column(name = "giorno")
    @Temporal(TemporalType.DATE)
    private Date giorno;
    @Temporal(TemporalType.TIME)
    @Column(name = "orariostart")
    private Date orariostart;
    @Temporal(TemporalType.TIME)
    @Column(name = "orarioend")
    private Date orarioend;
    @Column(name = "presenti", columnDefinition = "TEXT")
    private String presenti;
    @Column(name = "ore")
    private double ore;
    @Column(name = "ore_convalidate")
    private double ore_convalidate;
    @Column(name = "validate")
    private double validate;
    @ManyToOne
    @JoinColumn(name = "iddocente")
    Docenti docente;
    @ManyToOne
    @JoinColumn(name = "idprogetto")
    ProgettiFormativi progetto;

    @Transient
    List<Presenti> presenti_list = new ArrayList<>();

    public DocumentiPrg() {
    }

    public double getValidate() {
        return validate;
    }

    public void setValidate(double validate) {
        this.validate = validate;
    }

    public double getOre_convalidate() {
        return ore_convalidate;
    }

    public void setOre_convalidate(double ore_convalidate) {
        this.ore_convalidate = ore_convalidate;
    }

    public DocumentiPrg(Long id, String path, TipoDoc tipo) {
        this.id = id;
        this.path = path;
        this.tipo = tipo;
    }

    public DocumentiPrg(String path, TipoDoc tipo, ProgettiFormativi progetto) {
        this.path = path;
        this.tipo = tipo;
        this.progetto = progetto;
    }
    
    
    
    public List<Presenti> getPresenti_list() {
        if (this.presenti != null && !this.presenti.equals("") && this.presenti_list.isEmpty()) {
            try {
                this.presenti_list = Arrays.asList(new ObjectMapper().readValue(presenti, Presenti[].class));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return presenti_list;
    }

    public void setPresenti_list(List<Presenti> presenti_list) {
        this.presenti_list = presenti_list;
    }

    public double getOre() {
        return ore;
    }

    public void setOre(double ore) {
        this.ore = ore;
    }

    public Date getGiorno() {
        return giorno;
    }

    public void setGiorno(Date giorno) {
        this.giorno = giorno;
    }

    public Date getOrariostart() {
        return orariostart;
    }

    public void setOrariostart(Date orariostart) {
        this.orariostart = orariostart;
    }

    public Date getOrarioend() {
        return orarioend;
    }

    public void setOrarioend(Date orarioend) {
        this.orarioend = orarioend;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public TipoDoc getTipo() {
        return tipo;
    }

    public void setTipo(TipoDoc tipo) {
        this.tipo = tipo;
    }

    public Date getScadenza() {
        return scadenza;
    }

    public void setScadenza(Date scadenza) {
        this.scadenza = scadenza;
    }

    public Docenti getDocente() {
        return docente;
    }

    public void setDocente(Docenti docente) {
        this.docente = docente;
    }

    public ProgettiFormativi getProgetto() {
        return progetto;
    }

    public void setProgetto(ProgettiFormativi progetto) {
        this.progetto = progetto;
    }

    public int getDeleted() {
        return deleted;
    }

    public void setDeleted(int deleted) {
        this.deleted = deleted;
    }

    public String getPresenti() {
        return presenti;
    }

    public void setPresenti(String presenti) {
        this.presenti = presenti;
        if (presenti != null && !presenti.equals("")) {
            try {
                presenti_list = Arrays.asList(new ObjectMapper().readValue(presenti, Presenti[].class));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof DocumentiPrg)) {
            return false;
        }
        DocumentiPrg other = (DocumentiPrg) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "DocumentiPrg{" + "id=" + id + ", path=" + path + ", scadenza=" + scadenza + ", deleted=" + deleted + ",\n tipo=" + tipo + ",\n docente=" + docente + ",\n progetto=" + progetto + '}';
    }

}
