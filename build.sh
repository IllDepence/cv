SRC_DIR="cv"
BUILD_DIR="build"
FONTS_DIR="fonts"
SCAFFOLDS_DIR="scaffolds"
IMAGES_DIR="${SRC_DIR}/images"
DIST_DIR="dist"
DATE=`date +'%B %d, %Y'`

echo "creating dirs"
mkdir -p $BUILD_DIR
mkdir -p $DIST_DIR

echo "compiling stylesheets"
bundle exec compass compile \
  --require susy \
  --sass-dir stylesheets \
  --javascripts-dir javascripts \
  --css-dir "${DIST_DIR}/stylesheets" \
  --image-dir "${IMAGES_DIR}" \
  stylesheets/style.scss

echo "copying files"
rsync -rupE $FONTS_DIR $DIST_DIR
rsync -rupE $IMAGES_DIR $DIST_DIR

echo "converting CV to HTML"
pandoc --standalone \
  --section-divs \
  --template templates/cv.html \
  --from markdown+yaml_metadata_block+header_attributes+definition_lists+smart \
  --to html5 \
  --variable=date:"${DATE}" \
  --css stylesheets/style.css \
  --output "${DIST_DIR}/index.html" "${SRC_DIR}/cv.md"

# pandoc \
#   --from markdown+yaml_metadata_block \
#   --template templates/pdf.metadata \
#   --template templates/pdf.metadata \
#   --variable=date:"${DATE}" \
#   --output "${BUILD_DIR}/pdftags.txt" "${SRC_DIR}/cv.md"
# wkhtmltopdf --print-media-type --orientation Portrait --page-size A4 --margin-top 15 --margin-left 15 --margin-right 15 --margin-bottom 15 "${DIST_DIR}/cv.html" "${DIST_DIR}/cv.pdf"
# exiftool `cat "${BUILD_DIR}/pdftags.txt"` "${DIST_DIR}/cv.pdf"
