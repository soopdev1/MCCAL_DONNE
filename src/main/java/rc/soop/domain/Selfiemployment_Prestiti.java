/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.domain;


import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
/**
 *
 * @author rcosco
 */
@Entity
@Table(name = "selfiemployment_prestiti")
@NamedQueries(value = {
    @NamedQuery(name = "se_p.Elenco", query = "select se_p from Selfiemployment_Prestiti se_p ORDER BY se_p.id")
})
public class Selfiemployment_Prestiti implements Serializable {

    @Column(name = "id")
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    @Column(name="descrizione")
    private String descrizione;
  
    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

   
    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public Selfiemployment_Prestiti() {
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Selfiemployment_Prestiti)) {
            return false;
        }
        Selfiemployment_Prestiti other = (Selfiemployment_Prestiti) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Selfiemployment_Prestiti{" + "id=" + id + ", descrizione=" + descrizione + '}';
    }

}
