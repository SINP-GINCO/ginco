#!/bin/bash
# set -x
#------------------------------------------------------------------------------
# Download and install the last version of CKEditor,
# as the install command from IvoryCKEditorBundle doesn't work with proxies.
#------------------------------------------------------------------------------

# get the last version of ckeditor
curl -Ls https://github.com/ckeditor/ckeditor-releases/archive/full/latest.zip > ckeditor.zip

# extract in the ckeditor bundle directory
unzip -q -d vendor/egeloen/ckeditor-bundle/Resources ckeditor.zip
rm -rf vendor/egeloen/ckeditor-bundle/Resources/public
mv -f vendor/egeloen/ckeditor-bundle/Resources/ckeditor-releases-full-latest vendor/egeloen/ckeditor-bundle/Resources/public
rm -rf vendor/egeloen/ckeditor-bundle/Resources/public/samples

# Cleaning
rm ckeditor.zip
