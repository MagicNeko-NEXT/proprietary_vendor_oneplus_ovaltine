# ovaltine firmware partition images (radio): not shipped with the repo

The **24 firmware images** this directory needs (`abl.img`, `modem.img`, `tz.img`, `xbl.img`, etc.)
are **not in this repo's git history**.

The reason is simple: `modem.img` alone is **270.8 MiB**, over GitHub's 100 MiB per-file hard limit,
and GitHub rejects any push containing it. So the firmware is distributed separately as a **GitHub Release asset**.

## How to get them

### Option 1: script (recommended)

```bash
./tools/fetch-firmware.sh
```

The script downloads the asset, verifies sha256 and extracts it to this directory.

### Option 2: manual

```bash
TAG=firmware-CPH2415_15.0.0.700
ASSET=ovaltine-radio-CPH2415_15.0.0.700.tar.zst
URL=https://github.com/MagicNeko-ROM/proprietary_vendor_oneplus_ovaltine/releases/download/$TAG/$ASSET

curl -L --fail -O "$URL"
tar --zstd -xf "$ASSET" -C radio/
cd radio && sha256sum -c SHA256SUMS
```

After extracting, this directory should have **24 `.img` files** plus a `SHA256SUMS`.

## File list (24 partitions)

```
abl.img        aop.img         aop_config.img   bluetooth.img
cpucp.img      devcfg.img      dsp.img          engineering_cdt.img
featenabler.img  hyp.img        imagefv.img      keymaster.img
modem.img      oplus_sec.img   oplusstanvbk.img qupfw.img
shrm.img       splash.img      tz.img           uefi.img
uefisecapp.img xbl.img         xbl_config.img   xbl_ramdump.img
```

Per-image sha256 values are in `SHA256SUMS` (included with the asset, appears after extraction).

## Source and use

- Source firmware: **CPH2415_15.0.0.700(EX01)** (extracted from the official OnePlus 10T / ovaltine OTA)
- Use: `BOARD_PACK_RADIOIMAGES` in `device/oneplus/sm8450-common`
  and `add-radio-file-sha1-checked` read images from this directory and pack them into target_files and the OTA
- **If missing**: the build still passes, but the OTA **has no firmware partitions**, so modem/boot chain aren't updated after flashing

## Notes

- `radio/*` is in `.gitignore`, so extracted images **won't be committed by accident**
- Don't flash boot chain partitions such as `xbl`/`abl`/`tz` without verification: ARB fuse blowing is irreversible
