#!/bin/sh

read -p 'Zip Name (Without .zip at end): ' zip_name
echo "Zipping file..."

zip -r "$zip_name.zip" . -x *.git* -x "*.zip" -x "*.DS_Store" -x "__MACOSX"

mkdir out
mv "$zip_name.zip" out

read -p "Would you like to move to releases?: " release_move
if [ "$release_move" = "yes" ] || [ "$release_move" = "Yes" ]; then
    cp "out/$zip_name.zip" ../BlackenedMod-releases
else
    echo "Done, check the out folder for the finished build"
fi;
