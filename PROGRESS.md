# Learning Progress: ZedBoard (Yocto + Vivado + FPGA + DSP + SDR)

**Student:** Liebert
**Target Hardware:** Digilent ZedBoard (Xilinx Zynq-7000 SoC `xc7z020clg484-1`)

---

## Roadmap & Status

### Phase 1: Embedded Linux & Yocto on Zynq-7000
- [x] **Topic 1.1:** High-level overview of Vivado -> Yocto inputs/outputs, SD card layout, and `.xsa` integration in a custom Yocto layer
- [x] **Vivado Base Hardware (`zed_board_intro`):** Inspected Zynq7 PS + AXI GPIO (`0x41200000`, 8 LEDs on `LD0-LD7`), changed project from extensible to fixed platform, and exported [zedboard_led_gpio.xsa](file:///c:/Users/liebert.silva/Desktop/testes_zedboard/zedboard_led_gpio.xsa) with bitstream.
- [x] **Topic 1.3:** Created custom layer [`meta-zedboard-custom`](file:///c:/Users/liebert.silva/Desktop/testes_zedboard/meta-zedboard-custom) with `external-hdf.bbappend` (feeding `zedboard_led_gpio.xsa`) and custom C application recipe (`led-blink_1.0.bb` + `led_blink.c`) to control the AXI GPIO LEDs at `0x41200000`.
- [x] **Topic 1.2 & 1.4:** Explained Yocto workspace setup (`bblayers.conf`, `local.conf`), created automated build script [`setup_and_build_yocto.sh`](file:///c:/Users/liebert.silva/Desktop/testes_zedboard/setup_and_build_yocto.sh), and documented SD card flashing & ZedBoard jumper/UART boot procedure.
- [ ] **Topic 1.5:** Interacting with custom PL IP from Linux (`/dev/mem` vs. Linux GPIO `/sys/class/gpio` / `libgpiod` vs. UIO) and understanding how Device Tree works.

### Phase 2: Vivado FPGA & AXI Integration
- [ ] **Topic 2.1:** AXI4-Lite (control/registers) vs. AXI4-Stream / AXI-DMA (high-speed data)
- [ ] **Topic 2.2:** Updating the Device Tree for custom PL peripherals

### Phase 3: DSP on FPGA
- [ ] **Topic 3.1:** Fixed-point arithmetic, FIR filters, NCO/DDS, and FFT in PL
- [ ] **Topic 3.2:** Streaming DSP data to Linux via AXI DMA

### Phase 4: SDR Integration
- [ ] **Topic 4.1:** Interfacing RF frontends (e.g., AD9361 / FMCOMMS) or baseband I/Q processing
- [ ] **Topic 4.2:** Industrial I/O (IIO) subsystem & GNU Radio / libiio integration

---

## Session Notes
- **2026-10-29:** Initialized learning track. Covered the big picture of Vivado `.xsa` -> Yocto -> Zynq boot flow and SD card layout.

