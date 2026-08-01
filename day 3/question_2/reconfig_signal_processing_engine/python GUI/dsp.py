import sys
import serial
import threading
from collections import deque

from PyQt5.QtWidgets import (
    QApplication,
    QWidget,
    QPushButton,
    QLabel,
    QVBoxLayout,
    QHBoxLayout,
)

from PyQt5.QtCore import QTimer

import pyqtgraph as pg

# ----------------------------
# UART Configuration
# ----------------------------

PORT = "COM3"      # Change if needed
BAUD = 115200

ser = serial.Serial(PORT, BAUD, timeout=1)

# Buffer for plotting
samples = deque(maxlen=300)


class DSP_GUI(QWidget):

    def __init__(self):

        super().__init__()

        self.setWindowTitle("Reconfigurable DSP Engine")

        self.resize(900, 500)

        # Graph
        self.graph = pg.PlotWidget()
        self.graph.setYRange(-10, 300)
        self.graph.showGrid(x=True, y=True)

        self.curve = self.graph.plot(pen='y')

        # Buttons

        self.avg_btn = QPushButton("Moving Average")

        self.fir_btn = QPushButton("FIR Filter")

        self.peak_btn = QPushButton("Peak Detector")

        self.status = QLabel("Connected")

        # Layout

        buttons = QHBoxLayout()

        buttons.addWidget(self.avg_btn)
        buttons.addWidget(self.fir_btn)
        buttons.addWidget(self.peak_btn)

        layout = QVBoxLayout()

        layout.addWidget(self.graph)
        layout.addLayout(buttons)
        layout.addWidget(self.status)

        self.setLayout(layout)

        # Button actions

        self.avg_btn.clicked.connect(lambda: self.send_command('1'))
        self.fir_btn.clicked.connect(lambda: self.send_command('2'))
        self.peak_btn.clicked.connect(lambda: self.send_command('3'))

        # Graph refresh timer

        self.timer = QTimer()

        self.timer.timeout.connect(self.update_graph)

        self.timer.start(50)

        # UART thread

        self.thread = threading.Thread(target=self.read_uart)

        self.thread.daemon = True

        self.thread.start()

    # ------------------------
    # Send RM Selection
    # ------------------------

    def send_command(self, cmd):

        ser.write(cmd.encode())

        if cmd == '1':
            self.status.setText("Moving Average Active")

        elif cmd == '2':
            self.status.setText("FIR Filter Active")

        elif cmd == '3':
            self.status.setText("Peak Detector Active")

    # ------------------------
    # UART Receive Thread
    # ------------------------

    def read_uart(self):

        while True:

            try:

                line = ser.readline().decode().strip()

                if line != "":

                    value = int(line)

                    samples.append(value)

            except:
                pass

    # ------------------------
    # Update Graph
    # ------------------------

    def update_graph(self):

        self.curve.setData(list(samples))


app = QApplication(sys.argv)

window = DSP_GUI()

window.show()

sys.exit(app.exec_())
