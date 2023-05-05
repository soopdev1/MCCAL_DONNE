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
@Table(name = "storico_prg")
@NamedQueries(value = {
    @NamedQuery(name = "storico.byPrg", query = "SELECT s FROM Storico_Prg s WHERE s.progetto=:progetto")})
public class Storico_Prg implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "idstorico_prg")
    private Long id;
    @Column(name = "motivo")
    private String motivo;
    @Column(name = "data")
    @Temporal(TemporalType.DATE)
    private Date data;

    @JoinColumn(name = "idprogetto")
    ProgettiFormativi progetto;
    @ManyToOne
    @JoinColumn(name = "stato")
    StatiPrg stato;

    public Storico_Prg() {
    }

    public Storico_Prg(String motivo, Date data, ProgettiFormativi progetto, StatiPrg stato) {
        this.motivo = motivo;
        this.data = data;
        this.progetto = progetto;
        this.stato = stato;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public Date getData() {
        return data;
    }

    public void setData(Date data) {
        this.data = data;
    }

    public ProgettiFormativi getProgetto() {
        return progetto;
    }

    public void setProgetto(ProgettiFormativi progetto) {
        this.progetto = progetto;
    }

    public StatiPrg getStato() {
        return stato;
    }

    public void setStato(StatiPrg stato) {
        this.stato = stato;
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
        if (!(object instanceof Storico_Prg)) {
            return false;
        }
        Storico_Prg other = (Storico_Prg) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Storico_Prg{" + "id=" + id + ", motivo=" + motivo + ", data=" + data + ", progetto=" + progetto + ", stato=" + stato + '}';
    }

}
