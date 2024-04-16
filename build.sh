#!/bin/bash
#sudo systemctl start docker
cargo build -r
cross build --target x86_64-pc-windows-gnu --release

zip -j bbscript-linux.zip ./target/release/bbscript
zip -r bbscript-linux.zip ./static_db/dbfz.ron

zip -j bbscript-windows.zip ./target/x86_64-pc-windows-gnu/release/bbscript.exe
zip -r bbscript-windows.zip ./static_db/dbfz.ron
