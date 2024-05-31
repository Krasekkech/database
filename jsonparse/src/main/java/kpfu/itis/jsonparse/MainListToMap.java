package kpfu.itis.jsonparse;

import com.fasterxml.jackson.databind.ObjectMapper;
import kpfu.itis.jsonparse.model.TrasportDataBase;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class MainListToMap {

    public static void main(String[] args) throws IOException {

        List<TestData> list = new ArrayList<>();
        list.add(new TestData("1",2));
        list.add(new TestData("1",2));
        list.add(new TestData("2",3));
        list.add(new TestData("1",1));
        list.add(new TestData("3",5));
        list.add(new TestData("2",6));
        list.add(new TestData("3",4));
        list.add(new TestData("1",3));

        Map<String, Integer> map = list.stream().collect(Collectors.toMap(
                d -> d.name,
                d -> d.count,
                (a,b) -> a + b
        ));

        map.forEach((a,b) -> System.out.println(a + " : " + b));
    }

    static class TestData {
        public String name;
        public Integer count;

        public TestData(String name, Integer count) {
            this.name = name;
            this.count = count;
        }
    }
}
