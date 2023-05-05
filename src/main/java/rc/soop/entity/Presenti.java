/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.entity;

import java.util.Date;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 *
 * @author rcosco
 */
public class Presenti {

    Long id;
    String nome, cognome;
    Date start, end;
    double ore, ore_riconosciute = 0;

    String fase, data, cf, orestring;

    public Presenti(String fase, String data, String cf, String orestring, double ore, double ore_riconosciute) {
        this.ore = ore;
        this.ore_riconosciute = ore_riconosciute;
        this.fase = fase;
        this.data = data;
        this.cf = cf;
        this.orestring = orestring;
    }

    public String getFase() {
        return fase;
    }

    public void setFase(String fase) {
        this.fase = fase;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getCf() {
        return cf;
    }

    public void setCf(String cf) {
        this.cf = cf;
    }

    public String getOrestring() {
        return orestring;
    }

    public void setOrestring(String orestring) {
        this.orestring = orestring;
    }

    public Presenti(Long id, String nome, String cognome, Date start, Date end, double ore) {
        this.id = id;
        this.nome = nome;
        this.cognome = cognome;
        this.start = start;
        this.end = end;
        this.ore = ore;
    }

    public Presenti(Long id, String nome, String cognome, Date start, Date end, double ore, double ore_riconosciute) {
        this.id = id;
        this.nome = nome;
        this.cognome = cognome;
        this.start = start;
        this.end = end;
        this.ore = ore;
        this.ore_riconosciute = ore_riconosciute;
    }

    public Presenti() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCognome() {
        return cognome;
    }

    public void setCognome(String cognome) {
        this.cognome = cognome;
    }

    public Date getStart() {
        return start;
    }

    public void setStart(Date start) {
        this.start = start;
    }

    public Date getEnd() {
        return end;
    }

    public void setEnd(Date end) {
        this.end = end;
    }

    public double getOre() {
        return ore;
    }

    public void setOre(double ore) {
        this.ore = ore;
    }

    public double getOre_riconosciute() {
        return ore_riconosciute;
    }

    public void setOre_riconosciute(double ore_riconosciute) {
        this.ore_riconosciute = ore_riconosciute;
    }

    @Override
    public String toString() {
        return org.apache.commons.lang3.builder.ReflectionToStringBuilder.toString(this, ToStringStyle.JSON_STYLE);
    }

}
