import java.rmi.Naming;

public class Client {
    public static void main(String[] args) {
        try {
            Calculator obj = (Calculator) Naming.lookup("rmi://localhost/Calculator");

            System.out.println("Addition = " + obj.add(10, 20));

            System.out.println("Subtraction = " + obj.subtract(20, 10));
        } catch (Exception e) {
            System.out.println(e);
        }
    }
}