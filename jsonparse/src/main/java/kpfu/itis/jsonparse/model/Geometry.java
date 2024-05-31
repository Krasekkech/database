package kpfu.itis.jsonparse.model;
import lombok.Getter;
import lombok.Setter;

@Getter@Setter
public class Geometry {
    String type;
    double[][] coordinates;
}
