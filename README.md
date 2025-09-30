<p align="center">
  <img src="https://img.shields.io/badge/SystemVerilog-6B2B44?style=for-the-badge&logo=systemverilog&logoColor=white" />
  <img src="https://img.shields.io/badge/UVM-FF6A21?style=for-the-badge&logo=uvm&logoColor=white" />
  <img src="https://img.shields.io/badge/SVA-5A47FF?style=for-the-badge&logo=sva&logoColor=white" />
  <img src="https://img.shields.io/badge/FSMs-3B36E9?style=for-the-badge&logo=gnu&logoColor=white" />
  <img src="https://img.shields.io/badge/Questasim-008080?style=for-the-badge&logo=mentor&logoColor=white" />
</p>

<h1 align="center" style="color:#6B2B44;">🔎 UVM & SVA-Based AMBA APB Verification Project (Standardized FSM Driving) 🔎</h1>

<p align="center">
  <b>Comprehensive UVM-class verification of an AMBA APB SystemVerilog design, with SVA protocol checks, standardized FSM-driven stimulus, and modular, commented code. Based on Christian Slav’s Udemy course.</b>
</p>

---

## 🎨 Overview

This repository demonstrates the design and thorough verification of an **AMBA APB (Advanced Peripheral Bus)** using:
- <span style="color:#6B2B44"><b>SystemVerilog</b></span> for RTL and assertions
- <span style="color:#FF6A21"><b>UVM</b></span> for a modular, reusable testbench
- <span style="color:#5A47FF"><b>SystemVerilog Assertions (SVA)</b></span> for protocol property checking
- <span style="color:#3B36E9"><b>Finite State Machines (FSMs)</b></span> for standardized, controlled stimulus generation

The structure and verification methodology closely follows best practices as taught in Christian Slav’s course: ["Design Verification using SystemVerilog/UVM"](https://www.udemy.com/course/design-verification-using-systemverilog-uvm/).

---

## 📁 Repository Structure

```
.
├── rtl/             # APB RTL design (SystemVerilog)
├── dv/              # UVM-based testbench & agents
├── sva/             # SystemVerilog Assertions
├── illustrations/   # Block diagrams, docs, waveforms
├── scripts/         # Compile & run scripts (Questasim)
```

- <span style="color:#6B2B44"><b>/rtl</b></span>: AMBA APB RTL sources
- <span style="color:#FF6A21"><b>/dv</b></span>: UVM testbench, agents, sequences, scoreboard
- <span style="color:#5A47FF"><b>/sva</b></span>: Protocol assertions
- <span style="color:#3B36E9"><b>/illustrations</b></span>: Block diagrams, waveforms, documentation

---

## ✨ Features

- <img src="https://img.shields.io/badge/APB%20RTL-6B2B44?style=flat-square" height="18"/> Fully synthesizable AMBA APB RTL
- <img src="https://img.shields.io/badge/UVM%20Testbench-FF6A21?style=flat-square" height="18"/> Modular, reusable, and class-based
- <img src="https://img.shields.io/badge/SVA%20Assertions-5A47FF?style=flat-square" height="18"/> Protocol compliance checked with SVA
- <img src="https://img.shields.io/badge/FSM%20Driving-3B36E9?style=flat-square" height="18"/> Standardized, state machine driven stimulus
- <img src="https://img.shields.io/badge/Constrained%20Random-ED254E?style=flat-square" height="18"/> Randomization & coverage
- <img src="https://img.shields.io/badge/Documentation-3B36E9?style=flat-square" height="18"/> Block diagrams, test plan, waveforms

---

## 🚀 Getting Started

1. **Clone the repository**
   ```sh
   git clone https://github.com/AbdelrahmanYassien11/Verification-of-AMBA-APB-using-UVM-SVA-Standardized-driving-using-FSMs.git
   cd Verification-of-AMBA-APB-using-UVM-SVA-Standardized-driving-using-FSMs
   ```

2. **Explore the folders**
   - RTL: <span style="color:#6B2B44">`/rtl`</span>
   - UVM env & testbench: <span style="color:#FF6A21">`/dv`</span>
   - Assertions: <span style="color:#5A47FF">`/sva`</span>
   - Docs & diagrams: <span style="color:#3B36E9">`/illustrations`</span>

3. **Run Simulations with Questasim**
   - Makefile and scripts provided for Questasim compatibility.
   ```sh
   cd dv
   make run
   # or, for manual compilation
   vlog ../rtl/*.sv ../dv/*.sv ../sva/*.sv
   vsim -c -do "run -all; quit"
   ```

---

## 📖 Documentation

- **APB Protocol & Features:** `/rtl` and `/illustrations`
- **Verification Plan & Test Strategy:** `/dv` and `/illustrations`
- **Assertion Details:** `/sva`
- **FSM Driving Logic:** `/dv/sequences/` or `/dv/agents/`

---

## 🖼️ Visuals

<p align="center">
  <img src="illustrations/apb_agent_tlm_diagram.png" alt="APB Agent TLM Diagram"><br>
  <i>APB Agent TLM Diagram</i>
</p>

<p align="center">
  <img src="illustrations/fsm_driving_flow.png" alt="FSM Driving Flow"><br>
  <i>FSM Driving Flow</i>
</p>

<p align="center">
  <img src="illustrations/protocol_waveform.png" alt="Protocol Simulation Waveform"><br>
  <i>Example Functional Simulation Waveform</i>
</p>

> _See the full [illustrations folder](./illustrations) for more diagrams & screenshots._

---

## 🤝 Contributors

Worked on this project independently, inspired by Christian Slav’s course.  
Future contributions, issues, and PRs are welcome. For significant changes, please open an issue to discuss first.

---

## 📫 Contact

- <img src="https://img.shields.io/badge/GitHub-AbdelrahmanYassien11-6B2B44?style=flat-square&logo=github&logoColor=white" height="18"/> [AbdelrahmanYassien11](https://github.com/AbdelrahmanYassien11)
- <img src="https://img.shields.io/badge/LinkedIn-Abdelrahman%20Mohamad%20Yassien-AA1745?style=flat-square&logo=linkedin&logoColor=white" height="18"/> [LinkedIn](https://www.linkedin.com/in/abdelrahman-mohamad-yassien/)

---

<p align="center" style="color:#ED254E; font-size:1.1em;">
  <b>🌟 Star this repo if you found it useful or inspiring!</b>
</p>