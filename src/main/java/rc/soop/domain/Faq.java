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
import javax.persistence.Lob;
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
@Table(name = "faq")
@NamedQueries(value = {
    @NamedQuery(name = "faq.BySoggetto", query = "SELECT f FROM Faq f WHERE f.soggetto=:soggetto"),
    @NamedQuery(name = "faq.LastBySoggetto", query = "SELECT f FROM Faq f WHERE f.soggetto=:soggetto ORDER BY f.id DESC"),
    @NamedQuery(name = "faq.SA", query = "SELECT f FROM Faq f WHERE f.tipo.id=2 OR f.tipo.id=3"),
    @NamedQuery(name = "faq.Public", query = "SELECT f FROM Faq f WHERE f.tipo.id=3"),
    @NamedQuery(name = "faq.NoAnswer", query = "select f from Faq f where f.id in (SELECT max(f.id) FROM Faq f group by f.soggetto)"),
    @NamedQuery(name = "faq.Answer", query = "select f from Faq f WHERE f.risposta IS NOT NULL ORDER BY f.timestamp DESC"),
    @NamedQuery(name = "faq.count", query = "select count(f.id) from Faq f where f.id in (SELECT max(f.id) FROM Faq f group by f.soggetto) and f.risposta is null"),
})
public class Faq implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "idfaq")
    private Long id;
    @Column(name = "domanda")
    @Lob
    private String domanda;
    @Column(name = "domanda_mod")
    @Lob
    private String domanda_mod;
    @Column(name = "risposta")
    @Lob
    private String risposta;
    @Temporal(TemporalType.DATE)
    @Column(name = "date_ask")
    private Date date_ask;
    @Temporal(TemporalType.DATE)
    @Column(name = "date_answer")
    private Date date_answer;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP", name = "timestamp")
    private Date timestamp;
    
    @ManyToOne
    @JoinColumn(name = "tipo")
    private TipoFaq tipo;
    
    @ManyToOne
    @JoinColumn(name = "idsoggetto")
    private SoggettiAttuatori soggetto;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getDomanda() {
        return domanda;
    }

    public void setDomanda(String domanda) {
        this.domanda = domanda;
    }

    public String getDomanda_mod() {
        return domanda_mod;
    }

    public void setDomanda_mod(String domanda_mod) {
        this.domanda_mod = domanda_mod;
    }

    public String getRisposta() {
        return risposta;
    }

    public void setRisposta(String risposta) {
        this.risposta = risposta;
    }

    public Date getDate_ask() {
        return date_ask;
    }

    public void setDate_ask(Date date_ask) {
        this.date_ask = date_ask;
    }

    public Date getDate_answer() {
        return date_answer;
    }

    public void setDate_answer(Date date_answer) {
        this.date_answer = date_answer;
    }

    public SoggettiAttuatori getSoggetto() {
        return soggetto;
    }

    public void setSoggetto(SoggettiAttuatori soggetto) {
        this.soggetto = soggetto;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public TipoFaq getTipo() {
        return tipo;
    }

    public void setTipo(TipoFaq tipo) {
        this.tipo = tipo;
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
        if (!(object instanceof Faq)) {
            return false;
        }
        Faq other = (Faq) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "rc.soop.domain.Faq[ id=" + id + " ]";
    }

}
