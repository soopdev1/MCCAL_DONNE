/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.domain;

import java.io.Serializable;
import java.util.Objects;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 *
 * @author rcosco
 */
@Entity
@Table(name = "titoli_studio")
@NamedQueries(value = {
    @NamedQuery(name = "titoli_studio.Elenco", query = "select ts from TitoliStudio ts ORDER BY ts.codice")
})
public class TitoliStudio implements Serializable {

    @Id
    @Column(name = "codice")
    private String codice;
    @Column(name = "descrizione")
    private String descrizione;
    @Column(name = "isced")
    private String isced;

    public TitoliStudio() {
    }

    public String getCodice() {
        return codice;
    }

    public void setCodice(String codice) {
        this.codice = codice;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public String getIsced() {
        return isced;
    }

    public void setIsced(String isced) {
        this.isced = isced;
    }

    @Override
    public int hashCode() {
        int hash = 5;
        hash = 89 * hash + Objects.hashCode(this.codice);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final TitoliStudio other = (TitoliStudio) obj;
        if (!Objects.equals(this.codice, other.codice)) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "TitoliStudio{" + "codice=" + codice + ", descrizione=" + descrizione + ", isced=" + isced + '}';
    }

}
