/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rc.soop.util;

/**
 *
 * @author rcosco
 */
import rc.soop.db.Entity;
import javax.net.ssl.HttpsURLConnection;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.net.URL;
import org.json.JSONObject;

/**
 * Recaptcha V3 - Java Example
 */
public class GoogleRecaptcha {

    public static boolean isValid(String clientRecaptchaResponse) {
        try {
            Entity e = new Entity();
            final String RECAPTCHA_SERVICE_URL = "https://www.google.com/recaptcha/api/siteverify";
            final String SECRET_KEY = e.getPath("googlePrivateKey");
            e.close();
            if (clientRecaptchaResponse == null || "".equals(clientRecaptchaResponse)) {
                return false;
            }
            URL obj = new URL(RECAPTCHA_SERVICE_URL);
            HttpsURLConnection con = (HttpsURLConnection) obj.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
            String postParams
                    = "secret=" + SECRET_KEY
                    + "&response=" + clientRecaptchaResponse;

            con.setDoOutput(true);
            DataOutputStream wr = new DataOutputStream(con.getOutputStream());
            wr.writeBytes(postParams);
            wr.flush();
            wr.close();

            BufferedReader in = new BufferedReader(new InputStreamReader(
                    con.getInputStream()));
            String inputLine;
            StringBuilder response = new StringBuilder();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
            JSONObject json = new JSONObject(response.toString());

            Boolean success = (Boolean) json.get("success");
            BigDecimal score = (BigDecimal) json.get("score");

            boolean ctrl1 = success;
            boolean ctrl2 = score.doubleValue() >= 0.5;
            return (ctrl1 && ctrl2);
        } catch (Exception ex) {
            Utility.log.severe(Utility.estraiEccezione(ex));
            return false;
        }

    }
}
