import serial
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from collections import deque

# ----------------------------
# UART Configuration
# ----------------------------
PORT = "COM4"
BAUD = 115200

ser = serial.Serial(PORT, BAUD, timeout=0.1)

# ----------------------------
# Plot Buffer
# ----------------------------
BUFFER_SIZE = 200
samples = deque([0] * BUFFER_SIZE, maxlen=BUFFER_SIZE)

fig, ax = plt.subplots(figsize=(10,4))
line, = ax.plot(samples)

ax.set_title("Live Waveform from Basys 3")
ax.set_xlabel("Sample Number")
ax.set_ylabel("Amplitude")

ax.set_ylim(0, 255)
ax.set_xlim(0, BUFFER_SIZE)

def update(frame):

    while ser.in_waiting > 0:
        value = ser.read(1)

        if value:
            samples.append(value[0])

    line.set_ydata(samples)

    return line,

ani = FuncAnimation(
    fig,
    update,
    interval=20,
    blit=True,
    cache_frame_data=False
)

plt.show()

ser.close()
