using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Windows.Forms;
using System.Numerics;

namespace WindowsFormsApplication1.Classes {
    /// <summary>
    /// Interface which tracks the CNC head, displays is past and future paths.
    /// </summary>
    public partial class HeadMonitor : UserControl {
        /// <summary>
        /// 
        /// </summary>
        private int instruction;
        public Vector3[] currentPattern;

        public Queue<Vector3[]> patternList;

        private int crosshairRadius = 5;

        Stopwatch timer;
        float instructionPeriod;

        public bool running;

        public HeadMonitor() {

            InitializeComponent();
            patternList = new Queue<Vector3[]>();
            currentPattern = new Vector3[] { };
            timer = new Stopwatch();
            DoubleBuffered = true;
        }
        Pen blackPen = new Pen(Color.Black);
        Pen greenPen = new Pen(Color.LightGreen);
        Pen bluePen = new Pen(Color.Blue);
        
        public void PaintSelf(PaintEventArgs e) {
            
            Graphics g = e.Graphics;
            if (currentPattern.Any()) {
                //drawing Structure
                int i = 0;
                while (i < instruction) {
                    g.DrawLine(blackPen, (float)currentPattern[i].X, (float)currentPattern[i].Y, (float)currentPattern[i + 1].X, (float)currentPattern[i + 1].Y);
                    i++;
                }
                Pen pen = greenPen;
                while (i < currentPattern.Length - 1) {
                    g.DrawLine(pen, (float)currentPattern[i].X, (float)currentPattern[i].Y, (float)currentPattern[i + 1].X, (float)currentPattern[i + 1].Y);
                    pen = bluePen;
                    i++;
                }
                //crosshair
                if (running) {
                    Vector3 crosshair = instruction == -1 ? currentPattern[0] : Vector3.Lerp(currentPattern[instruction], currentPattern[instruction + 1], (float)timer.ElapsedMilliseconds / (1000 * instructionPeriod));
                    g.DrawLine(blackPen, crosshair.X + crosshairRadius, crosshair.Y, crosshair.X - crosshairRadius, crosshair.Y);
                    g.DrawLine(blackPen, crosshair.X, crosshair.Y + crosshairRadius, crosshair.X, crosshair.Y - crosshairRadius);
                }
            } else {
                g.DrawString("No Program Loaded", Font, Brushes.Black, 0, 0);


            }
            Invalidate();
            
            
        }
        
        public void NextInstruction() {
            if (running) {
                if (currentPattern.Length > instruction + 2) {
                    instruction++;
                    instructionPeriod = Form1.GetInstructionTime(currentPattern[instruction]-currentPattern[instruction+1]);
                    timer.Restart();

                    // if end of program, switch to new pattern or wait for pattern.
                } else {
                    Console.WriteLine("MISTAKE HAS OCCURED");
                }
            }
        }

        public void LoadProgram(Vector3[] pattern) {
            instruction = -1;
            currentPattern = pattern;
        }

        public bool Start() {
            if (currentPattern.Any()) {
                running = true;
                instructionPeriod = 1;
                return true;
            }
            return false;
        }

        public void Stop() {
            instruction = -1;
            running = false;
            if (patternList.Any()) {
                LoadProgram(patternList.Dequeue());
            } else {
                currentPattern = new Vector3[] { };
            }
        }

        private void HeadMonitor_Load(object sender, EventArgs e) {

        }
    }
}
