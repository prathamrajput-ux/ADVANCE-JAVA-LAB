import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JOptionPane;

public class ControllerCalculator implements ActionListener {

    private ViewsCalculator vc;
    private ModelCalculator mc;

    ControllerCalculator(ViewsCalculator vc, ModelCalculator mc) {
        this.mc = mc;
        this.vc = vc;

        vc.addButton.addActionListener(this);
        vc.subButton.addActionListener(this);
        vc.mulButton.addActionListener(this);
        vc.divButton.addActionListener(this);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        double a;
        double b;
        try {
            a = Double.parseDouble(vc.aTextField.getText().trim());
            b = Double.parseDouble(vc.bTextField.getText().trim());
        } catch (NumberFormatException ex) {
            JOptionPane.showMessageDialog(vc, "Please enter valid numbers in both fields.", "Input Error", JOptionPane.ERROR_MESSAGE);
            return;
        }

        double res = 0;
        if (e.getSource() == vc.addButton) {
            res = mc.add(a, b);
        } else if (e.getSource() == vc.subButton) {
            res = mc.sub(a, b);
        } else if (e.getSource() == vc.mulButton) {
            res = mc.mul(a, b);
        } else if (e.getSource() == vc.divButton) {
            if (b == 0) {
                JOptionPane.showMessageDialog(vc, "Cannot divide by zero.", "Math Error", JOptionPane.ERROR_MESSAGE);
                return;
            }
            res = mc.div(a, b);
        }

        vc.resultTextField.setText(String.valueOf(res));
    }
}