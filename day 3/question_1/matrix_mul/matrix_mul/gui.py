import tkinter as tk
from tkinter import messagebox
import serial, struct

PORT = "COM5"   # change to your Basys3's COM port
BAUD = 115200
OPCODES = {"ADD": 1, "MUL": 2, "TRANSPOSE": 3}

class MatrixGUI:
    def __init__(self, root):
        self.root = root
        root.title("Matrix Accelerator")
        self.entries_a = self.make_frame("Matrix A", 0)
        self.entries_b = self.make_frame("Matrix B", 6)
        self.op = tk.StringVar(value="ADD")
        f = tk.LabelFrame(root, text="Operation")
        f.grid(row=12, column=0, columnspan=5, pady=5)
        for o in OPCODES:
            tk.Radiobutton(f, text=o, variable=self.op, value=o).pack(side="left", padx=5)
        tk.Button(root, text="Send", command=self.send, bg="lightgreen").grid(
            row=13, column=0, columnspan=5, pady=5
        )
        self.result = self.make_frame("Result", 14, editable=False)

    def make_frame(self, title, row, editable=True):
        f = tk.LabelFrame(self.root, text=title)
        f.grid(row=row, column=0, columnspan=5, padx=5, pady=5)
        entries = []
        for r in range(5):
            row_entries = []
            for c in range(5):
                if editable:
                    e = tk.Entry(f, width=5, justify="center")
                    e.insert(0, "0")
                else:
                    e = tk.Label(f, width=5, relief="sunken", bg="white")
                    e["text"] = "0"
                e.grid(row=r, column=c, padx=2, pady=2)
                row_entries.append(e)
            entries.append(row_entries)
        return entries

    def read_matrix(self, entries):
        vals = []
        for r in range(5):
            for c in range(5):
                try:
                    vals.append(int(entries[r][c].get()))
                except ValueError:
                    messagebox.showerror("Input error", f"Bad value at ({r},{c})")
                    return None
        return vals

    def send(self):
        matA = self.read_matrix(self.entries_a)
        matB = self.read_matrix(self.entries_b)
        if matA is None or matB is None:
            return

        opcode = OPCODES[self.op.get()]

        try:
            ser = serial.Serial(PORT, BAUD, timeout=2)
            packet = bytearray([opcode])
            for v in matA:
                packet += struct.pack(">h", v)
            for v in matB:
                packet += struct.pack(">h", v)
            ser.write(packet)

            resp = ser.read(50)
            ser.close()

            if len(resp) != 50:
                messagebox.showerror("Error", f"Only received {len(resp)} bytes")
                return

            values = struct.unpack(">25h", resp)
            idx = 0
            for r in range(5):
                for c in range(5):
                    self.result[r][c]["text"] = str(values[idx])
                    idx += 1

        except serial.SerialException as e:
            messagebox.showerror("Serial error", str(e))


if __name__ == "__main__":
    root = tk.Tk()
    MatrixGUI(root)
    root.mainloop()