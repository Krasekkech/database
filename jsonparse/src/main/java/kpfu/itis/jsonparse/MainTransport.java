package kpfu.itis.jsonparse;

import com.fasterxml.jackson.databind.ObjectMapper;
import kpfu.itis.jsonparse.model.*;

import java.io.File;
import java.io.IOException;

public class MainTransport {

    public static void main(String[] args) throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        TrasportDataBase dataBase =
                mapper.readValue(new File("C:\\Users\\kechk\\IdeaProjects\\database\\jsonparse\\src\\main\\java\\kpfu\\itis\\jsonparse\\transport.json"), TrasportDataBase.class);




    }
}
