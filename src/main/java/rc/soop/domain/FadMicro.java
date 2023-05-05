/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.domain;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

/**
 *
 * @author rcosco
 */
@Entity
@Table(name = "fad_micro")
public class FadMicro implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "idfad")
    private Long id;
    @Column(name = "nomestanza")
    private String nomestanza;
    @Column(name = "password")
    private String password;
    @Column(name = "partecipanti")
    @Lob
    private String partecipanti;
    @Temporal(TemporalType.TIMESTAMP)
    @Column(columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP", name = "datacreazione")
    private Date datacreazione;
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "inizio")
    private Date inizio;
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "fine")
    private Date fine;
    @Column(name = "stato", columnDefinition = "INT(1) DEFAULT 0")
    private int stato;

    @ManyToOne
    @JoinColumn(name = "iduser")
    private User user;

    @Transient
    private List<String> list_partecipanti = new ArrayList<>();

    @Lob
    @Column(name = "note", length = 512)
    private String note;

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
    
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNomestanza() {
        return nomestanza;
    }

    public void setNomestanza(String nomestanza) {
        this.nomestanza = nomestanza;
    }

    public Date getDatacreazione() {
        return datacreazione;
    }

    public void setDatacreazione(Date datacreazione) {
        this.datacreazione = datacreazione;
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

    public String getPartecipanti() {
        return partecipanti;
    }

    public void setPartecipanti(String partecipanti) {
        this.partecipanti = partecipanti;
        if (this.partecipanti != null && !this.partecipanti.equals("") && this.list_partecipanti.isEmpty()) {
            try {
                this.list_partecipanti = Arrays.asList(new ObjectMapper().readValue(this.partecipanti, String[].class));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public List<String> getList_partecipanti() {
        if (this.partecipanti != null && !this.partecipanti.equals("") && this.list_partecipanti.isEmpty()) {
            try {
                this.list_partecipanti = Arrays.asList(new ObjectMapper().readValue(this.partecipanti, String[].class));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return list_partecipanti;
    }

    public void setList_partecipanti(List<String> list_partecipanti) {
        this.list_partecipanti = list_partecipanti;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Date getInizio() {
        return inizio;
    }

    public void setInizio(Date inizio) {
        this.inizio = inizio;
    }

    public Date getFine() {
        return fine;
    }

    public void setFine(Date fine) {
        this.fine = fine;
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
        if (!(object instanceof FadMicro)) {
            return false;
        }
        FadMicro other = (FadMicro) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "rc.soop.domain.FadMicro[ id=" + id + " ]";
    }

}
