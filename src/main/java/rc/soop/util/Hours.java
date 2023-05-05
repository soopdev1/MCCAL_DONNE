/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.util;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
import org.apache.poi.xssf.usermodel.XSSFColor;

/**
 *
 * @author rcosco
 */
public class Hours {

    String giorno, nome, cognome, cf, logindate, logoutdate;
    String millisecondtime;
    String docente;
    XSSFColor color;

    public Hours(String giorno, String nome, String cognome, String cf, String logindate, String logoutdate, String millisecondtime, XSSFColor color) {
        this.giorno = giorno;
        this.nome = nome;
        this.cognome = cognome;
        this.cf = cf;
        this.logindate = logindate;
        this.logoutdate = logoutdate;
        this.millisecondtime = millisecondtime;
        this.color = color;
        this.docente = "";
    }

    public String getDocente() {
        return docente;
    }

    public void setDocente(String docente) {
        this.docente = docente;
    }

    public XSSFColor getColor() {
        return color;
    }

    public void setColor(XSSFColor color) {
        this.color = color;
    }

    public String getGiorno() {
        return giorno;
    }

    public void setGiorno(String giorno) {
        this.giorno = giorno;
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

    public String getCf() {
        return cf;
    }

    public void setCf(String cf) {
        this.cf = cf;
    }

    public String getLogindate() {
        return logindate;
    }

    public void setLogindate(String logindate) {
        this.logindate = logindate;
    }

    public String getLogoutdate() {
        return logoutdate;
    }

    public void setLogoutdate(String logoutdate) {
        this.logoutdate = logoutdate;
    }

    public String getMillisecondtime() {
        return millisecondtime;
    }

    public void setMillisecondtime(String millisecondtime) {
        this.millisecondtime = millisecondtime;
    }

    @Override
    public String toString() {
        return ReflectionToStringBuilder.toString(this);
    }
}
