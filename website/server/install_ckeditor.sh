#!/bin/bash
# set -x
#------------------------------------------------------------------------------
# Download and install the last version of CKEditor,
# as the install command from IvoryCKEditorBundle doesn't work with proxies.
#------------------------------------------------------------------------------

# get the last version of ckeditor
curl -Ls https://github.com/ckeditor/ckeditor-releases/archive/full/latest.zip > ckeditor.zip

# extract in the ckeditor bundle directory
unzip -q -d vendor/friendsofsymfony/ckeditor-bundle/src/Resources ckeditor.zip
rm -rf vendor/friendsofsymfony/ckeditor-bundle/src/Resources/public
mv -f vendor/friendsofsymfony/ckeditor-bundle/src/Resources/ckeditor-releases-full-latest vendor/friendsofsymfony/ckeditor-bundle/src/Resources/public
rm -rf vendor/friendsofsymfony/ckeditor-bundle/src/Resources/public/samples

# Cleaning
rm ckeditor.zip

