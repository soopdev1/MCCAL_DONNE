/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.domain;

import java.io.Serializable;
import java.util.Date;
import java.util.Objects;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author rcosco
 */
@NamedQueries(value = {
    @NamedQuery(name = "storicomodifiche.bySA", query = "SELECT m FROM Storico_ModificheInfo m WHERE m.soggetto=:soggetto ORDER BY m.data DESC")})

@Entity
@Table(name = "storico_modificheinfo")
public class Storico_ModificheInfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "idstorico_mod")
    private Long id;
    @Column(name = "path")
    private String path;
    @Column(name = "operazione")
    private String operazione;
    @Column(name = "data")
    @Temporal(TemporalType.DATE)
    private Date data;

    @JoinColumn(name = "idsoggetto_attuatore")
    SoggettiAttuatori soggetto;

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

    public String getOperazione() {
        return operazione;
    }

    public void setOperazione(String operazione) {
        this.operazione = operazione;
    }

    public Date getData() {
        return data;
    }

    public void setData(Date data) {
        this.data = data;
    }

    public SoggettiAttuatori getSoggetto() {
        return soggetto;
    }

    public void setSoggetto(SoggettiAttuatori soggetto) {
        this.soggetto = soggetto;
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
        if (!(object instanceof Storico_ModificheInfo)) {
            return false;
        }
        Storico_ModificheInfo other = (Storico_ModificheInfo) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Storico_ModificheInfo{" + "id=" + id + ", path=" + path + ", operazione=" + operazione + ", data=" + data + ", soggetto=" + soggetto + '}';
    }

}
