/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.CascadeType;
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
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author rcosco
 */
@NamedQueries(value = {
    @NamedQuery(name = "user.UsernamePwd", query = "SELECT u FROM User u WHERE u.username=:username AND u.password=:password"),
    @NamedQuery(name = "user.byUsername", query = "SELECT u FROM User u WHERE u.username=:username"),
    @NamedQuery(name = "user.byUsernameToken", query = "SELECT u FROM User u WHERE u.username=:username AND u.token=:token"),
    @NamedQuery(name = "user.byEmail", query = "SELECT u FROM User u WHERE u.email=:email"),
    @NamedQuery(name = "user.bySA", query = "SELECT u FROM User u WHERE u.soggettoAttuatore=:sa"),
    @NamedQuery(name = "user.updateTipo", query = "UPDATE User u SET u.tipo=:tipo WHERE u.soggettoAttuatore=:soggettoattuatore")
})
@Entity
@Table(name = "user")
public class User implements Serializable {

    @Id
    @Column(name = "iduser")
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    @Column(name = "username")
    private String username;
    @Column(name = "password")
    private String password;
    @Column(name = "email")
    private String email;
    @Column(name = "stato")
    private int stato = 2;
    @Column(name = "tipo")
    private int tipo;
    @Column(name = "token")
    private String token;
    @Column(name = "token_timestamp")
    @Temporal(TemporalType.TIMESTAMP)
    private Date token_timestamp;
    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "idsoggetti_attuatori")
    private SoggettiAttuatori soggettoAttuatore;

    public User() {
    }

    public User(Long id, String username, String password, int stato, int tipo) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.stato = stato;
        this.tipo = tipo;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getStato() {
        return stato;
    }

    public void setStato(int stato) {
        this.stato = stato;
    }

    public int getTipo() {
        return tipo;
    }

    public void setTipo(int tipo) {
        this.tipo = tipo;
    }

    public SoggettiAttuatori getSoggettoAttuatore() {
        return soggettoAttuatore;
    }

    public void setSoggettoAttuatore(SoggettiAttuatori soggettoAttuatore) {
        this.soggettoAttuatore = soggettoAttuatore;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Date getToken_timestamp() {
        return token_timestamp;
    }

    public void setToken_timestamp(Date token_timestamp) {
        this.token_timestamp = token_timestamp;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof User)) {
            return false;
        }
        User other = (User) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "User{" + "id=" + id + ", username=" + username + ", password=" + password + ", email=" + email + ", stato=" + stato + ", tipo=" + tipo + ", token=" + token + ", token_timestamp=" + token_timestamp + ", soggettoAttuatore=" + soggettoAttuatore + '}';
    }

}
