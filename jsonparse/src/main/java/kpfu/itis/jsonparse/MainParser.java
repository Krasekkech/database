package kpfu.itis.jsonparse;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import org.json.JSONArray;
import org.json.JSONObject;

public class MainParser {
    public static void main(String[] args) {
        try {

            String filePath = "C:\\Users\\kechk\\IdeaProjects\\database\\jsonparse\\src\\main\\java\\kpfu\\itis\\jsonparse\\transport.json";

            // Чтение файла
            BufferedReader reader = new BufferedReader(new FileReader(filePath));
            StringBuilder jsonString = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonString.append(line);
            }
            reader.close();


            JSONObject jsonObject = new JSONObject(jsonString.toString());

            try (Connection connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "2203")) {
                JSONObject dataObject = jsonObject.getJSONObject("data");
                JSONArray vehiclesArray = dataObject.getJSONArray("vehicles");

                for (int i = 0; i < vehiclesArray.length(); i++) {
                    JSONObject vehicleObject = vehiclesArray.getJSONObject(i);
                    JSONObject metaDataObject = vehicleObject.getJSONObject("properties").getJSONObject("VehicleMetaData");

                    String id = metaDataObject.getString("id");
                    String threadId = metaDataObject.getJSONObject("Transport").getString("threadId");
                    String lineId = metaDataObject.getJSONObject("Transport").getString("lineId");
                    String name = metaDataObject.getJSONObject("Transport").getString("name");
                    String type = metaDataObject.getJSONObject("Transport").getString("type");
                    String uri = metaDataObject.getJSONObject("Transport").getString("uri");
                    String seoname = metaDataObject.getJSONObject("Transport").getString("seoname");

                    String insertVehicleQuery = "INSERT INTO Vehicles (id, threadId, lineId, name, type, uri, seoname) VALUES (?, ?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement statement = connection.prepareStatement(insertVehicleQuery)) {
                        statement.setString(1, id);
                        statement.setString(2, threadId);
                        statement.setString(3, lineId);
                        statement.setString(4, name);
                        statement.setString(5, type);
                        statement.setString(6, uri);
                        statement.setString(7, seoname);
                        statement.executeUpdate();
                    }
                    JSONArray featuresArray = vehicleObject.getJSONArray("features");
                    for (int j = 0;  j < featuresArray.length(); j++) {
                        JSONObject featureObject = featuresArray.getJSONObject(j);
                        JSONObject trajectorySegmentMetaData = featureObject.getJSONObject("properties").getJSONObject("TrajectorySegmentMetaData");
                        int featureId = j + 1;
                        int duration = trajectorySegmentMetaData.getInt("duration");
                        int time = trajectorySegmentMetaData.getInt("time");

                        String insertFeaturesQuery = "INSERT INTO Features (id, duration, time) VALUES (?,?,?)";
                        try (PreparedStatement statement = connection.prepareStatement(insertFeaturesQuery)) {
                            statement.setString(1, id);
                            statement.setString(2, String.valueOf(featureId));
                            statement.setString(3, String.valueOf(duration));
                            statement.setString(4, String.valueOf(time));
                            statement.executeUpdate();
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
