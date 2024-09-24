/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.util;

import com.google.common.base.Splitter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.TimeZone;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import static org.apache.commons.lang3.StringUtils.stripAccents;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.RegionUtil;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import rc.soop.db.Database;
import static rc.soop.util.Utility.estraiEccezione;
import static rc.soop.util.Utility.log;

/**
 *
 * @author rcosco
 */
public class ExcelFAD {

    public static final long MAX = 18000000;

    private static final XSSFColor col1 = new XSSFColor(new java.awt.Color(146, 208, 80), null);
    private static final XSSFColor col2 = new XSSFColor(new java.awt.Color(204, 236, 255), null);
    private static final XSSFColor col3 = new XSSFColor(new java.awt.Color(230, 230, 230), null);
    private static final String pattern0 = "yyyy-MM-dd HH:mm:ss";
    private static final DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");

    private static DateTime format(String ing, String pattern) {
        try {
            if (ing.contains(".")) {
                ing = ing.split("\\.")[0];
            }
            return DateTimeFormat.forPattern(pattern).parseDateTime(ing);
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        }
        return null;
    }

    private static long calcolaDurataLezione(String date, List<Items> calendar) {
        try {
            List<Items> ita = calendar.stream().filter(day -> day.getData().equals(date)).collect(Collectors.toList());
            Iterator<Items> i = ita.iterator();
            long start = 0;
            long end = 0;
            while (i.hasNext()) {
                Items it = i.next();
                DateTime start1 = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm").parseDateTime(it.getData() + " " + it.getOrainizio());
                DateTime end1 = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm").parseDateTime(it.getData() + " " + it.getOrafine());
                start += start1.getMillis();
                end += end1.getMillis();
            }
            long out = end - start;
            if (out > MAX) {
                return MAX;
            }
            return end - start;
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        }
        return 0;
    }

    private static String checkCalendar(String date, List<Items> calendar, Presenti pr1) {
        StringBuilder newdate = new StringBuilder();
        String solodata = date.split(" ")[0];
        String soloora = date.split(" ")[1];
//        System.out.println("com.mycompany.testmc.ExcelFAD.checkCalendar(INGRESSO) "+date);
        DateTime orario = DateTimeFormat.forPattern("HH:mm:ss").parseDateTime(soloora);

        List<Items> lezionidelgiorno = calendar.stream().filter(lez -> lez.getData().equals(solodata)).collect(Collectors.toList());

        if (lezionidelgiorno.isEmpty()) {
            return "";
        }

        lezionidelgiorno.sort(Comparator.comparing(a -> a.getOrainizio()));

        if (lezionidelgiorno.size() == 2) {
            for (int z = 0; z < lezionidelgiorno.size(); z++) {
                Items lezioneoggi = lezionidelgiorno.get(z);
                DateTime start = DateTimeFormat.forPattern("HH:mm").parseDateTime(lezioneoggi.getOrainizio());
                DateTime end = DateTimeFormat.forPattern("HH:mm").parseDateTime(lezioneoggi.getOrafine());
                boolean compreso = !orario.isBefore(start) && !orario.isAfter(end);

                if (compreso) {
                    break;
                } else {
                    boolean prima = orario.isBefore(start);
                    boolean dopo = orario.isAfter(end);
                    if (prima) {
                        newdate.append(solodata).append(" ").append(lezioneoggi.getOrainizio()).append(":00");
                        break;
                    }
                    if (dopo) {
                        if (z == 0) {
                            Items lezionepom = lezionidelgiorno.get(z + 1);
                            DateTime start_P = DateTimeFormat.forPattern("HH:mm").parseDateTime(lezionepom.getOrainizio());
                            DateTime end_P = DateTimeFormat.forPattern("HH:mm").parseDateTime(lezionepom.getOrafine());
                            boolean prima_P = orario.isBefore(start_P);
                            boolean dopo_P = orario.isAfter(end_P);

                            if (prima_P) {
                                if (pr1.isLogin()) {
                                    newdate.append(solodata).append(" ").append(lezionepom.getOrainizio()).append(":00");
                                    break;
                                } else if (pr1.isLogout()) {
                                    newdate.append(solodata).append(" ").append(lezioneoggi.getOrafine()).append(":00");
                                    break;
                                }
                            }
                            if (dopo_P) {
                                newdate.append(solodata).append(" ").append(lezionepom.getOrafine()).append(":00");
                                break;
                            }
                        }
                    }

                }

            }
        } else {
            for (Items lezione : lezionidelgiorno) {
                DateTime start = DateTimeFormat.forPattern("HH:mm").parseDateTime(lezione.getOrainizio());
                DateTime end = DateTimeFormat.forPattern("HH:mm").parseDateTime(lezione.getOrafine());

                boolean compreso = !orario.isBefore(start) && !orario.isAfter(end);
//                System.out.println("checkCalendar() "+orario+" -- "+compreso);
                if (!compreso) {
                    boolean prima = orario.isBefore(start);
                    boolean dopo = orario.isAfter(end);
                    if (prima) {
                        newdate.append(solodata).append(" ").append(lezione.getOrainizio()).append(":00");
                        break;
                    }
                    if (dopo) {
                        newdate.append(solodata).append(" ").append(lezione.getOrafine()).append(":00");
                        break;
                    }
                }
            }
        }

        if (newdate.toString().trim().equals("")) {
            return date;
        } else {
            return newdate.toString();
        }
    }

    private static long arrotonda(long durata) {
        try {
            long r = durata % (15 * 60 * 1000);
            durata -= r;
            durata += 15 * 60 * 1000;
        } catch (Exception ex) {
        }
        return durata;
    }

    private static void setBordersToMergedCells(XSSFSheet sheet) {
        List<CellRangeAddress> mergedRegions = sheet.getMergedRegions();
        mergedRegions.stream().map((rangeAddress) -> {
            RegionUtil.setBorderTop(BorderStyle.THIN, rangeAddress, sheet);
            return rangeAddress;
        }).map((rangeAddress) -> {
            RegionUtil.setBorderLeft(BorderStyle.THIN, rangeAddress, sheet);
            return rangeAddress;
        }).map((rangeAddress) -> {
            RegionUtil.setBorderRight(BorderStyle.THIN, rangeAddress, sheet);
            return rangeAddress;
        }).forEachOrdered((rangeAddress) -> {
            RegionUtil.setBorderBottom(BorderStyle.THIN, rangeAddress, sheet);
        });
    }

    private static XSSFRow get(XSSFSheet sh, int index) {
        try {
            XSSFRow row = sh.getRow(index);
            if (row == null) {
                row = sh.createRow(index);
            }
            return row;
        } catch (Exception ex) {
            return sh.createRow(index);
        }
    }

    private static XSSFCell get(XSSFRow row, int index) {
        try {
            XSSFCell cell = row.getCell(index);
            if (cell == null) {
                cell = row.createCell(index);

            }
            return cell;
        } catch (Exception ex) {
            return row.createCell(index);
        }
    }

