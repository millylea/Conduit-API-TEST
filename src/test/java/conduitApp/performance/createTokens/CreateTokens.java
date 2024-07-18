package conduitApp.performance.createTokens;
import java.util.ArrayList;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.HashMap;
import com.intuit.karate.Runner;


public class CreateTokens {
    private static final ArrayList<String> tokens = new ArrayList<>();
    private static final AtomicInteger counter = new AtomicInteger();
    private static String[] emails = {
        "kardemo1@test.com",
        "kardemo2@test.com",
        "kardemo3@test.com",
    };
    
    public static String getNextToken(){
        return tokens.get(counter.getAndIncrement() % tokens.size());
    }

    public static void createAccessTokens(){
        for (String email: emails){ 

            Map<String, Object> account = new HashMap<>();
            account.put("userEmail", email);
            account.put("userPassword", "Welcome1");
            account.put("apiURL", "https://api.realworld.io/api/");
            Map<String, Object> result = Runner.runFeature("classpath:helpers/CreateToken.feature", account, false);
            tokens.add(result.get("authtoken").toString());
        }
    }
}