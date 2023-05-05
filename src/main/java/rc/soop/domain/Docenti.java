/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.domain;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

/**
 *
 * @author rcosco
 */
@Entity
@Table(name = "docenti")
@NamedQueries(value = {
    @NamedQuery(name = "d.Active", query = "SELECT d FROM Docenti d WHERE d.stato='A'"),
    @NamedQuery(name = "d.byProgetto", query = "SELECT d FROM Docenti d WHERE d.progetti=:progetto AND d.stato='A'"),
    @NamedQuery(name = "d.byCf", query = "SELECT d FROM Docenti d WHERE d.codicefiscale=:cf AND d.stato='A'"),})
@JsonIgnoreProperties(value = {"progetti", "registri_aula", "registri_allievi"})
public class Docenti implements Serializable {

    @Id
    @Column(name = "iddocenti")
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    @Column(name = "nome")
    private String nome;
    @Column(name = "cognome")
    private String cognome;
    @Column(name = "codicefiscale")
    private String codicefiscale;
    @Column(name = "datanascita")
    @Temporal(TemporalType.DATE)
    private Date datanascita;
    @Column(name = "curriculum")
    private String curriculum;
    @Column(name = "docId")
    private String docId;
    @Column(name = "stato")
    private String stato = "A";
    @Column(name = "scadenza_doc")
    @Temporal(TemporalType.DATE)
    private Date scadenza_doc;
    @Column(name = "email")
    private String email;

    @ManyToOne
    @JoinColumn(name = "fascia")
    private FasceDocenti fascia;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "progetti_docenti",
            joinColumns = @JoinColumn(name = "iddocenti"),
            inverseJoinColumns = @JoinColumn(name = "idprogetti_formativi"))
    List<ProgettiFormativi> progetti;

    @OneToMany(mappedBy = "docente", fetch = FetchType.LAZY)
    List<DocumentiPrg> registri_aula;
    @OneToMany(mappedBy = "docente", fetch = FetchType.LAZY)
    List<Documenti_Allievi> registri_allievi;
    
    
    @Transient
    boolean assegnato;
    
    public Docenti(String nome, String cognome, String codicefiscale, Date datanascita) {
        this.nome = nome;
        this.cognome = cognome;
        this.codicefiscale = codicefiscale;
        this.datanascita = datanascita;
    }
    public Docenti(String nome, String cognome, String codicefiscale, Date datanascita, String email) {
        this.nome = nome;
        this.cognome = cognome;
        this.codicefiscale = codicefiscale;
        this.datanascita = datanascita;
        this.email = email;
    }

    public Docenti(Long id, String nome, String cognome, String codicefiscale, Date datanascita, String curriculum, String docId, String stato, List<ProgettiFormativi> progetti) {
        this.id = id;
        this.nome = nome;
        this.cognome = cognome;
        this.codicefiscale = codicefiscale;
        this.datanascita = datanascita;
        this.curriculum = curriculum;
        this.docId = docId;
        this.stato = stato;
        this.progetti = progetti;
    }

    public Docenti() {
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

    public boolean isAssegnato() {
        return assegnato;
    }

    public void setAssegnato(boolean assegnato) {
        this.assegnato = assegnato;
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

    public String getCodicefiscale() {
        return codicefiscale;
    }

    public void setCodicefiscale(String codicefiscale) {
        this.codicefiscale = codicefiscale;
    }

    public Date getDatanascita() {
        return datanascita;
    }

    public void setDatanascita(Date datanascita) {
        this.datanascita = datanascita;
    }

    public String getCurriculum() {
        return curriculum;
    }

    public void setCurriculum(String curriculum) {
        this.curriculum = curriculum;
    }

    public String getDocId() {
        return docId;
    }

    public void setDocId(String docId) {
        this.docId = docId;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

    public Date getScadenza_doc() {
        return scadenza_doc;
    }

    public void setScadenza_doc(Date scadenza_doc) {
        this.scadenza_doc = scadenza_doc;
    }

    public List<ProgettiFormativi> getProgetti() {
        List<ProgettiFormativi> progetti_list = new ArrayList<>();
        progetti_list.addAll(progetti);
        return progetti_list;
    }

    public void setProgetti(List<ProgettiFormativi> progetti) {
        this.progetti = progetti;
    }

    public List<DocumentiPrg> getRegistri_aula() {
        return registri_aula;
    }

    public void setRegistri_aula(List<DocumentiPrg> registri_aula) {
        this.registri_aula = registri_aula;
    }

    public List<Documenti_Allievi> getRegistri_allievi() {
        return registri_allievi;
    }

    public void setRegistri_allievi(List<Documenti_Allievi> registri_allievi) {
        this.registri_allievi = registri_allievi;
    }

    public FasceDocenti getFascia() {
        return fascia;
    }

    public void setFascia(FasceDocenti fascia) {
        this.fascia = fascia;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 37 * hash + Objects.hashCode(this.id);
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
        final Docenti other = (Docenti) obj;
        if (!Objects.equals(this.id, other.id)) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Docenti{" + "id=" + id + ", nome=" + nome + ", cognome=" + cognome + ", codicefiscale=" + codicefiscale + ", datanascita=" + datanascita + ", curriculum=" + curriculum + ", docId=" + docId + ", stato=" + stato + ", scadenza_doc=" + scadenza_doc + ", progetti=" + progetti + '}';
    }

}
