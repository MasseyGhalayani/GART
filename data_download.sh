#!/bin/bash

set -e

download_and_extract() {
    local zip_url=$1
    local zip_file=$2
    local extract_dir=$3
    local target_dir=$4
    local password=$5

    echo "Downloading $zip_file..."
    wget -q -O "$zip_file" "$zip_url"

    echo "Extracting $zip_file..."
    if [[ -n $password ]]; then
        unzip -q -P "$password" "$zip_file" -d "$extract_dir"
    else
        unzip -q "$zip_file" -d "$extract_dir"
    fi

    echo "Moving files to $target_dir..."
    mkdir -p "$target_dir"
    mv "$extract_dir"/* "$target_dir/"

    echo "Cleaning up..."
    rm -rf "$extract_dir" "$zip_file"

    echo "$zip_file successfully processed!"
}


download_and_extract \
    "https://download.is.tue.mpg.de/download.php?domain=smpl&sfile=SMPL_python_v.1.1.0.zip" \
    "SMPL_python_v.1.1.0.zip" \
    "SMPL_python_v.1.1.0" \
    "GART/data/smpl_model"


SMPL_DIR="GART/data/smpl_model"
mv "$SMPL_DIR/smpl/models/basicmodel_f_lbs_10_207_0_v1.1.0.pkl" "$SMPL_DIR/SMPL_FEMALE.pkl"
mv "$SMPL_DIR/smpl/models/basicmodel_m_lbs_10_207_0_v1.1.0.pkl" "$SMPL_DIR/SMPL_MALE.pkl"
mv "$SMPL_DIR/smpl/models/basicmodel_neutral_lbs_10_207_0_v1.1.0.pkl" "$SMPL_DIR/SMPL_NEUTRAL.pkl"

echo "SMPL models have been placed in $SMPL_DIR!"


download_and_extract \
    "https://graphics.tu-bs.de/upload/projects/videoavatars/people_snapshot_public.zip" \
    "people_snapshot_public.zip" \
    "people_snapshot" \
    "GART/data/people_snapshot" \
    "ZXy84PVgFe"


echo "Running People Snapshot preprocessing script..."
DATA_ROOT="GART/data/people_snapshot" bash utils/preprocess_people_snapshot.sh


echo "Downloading and processing UBC dataset..."
cd /data || exit
pip install -q gdown
gdown 18byTvRqOqRyWOQ3V7lFOSV4EOHlKcdHJ
unzip -q ubc_release.zip
rm -f ubc_release.zip
cd ..

echo "Preprocessing completed!"
