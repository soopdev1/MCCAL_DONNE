/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.entity;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

/**
 *
 * @author rcosco
 */
public class FadCalendar {

    String idprogetti_formativi, numerocorso, data,orainizio, orafine;

    public FadCalendar() {
    }

    public FadCalendar(String idprogetti_formativi, String numerocorso, String data, String orainizio, String orafine) {
        this.idprogetti_formativi = idprogetti_formativi;
        this.numerocorso = numerocorso;
        this.data = data;
        this.orainizio = orainizio;
        this.orafine = orafine;
    }

    public String getIdprogetti_formativi() {
        return idprogetti_formativi;
    }

    public void setIdprogetti_formativi(String idprogetti_formativi) {
        this.idprogetti_formativi = idprogetti_formativi;
    }

    public String getNumerocorso() {
        return numerocorso;
    }

    public void setNumerocorso(String numerocorso) {
        this.numerocorso = numerocorso;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getOrainizio() {
        return orainizio;
    }

    public void setOrainizio(String orainizio) {
        this.orainizio = orainizio;
    }

    public String getOrafine() {
        return orafine;
    }

    public void setOrafine(String orafine) {
        this.orafine = orafine;
    }
    
    
     @Override
    public String toString() {
        return ReflectionToStringBuilder.toString(this);
    }
    

}
