namespace WindowsFormsApplication1 {
    partial class Form1 {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing) {
            if (disposing && (components != null)) {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent() {
            this.components = new System.ComponentModel.Container();
            this.label1 = new System.Windows.Forms.Label();
            this.Debug2 = new System.Windows.Forms.Button();
            this.runningProgramMonitor = new System.Windows.Forms.TextBox();
            this.programLabel = new System.Windows.Forms.Label();
            this.queueLabel = new System.Windows.Forms.Label();
            this.loadLabel = new System.Windows.Forms.Label();
            this.programMonitor = new System.Windows.Forms.TextBox();
            this.loadButton = new System.Windows.Forms.Button();
            this.Debug1 = new System.Windows.Forms.Button();
            this.fileLocationLabel = new System.Windows.Forms.Label();
            this.fileLocationTextBox = new System.Windows.Forms.TextBox();
            this.portSelector = new System.Windows.Forms.ComboBox();
            this.stopButton = new System.Windows.Forms.Button();
            this.runButton = new System.Windows.Forms.Button();
            this.bindingSource1 = new System.Windows.Forms.BindingSource(this.components);
            this.portSelectorLabel = new System.Windows.Forms.Label();
            this.instructionMonitor = new System.Windows.Forms.TextBox();
            this.arduino = new System.IO.Ports.SerialPort(this.components);
            this.headMonitor = new WindowsFormsApplication1.Classes.HeadMonitor();
            ((System.ComponentModel.ISupportInitialize)(this.bindingSource1)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(231, 287);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(39, 13);
            this.label1.TabIndex = 33;
            this.label1.Text = "Debug";
            // 
            // Debug2
            // 
            this.Debug2.Location = new System.Drawing.Point(231, 336);
            this.Debug2.Name = "Debug2";
            this.Debug2.Size = new System.Drawing.Size(75, 42);
            this.Debug2.TabIndex = 32;
            this.Debug2.Text = "Add Program";
            this.Debug2.UseVisualStyleBackColor = true;
            this.Debug2.Click += new System.EventHandler(this.button2_Click);
            // 
            // runningProgramMonitor
            // 
            this.runningProgramMonitor.BackColor = System.Drawing.Color.WhiteSmoke;
            this.runningProgramMonitor.Location = new System.Drawing.Point(12, 94);
            this.runningProgramMonitor.Name = "runningProgramMonitor";
            this.runningProgramMonitor.ReadOnly = true;
            this.runningProgramMonitor.Size = new System.Drawing.Size(294, 20);
            this.runningProgramMonitor.TabIndex = 31;
            // 
            // programLabel
            // 
            this.programLabel.AutoSize = true;
            this.programLabel.Location = new System.Drawing.Point(12, 78);
            this.programLabel.Name = "programLabel";
            this.programLabel.Size = new System.Drawing.Size(95, 13);
            this.programLabel.TabIndex = 30;
            this.programLabel.Text = "Running Program: ";
            // 
            // queueLabel
            // 
            this.queueLabel.AutoSize = true;
            this.queueLabel.Location = new System.Drawing.Point(12, 120);
            this.queueLabel.Name = "queueLabel";
            this.queueLabel.Size = new System.Drawing.Size(95, 13);
            this.queueLabel.TabIndex = 29;
            this.queueLabel.Text = "Queued Programs:";
            // 
            // loadLabel
            // 
            this.loadLabel.AutoSize = true;
            this.loadLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.loadLabel.Location = new System.Drawing.Point(100, 9);
            this.loadLabel.Name = "loadLabel";
            this.loadLabel.Size = new System.Drawing.Size(109, 20);
            this.loadLabel.TabIndex = 28;
            this.loadLabel.Text = "Load Program";
            // 
            // programMonitor
            // 
            this.programMonitor.AcceptsReturn = true;
            this.programMonitor.BackColor = System.Drawing.Color.WhiteSmoke;
            this.programMonitor.Location = new System.Drawing.Point(12, 136);
            this.programMonitor.Multiline = true;
            this.programMonitor.Name = "programMonitor";
            this.programMonitor.ReadOnly = true;
            this.programMonitor.Size = new System.Drawing.Size(294, 132);
            this.programMonitor.TabIndex = 27;
            // 
            // loadButton
            // 
            this.loadButton.Location = new System.Drawing.Point(231, 48);
            this.loadButton.Name = "loadButton";
            this.loadButton.Size = new System.Drawing.Size(75, 23);
            this.loadButton.TabIndex = 26;
            this.loadButton.Text = "Load";
            this.loadButton.UseVisualStyleBackColor = true;
            this.loadButton.Click += new System.EventHandler(this.LoadFile);
            // 
            // Debug1
            // 
            this.Debug1.Location = new System.Drawing.Point(231, 306);
            this.Debug1.Name = "Debug1";
            this.Debug1.Size = new System.Drawing.Size(75, 23);
            this.Debug1.TabIndex = 25;
            this.Debug1.Text = "Step";
            this.Debug1.UseVisualStyleBackColor = true;
            this.Debug1.Click += new System.EventHandler(this.button1_Click);
            // 
            // fileLocationLabel
            // 
            this.fileLocationLabel.AutoSize = true;
            this.fileLocationLabel.Location = new System.Drawing.Point(12, 53);
            this.fileLocationLabel.Name = "fileLocationLabel";
            this.fileLocationLabel.Size = new System.Drawing.Size(51, 13);
            this.fileLocationLabel.TabIndex = 23;
            this.fileLocationLabel.Text = "Location:";
            // 
            // fileLocationTextBox
            // 
            this.fileLocationTextBox.Location = new System.Drawing.Point(66, 50);
            this.fileLocationTextBox.Name = "fileLocationTextBox";
            this.fileLocationTextBox.Size = new System.Drawing.Size(159, 20);
            this.fileLocationTextBox.TabIndex = 22;
            // 
            // portSelector
            // 
            this.portSelector.FormattingEnabled = true;
            this.portSelector.Location = new System.Drawing.Point(47, 306);
            this.portSelector.Name = "portSelector";
            this.portSelector.Size = new System.Drawing.Size(121, 21);
            this.portSelector.TabIndex = 21;
            this.portSelector.SelectedIndexChanged += new System.EventHandler(this.portSelector_SelectedIndexChanged);
            // 
            // stopButton
            // 
            this.stopButton.Location = new System.Drawing.Point(93, 418);
            this.stopButton.Name = "stopButton";
            this.stopButton.Size = new System.Drawing.Size(75, 23);
            this.stopButton.TabIndex = 20;
            this.stopButton.Text = "Stop";
            this.stopButton.UseVisualStyleBackColor = true;
            this.stopButton.Click += new System.EventHandler(this.stopButton_Click);
            // 
            // runButton
            // 
            this.runButton.Location = new System.Drawing.Point(12, 418);
            this.runButton.Name = "runButton";
            this.runButton.Size = new System.Drawing.Size(75, 23);
            this.runButton.TabIndex = 19;
            this.runButton.Text = "Run";
            this.runButton.UseVisualStyleBackColor = true;
            this.runButton.Click += new System.EventHandler(this.runButton_Click);
            // 
            // portSelectorLabel
            // 
            this.portSelectorLabel.AutoSize = true;
            this.portSelectorLabel.Location = new System.Drawing.Point(12, 309);
            this.portSelectorLabel.Name = "portSelectorLabel";
            this.portSelectorLabel.Size = new System.Drawing.Size(29, 13);
            this.portSelectorLabel.TabIndex = 24;
            this.portSelectorLabel.Text = "Port:";
            // 
            // instructionMonitor
            // 
            this.instructionMonitor.BackColor = System.Drawing.Color.WhiteSmoke;
            this.instructionMonitor.Location = new System.Drawing.Point(312, 9);
            this.instructionMonitor.Multiline = true;
            this.instructionMonitor.Name = "instructionMonitor";
            this.instructionMonitor.ReadOnly = true;
            this.instructionMonitor.Size = new System.Drawing.Size(287, 434);
            this.instructionMonitor.TabIndex = 18;
            // 
            // headMonitor
            // 
            this.headMonitor.Location = new System.Drawing.Point(615, 12);
            this.headMonitor.Name = "headMonitor";
            this.headMonitor.Size = new System.Drawing.Size(507, 434);
            this.headMonitor.TabIndex = 34;
            this.headMonitor.Paint += new System.Windows.Forms.PaintEventHandler(this.headMonitor_Paint);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1125, 455);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.Debug2);
            this.Controls.Add(this.runningProgramMonitor);
            this.Controls.Add(this.programLabel);
            this.Controls.Add(this.queueLabel);
            this.Controls.Add(this.loadLabel);
            this.Controls.Add(this.programMonitor);
            this.Controls.Add(this.loadButton);
            this.Controls.Add(this.Debug1);
            this.Controls.Add(this.fileLocationLabel);
            this.Controls.Add(this.fileLocationTextBox);
            this.Controls.Add(this.portSelector);
            this.Controls.Add(this.stopButton);
            this.Controls.Add(this.runButton);
            this.Controls.Add(this.portSelectorLabel);
            this.Controls.Add(this.instructionMonitor);
            this.Controls.Add(this.headMonitor);
            this.Name = "Form1";
            this.Text = "Form1";
            ((System.ComponentModel.ISupportInitialize)(this.bindingSource1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button Debug2;
        private System.Windows.Forms.TextBox runningProgramMonitor;
        private System.Windows.Forms.Label programLabel;
        private System.Windows.Forms.Label queueLabel;
        private System.Windows.Forms.Label loadLabel;
        private System.Windows.Forms.TextBox programMonitor;
        private System.Windows.Forms.Button loadButton;
        private System.Windows.Forms.Button Debug1;
        private System.Windows.Forms.Label fileLocationLabel;
        private System.Windows.Forms.TextBox fileLocationTextBox;
        private System.Windows.Forms.ComboBox portSelector;
        private System.Windows.Forms.Button stopButton;
        private System.Windows.Forms.Button runButton;
        private System.Windows.Forms.BindingSource bindingSource1;
        private System.Windows.Forms.Label portSelectorLabel;
        private System.Windows.Forms.TextBox instructionMonitor;
        public System.IO.Ports.SerialPort arduino;
        private Classes.HeadMonitor headMonitor;
    }
}

