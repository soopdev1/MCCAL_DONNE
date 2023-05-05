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
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 *
 * @author rcosco
 */
@Entity
@Table(name = "tipo_documenti")
@NamedQueries(value = {
    @NamedQuery(name = "t.byStato", query = "SELECT t FROM TipoDoc t WHERE t.stato=:stato AND t.attivo=1"),
    @NamedQuery(name = "t.byStatoObbligatori", query = "SELECT t FROM TipoDoc t WHERE t.stato=:stato AND t.obbligatorio=1"),})
public class TipoDoc implements Serializable {

    @Id
    @Column(name = "idtipo_documenti")
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    @Column(name = "descrizione")
    private String descrizione;
    @Column(name = "obbligatorio")
    private int obbligatorio;
    @Column(name = "attivo", columnDefinition = "INT(1)")
    private int attivo;
    @Column(name = "modifiche_stati")
    private String modifiche_stati;
    @Column(name = "modifiche_stati_micro")
    private String modifiche_stati_micro;
    @Column(name = "estrazione", columnDefinition = "INT(1)")
    private int estrazione;
    @Column(name = "visible_sa", columnDefinition = "INT(1)")
    private int visible_sa;
    @ManyToOne
    @JoinColumn(name = "stato")
    StatiPrg stato;
    @ManyToOne
    @JoinColumn(name = "estensione")
    EstensioniFile estensione;

    public TipoDoc() {
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

    public int getObbligatorio() {
        return obbligatorio;
    }

    public void setObbligatorio(int obbligatorio) {
        this.obbligatorio = obbligatorio;
    }

    public String getModifiche_stati() {
        return modifiche_stati;
    }

    public void setModifiche_stati(String modifiche_stati) {
        this.modifiche_stati = modifiche_stati;
    }

    public StatiPrg getStato() {
        return stato;
    }

    public void setStato(StatiPrg stato) {
        this.stato = stato;
    }

    public int getAttivo() {
        return attivo;
    }

    public void setAttivo(int attivo) {
        this.attivo = attivo;
    }

    public EstensioniFile getEstensione() {
        return estensione;
    }

    public void setEstensione(EstensioniFile estensione) {
        this.estensione = estensione;
    }

    public int getEstrazione() {
        return estrazione;
    }

    public void setEstrazione(int estrazione) {
        this.estrazione = estrazione;
    }

    public int getVisible_sa() {
        return visible_sa;
    }

    public void setVisible_sa(int visible_sa) {
        this.visible_sa = visible_sa;
    }

    public String getModifiche_stati_micro() {
        return modifiche_stati_micro;
    }

    public void setModifiche_stati_micro(String modifiche_stati_micro) {
        this.modifiche_stati_micro = modifiche_stati_micro;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof TipoDoc)) {
            return false;
        }
        TipoDoc other = (TipoDoc) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "TipoDoc{" + "id=" + id + ", descrizione=" + descrizione + ", obbligatorio=" + obbligatorio + ", stato=" + stato + '}';
    }

}
