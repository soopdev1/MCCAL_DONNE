/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.domain;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import java.io.Serializable;
import java.util.Objects;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

/**
 *
 * @author rcosco
 */
@Entity
@Table(name = "modifiche_stato_prg")
@JsonIgnoreProperties(value = {"id"})
public class ModificheStatoPrg implements Serializable {

    @Id
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "idstati_progetto", referencedColumnName = "idstati_progetto")
    private StatiPrg id;

    @Column(name = "descrizione")
    private int descrizione;
    @Column(name = "nome")
    private int nome;
    @Column(name = "ore")
    private int ore;
    @Column(name = "ore_svolte")
    private int ore_svolte;
    @Column(name = "date")
    private int date;
    @Column(name = "sede")
    private int sede;
    @Column(name = "allievi")
    private int allievi;
    @Column(name = "docenti")
    private int docenti;

    public ModificheStatoPrg() {
    }

    public StatiPrg getId() {
        return id;
    }

    public void setId(StatiPrg id) {
        this.id = id;
    }

    public int getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(int descrizione) {
        this.descrizione = descrizione;
    }

    public int getNome() {
        return nome;
    }

    public void setNome(int nome) {
        this.nome = nome;
    }

    public int getOre() {
        return ore;
    }

    public void setOre(int ore) {
        this.ore = ore;
    }

    public int getOre_svolte() {
        return ore_svolte;
    }

    public void setOre_svolte(int ore_svolte) {
        this.ore_svolte = ore_svolte;
    }

    public int getDate() {
        return date;
    }

    public void setDate(int date) {
        this.date = date;
    }

    public int getSede() {
        return sede;
    }

    public void setSede(int sede) {
        this.sede = sede;
    }

    public int getAllievi() {
        return allievi;
    }

    public void setAllievi(int allievi) {
        this.allievi = allievi;
    }

    public int getDocenti() {
        return docenti;
    }

    public void setDocenti(int docenti) {
        this.docenti = docenti;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 71 * hash + Objects.hashCode(this.id);
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
        final ModificheStatoPrg other = (ModificheStatoPrg) obj;
        if (!Objects.equals(this.id, other.id)) {
            return false;
        }
        return true;
    }

}
