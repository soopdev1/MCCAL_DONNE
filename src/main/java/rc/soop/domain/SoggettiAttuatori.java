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
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author rcosco
 */
@Entity
@Table(name = "soggetti_attuatori")
@NamedQueries(value = {
    @NamedQuery(name = "sa.byPiva", query = "SELECT sa FROM SoggettiAttuatori sa WHERE sa.piva=:piva"),
    @NamedQuery(name = "sa.byEmail", query = "SELECT sa FROM SoggettiAttuatori sa WHERE sa.email=:email"),
    @NamedQuery(name = "sa.byCF", query = "SELECT sa FROM SoggettiAttuatori sa WHERE sa.codicefiscale=:codicefiscale"),
    @NamedQuery(name = "sa.listaSA", query = "SELECT sa FROM SoggettiAttuatori sa"),
})
@JsonIgnoreProperties(value = {"allievi", "progettiformativi"})
public class SoggettiAttuatori implements Serializable {

    @Id
    @Column(name = "idsoggetti_attuatori")
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "timestamp", columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP", insertable = false)
    private Date timestamp;
    @Column(name = "ragionesociale")
    private String ragionesociale;
    @Column(name = "piva")
    private String piva;
    @Column(name = "telefono_sa")
    private String telefono_sa;
    @Column(name = "cell_sa")
    private String cell_sa;
    @Column(name = "pec")
    private String pec;
    @Column(name = "email")
    private String email;
    @Column(name = "nome")
    private String nome;
    @Column(name = "cognome")
    private String cognome;
    @Column(name = "nome_refente")
    private String nome_refente;
    @Column(name = "cognome_referente")
    private String cognome_referente;
    @Column(name = "telefono_referente")
    private String telefono_referente;
    @Column(name = "indirizzo")
    private String indirizzo;
    @Column(name = "cap")
    private String cap;
    @Column(name = "datanascita")
    @Temporal(TemporalType.DATE)
    private Date datanascita;
    @Column(name = "dataprotocollo")
    @Temporal(TemporalType.DATE)
    private Date dataprotocollo;
    @Column(name = "telefono_ad")
    private String telefono_Ad;
    @Column(name = "nro_documento")
    private String nro_documento;
    @Column(name = "cartaid")
    private String cartaid;
    @Column(name = "protocollo")
    private String protocollo;
    @Column(name = "scadenza")
    @Temporal(TemporalType.DATE)
    private Date scadenza;
    @Column(name = "codicefiscale")
    private String codicefiscale;

    @ManyToOne
    @JoinColumn(name = "comune")
    private Comuni comune;

    @OneToMany(mappedBy = "soggetto", fetch = FetchType.LAZY)
    List<ProgettiFormativi> progettiformativi;

    @OneToMany(mappedBy = "soggetto", fetch = FetchType.LAZY)
    List<Allievi> allievi;

    public SoggettiAttuatori() {
    }

    public String getIndirizzo() {
        return indirizzo;
    }

    public void setIndirizzo(String indirizzo) {
        this.indirizzo = indirizzo;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Comuni getComune() {
        return comune;
    }

    public void setComune(Comuni comune) {
        this.comune = comune;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public String getRagionesociale() {
        return ragionesociale;
    }

    public void setRagionesociale(String ragionesociale) {
        this.ragionesociale = ragionesociale;
    }

    public String getPiva() {
        return piva;
    }

    public void setPiva(String piva) {
        this.piva = piva;
    }

    public String getTelefono_sa() {
        return telefono_sa;
    }

    public void setTelefono_sa(String telefono_sa) {
        this.telefono_sa = telefono_sa;
    }

    public String getCell_sa() {
        return cell_sa;
    }

    public void setCell_sa(String cell_sa) {
        this.cell_sa = cell_sa;
    }

    public String getPec() {
        return pec;
    }

    public void setPec(String pec) {
        this.pec = pec;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
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

    public Date getDatanascita() {
        return datanascita;
    }

    public void setDatanascita(Date datanascita) {
        this.datanascita = datanascita;
    }

    public Date getScadenza() {
        return scadenza;
    }

    public void setScadenza(Date scadenza) {
        this.scadenza = scadenza;
    }

    public String getTelefono_Ad() {
        return telefono_Ad;
    }

    public void setTelefono_Ad(String telefono_Ad) {
        this.telefono_Ad = telefono_Ad;
    }

    public String getNro_documento() {
        return nro_documento;
    }

    public void setNro_documento(String nro_documento) {
        this.nro_documento = nro_documento;
    }

    public String getNome_refente() {
        return nome_refente;
    }

    public void setNome_refente(String nome_refente) {
        this.nome_refente = nome_refente;
    }

    public String getCognome_referente() {
        return cognome_referente;
    }

    public void setCognome_referente(String cognome_referente) {
        this.cognome_referente = cognome_referente;
    }

    public String getTelefono_referente() {
        return telefono_referente;
    }

    public void setTelefono_referente(String telefono_referente) {
        this.telefono_referente = telefono_referente;
    }

    public String getCartaid() {
        return cartaid;
    }

    public void setCartaid(String cartaid) {
        this.cartaid = cartaid;
    }

    public String getProtocollo() {
        return protocollo;
    }

    public void setProtocollo(String protocollo) {
        this.protocollo = protocollo;
    }

    public String getCap() {
        return cap;
    }

    public void setCap(String cap) {
        this.cap = cap;
    }

    public List<ProgettiFormativi> getProgettiformativi() {
        List<ProgettiFormativi> pf = new ArrayList();
        pf.addAll(this.progettiformativi);
        return pf;
    }

    public void setProgettiformativi(List<ProgettiFormativi> progettiformativi) {
        this.progettiformativi = progettiformativi;
    }

    public Date getDataprotocollo() {
        return dataprotocollo;
    }

    public void setDataprotocollo(Date dataprotocollo) {
        this.dataprotocollo = dataprotocollo;
    }

    public List<Allievi> getAllievi() {
        List<Allievi> a = new ArrayList();//per fixare il bub dello stream  per le lazy list di EclipseLink
        a.addAll(this.allievi);
        return a;
    }

    public void setAllievi(List<Allievi> allievi) {
        this.allievi = allievi;
    }

    public String getCodicefiscale() {
        return codicefiscale;
    }

    public void setCodicefiscale(String codicefiscale) {
        this.codicefiscale = codicefiscale;
    }
    

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 59 * hash + Objects.hashCode(this.id);
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
        final SoggettiAttuatori other = (SoggettiAttuatori) obj;
        if (!Objects.equals(this.id, other.id)) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "SoggettiAttuatori{" + "id=" + id + ", timestamp=" + timestamp + ", ragionesociale=" + ragionesociale + ", piva=" + piva + ", telefono_sa=" + telefono_sa + ", cell_sa=" + cell_sa + ", pec=" + pec + ", email=" + email + ", nome=" + nome + ", cognome=" + cognome + ", nome_refente=" + nome_refente + ", cognome_referente=" + cognome_referente + ", telefono_referente=" + telefono_referente + ", indirizzo=" + indirizzo + ", cap=" + cap + ", datanascita=" + datanascita + ", dataprotocollo=" + dataprotocollo + ", telefono_Ad=" + telefono_Ad + ", nro_documento=" + nro_documento + ", cartaid=" + cartaid + ", protocollo=" + protocollo + ", scadenza=" + scadenza + ", codicefiscale=" + codicefiscale + ", comune=" + comune + ", progettiformativi=" + progettiformativi + ", allievi=" + allievi + '}';
    }

}
