#!/bin/bash

if [ $# -lt 2 ]; then
  echo "Usage: $0 ECID MODEL"
  exit 1
fi

ECID=$1
MODEL=$2

if [ "$MODEL" = "iPhone3,1" ]; then
  BUILDS="11A465 11A501 11B511 11B554a 11B651 11D201 11D257"
elif [ "$MODEL" = "iPhone4,1" ]; then
  BUILDS="11A465 11A501 11B511 11B554a 11B651 11D201 11D257"
elif [ "$MODEL" = "iPhone5,1" ]; then
  BUILDS="11A465 11A501 11B511 11B554a 11B651 11D201 11D257"
elif [ "$MODEL" = "iPhone5,2" ]; then
  BUILDS="11A465 11A501 11B511 11B554a 11B651 11D201 11D257"
elif [ "$MODEL" = "iPhone5,3" ]; then
  BUILDS="11A465 11A501 11B511 11B554a 11B651 11D201 11D257"
elif [ "$MODEL" = "iPhone5,4" ]; then
  BUILDS="11A465 11A501 11B511 11B554a 11B651 11D201 11D257"
elif [ "$MODEL" = "iPhone6,1" ]; then
  BUILDS="11A465 11A501 11B511 11B554a 11B651 11D201 11D257"
else
  echo "Model $MODEL not recognized. Please add builds for it in the script."
  exit 1
fi

SUBDIR="shsh/${MODEL}-${ECID}"
mkdir -p "$SUBDIR"

echo "Running tsschecker for model $MODEL, ECID $ECID..."
for BUILD in $BUILDS; do
  echo "  -> Build $BUILD"
  
  ./tsschecker -d "$MODEL" -e "$ECID" --server-url http://cydia.saurik.com/TSS/controller?action=2/ -s -g 0x1111111111111111 --buildid "$BUILD" > /dev/null 2>&1
  EXITCODE=$?

  if [ $EXITCODE -ne 0 ]; then
    echo "    check failed "
    continue
  fi

  shsh_files=( *"$BUILD"*.shsh2 )
  if [ -e "${shsh_files[0]}" ]; then
    for f in "${shsh_files[@]}"; do
      mv -f "$f" "$SUBDIR/"
      echo "    Saved blob $f"
    done
  else
    echo "    No shsh found for build $BUILD"
  fi
done

echo "All blobs saved in $SUBDIR"
