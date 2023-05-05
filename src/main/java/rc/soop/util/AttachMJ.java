/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.util;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

/**
 *
 * @author rcosco
 */
public class AttachMJ {
    String ContentType, Filename, Base64Content;

    public AttachMJ(String ContentType, String Filename, String Base64Content) {
        this.ContentType = ContentType;
        this.Filename = Filename;
        this.Base64Content = Base64Content;
    }

    public String getContentType() {
        return ContentType;
    }

    public void setContentType(String ContentType) {
        this.ContentType = ContentType;
    }

    public String getFilename() {
        return Filename;
    }

    public void setFilename(String Filename) {
        this.Filename = Filename;
    }

    public String getBase64Content() {
        return Base64Content;
    }

    public void setBase64Content(String Base64Content) {
        this.Base64Content = Base64Content;
    }
    
    
    @Override
    public String toString() {
        return ReflectionToStringBuilder.toString(this);
    }
    
}
