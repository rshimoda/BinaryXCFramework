#!/bin/sh
set -Eeo pipefail

if [[ $ACTION == "indexbuild" ]]; then
  exit 0
fi

# When archiving app, and there are lib target with public headers
# Xcode generates xcarchive in a such way,
# that app can not be validated and notarized using Xcode UI.

# Do not copy public headers when archiving product
if [[ -d "${INSTALL_ROOT}" ]]; then
  exit 0
fi

FULL_PUBLIC_HEADERS_FOLDER_PATH="${BUILT_PRODUCTS_DIR}${PUBLIC_HEADERS_FOLDER_PATH}"

mkdir -p "${FULL_PUBLIC_HEADERS_FOLDER_PATH}"

: $((INPUT_FILE_INDEX=0))
while [ $INPUT_FILE_INDEX -lt "$SCRIPT_INPUT_FILE_COUNT" ]
do
  eval HEADER_FILE="\$SCRIPT_INPUT_FILE_${INPUT_FILE_INDEX}"

  cp "${HEADER_FILE}" "${FULL_PUBLIC_HEADERS_FOLDER_PATH}"
  : $((INPUT_FILE_INDEX=INPUT_FILE_INDEX+1))
done

# Copies *-Swift.h file to the public headers path.

SWIFT_OBJC_INTERFACE_HEADER_NAME=${SWIFT_OBJC_INTERFACE_HEADER_NAME:-${SWIFT_MODULE_NAME:-${PRODUCT_MODULE_NAME}}-Swift.h}
if [[ -z "${SWIFT_OBJC_INTERFACE_HEADER_NAME}" ]]; then
  echo "error: This script is supposed to be executed during Xcode build phase"
  exit 1
fi

SWIFT_OBJC_INTERFACE_HEADER_FILENAME="${DERIVED_SOURCES_DIR}/${SWIFT_OBJC_INTERFACE_HEADER_NAME}"
if [[ ! -f "${SWIFT_OBJC_INTERFACE_HEADER_FILENAME}" ]]; then
  echo "error: File '${SWIFT_OBJC_INTERFACE_HEADER_NAME}' doesn't exists at '${DERIVED_SOURCES_DIR}'."
  exit 1
fi

echo "note: Copying '${SWIFT_OBJC_INTERFACE_HEADER_NAME}' from '${DERIVED_SOURCES_DIR}' to '${FULL_PUBLIC_HEADERS_FOLDER_PATH}'"
cp "${SWIFT_OBJC_INTERFACE_HEADER_FILENAME}" "${FULL_PUBLIC_HEADERS_FOLDER_PATH}"
