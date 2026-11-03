#!/usr/bin/env bash
# Fetches ovaltine firmware partition images (radio/), because modem.img at 270.8 MiB is over GitHub's 100 MiB hard limit,
# so these 24 images are kept in a Release asset, not in git history.
set -euo pipefail

ORG="MagicNeko-ROM"
REPO="proprietary_vendor_oneplus_ovaltine"
TAG="${OVALTINE_FW_TAG:-firmware-CPH2415_15.0.0.700}"
ASSET="ovaltine-radio-CPH2415_15.0.0.700.tar.zst"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$REPO_ROOT/radio"
URL="https://github.com/${ORG}/${REPO}/releases/download/${TAG}/${ASSET}"

cd "$REPO_ROOT"
mkdir -p "$DEST"

echo "==> Downloading $ASSET (${TAG})"
curl -L --fail --retry 3 -o "$ASSET" "$URL"

echo "==> Extracting to radio/"
tar --zstd -xf "$ASSET" -C "$DEST"

echo "==> Verifying sha256"
( cd "$DEST" && sha256sum -c SHA256SUMS )

n=$(find "$DEST" -maxdepth 1 -type f -name '*.img' | wc -l)
echo "==> Done: $n .img files in radio/ (should be 24)"
[ "$n" -eq 24 ] || { echo "Warning: count isn't 24, check that the asset is complete" >&2; exit 1; }
echo "==> You can delete the local archive: rm -f $ASSET"
