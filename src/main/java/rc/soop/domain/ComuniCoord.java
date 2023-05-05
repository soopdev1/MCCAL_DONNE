/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.domain;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import java.io.Serializable;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

/*
 * @author rcosco
 */
@Entity
@Table(name = "comuni_coord")
@JsonIgnoreProperties(value = {"id"})
public class ComuniCoord implements Serializable {

    @Id
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "idcomune", referencedColumnName = "idcomune")
    private Comuni id;
    @Column(name = "nome")
    private String nome;
    @Column(name = "longitudine")
    private double longitudine;
    @Column(name = "latitudine")
    private double latitudine;

    public Comuni getId() {
        return id;
    }

    public void setId(Comuni id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public double getLongitudine() {
        return longitudine;
    }

    public void setLongitudine(double longitudine) {
        this.longitudine = longitudine;
    }

    public double getLatitudine() {
        return latitudine;
    }

    public void setLatitudine(double latitudine) {
        this.latitudine = latitudine;
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
        if (!(object instanceof ComuniCoord)) {
            return false;
        }
        ComuniCoord other = (ComuniCoord) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "CominiCoord{" + "id=" + id + ", nome=" + nome + ", longitudine=" + longitudine + ", latitudine=" + latitudine + '}';
    }

    

}
