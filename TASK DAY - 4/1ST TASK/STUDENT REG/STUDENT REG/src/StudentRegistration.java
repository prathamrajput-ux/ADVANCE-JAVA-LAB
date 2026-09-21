import java.awt.event.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.swing.*;

public class StudentRegistration extends JFrame implements ActionListener {
    // Component Declarations
    private JLabel headingLabel, nameLabel, ageLabel, branchLabel, rollNoLabel, genderLabel;
    private JTextField nameTextField, ageTextField, branchTextField, rollNoTextField;
    private JRadioButton maleRadioButton, femaleRadioButton;
    private ButtonGroup genderGroup;
    private JCheckBox termsCheckBox;
    private JButton submitButton, resetButton;

    // Database Credentials (Apne MySQL username/password ke hisaab se update karein)
    private static final String DB_URL = "jdbc:mysql://localhost:3306/registration";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "2703"; 

    public StudentRegistration() {
        // Frame Settings
        setTitle("Student Registration Form");
        setBounds(300, 90, 450, 500);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setResizable(false);
        setLayout(null);

        // Heading
        headingLabel = new JLabel("Student Registration Form");
        headingLabel.setBounds(120, 20, 220, 30);
        add(headingLabel);

        // Name
        nameLabel = new JLabel("Name:");
        nameLabel.setBounds(50, 70, 100, 30);
        add(nameLabel);

        nameTextField = new JTextField();
        nameTextField.setBounds(160, 70, 200, 30);
        add(nameTextField);

        // Age
        ageLabel = new JLabel("Age:");
        ageLabel.setBounds(50, 110, 100, 30);
        add(ageLabel);

        ageTextField = new JTextField();
        ageTextField.setBounds(160, 110, 200, 30);
        add(ageTextField);

        // Roll No
        rollNoLabel = new JLabel("Roll No:");
        rollNoLabel.setBounds(50, 150, 100, 30);
        add(rollNoLabel);

        rollNoTextField = new JTextField();
        rollNoTextField.setBounds(160, 150, 200, 30);
        add(rollNoTextField);

        // Branch
        branchLabel = new JLabel("Branch:");
        branchLabel.setBounds(50, 190, 100, 30);
        add(branchLabel);

        branchTextField = new JTextField();
        branchTextField.setBounds(160, 190, 200, 30);
        add(branchTextField);

        // Gender
        genderLabel = new JLabel("Gender:");
        genderLabel.setBounds(50, 230, 100, 30);
        add(genderLabel);

        maleRadioButton = new JRadioButton("Male");
        maleRadioButton.setBounds(160, 230, 70, 30);
        add(maleRadioButton);

        femaleRadioButton = new JRadioButton("Female");
        femaleRadioButton.setBounds(240, 230, 80, 30);
        add(femaleRadioButton);

        genderGroup = new ButtonGroup();
        genderGroup.add(maleRadioButton);
        genderGroup.add(femaleRadioButton);

        // Terms
        termsCheckBox = new JCheckBox("Accept Terms and Conditions");
        termsCheckBox.setBounds(100, 280, 250, 30);
        add(termsCheckBox);

        // Buttons
        submitButton = new JButton("Submit");
        submitButton.setBounds(80, 340, 100, 30);
        submitButton.addActionListener(this);
        add(submitButton);

        resetButton = new JButton("Reset");
        resetButton.setBounds(220, 340, 100, 30);
        resetButton.addActionListener(this);
        add(resetButton);

        setVisible(true);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if (e.getSource() == resetButton) {
            resetFields();
        } else if (e.getSource() == submitButton) {
            // 1. Validation Logic
            if (nameTextField.getText().trim().isEmpty() ||
                ageTextField.getText().trim().isEmpty() ||
                rollNoTextField.getText().trim().isEmpty() ||
                branchTextField.getText().trim().isEmpty()) {
                
                JOptionPane.showMessageDialog(this, "Please fill in all fields.", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }

            if (!maleRadioButton.isSelected() && !femaleRadioButton.isSelected()) {
                JOptionPane.showMessageDialog(this, "Please select Gender.", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }

            if (!termsCheckBox.isSelected()) {
                JOptionPane.showMessageDialog(this, "Please accept Terms and Conditions.", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }

            // 2. Extract Values
            String name = nameTextField.getText().trim();
            int age;
            try {
                age = Integer.parseInt(ageTextField.getText().trim());
            } catch (NumberFormatException ex) {
                JOptionPane.showMessageDialog(this, "Age must be a valid number.", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }
            
            String rollNo = rollNoTextField.getText().trim();
            String branch = branchTextField.getText().trim();
            String gender = maleRadioButton.isSelected() ? "Male" : "Female";

            // 3. Database Insertion Logic (JDBC)
            String query = "INSERT INTO student_records (roll_no, name, age, branch, gender) VALUES (?, ?, ?, ?, ?)";

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement stmt = conn.prepareStatement(query)) {

                stmt.setString(1, rollNo);
                stmt.setString(2, name);
                stmt.setInt(3, age);
                stmt.setString(4, branch);
                stmt.setString(5, gender);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    JOptionPane.showMessageDialog(this, "Data Saved Successfully in MySQL Database!", "Success", JOptionPane.INFORMATION_MESSAGE);
                    resetFields();
                }

            } catch (SQLException ex) {
                ex.printStackTrace();
                JOptionPane.showMessageDialog(this, "Database Error: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void resetFields() {
        nameTextField.setText("");
        ageTextField.setText("");
        rollNoTextField.setText("");
        branchTextField.setText("");
        genderGroup.clearSelection();
        termsCheckBox.setSelected(false);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new StudentRegistration());
    }
}