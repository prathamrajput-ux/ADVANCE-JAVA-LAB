import java.io.*;
import java.net.*;

public class server {
    public static void main(String[] args) {
        try {
            ServerSocket serverSocket = new ServerSocket(5000);
            System.out.println("Server is waiting for client request...");

            while (true) {
                Socket socket = serverSocket.accept();
                System.out.println("Client connected");

                BufferedReader input = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                PrintWriter output = new PrintWriter(socket.getOutputStream(), true);

                String message = input.readLine();
                System.out.println("Received from client: " + message);

                output.println("Message received by server");
                socket.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}