    private static List<Items> list_Allievi(String idpr) {
        List<Items> out = new ArrayList<>();
        try {
            Database db2 = new Database();
            try (Statement st2 = db2.getC().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE); ResultSet rs2 = st2.executeQuery("SELECT idallievi,nome,cognome,codicefiscale FROM allievi f WHERE f.idprogetti_formativi='" + idpr + "'")) {
                while (rs2.next()) {
                    Items al = new Items(rs2.getString(1).trim(), (rs2.getString(2).trim() + " " + rs2.getString(3).trim()).toUpperCase());
                    al.setNome(rs2.getString(2).toUpperCase().trim());
                    al.setCognome(rs2.getString(3).toUpperCase().trim());
                    al.setCf(rs2.getString(4).toUpperCase().trim());
                    out.add(al);
                }
                db2.closeDB();
            }
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        }
        return out;
    }

    private static List<Items> list_Allievi_noAccento(String idpr) {
        List<Items> out = new ArrayList<>();
        try {
            Database db2 = new Database();
            try (Statement st2 = db2.getC().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE); ResultSet rs2 = st2.executeQuery("SELECT idallievi,nome,cognome,codicefiscale FROM allievi f WHERE f.idprogetti_formativi='" + idpr + "'")) {
                while (rs2.next()) {
                    Items al = new Items(rs2.getString(1).trim(), stripAccents(rs2.getString(2).trim() + " " + rs2.getString(3).trim()).toUpperCase());
                    al.setNome(stripAccents(rs2.getString(2).toUpperCase().trim()));
                    al.setCognome(stripAccents(rs2.getString(3).toUpperCase().trim()));
                    al.setCf(rs2.getString(4).toUpperCase().trim());
                    out.add(al);
                }
            }
            db2.closeDB();
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        }
        return out;
    }

    private static List<Items> list_Docenti(String idpr) {
        List<Items> out = new ArrayList<>();
        try {
            Database db2 = new Database();
            try (Statement st2 = db2.getC().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE); ResultSet rs2 = st2.executeQuery("SELECT iddocenti,nome,cognome FROM docenti f WHERE f.iddocenti IN (SELECT p.iddocenti FROM progetti_docenti p WHERE p.idprogetti_formativi='" + idpr + "')")) {
                while (rs2.next()) {
                    out.add(new Items(rs2.getString(1), (rs2.getString(2) + " " + rs2.getString(3)).toUpperCase()));
                }
            }
            db2.closeDB();
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        }
        return out;
    }

    private static List<Items> formatAction() {
        List<Items> out = new ArrayList<>();
        out.add(new Items("L1", "Login"));
        out.add(new Items("L2", "Logout"));
        out.add(new Items("L3", "Logout"));
        out.add(new Items("L3", "Logout"));
        out.add(new Items("L4", "Logout"));
        out.add(new Items("L5", "Chiusura stanza"));
        out.add(new Items("IN", "Info"));
        return out;
    }

    private static String calcoladurata(long millis) {
        if (millis <= 0) {
//            System.out.println("( ) " + millis);
            return "Dati non congrui per calcolare il tempo di permanenza.";
        }
        long hours = TimeUnit.MILLISECONDS.toHours(millis);
        millis -= TimeUnit.HOURS.toMillis(hours);
        long minutes = TimeUnit.MILLISECONDS.toMinutes(millis);
        millis -= TimeUnit.MINUTES.toMillis(minutes);
        long seconds = TimeUnit.MILLISECONDS.toSeconds(millis);
        StringBuilder sb = new StringBuilder(64);
        sb.append(StringUtils.leftPad(String.valueOf(hours), 2, "0"));
        sb.append(":");
        sb.append(StringUtils.leftPad(String.valueOf(minutes), 2, "0"));
        sb.append(":");
        sb.append(StringUtils.leftPad(String.valueOf(seconds), 2, "0"));

//        sb.append(hours);
//        sb.append("h ");
//        sb.append(minutes);
//        sb.append("min ");
//        sb.append(seconds);
//        sb.append("sec");
        return sb.toString();
    }

    public static final String timestamp = "yyyyMMddHHmmssSSS";
    public static final String timestampFAD = "yyyy-MM-dd HH:mm:ss.SSSSSS";
    public static final String timestampSQLZONE = "yyyy-MM-dd HH:mm:ss Z";
    public static final String timestampSQL = "yyyy-MM-dd HH:mm:ss";
    public static final DateTimeFormatter dtfad = DateTimeFormat.forPattern(timestampFAD);

    public static String convertTS_Italy(String ts1) {
        String dt1 = StringUtils.substring(ts1, 0, 26);
        try {
            if (dt1.length() != timestampFAD.length()) {
                if (dt1.length() == 19) {
                    dt1 += ".000000";
                }
            }
        } catch (Exception e) {
        }
        DateTime start = new DateTime(dtfad.parseDateTime(dt1));
        DateTime dateTimeIT = start.plus(getTimeDiff(start));
        return dateTimeIT.toString(timestampSQL);
    }

    public static long getTimeDiff(DateTime start) {
        try {
            TimeZone tz1 = TimeZone.getTimeZone("Europe/Rome");
            TimeZone tz2 = TimeZone.getTimeZone("GMT");
            TimeZone tz3 = TimeZone.getTimeZone("GMT+1");
            ZoneId arrivingZone = ZoneId.of("Europe/Rome");
            ZonedDateTime arrival = java.time.Instant.ofEpochMilli(start.toInstant().getMillis()).atZone(arrivingZone);
            if (arrivingZone.getRules().isDaylightSavings(arrival.toInstant())) {
                return tz1.getRawOffset() - tz2.getRawOffset() + tz1.getDSTSavings() - tz2.getDSTSavings();
            } else {
                return tz1.getRawOffset() - tz3.getRawOffset() + tz1.getDSTSavings() - tz3.getDSTSavings();
            }
        } catch (Exception e) {
        }
        return 0L;
    }

    public static void createDir(String path) {
        try {
            Files.createDirectories(Paths.get(path));
        } catch (Exception e) {
        }
    }

    public static File generatereportFAD_multistanza(String idpr, boolean print) {
        try {

            List<Items> elencostanze = new ArrayList<>();
            Database db0 = new Database();

            String nome = db0.getNomePR_F(idpr);
            String idsa = db0.getSAPR_F(idpr);

            String pathtemp = db0.getPathtemp("pathDocSA_Prg").replace("@rssa",
                    idsa).replace("@folder", String.valueOf(idpr));
//            String pathtemp = db0.getPathtemp("pathTemp");
            createDir(pathtemp);
            //ELENCO STANZE
            String sql0 = "SELECT nomestanza,numerocorso FROM fad_multi WHERE idprogetti_formativi=" + idpr;
            if (print) {
                log.info("1) " + sql0);
            }
            try (Statement st0 = db0.getC().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE); ResultSet rs0 = st0.executeQuery(sql0)) {
                while (rs0.next()) {
                    elencostanze.add(new Items(rs0.getString(1), rs0.getString(2)));
                }
                rs0.close();
            }
            db0.closeDB();

            List<Items> docenti = list_Docenti(idpr);
            List<Items> allievi = list_Allievi_noAccento(idpr);
            List<Items> allievi_corretti = list_Allievi(idpr);

            AtomicInteger ok = new AtomicInteger(0);
            if (!elencostanze.isEmpty()) {
                XSSFWorkbook workbook = new XSSFWorkbook();
                XSSFFont headerFont = workbook.createFont();
                headerFont.setBold(true);
                headerFont.setFontHeightInPoints((short) 15);
                XSSFCellStyle headerCellStyle = workbook.createCellStyle();
                headerCellStyle.setFont(headerFont);
                headerCellStyle.setBorderBottom(BorderStyle.THIN);
                headerCellStyle.setBottomBorderColor(IndexedColors.BLACK.getIndex());
                headerCellStyle.setBorderLeft(BorderStyle.THIN);
                headerCellStyle.setLeftBorderColor(IndexedColors.BLACK.getIndex());
                headerCellStyle.setBorderRight(BorderStyle.THIN);
                headerCellStyle.setRightBorderColor(IndexedColors.BLACK.getIndex());
                headerCellStyle.setBorderTop(BorderStyle.THIN);
                headerCellStyle.setTopBorderColor(IndexedColors.BLACK.getIndex());
                headerCellStyle.setFillForegroundColor(col3);
                headerCellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                XSSFFont normFont = workbook.createFont();
                normFont.setFontHeightInPoints((short) 12);

                elencostanze.forEach(room -> {
                    try {
                        String roomname = room.getId();
                        String numerocorso = room.getDescr();

                        String roomnamequery;

                        if (roomname.startsWith("FAD_3_")) {
                            roomnamequery = "FAD_3_1";
                        } else {
                            roomnamequery = roomname;
                        }

                        List<Items> calendar = new ArrayList<>();
                        List<Hours> times_A = new ArrayList<>();
                        List<Hours> times_B = new ArrayList<>();
                        List<Track> tracking = new ArrayList<>();
                        List<Items> idutenti = new ArrayList<>();
                        List<Items> azioni = formatAction();
                        Database db1 = new Database();
                        String sqlc1 = "SELECT data,orainizio,orafine FROM fad_calendar f WHERE f.idprogetti_formativi = "
                                + idpr + " AND f.numerocorso='" + numerocorso + "' ORDER BY data";
                        if (print) {
                            log.info("2) " + sqlc1);
                        }

                        try (Statement stc = db1.getC().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE); ResultSet rsc = stc.executeQuery(sqlc1);) {

                            while (rsc.next()) {
                                String inizio = rsc.getString(2);
                                String fine = rsc.getString(3);
                                if (inizio.contains(";") || fine.contains(";")) {
                                    List<String> orario_inizio = Splitter.on(";").splitToList(inizio);
                                    List<String> orario_fine = Splitter.on(";").splitToList(fine);
                                    if (orario_inizio.size() == orario_fine.size()) {
                                        for (int i = 0; i < orario_inizio.size(); i++) {
                                            Items lezione = new Items();
                                            lezione.setData(rsc.getString(1));
                                            lezione.setOrainizio(orario_inizio.get(i));
                                            lezione.setOrafine(orario_fine.get(i));
                                            calendar.add(lezione);
                                        }
                                    }
                                } else {
                                    Items lezione = new Items();
                                    lezione.setData(rsc.getString(1));
                                    lezione.setOrainizio(inizio);
                                    lezione.setOrafine(fine);
                                    calendar.add(lezione);
                                }
                            }
                        }

                        List<String> giornidilezione = calendar.stream().map(le -> le.getData()).collect(Collectors.toList());

                        Statement st1 = db1.getC().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
                        String sql01 = "SELECT DISTINCT(LEFT(DATE,10)) FROM fad_track f WHERE f.room = '" + roomnamequery + "'";
                        if (print) {
                            log.info("3) " + sql01);
                        }
                        ResultSet rs1 = st1.executeQuery(sql01);
                        Statement st02 = db1.getC().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
                        String queryrs02 = "SELECT p.start,p.end_fa,p.start_fb,p.end_fb FROM progetti_formativi p WHERE p.idprogetti_formativi = " + idpr;
                        ResultSet rs02 = st02.executeQuery(queryrs02);
                        if (print) {
                            log.info("4) " + queryrs02);
                        }
                        if (rs02.next()) {
                            List<String> date_A = new ArrayList<>();
                            List<String> date_B = new ArrayList<>();
                            String inizioA = rs02.getString(1);
                            String fineA = rs02.getString(2);
                            String inizioB = rs02.getString(3);
                            String fineB = rs02.getString(4);
                            while (rs1.next()) {
                                if (fineA == null || inizioB == null) {
                                    date_A.add(rs1.getString(1));
                                } else {
                                    DateTime check = dtf.parseDateTime(rs1.getString(1));
                                    DateTime in_A = dtf.parseDateTime(inizioA);
                                    DateTime fi_A = dtf.parseDateTime(fineA);
                                    if (check.isEqual(in_A) || check.isEqual(fi_A) || (check.isAfter(in_A) && check.isBefore(fi_A))) {
                                        date_A.add(rs1.getString(1));
                                        if (print) {
                                            log.info("ADD A )" + rs1.getString(1));
                                        }
                                        continue;
                                    }
                                    DateTime in_B = dtf.parseDateTime(inizioB);
                                    if (check.isEqual(in_B) || check.isAfter(in_B)) {
                                        date_B.add(rs1.getString(1));
                                        if (print) {
                                            log.info("ADD B )" + rs1.getString(1));
                                        }
                                        continue;
                                    }
                                    if (fineB != null) {
                                        DateTime fi_B = dtf.parseDateTime(fineB);
                                        if (check.isEqual(fi_B) || check.isBefore(fi_B)) {
                                            date_B.add(rs1.getString(1));
                                            if (print) {
                                                log.info("ADD B )" + rs1.getString(1));
                                            }
                                        }
                                    }
                                }
                            }
                            rs1.close();
                            rs02.close();
                            st1.close();
                            st02.close();
                            db1.closeDB();
                            Iterator<String> it_a = date_A.iterator();
                            while (it_a.hasNext()) {
                                String day = it_a.next(); // must be called before you can call i.remove()
                                if (!giornidilezione.contains(day)) {
                                    it_a.remove();
                                }
                            }
                            Iterator<String> it_b = date_B.iterator();
                            while (it_b.hasNext()) {
                                String day = it_b.next(); // must be called before you can call i.remove()
                                if (!giornidilezione.contains(day)) {
                                    it_b.remove();
                                }
                            }

                            if (!date_A.isEmpty()) {
                                Database db2 = new Database();
                                StringBuilder add1;
                                try (Statement st2 = db2.getC().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE)) {
                                    add1 = new StringBuilder("");
                                    List<Items> pr_new = new ArrayList<>();
                                    date_A.forEach(day -> {
                                        try {
                                            String queryrs03 = "SELECT * FROM fad_track f WHERE f.room = '" + roomnamequery + "' "
                                                    + "AND f.date > '" + day + " 04:00' AND f.date < '" + day + " 23:00'"
                                                    + "ORDER BY f.date";
                                            ResultSet rs2 = st2.executeQuery(queryrs03);
                                            if (print) {
                                                log.info("5) " + queryrs03);
                                            }
                                            while (rs2.next()) {
                                                String tipoazione = rs2.getString(2);

                                                String azione = stripAccents(rs2.getString(4).toUpperCase().replaceAll(":", ";"));
                                                if (azione.contains("MESSAGGIO ->")) {
                                                    continue;
                                                }
                                                String date = convertTS_Italy(rs2.getString(5));

                                                if (tipoazione.equals("L1") || tipoazione.equals("L2") || tipoazione.equals("L3")) {

                                                    if (print) {
                                                        log.info("6) " + azione);
                                                    }
                                                    if (azione.startsWith("ALLIEVO")) {
                                                        try {

                                                            String id = azione.split(";")[1];

                                                            Items neet_1 = allievi.stream().filter(al -> al.getId().equals(id)).findFirst().get();

                                                            azione = azioni.stream().filter(az -> az.getId().equalsIgnoreCase(tipoazione)).findFirst().get().getDescr() + " -> "
                                                                    + neet_1.getDescr();
                                                            Track t1 = new Track("", tipoazione, azione, date, day);
                                                            tracking.add(t1);
                                                            pr_new.add(neet_1);
                                                            if (print && day.equals("2021-04-20")) {
                                                                log.info("TR) " + t1.toString());
                                                            }
                                                        } catch (Exception ex) {
                                                        }
                                                    } else if (azione.startsWith("DOCENTE")) {
                                                        try {
                                                            String id = azione.split(";")[1];
                                                            Items doc_1 = docenti.stream().filter(al -> al.getId().equals(id)).findFirst().get();
                                                            azione = azioni.stream().filter(az -> az.getId().equalsIgnoreCase(tipoazione)).findFirst().get().getDescr() + " -> "
                                                                    + doc_1.getDescr();
                                                            tracking.add(new Track("DOCENTE", tipoazione, azione, date, day));
                                                            pr_new.add(doc_1);
                                                        } catch (Exception ex) {
                                                        }
                                                    } else {
                                                        continue;
                                                    }
                                                } else if (tipoazione.equals("L5")) {

                                                    //USCITI TUTTI
//                                                    List<Items> t11 = pr_new.stream().distinct().collect(Collectors.toList());
//                                                    t11.forEach(u1 -> {
//                                                        Track t1 = new Track("", "L2", "Logout -> " + u1.getNome() + " " + u1.getCognome(), date, day);
//                                                        tracking.add(t1);
//                                                    });
                                                } else if (tipoazione.equals("L4")) {
//                                                try {
//                                                    String idfad = StringUtils.remove(azione, "USCITA PARTECIPANTE -> ").trim();
//                                                    String nomecogn = idutenti.stream().filter(ut -> ut.getId().equals(idfad)).findFirst().get().getDescr().toUpperCase();
//                                                    azione = "Logout -> " + nomecogn;
//                                                    Track t1 = new Track("", tipoazione, azione, date, day);
//                                                    tracking.add(t1);
//                                                    if (print && day.equals("2021-04-20")) {
//                                                        System.out.println("TR) " + t1.toString());
//                                                    }
//                                                } catch (NoSuchElementException ex) {
//                                                }
                                                } else if (tipoazione.equals("IN")) {
                                                    if (azione.startsWith("UTENTE LOGGATO CON ID")) {
                                                        String idfad = StringUtils.remove(azione.split("--")[0], "UTENTE LOGGATO CON ID").trim();
                                                        if (azione.split("--").length > 1) {
                                                            String nomecogn = azione.split("--")[1].trim().toUpperCase();
                                                            idutenti.add(new Items(idfad, nomecogn));
                                                        }
                                                        continue;
                                                    } else if (azione.startsWith("PARTECIPANTI") || azione.startsWith("NOME CAMBIATO")) {
                                                        continue;

                                                    } else if (azione.startsWith("AVATAR MODIFICATO")) {
                                                        try {
                                                            String idfad = Splitter.on("->").splitToList(azione).get(1).trim();
                                                            if (StringUtils.isNumeric(idfad)) {
                                                                if (pr_new.stream().filter(ut -> ut.getId().equals(idfad)).findAny().orElse(null) != null) {
                                                                    Items u1 = pr_new.stream().filter(ut -> ut.getId().equals(idfad)).findAny().get();
                                                                    Track t1 = new Track("", "L1", "Login -> " + u1.getNome() + " " + u1.getCognome(), date, day);
                                                                    tracking.add(t1);
                                                                }
                                                            } else {
                                                                if (idutenti.stream().filter(ut -> ut.getId().equals(idfad)).findAny().orElse(null) != null) {
                                                                    String nomecogn = idutenti.stream().filter(ut -> ut.getId().equals(idfad)).findFirst().get().getDescr().toUpperCase();
                                                                    Track t1 = new Track("", "L1", "Login -> " + nomecogn, date, day);
                                                                    tracking.add(t1);
                                                                }
                                                            }
                                                        } catch (Exception e1) {
                                                            log.severe(estraiEccezione(e1));
                                                        }
                                                    } else if (azione.startsWith("NUOVO PARTECIPANTE")) {
                                                        String nomecogn = azione.split("--")[1].trim().toUpperCase();

                                                        if (!nomecogn.contains("UNDEFINED")) {
                                                            String idfad = StringUtils.remove(azione.split("--")[0], "NUOVO PARTECIPANTE ->").trim();
                                                            idutenti.add(new Items(idfad, nomecogn));
                                                            Track t1 = new Track("", "L1", "Login -> " + nomecogn, date, day);
                                                            tracking.add(t1);

                                                        }
                                                        continue;
                                                    }
                                                }
                                                tracking.add(new Track("", tipoazione, azione, date, day));
                                            }
                                        } catch (Exception ex3) {
                                            log.severe(estraiEccezione(ex3));
                                        }
                                    });
                                }
                                db2.closeDB();
                                List<Track> finaltr = tracking.stream().distinct().collect(Collectors.toList());
                                AtomicInteger index = new AtomicInteger(1);
                                date_A.forEach(day -> {
                                    String giorno = dtf.parseDateTime(day).toString("dd/MM/yyyy");
                                    LinkedList<Presenti> presenti = new LinkedList<>();
                                    List<Track> daytr = finaltr.stream().filter(d -> d.getDay().equals(day)).collect(Collectors.toList());
                                    daytr.forEach(tr1 -> {
                                        if (print && tr1.getDate().contains("2021-04-20")) {
                                            log.info("N) " + tr1.toString());
                                        }
                                        boolean content = allievi.stream().anyMatch(al -> tr1.getDescr().contains(al.getDescr()));
                                        if (print && tr1.getDate().contains("2021-04-20")) {
                                            log.info(content + " - " + tr1.toString());
                                        }
                                        if (content) {
                                            Items a = allievi.stream().filter(al -> tr1.getDescr().contains(al.getDescr())).findAny().get();
                                            Items a1 = allievi_corretti.stream().filter(al -> al.getId().equals(a.getId())).findAny().get();
                                            Presenti pr1 = new Presenti(a1.getNome(), a1.getCognome(), a.getCf());

//                                            System.out.println("N) "+pr1.toString());
                                            if (tr1.getDescr().contains("Login")) {
                                                pr1.setLogin(true);
                                            } else if (tr1.getDescr().contains("Logout")) {
                                                pr1.setLogout(true);
                                            }

                                            String d1 = checkCalendar(tr1.getDate(), calendar, pr1);
                                            if (!d1.equals("")) {
                                                pr1.setDate(d1);
                                                presenti.add(pr1);
                                            }

//                                            if (tr1.getDescr().contains("MIRIAM") && tr1.getDate().contains("2020-11-25")) {
//                                                System.out.println("fase3) " + pr1.toString());
//                                            }
                                        }

                                        if (tr1.getUsertype().equals("DOCENTE")) {
                                            if (tr1.getDescr().contains("Login")) {
                                                if (!room.getNome().trim().contains(StringUtils.remove(tr1.getDescr(), "Login -> ").trim())) {
                                                    if (room.getNome().trim().equals("")) {
                                                        room.setNome(StringUtils.remove(tr1.getDescr(), "Login -> ").trim());
                                                    } else {
                                                        String nuovonome = room.getNome().trim() + ";" + StringUtils.remove(tr1.getDescr(), "Login -> ").trim();
                                                        room.setNome(nuovonome);
                                                    }
                                                }
                                            }
                                        }
                                    });

                                    List<String> dist_cf = presenti.stream().map(cf -> cf.getCf()).distinct().collect(Collectors.toList());

                                    dist_cf.forEach(tr1 -> {
                                        Presenti selected = presenti.stream().filter(cf -> cf.getCf().equals(tr1)).findFirst().get();

                                        List<Presenti> userp = presenti.stream().filter(d -> d.getCf().equals(tr1)).distinct().collect(Collectors.toList());

                                        List<Presenti> login = userp.stream().filter(d -> d.isLogin()).distinct().collect(Collectors.toList());

                                        List<Presenti> logout = userp.stream().filter(d -> d.isLogout()).distinct().collect(Collectors.toList());

                                        if (logout.isEmpty()) {
                                            if (!login.isEmpty()) {
//                                                login.forEach(ll -> {
//                                                    if (print && ll.getDate().contains("2021-04-20")) {
//                                                        System.out.println("R2) " + ll.toString());
//                                                    }
//                                                });

                                                Presenti pr1 = login.get(0);
                                                pr1.setLogin(false);
                                                pr1.setLogout(true);
                                                String d1 = checkCalendar(pr1.getDate().split(" ")[0] + " 23:00:00", calendar, pr1);
                                                if (!d1.equals("")) {
                                                    pr1.setDate(d1);
                                                    presenti.addLast(pr1);
                                                    userp.clear();
                                                    userp.addAll(presenti.stream().filter(d -> d.getCf().equals(tr1)).distinct().collect(Collectors.toList()));
                                                    userp.sort(Comparator.comparing(a -> a.getDate()));
                                                    logout = userp.stream().filter(d -> d.isLogout()).distinct().collect(Collectors.toList());
                                                }
                                            }
                                        }

                                        if (!login.isEmpty() && !logout.isEmpty()) {

                                            StringBuilder loginvalue = new StringBuilder();
                                            StringBuilder logoutvalue = new StringBuilder();

                                            LinkedList<Presenti> userp_final = new LinkedList<>();
                                            AtomicInteger ind = new AtomicInteger(0);
                                            userp.forEach(ba1 -> {

                                                if (ind.get() == 0) {
                                                    if (ba1.isLogin()) {
                                                        userp_final.add(ba1);
                                                    }
                                                } else {
                                                    if (userp_final.isEmpty()) {
                                                        userp_final.add(ba1);
                                                    } else {
                                                        Presenti precedente = userp_final.getLast();
                                                        if (precedente.isLogin() && !ba1.isLogin()) {

                                                            if (!precedente.getDate().equals(ba1.getDate())) {
                                                                userp_final.add(ba1);
                                                            }

                                                        } else if (precedente.isLogout() && !ba1.isLogout()) {
                                                            if (!precedente.getDate().equals(ba1.getDate())) {
                                                                userp_final.add(ba1);
                                                            }
                                                        } else if (precedente.isLogout() && ba1.isLogout()) {
                                                            userp_final.removeLast();
                                                            userp_final.add(ba1);
                                                        }
                                                    }
                                                }
                                                ind.addAndGet(1);
                                            });

                                            if ((userp_final.size() % 2) != 0) {
                                                userp_final.removeLast();
                                            }

                                            if (!userp_final.isEmpty()) {

                                                AtomicLong millis = new AtomicLong(0);
                                                userp_final.forEach(ba1 -> {
//                                                    System.out.println("S2) " + ba1.toString());
                                                    if (ba1.isLogin()) {
                                                        millis.addAndGet(-format(ba1.getDate().split("\\.")[0], pattern0).getMillis());
                                                        loginvalue.append(ba1.getDate().split(" ")[1].split("\\.")[0]).append("\n");
                                                    } else if (ba1.isLogout()) {
                                                        millis.addAndGet(format(ba1.getDate().split("\\.")[0], pattern0).getMillis());
                                                        logoutvalue.append(ba1.getDate().split(" ")[1].split("\\.")[0]).append("\n");
                                                    }
                                                });

                                                XSSFColor c1;
                                                if ((index.get() % 2) == 0) {
                                                    c1 = col1;
                                                } else {
                                                    c1 = col2;
                                                }

                                                long duratalogin = arrotonda(millis.get());
                                                long maxlezione = calcolaDurataLezione(day, calendar);
                                                if (duratalogin > maxlezione) {
                                                    duratalogin = maxlezione;
                                                }

                                                String duratacollegamento = calcoladurata(duratalogin);
                                                Hours time = new Hours(giorno,
                                                        selected.getNome().toUpperCase(),
                                                        selected.getCognome().toUpperCase(),
                                                        tr1,
                                                        loginvalue.toString().trim(),
                                                        logoutvalue.toString().trim(),
                                                        duratacollegamento, c1);
                                                time.setDocente(room.getNome());
                                                times_A.add(time);
                                                add1.append("OK");
                                            }
                                        }
                                    });
                                    if (!add1.toString().equals("")) {
                                        index.addAndGet(1);
                                    }
                                    add1.setLength(0);
                                });
                            }

                            if (!date_B.isEmpty()) {
                                Database db2 = new Database();
                                StringBuilder add1;
                                try (Statement st2 = db2.getC().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE)) {
                                    add1 = new StringBuilder("");
                                    List<Items> pr_newB = new ArrayList<>();
                                    date_B.forEach(day -> {
                                        try {
                                            String sql1 = "SELECT * FROM fad_track f WHERE f.room = '" + roomnamequery + "' "
                                                    + "AND f.date > '" + day + " 04:00' AND f.date < '" + day + " 23:00'"
                                                    + "ORDER BY f.date";
                                            ResultSet rs2 = st2.executeQuery(sql1);

                                            while (rs2.next()) {
                                                String tipoazione = rs2.getString(2);
                                                String azione = stripAccents(rs2.getString(4).toUpperCase().replaceAll(":", ";"));
                                                if (azione.contains("MESSAGGIO ->")) {
                                                    continue;
                                                }
                                                String date = convertTS_Italy(rs2.getString(5));

                                                switch (tipoazione) {
                                                    case "L1":
                                                    case "L2":
                                                    case "L3":
                                                        if (azione.startsWith("ALLIEVO")) {
                                                            try {
                                                                String id = azione.split(";")[1];
                                                                Items neet_2 = allievi.stream().filter(al -> al.getId().equals(id)).findFirst().get();
                                                                azione = azioni.stream().filter(az -> az.getId().equalsIgnoreCase(tipoazione)).findFirst().get().getDescr() + " -> "
                                                                        + neet_2.getDescr();
                                                                tracking.add(new Track("", tipoazione, azione, date, day));
                                                                pr_newB.add(neet_2);
                                                            } catch (Exception ex) {

                                                            }
                                                        } else if (azione.startsWith("DOCENTE")) {
                                                            try {
                                                                String id = azione.split(";")[1];
                                                                Items doc_2 = docenti.stream().filter(al -> al.getId().equals(id)).findFirst().get();
                                                                azione = azioni.stream().filter(az -> az.getId().equalsIgnoreCase(tipoazione)).findFirst().get().getDescr() + " -> "
                                                                        + doc_2.getDescr();
                                                                tracking.add(new Track("DOCENTE", tipoazione, azione, date, day));
                                                                pr_newB.add(doc_2);
                                                            } catch (Exception ex) {

                                                            }
                                                        } else {
                                                            continue;
                                                        }
                                                        break;
//                                                        //USCITI TUTTI
//                                                    List<Items> t11 = pr_newB.stream().distinct().collect(Collectors.toList());
//                                                    t11.forEach(u1 -> {
//                                                        Track t1 = new Track("", "L2", "Logout -> " + u1.getNome() + " " + u1.getCognome(), date, day);
//                                                        tracking.add(t1);
//                                                    });
                                                    //                                                try {
//                                                    String idfad = StringUtils.remove(azione, "USCITA PARTECIPANTE -> ").trim();
//                                                    String nomecogn = idutenti.stream().filter(ut -> ut.getId().equals(idfad)).findFirst().get().getDescr().toUpperCase();
//                                                    azione = "Logout -> " + nomecogn;
////                                                    System.out.println(azione);
//                                                    tracking.add(new Track("", tipoazione, azione, date, day));
//                                                } catch (NoSuchElementException ex) {
//
//                                                }
                                                    case "L5":
                                                        break;
                                                    case "L4":
                                                        break;
                                                    case "IN":
                                                        if (azione.startsWith("UTENTE LOGGATO CON ID")) {
                                                            String nomecogn = azione.split("--")[1].trim().toUpperCase();
                                                            String idfad = StringUtils.remove(azione.split("--")[0], "UTENTE LOGGATO CON ID").trim();
                                                            idutenti.add(new Items(idfad, nomecogn));
                                                            continue;
                                                        } else if (azione.startsWith("PARTECIPANTI") || azione.startsWith("NOME CAMBIATO")) {
                                                            continue;
                                                        } else if (azione.startsWith("AVATAR MODIFICATO")) {
                                                            try {
                                                                String idfad = Splitter.on("->").splitToList(azione).get(1).trim();
                                                                if (StringUtils.isNumeric(idfad)) {
                                                                    if (pr_newB.stream().filter(ut -> ut.getId().equals(idfad)).findAny().orElse(null) != null) {
                                                                        Items u1 = pr_newB.stream().filter(ut -> ut.getId().equals(idfad)).findAny().get();
                                                                        Track t1 = new Track("", "L1", "Login -> " + u1.getNome() + " " + u1.getCognome(), date, day);
                                                                        tracking.add(t1);
                                                                    }
                                                                } else {
                                                                    if (idutenti.stream().filter(ut -> ut.getId().equals(idfad)).findAny().orElse(null) != null) {
                                                                        String nomecogn = idutenti.stream().filter(ut -> ut.getId().equals(idfad)).findFirst().get().getDescr().toUpperCase();
                                                                        Track t1 = new Track("", "L1", "Login -> " + nomecogn, date, day);
                                                                        tracking.add(t1);
                                                                    }
                                                                }
                                                            } catch (Exception ex) {
                                                                log.severe(estraiEccezione(ex));
                                                            }
                                                        } else if (azione.startsWith("NUOVO PARTECIPANTE")) {
                                                            String nomecogn = azione.split("--")[1].trim().toUpperCase();
                                                            if (!nomecogn.contains("UNDEFINED")) {
                                                                String idfad = StringUtils.remove(azione.split("--")[0], "NUOVO PARTECIPANTE ->").trim();
                                                                idutenti.add(new Items(idfad, nomecogn));
                                                                tracking.add(new Track("", "L1", "Login -> " + nomecogn, date, day));
//                                                        if (nomecogn.contains("DAVIDE")) {
//                                                            System.out.println("TR) " + nomecogn);
//                                                        }
                                                            }
                                                            continue;
                                                        }
                                                        break;
                                                    default:
                                                        break;
                                                }
                                                tracking.add(new Track("", tipoazione, azione, date, day));
                                            }
                                        } catch (Exception ex) {
                                            log.severe(estraiEccezione(ex));
                                        }
                                    });
                                }
                                db2.closeDB();
                                List<Track> finaltr = tracking.stream().distinct().collect(Collectors.toList());

//                                allievi.forEach(st4 -> {
//                                    System.out.println(st4.getDescr());
//                                });
                                AtomicInteger index = new AtomicInteger(1);
                                date_B.forEach(day -> {

                                    String giorno = dtf.parseDateTime(day).toString("dd/MM/yyyy");
                                    LinkedList<Presenti> presenti = new LinkedList<>();
                                    List<Track> daytr = finaltr.stream().filter(d -> d.getDay().equals(day)).collect(Collectors.toList());
                                    daytr.forEach(tr1 -> {
//                                        if(tr1.getDate().contains("2020-08-12")){
//                                        System.out.println("A) "+tr1);
//                                        }

                                        boolean content = allievi.stream().anyMatch(al -> tr1.getDescr().contains(al.getDescr()));
//                                        if (tr1.getDescr().contains("DAVIDE")) {
//                                            System.out.println(content + " B) " + tr1);
//                                        }
                                        if (content) {

//                                            if (tr1.getDate().contains("2020-08-12")) {
//                                                System.out.println("B) " + tr1);
//                                            }
                                            Items a = allievi.stream().filter(al -> tr1.getDescr().contains(al.getDescr())).findAny().get();
                                            Items a1 = allievi_corretti.stream().filter(al -> al.getId().equals(a.getId())).findAny().get();
                                            Presenti pr1 = new Presenti(a1.getNome(), a1.getCognome(), a.getCf());

                                            if (tr1.getDescr().contains("Login")) {
                                                pr1.setLogin(true);
                                            } else if (tr1.getDescr().contains("Logout")) {
                                                pr1.setLogout(true);
                                            }
                                            String d1 = checkCalendar(tr1.getDate(), calendar, pr1);
                                            if (!d1.equals("")) {
                                                pr1.setDate(d1);
                                                presenti.add(pr1);
                                            }
//                                            System.out.println("C) "+pr1);
                                        }
                                        if (tr1.getUsertype().equals("DOCENTE")) {
                                            if (tr1.getDescr().contains("Login")) {
                                                if (!room.getNome().trim().contains(StringUtils.remove(tr1.getDescr(), "Login -> ").trim())) {
                                                    if (room.getNome().trim().equals("")) {
                                                        room.setNome(StringUtils.remove(tr1.getDescr(), "Login -> ").trim());
                                                    } else {
                                                        String nuovonome = room.getNome().trim() + ";" + StringUtils.remove(tr1.getDescr(), "Login -> ").trim();
                                                        room.setNome(nuovonome);
                                                    }
                                                }
                                            }
                                        }
                                    });
                                    List<String> dist_cf = presenti.stream().map(cf -> cf.getCf()).distinct().collect(Collectors.toList());
                                    dist_cf.forEach(tr1 -> {

                                        Presenti selected = presenti.stream().filter(cf -> cf.getCf().equals(tr1)).findFirst().get();
                                        List<Presenti> userp = presenti.stream().filter(d -> d.getCf().equals(tr1)).distinct().collect(Collectors.toList());
                                        List<Presenti> login = userp.stream().filter(d -> d.isLogin()).distinct().collect(Collectors.toList());
                                        List<Presenti> logout = userp.stream().filter(d -> d.isLogout()).distinct().collect(Collectors.toList());

                                        if (logout.isEmpty()) {
                                            if (!login.isEmpty()) {
                                                Presenti pr1 = login.get(0);
                                                pr1.setLogin(false);
                                                pr1.setLogout(true);
                                                String d1 = checkCalendar(pr1.getDate().split(" ")[0] + " 23:00:00", calendar, pr1);
                                                if (!d1.equals("")) {
                                                    pr1.setDate(d1);
                                                    presenti.addLast(pr1);
                                                    userp.clear();
                                                    userp.addAll(presenti.stream().filter(d -> d.getCf().equals(tr1)).distinct().collect(Collectors.toList()));
                                                    userp.sort(Comparator.comparing(a -> a.getDate()));
                                                    logout = userp.stream().filter(d -> d.isLogout()).distinct().collect(Collectors.toList());
                                                }
                                            }
                                        }

                                        if (!login.isEmpty() && !logout.isEmpty()) {
                                            StringBuilder loginvalue = new StringBuilder();
                                            StringBuilder logoutvalue = new StringBuilder();
                                            LinkedList<Presenti> userp_final = new LinkedList<>();
                                            AtomicInteger ind = new AtomicInteger(0);
                                            userp.forEach(ba1 -> {
                                                if (ind.get() == 0) {
                                                    if (ba1.isLogin()) {
                                                        userp_final.add(ba1);
                                                    }
                                                } else {
                                                    if (userp_final.isEmpty()) {
                                                        userp_final.add(ba1);
                                                    } else {
                                                        Presenti precedente = userp_final.getLast();
                                                        if (precedente.isLogin() && !ba1.isLogin()) {
                                                            if (!precedente.getDate().equals(ba1.getDate())) {
                                                                userp_final.add(ba1);
                                                            }
                                                        } else if (precedente.isLogout() && !ba1.isLogout()) {
                                                            if (!precedente.getDate().equals(ba1.getDate())) {
                                                                userp_final.add(ba1);
                                                            }
                                                        } else if (precedente.isLogout() && ba1.isLogout()) {
                                                            userp_final.removeLast();
                                                            userp_final.add(ba1);
                                                        }
                                                    }
                                                }
                                                ind.addAndGet(1);
                                            });

                                            if ((userp_final.size() % 2) != 0) {
                                                userp_final.removeLast();
                                            }

                                            if (!userp_final.isEmpty()) {

                                                AtomicLong millis = new AtomicLong(0);
                                                userp_final.forEach(ba1 -> {
                                                    if (ba1.isLogin()) {
                                                        millis.addAndGet(-format(ba1.getDate().split("\\.")[0], pattern0).getMillis());
                                                        loginvalue.append(ba1.getDate().split(" ")[1].split("\\.")[0]).append("\n");
                                                    } else if (ba1.isLogout()) {
                                                        millis.addAndGet(format(ba1.getDate().split("\\.")[0], pattern0).getMillis());
                                                        logoutvalue.append(ba1.getDate().split(" ")[1].split("\\.")[0]).append("\n");
                                                    }
                                                });
                                                XSSFColor c1;
                                                if ((index.get() % 2) == 0) {
                                                    c1 = col1;
                                                } else {
                                                    c1 = col2;
                                                }
                                                long duratalogin = arrotonda(millis.get());
                                                long maxlezione = calcolaDurataLezione(day, calendar);
                                                if (duratalogin > maxlezione) {
                                                    duratalogin = maxlezione;
                                                }
                                                String duratacollegamento = calcoladurata(duratalogin);

                                                Hours time = new Hours(giorno, selected.getNome().toUpperCase(), selected.getCognome().toUpperCase(), tr1,
                                                        loginvalue.toString().trim(),
                                                        logoutvalue.toString().trim(),
                                                        duratacollegamento, c1);
                                                time.setDocente(room.getNome());
                                                times_B.add(time);
                                                add1.append("OK");
//                                            }
                                            }
                                        }
                                    });
                                    if (!add1.toString().equals("")) {
                                        index.addAndGet(1);
                                    }
                                    add1.setLength(0);
                                });
                            }
                            XSSFSheet sheet = workbook.createSheet("FAD Report - Stanza " + roomname);
                            XSSFRow row = get(sheet, 0);
                            XSSFCell cell1 = get(row, 1);
                            cell1.setCellValue("FAD Progetto Formativo: ");
                            cell1.setCellStyle(headerCellStyle);
                            sheet.addMergedRegion(new CellRangeAddress(0, 0, 1, 3));
                            XSSFCell cell3 = get(row, 4);
                            cell3.setCellValue(nome);
                            cell3.setCellStyle(headerCellStyle);
                            sheet.addMergedRegion(new CellRangeAddress(0, 0, 4, 7));

                            row = get(sheet, 1);
                            XSSFCell cell2a = get(row, 1);
                            cell2a.setCellValue("Docenti: ");
                            cell2a.setCellStyle(headerCellStyle);
                            sheet.addMergedRegion(new CellRangeAddress(1, 1, 1, 3));
                            XSSFCell cell3a = get(row, 4);
                            cell3a.setCellValue(room.getNome());
                            cell3a.setCellStyle(headerCellStyle);
                            sheet.addMergedRegion(new CellRangeAddress(1, 1, 4, 7));

                            AtomicInteger in = new AtomicInteger(2);
                            if (!times_A.isEmpty()) {
                                ok.addAndGet(1);
                                XSSFRow row_f = get(sheet, in.get());
                                XSSFCell cell_f = get(row_f, 1);
                                cell_f.setCellValue("FASE A");
                                headerCellStyle.setAlignment(HorizontalAlignment.CENTER);
                                cell_f.setCellStyle(headerCellStyle);
                                sheet.addMergedRegion(new CellRangeAddress(in.get(), in.get(), 1, 7));
                                in.addAndGet(1);
                                row = get(sheet, in.get());
                                cell1 = get(row, 1);
                                cell1.setCellValue("Data");
                                cell1.setCellStyle(headerCellStyle);
                                XSSFCell cell2 = get(row, 2);
                                cell2.setCellValue("Nome");
                                cell2.setCellStyle(headerCellStyle);
                                cell3 = get(row, 3);
                                cell3.setCellValue("Cognome");
                                cell3.setCellStyle(headerCellStyle);
                                XSSFCell cell4 = get(row, 4);
                                cell4.setCellValue("Codice Fiscale");
                                cell4.setCellStyle(headerCellStyle);
                                XSSFCell cell5 = get(row, 5);
                                cell5.setCellValue("Orari Login");
                                cell5.setCellStyle(headerCellStyle);
                                XSSFCell cell6 = get(row, 6);
                                cell6.setCellValue("Orari Logout");
                                cell6.setCellStyle(headerCellStyle);
                                XSSFCell cell7 = get(row, 7);
                                cell7.setCellValue("Totale Ore");
                                cell7.setCellStyle(headerCellStyle);
                                in.addAndGet(1);
                                times_A.forEach(exc -> {
                                    XSSFCellStyle normCellStyle = workbook.createCellStyle();
                                    normCellStyle.setBorderBottom(BorderStyle.THIN);
                                    normCellStyle.setBottomBorderColor(IndexedColors.BLACK.getIndex());
                                    normCellStyle.setBorderLeft(BorderStyle.THIN);
                                    normCellStyle.setLeftBorderColor(IndexedColors.BLACK.getIndex());
                                    normCellStyle.setBorderRight(BorderStyle.THIN);
                                    normCellStyle.setRightBorderColor(IndexedColors.BLACK.getIndex());
                                    normCellStyle.setBorderTop(BorderStyle.THIN);
                                    normCellStyle.setTopBorderColor(IndexedColors.BLACK.getIndex());
                                    normCellStyle.setWrapText(true);
                                    normCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                                    normCellStyle.setFont(normFont);
                                    normCellStyle.setFillForegroundColor(exc.getColor());
                                    normCellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                                    XSSFRow row1 = get(sheet, in.get());
                                    XSSFCell cell_c1 = get(row1, 1);
                                    cell_c1.setCellValue(exc.getGiorno());
                                    cell_c1.setCellStyle(normCellStyle);
                                    XSSFCell cell_c2 = get(row1, 2);
                                    cell_c2.setCellValue(exc.getNome());
                                    cell_c2.setCellStyle(normCellStyle);
                                    XSSFCell cell_c3 = get(row1, 3);
                                    cell_c3.setCellValue(exc.getCognome());
                                    cell_c3.setCellStyle(normCellStyle);
                                    XSSFCell cell_c4 = get(row1, 4);
                                    cell_c4.setCellValue(exc.getCf());
                                    cell_c4.setCellStyle(normCellStyle);
                                    XSSFCell cell_c5 = get(row1, 5);
                                    cell_c5.setCellValue(exc.getLogindate());
                                    cell_c5.setCellStyle(normCellStyle);
                                    XSSFCell cell_c6 = get(row1, 6);
                                    cell_c6.setCellValue(exc.getLogoutdate());
                                    cell_c6.setCellStyle(normCellStyle);
                                    XSSFCell cell_c7 = get(row1, 7);
                                    cell_c7.setCellValue(exc.getMillisecondtime());
                                    cell_c7.setCellStyle(normCellStyle);
                                    in.addAndGet(1);
                                });
                                in.addAndGet(1);
                                in.addAndGet(1);
                                in.addAndGet(1);
                            }
                            if (!times_B.isEmpty()) {
                                ok.addAndGet(1);
                                XSSFRow row_f = get(sheet, in.get());
                                XSSFCell cell_f = get(row_f, 1);
                                cell_f.setCellValue("FASE B");
                                headerCellStyle.setAlignment(HorizontalAlignment.CENTER);
                                cell_f.setCellStyle(headerCellStyle);
                                sheet.addMergedRegion(new CellRangeAddress(in.get(), in.get(), 1, 7));
                                in.addAndGet(1);
                                row = get(sheet, in.get());
                                cell1 = get(row, 1);
                                cell1.setCellValue("Data");
                                cell1.setCellStyle(headerCellStyle);
                                XSSFCell cell2 = get(row, 2);
                                cell2.setCellValue("Nome");
                                cell2.setCellStyle(headerCellStyle);
                                cell3 = get(row, 3);
                                cell3.setCellValue("Cognome");
                                cell3.setCellStyle(headerCellStyle);
                                XSSFCell cell4 = get(row, 4);
                                cell4.setCellValue("Codice Fiscale");
                                cell4.setCellStyle(headerCellStyle);
                                XSSFCell cell5 = get(row, 5);
                                cell5.setCellValue("Orari Login");
                                cell5.setCellStyle(headerCellStyle);
                                XSSFCell cell6 = get(row, 6);
                                cell6.setCellValue("Orari Logout");
                                cell6.setCellStyle(headerCellStyle);
                                XSSFCell cell7 = get(row, 7);
                                cell7.setCellValue("Totale Ore");
                                cell7.setCellStyle(headerCellStyle);
                                in.addAndGet(1);
                                times_B.forEach(exc -> {
                                    XSSFCellStyle normCellStyle = workbook.createCellStyle();
                                    normCellStyle.setBorderBottom(BorderStyle.THIN);
                                    normCellStyle.setBottomBorderColor(IndexedColors.BLACK.getIndex());
                                    normCellStyle.setBorderLeft(BorderStyle.THIN);
                                    normCellStyle.setLeftBorderColor(IndexedColors.BLACK.getIndex());
                                    normCellStyle.setBorderRight(BorderStyle.THIN);
                                    normCellStyle.setRightBorderColor(IndexedColors.BLACK.getIndex());
                                    normCellStyle.setBorderTop(BorderStyle.THIN);
                                    normCellStyle.setTopBorderColor(IndexedColors.BLACK.getIndex());
                                    normCellStyle.setWrapText(true);
                                    normCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                                    normCellStyle.setFont(normFont);
                                    normCellStyle.setFillForegroundColor(exc.getColor());
                                    normCellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                                    XSSFRow row1 = get(sheet, in.get());
                                    XSSFCell cell_c1 = get(row1, 1);
                                    cell_c1.setCellValue(exc.getGiorno());
                                    cell_c1.setCellStyle(normCellStyle);
                                    XSSFCell cell_c2 = get(row1, 2);
                                    cell_c2.setCellValue(exc.getNome());
                                    cell_c2.setCellStyle(normCellStyle);
                                    XSSFCell cell_c3 = get(row1, 3);
                                    cell_c3.setCellValue(exc.getCognome());
                                    cell_c3.setCellStyle(normCellStyle);
                                    XSSFCell cell_c4 = get(row1, 4);
                                    cell_c4.setCellValue(exc.getCf());
                                    cell_c4.setCellStyle(normCellStyle);
                                    XSSFCell cell_c5 = get(row1, 5);
                                    cell_c5.setCellValue(exc.getLogindate());
                                    cell_c5.setCellStyle(normCellStyle);
                                    XSSFCell cell_c6 = get(row1, 6);
                                    cell_c6.setCellValue(exc.getLogoutdate());
                                    cell_c6.setCellStyle(normCellStyle);
                                    XSSFCell cell_c7 = get(row1, 7);
                                    cell_c7.setCellValue(exc.getMillisecondtime());
                                    cell_c7.setCellStyle(normCellStyle);
                                    in.addAndGet(1);
                                });
                                in.addAndGet(1);
                                in.addAndGet(1);
                                in.addAndGet(1);
                            }
                            setBordersToMergedCells(sheet);
                            sheet.autoSizeColumn(1, true);
                            sheet.autoSizeColumn(2, true);
                            sheet.autoSizeColumn(3, true);
                            sheet.autoSizeColumn(4, true);
                            sheet.autoSizeColumn(5, true);
                            sheet.autoSizeColumn(6, true);
                            sheet.autoSizeColumn(7, true);
                        }
                    } catch (Exception ex) {
                        log.severe(estraiEccezione(ex));
                    }
                });
                if (ok.get() > 0) {
                    if (!new File(pathtemp).exists()) {
                        new File(pathtemp).mkdirs();
                    }

                    File out = new File(pathtemp + "Progetto_" + idpr + "_reportFAD_temp_" + Utility.getRandomString(10) + ".xlsx");
                    try (FileOutputStream fileOut = new FileOutputStream(out)) {
                        workbook.write(fileOut);
                        Database db1 = new Database();
                        String update = "UPDATE documenti_progetti SET path='" + out.getPath() + "' WHERE tipo=30 AND idprogetto=" + idpr;
                        try (Statement st = db1.getC().createStatement()) {
                            st.executeUpdate(update);
                        } catch (Exception ex) {
                            log.severe(estraiEccezione(ex));
                        }
                        db1.closeDB();
                    }
//                    String base64 = new String(Base64.encodeBase64(FileUtils.readFileToByteArray(out)));
                    log.info("GENERATO: " + out.getPath());
//                    }
//                    out.delete();
                    return out;
                }
            }
        } catch (Exception ex) {
            log.severe(estraiEccezione(ex));
        }

        return null;
    }

}
