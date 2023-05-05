/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.entity;

/**
 *
 * @author rcosco
 */
public class Item {

    String value, desc, desc2, visual;

    public Item(String value, String desc, String visual) {
        this.value = value;
        this.desc = desc;
        this.visual = visual;
    }

    public Item(String value, String desc, String desc2, String visual) {
        this.value = value;
        this.desc = desc;
        this.desc2 = desc2;
        this.visual = visual;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getVisual() {
        return visual;
    }

    public void setVisual(String visual) {
        this.visual = visual;
    }

    public String getDesc2() {
        return desc2;
    }

    public void setDesc2(String desc2) {
        this.desc2 = desc2;
    }
    
    
//    public static void main(String[] args) {
//        
//        String id = "1";
//        String nstanza = RandomStringUtils.randomAlphabetic(15-id.length()).toUpperCase();
//        
//        
//        
//    }
    
}

