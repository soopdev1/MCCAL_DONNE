/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.util;

/**
 *
 * @author rcosco
 */
public class Fadroom {

    String nomestanza, idpr, numerocorso, stato;

    public Fadroom() {
    }

    public Fadroom(String nomestanza, String idpr, String numerocorso, String stato) {
        this.nomestanza = nomestanza;
        this.idpr = idpr;
        this.numerocorso = numerocorso;
        this.stato = stato;
    }

    public String getNomestanza() {
        return nomestanza;
    }

    public void setNomestanza(String nomestanza) {
        this.nomestanza = nomestanza;
    }

    public String getIdpr() {
        return idpr;
    }

    public void setIdpr(String idpr) {
        this.idpr = idpr;
    }

    public String getNumerocorso() {
        return numerocorso;
    }

    public void setNumerocorso(String numerocorso) {
        this.numerocorso = numerocorso;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

}
