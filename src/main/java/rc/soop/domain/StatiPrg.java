/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.domain;

import java.io.Serializable;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToOne;
import javax.persistence.Table;

/**
 *
 * @author rcosco
 */
@Entity
@Table(name = "stati_progetto")
@NamedQueries(value = {
    @NamedQuery(name = "statiPrg.Tipo", query = "SELECT sp FROM StatiPrg sp GROUP BY sp.tipo ORDER BY sp.ordine")
    ,
    @NamedQuery(name = "statiPrg.ByTipo", query = "SELECT sp FROM StatiPrg sp WHERE sp.tipo=:tipo")
    ,
    @NamedQuery(name = "statiPrg.ByDescrizione", query = "SELECT sp FROM StatiPrg sp WHERE sp.descrizione=:descrizione")
    ,
    @NamedQuery(name = "statiPrg.ByOrdinePocesso", query = "SELECT sp FROM StatiPrg sp WHERE sp.ordine_processo=:ordine")
})
public class StatiPrg implements Serializable {

    @Id
    @Column(name = "idstati_progetto")
    private String id;
    @Column(name = "descrizione")
    private String descrizione;
    @Column(name = "tipo")
    private String tipo;
    @Column(name = "de_tipo")
    private String de_tipo;
    @Column(name = "ordine")
    private int ordine;
    @Column(name = "controllare")
    private int controllare;
    @Column(name = "modificabile")
    private int modificabile;
    @Column(name = "modifica_doc")
    private int modifica_doc;
    @Column(name = "errore")
    private int errore;
    @Column(name = "ordine_processo")
    private int ordine_processo;

    @OneToOne(mappedBy = "id", cascade = CascadeType.ALL,
            fetch = FetchType.LAZY, optional = false)
    private ModificheStatoPrg modifiche;

    public StatiPrg() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public int getOrdine() {
        return ordine;
    }

    public void setOrdine(int ordine) {
        this.ordine = ordine;
    }

    public int getControllare() {
        return controllare;
    }

    public void setControllare(int controllare) {
        this.controllare = controllare;
    }

    public int getErrore() {
        return errore;
    }

    public void setErrore(int errore) {
        this.errore = errore;
    }

    public String getDe_tipo() {
        return de_tipo;
    }

    public void setDe_tipo(String de_tipo) {
        this.de_tipo = de_tipo;
    }

    public ModificheStatoPrg getModifiche() {
        return modifiche;
    }

    public void setModifiche(ModificheStatoPrg modifiche) {
        this.modifiche = modifiche;
    }

    public int getModificabile() {
        return modificabile;
    }

    public void setModificabile(int modificabile) {
        this.modificabile = modificabile;
    }

    public int getModifica_doc() {
        return modifica_doc;
    }

    public void setModifica_doc(int modifica_doc) {
        this.modifica_doc = modifica_doc;
    }

    public int getOrdine_processo() {
        return ordine_processo;
    }

    public void setOrdine_processo(int ordine_processo) {
        this.ordine_processo = ordine_processo;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof StatiPrg)) {
            return false;
        }
        StatiPrg other = (StatiPrg) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "StatiPrg{" + "id=" + id + ", descrizione=" + descrizione + '}';
    }

}
