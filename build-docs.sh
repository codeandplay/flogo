#!/usr/bin/env bash

# Description: Build script for Project Flogo documentation
# Author: retgits <https://github.com/retgits>
# Last Updated: 2018-10-01

#--- Variables ---
HUGO_VERSION=0.49

#--- Download and install prerequisites ---
prerequisites() {
    wget -O hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz
    mkdir -p hugobin
    tar -xzvf hugo.tar.gz -C ./hugobin
    mv ./hugobin/hugo $HOME/gopath/bin
    rm hugo.tar.gz && rm -rf ./hugobin
}

#--- Get external docs ---
ext_docs() {
    echo "Getting the docs for the activities and triggers"
    git clone https://github.com/TIBCOSoftware/flogo-contrib
    for i in `find flogo-contrib/activity -name \*.md` ; do filename=$(basename $(dirname $i)); cp $i docs/content/development/webui/activities/$filename.md; done;
    for i in `find flogo-contrib/trigger -name \*.md` ; do filename=$(basename $(dirname $i)); cp $i docs/content/development/webui/triggers/$filename.md; done;
    rm -rf flogo-contrib

    echo "Getting the docs for the commandline tools"
    curl -o docs/content/flogo-cli/flogo-cli.md https://raw.githubusercontent.com/TIBCOSoftware/flogo-cli/master/docs/flogo-cli.md
    curl -o docs/content/flogo-cli/flogodevice-cli.md https://raw.githubusercontent.com/TIBCOSoftware/flogo-cli/master/docs/flogodevice-cli.md
    curl -o docs/content/flogo-cli/flogogen-cli.md https://raw.githubusercontent.com/TIBCOSoftware/flogo-cli/master/docs/flogogen-cli.md
    curl -o docs/content/flogo-cli/tools-overview.md https://raw.githubusercontent.com/TIBCOSoftware/flogo-cli/master/docs/tools-overview.md
}

#--- Update contributions page ---
update_page_contrib() {
    echo "Update contributing page"
    cp CONTRIBUTING.md docs/content/contributing/contributing.md
    sed -i '1d' docs/content/contributing/contributing.md
    sed -i '1i ---' docs/content/contributing/contributing.md
    sed -i '1i weight: 9010' docs/content/contributing/contributing.md
    sed -i '1i title: Contributing to Project Flogo' docs/content/contributing/contributing.md
    sed -i '1i ---' docs/content/contributing/contributing.md
}

#--- Update introduction page ---
update_page_introduction() {
    cp README.md docs/content/introduction/_index.md
    sed -i '1,4d' docs/content/introduction/_index.md
    sed -i '5,17d' docs/content/introduction/_index.md
    sed -i '1i ---' docs/content/introduction/_index.md
    sed -i '1i pre: "<i class=\\"fas fa-home\\" aria-hidden=\\"true\\"></i> "' docs/content/introduction/_index.md
    sed -i '1i weight: 1000' docs/content/introduction/_index.md
    sed -i '1i title: Introduction' docs/content/introduction/_index.md
    sed -i '1i ---' docs/content/introduction/_index.md
    sed -i 's#images/eventhandlers.png#https://raw.githubusercontent.com/TIBCOSoftware/flogo/master/images/eventhandlers.png#g' docs/content/introduction/_index.md
    sed -i 's#images/flogostack.png#https://raw.githubusercontent.com/TIBCOSoftware/flogo/master/images/flogostack.png#g' docs/content/introduction/_index.md
    sed -i 's#images/flogo-web2.gif#https://raw.githubusercontent.com/TIBCOSoftware/flogo/master/images/flogo-web2.gif#g' docs/content/introduction/_index.md
    sed -i 's#images/flogo-cli.gif#https://raw.githubusercontent.com/TIBCOSoftware/flogo/master/images/flogo-cli.gif#g' docs/content/introduction/_index.md
}

#--- Update page ---
update_page() {
    case "$1" in
        "contributing")
            update_page_contrib
            ;;
        "introduction")
            update_page_introduction
            ;;
        *)
            echo "Updating all pages"
            update_page_contrib
            update_page_introduction
    esac
}

#--- Execute build ---
build() {
    echo "Build docs site..."
    cd docs && hugo
    cd ../showcases && hugo
    mv public ../docs/public/showcases
    cd ../docs
    cd public && ls -alh
}


case "$1" in 
    "prerequisites")
        prerequisites
        ;;
    "ext-docs")
        ext_docs
        ;;
    "update-page")
        update_page $2
        ;;
    "build")
        build
        ;;
    *)
        echo "The target {$1} you want to execute doesn't exist"
esac
