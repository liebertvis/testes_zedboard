SUMMARY = "ZedBoard AXI GPIO LED Control Application"
DESCRIPTION = "Simple C userspace program to control the 8 PL LEDs via AXI GPIO at 0x41200000"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://led_blink.c"

S = "${WORKDIR}"

do_compile() {
    ${CC} ${CFLAGS} ${LDFLAGS} led_blink.c -o led_blink
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 led_blink ${D}${bindir}/led_blink
}

