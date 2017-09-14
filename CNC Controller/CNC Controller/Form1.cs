using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO.Ports;
using System.Numerics;
using WindowsFormsApplication1.Classes;
using System.IO;

namespace WindowsFormsApplication1 {
    public partial class Form1 : Form {

        bool debug = true;
        public Vector3[] data1;

        public const float maxSpeed = 30f; // mm/s
        public static Queue<string> InstructionList;
        public Form1() {
            InitializeComponent();
            InstructionList = new Queue<string>();

            AddRandomPrograms();
            Debug1.Enabled = debug;
        }
        private void AddRandomPrograms() {
            Random r = new Random();
            int programLength = 5;
            int programNum = 5;
            for (int i = 0; i < programNum; i++) {

                Vector3[] data = new Vector3[5];
                for (int j = 0; j < programLength; j++) {
                    data[j] = new Vector3((float)r.NextDouble() * 400, (float)r.NextDouble() * 400, (float)r.NextDouble() * 400);
                }
                AddProgram(data, r.Next().ToString());


            }


        }

        private void Form1_Load(object sender, EventArgs e) {
            string[] portnames = SerialPort.GetPortNames();
            Array.Sort(portnames);
            foreach (string name in portnames) {
                if (!portSelector.Items.Contains(name)) {
                    portSelector.Items.Add(name);
                }
            }
        }
        
        /* Will play ping pong with the arduino.
         * Program will send a start message to the arduino. After that, Ardunio will acknowledge and up to 16 instructions will be sent to the arduino. 
         *
         */
        private void AddProgram(Vector3[] pattern, string filename) {
            runButton.Enabled = true;
            programMonitor.AppendText(filename + "\r\n");
            Vector3 old = pattern[0];
            Vector3 curr;
            if (!headMonitor.currentPattern.Any()) {
                headMonitor.LoadProgram(pattern);
            } else {
                headMonitor.patternList.Enqueue(pattern);
            }
            InstructionList.Enqueue("<");
            for (int i = 1; i < pattern.Length; i++) {
                curr = pattern[i];
                Vector3 diff = old - curr;
                float time = GetInstructionTime(diff);
                InstructionList.Enqueue(String.Format("{0},{1},{2},{3}", diff.X, diff.Y, diff.Z, time));
                old = curr;
            }
            InstructionList.Enqueue(">");
        }
        //messages arduino to initialise program. Comms loop is event based, so this will continue automatically
        private bool RunProgram() {
            //enable and disable components
            headMonitor.Start();
            runButton.Enabled = false;
            stopButton.Enabled = true;
            portSelector.Enabled = false;

            //the first instruction is split from the rest and given to the runningmonitor while the rest stay in the
            string[] splitInstructions = programMonitor.Text.Split(new char[] { '\n' }, 2);
            if (splitInstructions.Length == 2) {
                runningProgramMonitor.Text = splitInstructions[0];
                programMonitor.Text = splitInstructions[1];
                Console.WriteLine(programMonitor.Text);
            } else {
                runningProgramMonitor.Clear();
            }

            //Instructions will be discarded until a start indicator is found.
            if (!InstructionList.Any()) {
                return false;
            }
            try {
                while (InstructionList.Peek() != "<") {
                    Console.WriteLine("**WARNING: " + InstructionList.Dequeue() + " DISCARDED**");
                    if (!InstructionList.Any()) {
                        throw new InvalidProgramException("Program malformed - Start indicator not detected");
                    }
                }
                SerialWrite(InstructionList.Dequeue());
            } catch (InvalidProgramException e) {
                Console.WriteLine(e.Message);
                return false;
            }
            return true;

        }
        private bool StopProgram() {
            headMonitor.Stop();
            arduino.Close();
            portSelector.Enabled = true;
            runningProgramMonitor.Text = "";

            if (InstructionList.Any()) {
                runButton.Enabled = true;
            }
            stopButton.Enabled = false;
            return true;
        }

        private void SubmitFileLocation(object sender, KeyEventArgs e) {
            if (e.KeyCode == Keys.Enter) {
                Console.WriteLine("Files not implemented yet!");
            }
        }
        private void runButton_Click(object sender, EventArgs e) {
            RunProgram();
        }
        private void stopButton_Click(object sender, EventArgs e) {
            StopProgram();
        }

        private void portSelector_SelectedIndexChanged(object sender, EventArgs e) {
            arduino.Close();
            arduino.PortName = portSelector.Text;
        }

        private void arduino_DataReceived(object sender, SerialDataReceivedEventArgs e) {
            int missingInstructions = int.Parse(e.ToString());
            for (int i = 0; i < missingInstructions; i++) {
                if (InstructionList.Any()) {
                    SerialWrite(InstructionList.Dequeue());
                    headMonitor.NextInstruction();
                } else {
                    arduino.Write("!");
                }
            }
        }
        private void arduino_DataReceived(string e) {
            int missingInstructions = int.Parse(e);
            instructionMonitor.AppendText("I:" + e + "\n");
            if (headMonitor.running) {
                for (int i = 0; i < missingInstructions; i++) {
                    if (InstructionList.Any()) {
                        if (InstructionList.Peek() == ">") {
                            StopProgram();
                        } else { 
                            headMonitor.NextInstruction();
                        }
                        SerialWrite(InstructionList.Dequeue() + "\n");

                    } else {
                        Console.WriteLine("!");
                    }
                }
            }
        }


        private void SerialWrite(string message) {
            if (!debug) {
                arduino.Write(message);
            }
            instructionMonitor.AppendText("O:" +message + "\n");
        }
        public static float GetInstructionTime(float x, float y, float z) {
            return  (float)Math.Sqrt(x * x + y * y + z * z)/maxSpeed;
        }
        public static float GetInstructionTime(Vector3 v) {
            return v.Length()/maxSpeed;
        }

        private void button1_Click(object sender, EventArgs e) {
            arduino_DataReceived("1");
        }

        private void button2_Click(object sender, EventArgs e) {
            AddRandomPrograms();
        }

        private void headMonitor_Paint(object sender, PaintEventArgs e) {
            headMonitor.PaintSelf(e);
        }

        //In charge of turning a linechain map into an instruction set.
        private void LoadFile(object sender, EventArgs e) {

            List<Vector3> pointlist = new List<Vector3>();
            
            try {
                string filetext = File.ReadAllText(fileLocationTextBox.Text).Trim(); ;

                Console.WriteLine(filetext);
                string[] pointdata = filetext.Split('*');
                foreach (string point in pointdata) {
                    string[] components = point.Split(',');
                    Console.WriteLine(components.ToString());
                    if(components.Length == 3) { 
                        pointlist.Add(new Vector3(float.Parse(components[0]), float.Parse(components[1]), float.Parse(components[2])));
                    }
                }
                AddProgram(pointlist.ToArray<Vector3>(),fileLocationTextBox.Text);
                fileLocationTextBox.Clear();
            } catch (FileNotFoundException) {
                Console.WriteLine("File Not Found.");
                return;
            }
        }
    }
}