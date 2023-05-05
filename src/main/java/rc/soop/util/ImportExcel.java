/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.util;

import rc.soop.db.Entity;
import rc.soop.domain.Docenti;
import rc.soop.domain.FasceDocenti;
import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;
import java.util.regex.Pattern;
import javax.persistence.PersistenceException;
import org.apache.commons.validator.routines.EmailValidator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

/**
 *
 * @author rcosco
 */
public class ImportExcel {

    public static boolean importSedi(InputStream in, String id_user) throws IOException, PersistenceException {
        Entity e = new Entity();
//        HashMap<String, FasceDocenti> fasce = e.getFasceMap();
        try {
            Workbook workbook = WorkbookFactory.create(in);
            Sheet sheet = workbook.getSheetAt(0);

            Iterator<Row> rows = sheet.iterator();
            Row row;

            e.begin();

            FasceDocenti fa = e.getEm().find(FasceDocenti.class, "FA");

            while (rows.hasNext()) {
                row = rows.next();
                if (row.getCell(2) != null) {
                    if (Pattern.matches("[A-Z]{6}\\d{2}[A-Z]\\d{2}[A-Z]\\d{3}[A-Z]", row.getCell(2).getStringCellValue().trim().toUpperCase())) {
                        if (e.getDocenteByCf(row.getCell(2).getStringCellValue()) == null) {    // VERIFICO CHE QUESTO CF NON SIA GIA' PRESENTE
                            try {
                                Docenti d = new Docenti();
                                d.setNome(row.getCell(0).getStringCellValue().trim());
                                d.setCognome(row.getCell(1).getStringCellValue().trim());
                                d.setCodicefiscale(row.getCell(2).getStringCellValue().trim().toUpperCase());
                                d.setDatanascita(row.getCell(3).getDateCellValue());
                                d.setFascia(fa);
                                String emailtoinsert = row.getCell(5).getStringCellValue().trim().toLowerCase();
                                if (EmailValidator.getInstance().isValid(emailtoinsert)) {
                                    d.setEmail(emailtoinsert);
                                }
                                e.persist(d);
                            } catch (Exception ex) {
                                e.insertTracking(id_user, "ImportExcel.importSedi: " + ex.getMessage());
                                ex.printStackTrace();
                            }
                        }
                    }
                }
            }
            e.commit();
            return true;
        } catch (Exception ex) {
            e.insertTracking(id_user, "ImportExcel.importSedi: " + Utility.estraiEccezione(ex));
        } finally {
            e.close();
        }
        return false;
    }

}
