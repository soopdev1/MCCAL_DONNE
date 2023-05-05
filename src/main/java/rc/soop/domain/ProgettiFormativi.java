/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.domain;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import rc.soop.util.Fadroom;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
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
@NamedQueries(value = {
    @NamedQuery(name = "progetti.ProgettiDocente", query = "SELECT p FROM ProgettiFormativi p WHERE p.docenti=:docente"),
    @NamedQuery(name = "progetti.ProgettiSAOrdered", query = "SELECT p FROM ProgettiFormativi p WHERE p.soggetto=:soggetto ORDER BY CASE WHEN p.stato.tipo = 'chiuso' THEN 0 WHEN p.stato.tipo = 'errore' THEN 1 WHEN p.stato.tipo = 'controllare' THEN 2 ELSE 3 END, p.stato.tipo"),
    @NamedQuery(name = "progetti.ProgettiSA_Fa", query = "SELECT p FROM ProgettiFormativi p WHERE p.soggetto=:soggetto AND p.stato.id='FA'"),
    @NamedQuery(name = "progetti.toExtaxt", query = "SELECT p FROM ProgettiFormativi p WHERE p.stato.id='AR' and p.extract=0"),
    @NamedQuery(name = "progetti.countConclusi", query = "SELECT count(p.id) as c FROM ProgettiFormativi p WHERE p.stato.ordine_processo >= 9"),})
@Entity
@Table(name = "progetti_formativi")
@JsonIgnoreProperties(value = {"docenti", "allievi", "documenti"})
public class ProgettiFormativi implements Serializable {

    @Id
    @Column(name = "idprogetti_formativi")
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    @Column(name = "data_up")
    @Temporal(TemporalType.DATE)
    private Date data_up;
    @Column(name = "start")
    @Temporal(TemporalType.DATE)
    private Date start;
    @Column(name = "end")
    @Temporal(TemporalType.DATE)
    private Date end;
    @Temporal(TemporalType.TIMESTAMP)
    @Column(columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP", name = "timestamp", insertable = false)
    private Date timestamp;
    @Column(name = "descrizione")
    private String descrizione;
    @ManyToOne
    @JoinColumn(name = "nome")
    private NomiProgetto nome;
    @Column(name = "cip")
    private String cip;
    @Column(name = "motivo")
    private String motivo;
    @Column(name = "ore")
    private double ore;
    @Column(name = "ore_svolte")
    private int ore_svolte;
    @Column(name = "controllable", columnDefinition = "INT(1) DEFAULT 0")
    private int controllable;
    @Column(name = "rendicontato", columnDefinition = "INT(1) DEFAULT 0")
    private int rendicontato;
    @Column(name = "batch_rendicontato", columnDefinition = "INT(1) DEFAULT 0")
    private int batch_rendicontato;
    @Column(name = "archiviabile", columnDefinition = "INT(1) DEFAULT 0")
    private int archiviabile;
    @Column(name = "extract", columnDefinition = "INT(1) DEFAULT 0")
    private int extract;
    @Temporal(TemporalType.DATE)
    @Column(name = "end_fa")
    private Date end_fa;
    @Temporal(TemporalType.DATE)
    @Column(name = "start_fb")
    private Date start_fb;
    @Temporal(TemporalType.DATE)
    @Column(name = "end_fb")
    private Date end_fb;
    @Column(name = "importo")
    private double importo;
    @Column(name = "importo_ente")
    private double importo_ente;
    @ManyToOne
    @JoinColumn(name = "stato")
    StatiPrg stato;

    @ManyToOne
    @JoinColumn(name = "idsoggetti_attuatori")
    SoggettiAttuatori soggetto;

    @ManyToOne
    @JoinColumn(name = "idsede")
    SediFormazione sede;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "progetti_docenti",
            joinColumns = @JoinColumn(name = "idprogetti_formativi"),
            inverseJoinColumns = @JoinColumn(name = "iddocenti"))
    List<Docenti> docenti;

    @OneToMany(mappedBy = "progetto", fetch = FetchType.LAZY)
    List<Allievi> allievi;

    @OneToMany(mappedBy = "progetto", fetch = FetchType.LAZY)
    List<DocumentiPrg> documenti;

    @Transient
    String fadlink;
    @Transient
    List<Fadroom> fadroom;
    @Transient
    boolean fadreport;
    @Transient
    String usermc;
    @Transient
    boolean multidocente;
        
    
    @Transient
    boolean fadtemp;
    

    @Column(name = "misto")
    private boolean misto;
    @Column(name = "cip_misto")
    private String cip_misto;

    
    
    public ProgettiFormativi() {
    }

    public boolean isFadtemp() {
        return fadtemp;
    }

    public void setFadtemp(boolean fadtemp) {
        this.fadtemp = fadtemp;
    }

    
    public String getCip_misto() {
        return cip_misto;
    }

    public void setCip_misto(String cip_misto) {
        this.cip_misto = cip_misto;
    }
    
    
    public int getRendicontato() {
        return rendicontato;
    }

    public void setRendicontato(int rendicontato) {
        this.rendicontato = rendicontato;
    }

    public String getFadlink() {
        return fadlink;
    }

