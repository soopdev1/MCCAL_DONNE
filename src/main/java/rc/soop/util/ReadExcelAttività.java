package rc.soop.util;

import rc.soop.db.Entity;
import rc.soop.domain.Comuni;
import rc.soop.domain.Attivita;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author rcosco
 */
public class ReadExcelAttività {

    public static void main(String[] args) {
        Entity e = new Entity();
        try {
            Workbook workbook = WorkbookFactory.create(new File("C:\\Users\\rcosco\\Desktop\\ELENCO AMMISSIONI YISUCAL.xlsx"));
            Sheet sheet = workbook.getSheetAt(0);

            Iterator<Row> rows = sheet.iterator();
            Row row;
            rows.next();//salto la prima

            ArrayList<attivita> activity = new ArrayList<>();

            while (rows.hasNext()) {
                row = rows.next();
                activity.add(new attivita(row.getCell(0).getStringCellValue(), row.getCell(1).getStringCellValue().toLowerCase()));
            }

            e.begin();
            HashMap<String, Comuni> comuni = e.getComuniCalabria();

            for (attivita a : activity) {
                if (!a.getIntestazione().trim().equals("")) {
                    Attivita at = new Attivita();
                    at.setComune(comuni.get(a.getComune().trim()));
                    at.setName(a.getIntestazione().trim());
                    if (at.getComune() != null) {
                        at.setLatitutdine(at.getComune().getCoordinate().getLatitudine() + (getRandomNumber(-20, 20) / 10000));
                        at.setLongitudine(at.getComune().getCoordinate().getLongitudine() + (getRandomNumber(-20, 20) / 10000));
                    } else {
                        System.out.println(a.getIntestazione() + " " + a.getComune());
                    }
                e.persist(at);
                }
            }
            e.commit();
        } catch (Exception ex) {
            e.rollBack();
            ex.printStackTrace();
        } finally {
            e.close();
        }
    }

    public static double getRandomNumber(int min, int max) {
        return ((Math.random() * (max - min)) + min);
    }

}

class attivita {

    String intestazione, comune;

    public attivita(String intestazione, String comune) {
        this.intestazione = intestazione;
        this.comune = comune;
    }

    public String getIntestazione() {
        return intestazione;
    }

    public void setIntestazione(String intestazione) {
        this.intestazione = intestazione;
    }

    public String getComune() {
        return comune;
    }

    public void setComune(String comune) {
        this.comune = comune;
    }

}
