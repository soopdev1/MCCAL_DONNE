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
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author rcosco
 */
@Entity
@Table(name = "allievi_pregresso")
@JsonIgnoreProperties(value = {"documenti"})
public class Allievi_Pregresso implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "idallievi_pregresso")
    private Long id;
    @Column(name = "cognome")
    private String cognome;
    @Column(name = "nome")
    private String nome;
    @Column(name = "data_di_nascita")
    private String data_di_nascita;
    @Column(name = "codice_fiscale")
    private String codice_fiscale;
    @Column(name = "sesso")
    private String sesso;
    @Column(name = "stato_nascita")
    private String stato_nascita;
    @Column(name = "cittadinanza")
    private String cittadinanza;
    @Column(name = "comune_di_nascita")
    private String comune_di_nascita;
    @Column(name = "provincia_di_nascita")
    private String provincia_di_nascita;
    @Column(name = "cellulare")
    private String cellulare;
    @Column(name = "email")
    private String email;
    @Column(name = "comune_di_residenza")
    private String comune_di_residenza;
    @Column(name = "indirizzo_residenza")
    private String indirizzo_residenza;
    @Column(name = "regione_residenza")
    private String regione_residenza;
    @Column(name = "provincia_sigla")
    private String provincia_sigla;
    @Column(name = "istat_cap_cod_istat")
    private String istat_cap_cod_istat;
    @Column(name = "comune_domicilio")
    private String comune_domicilio;
    @Column(name = "provincia_domicilio")
    private String provincia_domicilio;
    @Column(name = "istat_domicilio")
    private String istat_domicilio;
    @Column(name = "titolo_di_studio")
    private String titolo_di_studio;
    @Column(name = "cod_studio")
    private String cod_studio;
    @Column(name = "esperienza_lavorativa")
    private String esperienza_lavorativa;
    @Column(name = "cod_condizione_mercato")
    private String cod_condizione_mercato;
    @Column(name = "modello_1")
    private String modello_1;
    @Column(name = "data_iscrizione_gg")
    private String data_iscrizione_gg;
    @Column(name = "cpi_di_competenza")
    private String cpi_di_competenza;
    @Column(name = "eta")
    private String eta;
    @Column(name = "sog_attuatore_71")
    private String sog_attuatore_71;
    @Column(name = "cf_sa")
    private String cf_sa;
    @Column(name = "id_percorso")
    private String id_percorso;
    @Column(name = "modello_8")
    private String modello_8;
    @Column(name = "data_inizio_fase_a")
    private String data_inizio_fase_a;
    @Column(name = "data_fine_fase_a")
    private String data_fine_fase_a;
    @Column(name = "ore_riconosciute_fase_a")
    private String ore_riconosciute_fase_a;
    @Column(name = "data_inizio_fase_b")
    private String data_inizio_fase_b;
    @Column(name = "data_fine_fase_b")
    private String data_fine_fase_b;
    @Column(name = "ore_riconosciute_fase_b")
    private String ore_riconosciute_fase_b;
    @Column(name = "x_ore_totale_riconosciute")
    private String x_ore_totale_riconosciute;
    @Column(name = "domanda_selfiemployment")
    private String domanda_selfiemployment;
    @Column(name = "cod_stato_partecipazione")
    private String cod_stato_partecipazione;
    @Column(name = "id_allievo_piattaforma")
    private String id_allievo_piattaforma;
    @Column(name = "nota")
    private String nota;
    @Column(name = "numero_rendiconto")
    private String numero_rendiconto;
    @Column(name = "data_rendiconto")
    private String data_rendiconto;
    @Temporal(TemporalType.TIMESTAMP)
    @Column(columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP", name = "timestamp", insertable = false)
    private Date timestamp;
    @Column(name = "docid")
    private String docid;

    @OneToMany(mappedBy = "allievo", fetch = FetchType.LAZY)
    List<Documenti_Allievi_Pregresso> documenti;

    public Allievi_Pregresso() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCognome() {
        return cognome;
    }

    public void setCognome(String cognome) {
        this.cognome = cognome;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getData_di_nascita() {
        return data_di_nascita;
    }

    public void setData_di_nascita(String data_di_nascita) {
        this.data_di_nascita = data_di_nascita;
    }

    public String getCodice_fiscale() {
        return codice_fiscale;
    }

    public void setCodice_fiscale(String codice_fiscale) {
        this.codice_fiscale = codice_fiscale;
    }

    public String getSesso() {
        return sesso;
    }

    public void setSesso(String sesso) {
        this.sesso = sesso;
    }

    public String getStato_nascita() {
        return stato_nascita;
    }

    public void setStato_nascita(String stato_nascita) {
        this.stato_nascita = stato_nascita;
    }

    public String getCittadinanza() {
        return cittadinanza;
    }

    public void setCittadinanza(String cittadinanza) {
        this.cittadinanza = cittadinanza;
    }

    public String getComune_di_nascita() {
        return comune_di_nascita;
    }

    public void setComune_di_nascita(String comune_di_nascita) {
        this.comune_di_nascita = comune_di_nascita;
    }

    public String getProvincia_di_nascita() {
        return provincia_di_nascita;
    }

    public void setProvincia_di_nascita(String provincia_di_nascita) {
        this.provincia_di_nascita = provincia_di_nascita;
    }

    public String getCellulare() {
        return cellulare;
    }

    public void setCellulare(String cellulare) {
        this.cellulare = cellulare;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getComune_di_residenza() {
        return comune_di_residenza;
    }

    public void setComune_di_residenza(String comune_di_residenza) {
        this.comune_di_residenza = comune_di_residenza;
    }

    public String getIndirizzo_residenza() {
        return indirizzo_residenza;
    }

    public void setIndirizzo_residenza(String indirizzo_residenza) {
        this.indirizzo_residenza = indirizzo_residenza;
    }

    public String getRegione_residenza() {
        return regione_residenza;
    }

    public void setRegione_residenza(String regione_residenza) {
        this.regione_residenza = regione_residenza;
    }

    public String getProvincia_sigla() {
        return provincia_sigla;
    }

    public void setProvincia_sigla(String provincia_sigla) {
        this.provincia_sigla = provincia_sigla;
    }

    public String getIstat_cap_cod_istat() {
        return istat_cap_cod_istat;
    }

    public void setIstat_cap_cod_istat(String istat_cap_cod_istat) {
        this.istat_cap_cod_istat = istat_cap_cod_istat;
    }

    public String getComune_domicilio() {
        return comune_domicilio;
    }

    public void setComune_domicilio(String comune_domicilio) {
        this.comune_domicilio = comune_domicilio;
    }

    public String getProvincia_domicilio() {
        return provincia_domicilio;
    }

    public void setProvincia_domicilio(String provincia_domicilio) {
        this.provincia_domicilio = provincia_domicilio;
    }

    public String getIstat_domicilio() {
        return istat_domicilio;
    }

    public void setIstat_domicilio(String istat_domicilio) {
        this.istat_domicilio = istat_domicilio;
    }

    public String getTitolo_di_studio() {
        return titolo_di_studio;
    }

    public void setTitolo_di_studio(String titolo_di_studio) {
        this.titolo_di_studio = titolo_di_studio;
    }

    public String getCod_studio() {
        return cod_studio;
    }

    public void setCod_studio(String cod_studio) {
        this.cod_studio = cod_studio;
    }

    public String getEsperienza_lavorativa() {
        return esperienza_lavorativa;
    }

    public void setEsperienza_lavorativa(String esperienza_lavorativa) {
        this.esperienza_lavorativa = esperienza_lavorativa;
    }

    public String getCod_condizione_mercato() {
        return cod_condizione_mercato;
    }

    public void setCod_condizione_mercato(String cod_condizione_mercato) {
        this.cod_condizione_mercato = cod_condizione_mercato;
    }

    public String getModello_1() {
        return modello_1;
    }

    public void setModello_1(String modello_1) {
        this.modello_1 = modello_1;
    }

    public String getData_iscrizione_gg() {
        return data_iscrizione_gg;
    }

    public void setData_iscrizione_gg(String data_iscrizione_gg) {
        this.data_iscrizione_gg = data_iscrizione_gg;
    }

    public String getCpi_di_competenza() {
        return cpi_di_competenza;
    }

    public void setCpi_di_competenza(String cpi_di_competenza) {
        this.cpi_di_competenza = cpi_di_competenza;
    }

    public String getEta() {
        return eta;
    }

    public void setEta(String eta) {
        this.eta = eta;
    }

    public String getSog_attuatore_71() {
        return sog_attuatore_71;
    }

    public void setSog_attuatore_71(String sog_attuatore_71) {
        this.sog_attuatore_71 = sog_attuatore_71;
    }

    public String getCf_sa() {
        return cf_sa;
    }

    public void setCf_sa(String cf_sa) {
        this.cf_sa = cf_sa;
    }

    public String getId_percorso() {
        return id_percorso;
    }

    public void setId_percorso(String id_percorso) {
        this.id_percorso = id_percorso;
    }

    public String getModello_8() {
        return modello_8;
    }

    public void setModello_8(String modello_8) {
        this.modello_8 = modello_8;
    }

    public String getData_inizio_fase_a() {
        return data_inizio_fase_a;
    }

    public void setData_inizio_fase_a(String data_inizio_fase_a) {
        this.data_inizio_fase_a = data_inizio_fase_a;
    }

    public String getData_fine_fase_a() {
        return data_fine_fase_a;
    }

    public void setData_fine_fase_a(String data_fine_fase_a) {
        this.data_fine_fase_a = data_fine_fase_a;
    }

    public String getOre_riconosciute_fase_a() {
        return ore_riconosciute_fase_a;
    }

    public void setOre_riconosciute_fase_a(String ore_riconosciute_fase_a) {
        this.ore_riconosciute_fase_a = ore_riconosciute_fase_a;
    }

    public String getData_inizio_fase_b() {
        return data_inizio_fase_b;
    }

    public void setData_inizio_fase_b(String data_inizio_fase_b) {
        this.data_inizio_fase_b = data_inizio_fase_b;
    }

    public String getData_fine_fase_b() {
        return data_fine_fase_b;
    }

    public void setData_fine_fase_b(String data_fine_fase_b) {
        this.data_fine_fase_b = data_fine_fase_b;
    }

    public String getOre_riconosciute_fase_b() {
        return ore_riconosciute_fase_b;
    }

    public void setOre_riconosciute_fase_b(String ore_riconosciute_fase_b) {
        this.ore_riconosciute_fase_b = ore_riconosciute_fase_b;
    }

    public String getX_ore_totale_riconosciute() {
        return x_ore_totale_riconosciute;
    }

    public void setX_ore_totale_riconosciute(String x_ore_totale_riconosciute) {
        this.x_ore_totale_riconosciute = x_ore_totale_riconosciute;
    }

    public String getDomanda_selfiemployment() {
        return domanda_selfiemployment;
    }

    public void setDomanda_selfiemployment(String domanda_selfiemployment) {
        this.domanda_selfiemployment = domanda_selfiemployment;
    }

    public String getCod_stato_partecipazione() {
        return cod_stato_partecipazione;
    }

    public void setCod_stato_partecipazione(String cod_stato_partecipazione) {
        this.cod_stato_partecipazione = cod_stato_partecipazione;
    }

    public String getId_allievo_piattaforma() {
        return id_allievo_piattaforma;
    }

    public void setId_allievo_piattaforma(String id_allievo_piattaforma) {
        this.id_allievo_piattaforma = id_allievo_piattaforma;
    }

    public String getNota() {
        return nota;
    }

    public void setNota(String nota) {
        this.nota = nota;
    }

    public String getNumero_rendiconto() {
        return numero_rendiconto;
    }

    public void setNumero_rendiconto(String numero_rendiconto) {
        this.numero_rendiconto = numero_rendiconto;
    }

    public String getData_rendiconto() {
        return data_rendiconto;
    }

    public void setData_rendiconto(String data_rendiconto) {
        this.data_rendiconto = data_rendiconto;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public List<Documenti_Allievi_Pregresso> getDocumenti() {
        List<Documenti_Allievi_Pregresso> documenti_list = new ArrayList<>();
        documenti_list.addAll(this.documenti);
        return documenti_list;
    }

    public void setDocumenti(List<Documenti_Allievi_Pregresso> documenti) {
        this.documenti = documenti;
    }

    public String getDocid() {
        return docid;
    }

    public void setDocid(String docid) {
        this.docid = docid;
    }

    @Override
    public int hashCode() {
        int hash = 3;
        hash = 89 * hash + Objects.hashCode(this.id);
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
        final Allievi_Pregresso other = (Allievi_Pregresso) obj;
        if (!Objects.equals(this.id, other.id)) {
            return false;
        }
        return true;
    }

}
