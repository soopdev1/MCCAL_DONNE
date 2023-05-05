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
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 *
 * @author rcosco
 */
@Entity
@Table(name = "tipo_documenti_allievi_pregresso")
public class TipoDoc_Allievi_Pregresso implements Serializable {

    @Id
    @Column(name = "idtipodocumenti_allievi_pregresso")
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    @Column(name = "descrizione")
    private String descrizione;
    @ManyToOne
    @JoinColumn(name = "estensione")
    EstensioniFile estensione;

    public TipoDoc_Allievi_Pregresso() {
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

    public EstensioniFile getEstensione() {
        return estensione;
    }

    public void setEstensione(EstensioniFile estensione) {
        this.estensione = estensione;
    }

    @Override
    public int hashCode() {
        int hash = 5;
        hash = 97 * hash + Objects.hashCode(this.id);
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
        final TipoDoc_Allievi_Pregresso other = (TipoDoc_Allievi_Pregresso) obj;
        if (!Objects.equals(this.id, other.id)) {
            return false;
        }
        return true;
    }

    

}
