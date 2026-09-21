import javax.swing.*;

public class ViewsCalculator extends JFrame {

    public JLabel headingLabel, aLabel, bLabel, resultLabel;
    public JTextField aTextField, bTextField, resultTextField;
    public JButton addButton, subButton, mulButton, divButton;

    ViewsCalculator() {

        setTitle("Calculator");
        setBounds(300, 90, 420, 360);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setResizable(false);
        setLayout(null);

        headingLabel = new JLabel("CALCULATOR");
        headingLabel.setBounds(150, 20, 120, 30);
        add(headingLabel);

        aLabel = new JLabel("ENTER A:");
        aLabel.setBounds(50, 70, 100, 30);
        add(aLabel);

        aTextField = new JTextField();
        aTextField.setBounds(150, 70, 200, 30);
        add(aTextField);

        bLabel = new JLabel("ENTER B:");
        bLabel.setBounds(50, 120, 100, 30);
        add(bLabel);

        bTextField = new JTextField();
        bTextField.setBounds(150, 120, 200, 30);
        add(bTextField);

        addButton = new JButton("+");
        addButton.setBounds(50, 180, 70, 40);
        add(addButton);

        subButton = new JButton("-");
        subButton.setBounds(130, 180, 70, 40);
        add(subButton);

        mulButton = new JButton("*");
        mulButton.setBounds(210, 180, 70, 40);
        add(mulButton);

        divButton = new JButton("/");
        divButton.setBounds(290, 180, 70, 40);
        add(divButton);

        resultLabel = new JLabel("RESULT:");
        resultLabel.setBounds(50, 240, 100, 30);
        add(resultLabel);

        resultTextField = new JTextField();
        resultTextField.setBounds(150, 240, 200, 30);
        resultTextField.setEditable(false);
        add(resultTextField);

        setVisible(true);
    }
}