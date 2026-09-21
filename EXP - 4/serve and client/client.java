import java.io.*;
import java.net.*;

public class client {
    public static void main(String[] args) {
        try {
            Socket socket = new Socket("localhost", 5000);
            System.out.println("Connected to server");

            BufferedReader input = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            PrintWriter output = new PrintWriter(socket.getOutputStream(), true);
            BufferedReader userInput = new BufferedReader(new InputStreamReader(System.in));

            System.out.print("Enter a message to send to the server: ");
            String message = userInput.readLine();
            output.println(message);

            String response = input.readLine();
            System.out.println("Server response: " + response);

            socket.close();
        } catch (IOException e) {
            System.out.println("Client error: " + e.getMessage());
        }

        System.out.println("Client is running...");
    }
}