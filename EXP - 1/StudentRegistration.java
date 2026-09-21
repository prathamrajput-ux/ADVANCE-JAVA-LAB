import javax.swing.*;
import java.awt.event.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class StudentRegistration extends JFrame implements ActionListener {
    
    private JLabel headingLabel, nameLabel, ageLabel, branchLabel, rollNoLabel, genderLabel;
    private JTextField nameTextField, ageTextField, branchTextField, rollNoTextField;
    private JRadioButton maleRadioButton, femaleRadioButton;
    private ButtonGroup genderGroup;
    private JCheckBox termsCheckBox;
    private JButton submitButton, resetButton;
    private static final String INSERT_STUDENT_SQL =
            "INSERT INTO students (name, age, roll_no, branch, gender) VALUES (?, ?, ?, ?, ?)";

    public StudentRegistration() {
        
        setTitle("Student Registration Form");
        setBounds(300, 90, 420, 430);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setResizable(false);
        setLayout(null);

        headingLabel = new JLabel("Student Registration Form");
        headingLabel.setBounds(130, 20, 200, 30);
        add(headingLabel);

        nameLabel = new JLabel("Name:");
        nameLabel.setBounds(50, 60, 100, 30);
        add(nameLabel);

        nameTextField = new JTextField();
        nameTextField.setBounds(160, 60, 200, 30);
        add(nameTextField);

        ageLabel = new JLabel("Age:");
        ageLabel.setBounds(50, 100, 100, 30);
        add(ageLabel);

        ageTextField = new JTextField();
        ageTextField.setBounds(160, 100, 200, 30);
        add(ageTextField);

        rollNoLabel = new JLabel("Roll No:");
        rollNoLabel.setBounds(50, 140, 100, 30);
        add(rollNoLabel);

        rollNoTextField = new JTextField();
        rollNoTextField.setBounds(160, 140, 200, 30);
        add(rollNoTextField);

        branchLabel = new JLabel("Branch:");
        branchLabel.setBounds(50, 180, 100, 30);
        add(branchLabel);

        branchTextField = new JTextField();
        branchTextField.setBounds(160, 180, 200, 30);
        add(branchTextField);

        genderLabel = new JLabel("Gender:");
        genderLabel.setBounds(50, 220, 100, 30);
        add(genderLabel);

        maleRadioButton = new JRadioButton("Male");
        maleRadioButton.setBounds(160, 220, 70, 30);
        add(maleRadioButton);

        femaleRadioButton = new JRadioButton("Female");
        femaleRadioButton.setBounds(240, 220, 80, 30);
        add(femaleRadioButton);

        genderGroup = new ButtonGroup();
        genderGroup.add(maleRadioButton);
        genderGroup.add(femaleRadioButton);

        termsCheckBox = new JCheckBox("Accept Terms and Conditions");
        termsCheckBox.setBounds(100, 265, 220, 30);
        add(termsCheckBox);

        submitButton = new JButton("Submit");
        submitButton.setBounds(85, 315, 100, 30);
        submitButton.addActionListener(this);
        add(submitButton);

        resetButton = new JButton("Reset");
        resetButton.setBounds(215, 315, 100, 30);
        resetButton.addActionListener(this);
        add(resetButton);

        setVisible(true);
    }

    private void clearFields() {
        nameTextField.setText("");
        ageTextField.setText("");
        rollNoTextField.setText("");
        branchTextField.setText("");
        genderGroup.clearSelection();
        termsCheckBox.setSelected(false);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if (e.getSource() == resetButton) {
            clearFields();
        } else if (e.getSource() == submitButton) {
            if (nameTextField.getText().trim().isEmpty()) {
                JOptionPane.showMessageDialog(this, "Please enter your Name.", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }

            String ageInput = ageTextField.getText().trim();
            if (ageInput.isEmpty()) {
                JOptionPane.showMessageDialog(this, "Please enter your Age.", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }
            try {
                int age = Integer.parseInt(ageInput);
                if (age < 0 || age > 100) {
                    JOptionPane.showMessageDialog(this, "Age must be between 0 and 100.", "Error", JOptionPane.ERROR_MESSAGE);
                    return;
                }
            } catch (NumberFormatException ex) {
                JOptionPane.showMessageDialog(this, "Please enter a valid numeric Age.", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }

            if (rollNoTextField.getText().trim().isEmpty()) {
                JOptionPane.showMessageDialog(this, "Please enter your Roll No.", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }
            if (branchTextField.getText().trim().isEmpty()) {
                JOptionPane.showMessageDialog(this, "Please enter your Branch.", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }
            if (!maleRadioButton.isSelected() && !femaleRadioButton.isSelected()) {
                JOptionPane.showMessageDialog(this, "Please select your Gender.", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }
            if (!termsCheckBox.isSelected()) {
                JOptionPane.showMessageDialog(this, "Please accept the Terms and Conditions.", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }

            String name = nameTextField.getText().trim();
            int age = Integer.parseInt(ageInput);
            String rollNo = rollNoTextField.getText().trim();
            String branch = branchTextField.getText().trim();
            String gender = maleRadioButton.isSelected() ? "Male" : "Female";

            try (Connection connection = DBConnection.getConnection();
                 PreparedStatement statement = connection.prepareStatement(INSERT_STUDENT_SQL)) {
                statement.setString(1, name);
                statement.setInt(2, age);
                statement.setString(3, rollNo);
                statement.setString(4, branch);
                statement.setString(5, gender);

                statement.executeUpdate();

                String details = "Registration Successful!\n\n" +
                        "Name: " + name + "\n" +
                        "Age: " + age + "\n" +
                        "Roll No: " + rollNo + "\n" +
                        "Branch: " + branch + "\n" +
                        "Gender: " + gender;

                JOptionPane.showMessageDialog(this, details, "Success", JOptionPane.INFORMATION_MESSAGE);
                clearFields();
            } catch (SQLException ex) {
                JOptionPane.showMessageDialog(
                        this,
                        "Database Error: " + ex.getMessage(),
                        "Error",
                        JOptionPane.ERROR_MESSAGE
                );
            }

        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new StudentRegistration());
    }
}