/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.domain;

import java.io.Serializable;
import java.util.Objects;
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

/**
 *
 * @author rcosco
 */
@Entity
@Table(name = "documenti_allievi_pregresso")
@NamedQueries(value = {
    @NamedQuery(name = "docP.byAllievo", query = "SELECT d FROM Documenti_Allievi_Pregresso d WHERE d.allievo=:allievo")
})
public class Documenti_Allievi_Pregresso implements Serializable {

    @Id
    @Column(name = "iddocumenti_allievi_pregresso")
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    @Column(name = "path")
    private String path;
    @ManyToOne
    @JoinColumn(name = "tipo")
    TipoDoc_Allievi_Pregresso tipo;
    @ManyToOne
    @JoinColumn(name = "idallievo_pregresso")
    Allievi_Pregresso allievo;
    @Column(name = "deleted", columnDefinition = "INT(1) DEFAULT 0")
    private int deleted;
    

    public Documenti_Allievi_Pregresso() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public TipoDoc_Allievi_Pregresso getTipo() {
        return tipo;
    }

    public void setTipo(TipoDoc_Allievi_Pregresso tipo) {
        this.tipo = tipo;
    }

    public int getDeleted() {
        return deleted;
    }

    public void setDeleted(int deleted) {
        this.deleted = deleted;
    }

    public Allievi_Pregresso getAllievo() {
        return allievo;
    }

    public void setAllievo(Allievi_Pregresso allievo) {
        this.allievo = allievo;
    }

    @Override
    public int hashCode() {
        int hash = 7;
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
        final Documenti_Allievi_Pregresso other = (Documenti_Allievi_Pregresso) obj;
        if (!Objects.equals(this.id, other.id)) {
            return false;
        }
        return true;
    }

    
    
}