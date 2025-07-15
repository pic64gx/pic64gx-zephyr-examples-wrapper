# pic64gx-zephyr-examples-wrapper
PIC64GX zephyr examples wrapper for buildroot
Wrap the different piece of a zephyr project to build in buildroot package

# Install
```
git clone https://github.com/pic64gx/pic64gx-zephyr-examples-wrapper.git
git submodule update --init --recursive
```

# Update
```
git pull
git submodule update --init --recursive
```

## Update from pic64gx-linux-examples (for dev)
To update from https://github.com/pic64gx/pic64gx-linux-examples
```
pushd pic64gx-soc
git pull
popd
pushd zephyr
git pull
popd
./scripts/update.sh
```

# Build
In standalone
```
cmake -Bbuild -DBOARD=pic64gx_curiosity_kit -G "Unix Makefiles" pic64gx-soc/apps/blinky
make -C build
```

the resulting elf is located here: build/zephyr/zephyr.elf

# Flash

## Generate payload
to be flashed on a sdcard it need a HSS compatible header
for blinky example:
```
<path to hss repository>/tools/hss-payload-generator/hss-payload-generator -c pic64gx-soc/payload-configs/single_hart_ddr.yaml output.bin
```
Please not that the tool need to be build, please follow documentation:
https://github.com/pic64gx/pic64gx-hart-software-services/tree/pic64gx/tools/hss-payload-generator

## Flashing a payload
Once the payload is generated the easiest way to flash is to use,
assuming sdcard is on /dev/sda
```
sudo dd if=output.bin of=/dev/sda
```
to check your sdcard directory (before after/after pluging the card)
```
lsblk
```
Warning:
PLease be extremely careful about the dd command, you can wipe your entire system disk with it, please double check sdcard location

# Notes

PLease note that for the moment no zepyr modules have been added, as
they have to be added individualy as submodule.
