/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author rcosco
 */
@Entity
@Table(name = "cad")
public class Cad implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "idcad")
    private Long id;
    @Column(name = "nome")
    private String nome;
    @Column(name = "cognome")
    private String cognome;
    @Column(name = "email")
    private String email;
    @Column(name = "numero")
    private String numero;
    @Column(name = "giorno")
    @Temporal(TemporalType.DATE)
    private Date giorno;
    @Temporal(TemporalType.TIME)
    @Column(name = "orariostart")
    private Date orariostart;
    @Temporal(TemporalType.TIME)
    @Column(name = "orarioend")
    private Date orarioend;
    @Column(name = "password")
    private String password;
    @Column(name = "stato", columnDefinition = "INT(1) DEFAULT 0")//0 aperta | 1 chiusa | 2 eliminata
    private int stato;//stato 0 Aperto 1 Chiusa 2 Eliminata

    @ManyToOne
    @JoinColumn(name = "iduser")
    User user;

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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public Date getGiorno() {
        return giorno;
    }

    public void setGiorno(Date giorno) {
        this.giorno = giorno;
    }

    public Date getOrariostart() {
        return orariostart;
    }

    public void setOrariostart(Date orariostart) {
        this.orariostart = orariostart;
    }

    public Date getOrarioend() {
        return orarioend;
    }

    public void setOrarioend(Date orarioend) {
        this.orarioend = orarioend;
    }

    public int getStato() {
        return stato;
    }

    public void setStato(int stato) {
        this.stato = stato;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
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
        if (!(object instanceof Cad)) {
            return false;
        }
        Cad other = (Cad) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Cad{" + "id=" + id + ", nome=" + nome + ", cognome=" + cognome + ", email=" + email + ", numero=" + numero + ", giorno=" + giorno + ", orariostart=" + orariostart + ", orarioend=" + orarioend + ", password=" + password + ", stato=" + stato + ", user=" + user + '}';
    }

}