    public void setFadlink(String fadlink) {
        this.fadlink = fadlink;
    }

    public boolean isMultidocente() {
        return multidocente;
    }

    public void setMultidocente(boolean multidocente) {
        this.multidocente = multidocente;
    }

    public String getUsermc() {
        return usermc;
    }

    public void setUsermc(String usermc) {
        this.usermc = usermc;
    }

    public List<Fadroom> getFadroom() {
        return fadroom;
    }

    public void setFadroom(List<Fadroom> fadroom) {
        this.fadroom = fadroom;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Date getData_up() {
        return data_up;
    }

    public void setData_up(Date data_up) {
        this.data_up = data_up;
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

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public NomiProgetto getNome() {
        return nome;
    }

    public void setNome(NomiProgetto nome) {
        this.nome = nome;
    }

    public double getOre() {
        return ore;
    }

    public void setOre(double ore) {
        this.ore = ore;
    }

    public int getOre_svolte() {
        return ore_svolte;
    }

    public boolean isMisto() {
        return misto;
    }

    public void setMisto(boolean misto) {
        this.misto = misto;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public void setOre_svolte(int ore_svolte) {
        this.ore_svolte = ore_svolte;
    }

    public String getCip() {
        return cip;
    }

    public void setCip(String cip) {
        this.cip = cip;
    }

    public SoggettiAttuatori getSoggetto() {
        return soggetto;
    }

    public void setSoggetto(SoggettiAttuatori soggetto) {
        this.soggetto = soggetto;
    }

    public List<Docenti> getDocenti() {
        List<Docenti> docenti_list = new ArrayList<>();
        docenti_list.addAll(this.docenti);
        return docenti_list;
    }

    public void setDocenti(List<Docenti> docenti) {
        this.docenti = docenti;
    }

    public StatiPrg getStato() {
        return stato;
    }

    public void setStato(StatiPrg stato) {
        this.stato = stato;
    }

    public List<Allievi> getAllievi() {
        List<Allievi> list_allievi = new ArrayList<>();//per fixare il bub dello stream  per le lazy list di EclipseLink
        list_allievi.addAll(this.allievi);
        return list_allievi;
    }

    public void setAllievi(List<Allievi> allievi) {
        this.allievi = allievi;
    }

    public SediFormazione getSede() {
        return sede;
    }

    public void setSede(SediFormazione sede) {
        this.sede = sede;
    }

    public List<DocumentiPrg> getDocumenti() {
        List<DocumentiPrg> doc_list = new ArrayList<>();//per fixare il bub dello stream  per le lazy list di EclipseLink
        doc_list.addAll(this.documenti);
        return doc_list;
    }

    public void setDocumenti(List<DocumentiPrg> documenti) {
        this.documenti = documenti;
    }

    public int getControllable() {
        return controllable;
    }

    public void setControllable(int controllable) {
        this.controllable = controllable;
    }

    public Date getEnd_fa() {
        return end_fa;
    }

    public void setEnd_fa(Date end_fa) {
        this.end_fa = end_fa;
    }

    public Date getStart_fb() {
        return start_fb;
    }

    public void setStart_fb(Date start_fb) {
        this.start_fb = start_fb;
    }

    public Date getEnd_fb() {
        return end_fb;
    }

    public void setEnd_fb(Date end_fb) {
        this.end_fb = end_fb;
    }

    public double getImporto() {
        return importo;
    }

    public void setImporto(double importo) {
        this.importo = importo;
    }

    public int getArchiviabile() {
        return archiviabile;
    }

    public void setArchiviabile(int archiviabile) {
        this.archiviabile = archiviabile;
    }

    public int getExtract() {
        return extract;
    }

    public void setExtract(int extract) {
        this.extract = extract;
    }

    public boolean isFadreport() {
        return fadreport;
    }

    public void setFadreport(boolean fadreport) {
        this.fadreport = fadreport;
    }

    public double getImporto_ente() {
        return importo_ente;
    }

    public void setImporto_ente(double importo_ente) {
        this.importo_ente = importo_ente;
    }

    public int getBatch_rendicontato() {
        return batch_rendicontato;
    }

    public void setBatch_rendicontato(int batch_rendicontato) {
        this.batch_rendicontato = batch_rendicontato;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof ProgettiFormativi)) {
            return false;
        }
        ProgettiFormativi other = (ProgettiFormativi) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "ProgettiFormativi{" + "id=" + id + ", data_up=" + data_up + ", start=" + start + ", end=" + end + ", timestamp=" + timestamp + ", descrizione=" + descrizione + ", nome=" + nome + ", cip=" + cip + ", motivo=" + motivo + ", ore=" + ore + ", ore_svolte=" + ore_svolte + ", controllable=" + controllable + ", archiviabile=" + archiviabile + ", extract=" + extract + ", end_fa=" + end_fa + ", start_fb=" + start_fb + ", end_fb=" + end_fb + ", importo=" + importo + ", stato=" + stato + ", soggetto=" + soggetto + ", sede=" + sede + ", docenti=" + docenti + ", allievi=" + allievi + ", documenti=" + documenti + '}';
    }

}
