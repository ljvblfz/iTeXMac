#!/bin/sh
echo "warning: iTeXMac2 INFO, merging the ${PRODUCT_NAME} headers"
# this is only while developping
cd "${TARGET_BUILD_DIR}/${PUBLIC_HEADERS_FOLDER_PATH}"
chmod -R u+w .
header="${PRODUCT_NAME}.h"
if [ -f "${header}" ]
then
		rm -Rf "${header}"
fi
targets="`ls -1 -R *.h`$IFS"
echo "// ${PRODUCT_NAME} merged headers" > "${header}"
echo "// Automatically created when building project ${PROJECT_NAME}" >> "${header}"
echo "// Created on `date "+Created on %m/%d/%y at %H:%M:%S"`" >> "${header}"
for var in ${targets}
do
	echo "#import <${PRODUCT_NAME}/$var>" >> "${header}"
done
find . -name "*.h" -exec chmod a-w {} \;
ls -l *.h
echo "warning: iTeXMac2 INFO, merging the ${PRODUCT_NAME} headers... DONE"
exit 0
