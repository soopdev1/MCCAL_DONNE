/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.domain;

import java.io.Serializable;
import java.util.Date;
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

/**
 *
 * @author rcosco
 */
@Entity
@Table(name = "documenti_allievi")
@NamedQueries(value = {
    @NamedQuery(name = "da.byAllievo", query = "SELECT da FROM Documenti_Allievi da WHERE da.allievo=:allievo AND da.deleted=0"),
    @NamedQuery(name = "da.registriByAllievi", query = "SELECT da FROM Documenti_Allievi da WHERE da.deleted=0 AND da.allievo IN :allievi AND da.giorno IS NOT NULL"),
    @NamedQuery(name = "da.registriByAllievoAndDay", query = "SELECT da FROM Documenti_Allievi da WHERE da.deleted=0 AND da.allievo=:allievo and da.giorno=:giorno"),
})
public class Documenti_Allievi implements Serializable {

    @Id
    @Column(name = "iddocumenti_allievi")
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    @Column(name = "path")
    private String path;
    @ManyToOne
    @JoinColumn(name = "tipo")
    TipoDoc_Allievi tipo;
    @Column(name = "scadenza")
    @Temporal(TemporalType.DATE)
    private Date scadenza;
    @ManyToOne
    @JoinColumn(name = "idallievo")
    Allievi allievo;
    @Column(name = "deleted", columnDefinition = "INT(1) DEFAULT 0")
    private int deleted;
    @Column(name = "giorno")
    @Temporal(TemporalType.DATE)
    private Date giorno;
    @Temporal(TemporalType.TIME)
    @Column(name = "orariostart_mattina")
    private Date orariostart_mattina;
    @Temporal(TemporalType.TIME)
    @Column(name = "orariostart_pom")
    private Date orariostart_pom;
    @Temporal(TemporalType.TIME)
    @Column(name = "orarioend_mattina")
    private Date orarioend_mattina;
    @Temporal(TemporalType.TIME)
    @Column(name = "orarioend_pom")
    private Date orarioend_pom;
    @Column(name = "orericonosciute")
    private Double orericonosciute;
    @ManyToOne
    @JoinColumn(name = "iddocente")
    Docenti docente;

    public Documenti_Allievi() {
    }

    public Documenti_Allievi(String path, TipoDoc_Allievi tipo, Date scadenza, Allievi allievo) {
        this.path = path;
        this.tipo = tipo;
        this.scadenza = scadenza;
        this.allievo = allievo;
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

    public TipoDoc_Allievi getTipo() {
        return tipo;
    }

    public void setTipo(TipoDoc_Allievi tipo) {
        this.tipo = tipo;
    }

    public Date getScadenza() {
        return scadenza;
    }

    public void setScadenza(Date scadenza) {
        this.scadenza = scadenza;
    }

    public Allievi getAllievo() {
        return allievo;
    }

    public void setAllievo(Allievi allievo) {
        this.allievo = allievo;
    }

    public int getDeleted() {
        return deleted;
    }

    public void setDeleted(int deleted) {
        this.deleted = deleted;
    }

    public Date getGiorno() {
        return giorno;
    }

    public void setGiorno(Date giorno) {
        this.giorno = giorno;
    }

    public Date getOrariostart_mattina() {
        return orariostart_mattina;
    }

    public void setOrariostart_mattina(Date orariostart_mattina) {
        this.orariostart_mattina = orariostart_mattina;
    }

    public Date getOrariostart_pom() {
        return orariostart_pom;
    }

    public void setOrariostart_pom(Date orariostart_pom) {
        this.orariostart_pom = orariostart_pom;
    }

    public Date getOrarioend_mattina() {
        return orarioend_mattina;
    }

    public void setOrarioend_mattina(Date orarioend_mattina) {
        this.orarioend_mattina = orarioend_mattina;
    }

    public Date getOrarioend_pom() {
        return orarioend_pom;
    }

    public void setOrarioend_pom(Date orarioend_pom) {
        this.orarioend_pom = orarioend_pom;
    }

    public Docenti getDocente() {
        return docente;
    }

    public void setDocente(Docenti docente) {
        this.docente = docente;
    }

    public Double getOrericonosciute() {
        return orericonosciute;
    }

    public void setOrericonosciute(Double orericonosciute) {
        this.orericonosciute = orericonosciute;
    }
    
    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Documenti_Allievi)) {
            return false;
        }
        Documenti_Allievi other = (Documenti_Allievi) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Documenti_Allievi{" + "id=" + id + ", path=" + path + ", tipo=" + tipo + ", scadenza=" + scadenza + ", allievo=" + allievo + ", deleted=" + deleted + ", giorno=" + giorno + ", orariostart_mattina=" + orariostart_mattina + ", orariostart_pom=" + orariostart_pom + ", orarioend_mattina=" + orarioend_mattina + ", orarioend_pom=" + orarioend_pom + ", orericonosciute=" + orericonosciute + ", docente=" + docente + '}';
    }

}
