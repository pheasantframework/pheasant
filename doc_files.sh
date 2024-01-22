foldernames=( "pheasant_temp" "pheasant" "pheasant_assets" "pheasant_cli" "pheasant_meta" "pheasant_build" )

for ELEMENT in ${foldernames[@]}
do
    cd "${ELEMENT}"
    dart doc
    cd ..
done