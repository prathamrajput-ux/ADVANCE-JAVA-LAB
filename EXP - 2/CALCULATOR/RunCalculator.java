import javax.swing.*;

public class RunCalculator {

    public static void main(String[] args) {
        ViewsCalculator vc = new ViewsCalculator();
        ModelCalculator mc = new ModelCalculator();
        new ControllerCalculator(vc, mc);
    }
}