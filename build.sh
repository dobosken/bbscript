#!/bin/bash
script_path=$(dirname "$(realpath "${0}")")
cd "${script_path}"
targets=(
	"x86_64-unknown-linux-gnu"
	"x86_64-pc-windows-gnu"
	# "aarch64-unknown-linux-gnu"
	# "aarch64-pc-windows-gnu"
)

commands=(
	"cargo"    # https://rustup.rs
	"rustc"
	"docker"   # https://docs.docker.com/engine/
	"cross"    # cargo install cross --git https://github.com/cross-rs/cross
)
c_err=0
for i in "${commands[@]}"
	do if ! command -v ${i} &> /dev/null
		then echo "'${i}' could not be found."
		c_err=1
	fi
done
if [[ ${c_err} != "0" ]]
	then echo -e "\nDependencies for ${0##*/} are missing."
	echo "Please install the required software, and make sure your \$PATH variable is up to date."
	exit 1
fi

docker info > /dev/null 2>&1
c_err=$?
if [[ ${c_err} != "0" ]]
	then echo "Docker error. This is needed for cross-compiling."
	echo "Check your system logs, or run 'docker info' in a terminal."
	exit 1
fi

ver=$(grep -m1 "version" Cargo.toml | cut -d'"' -f2)
if [[ ! ${ver} =~ ^[0-9\.]+$ ]]
	then echo "Couldn't get proper version info from 'Cargo.toml'."
	exit 1
fi

host=$(rustc --print host-tuple)
for i in "${targets[@]}"
	do echo "Building for ${i}"
	if [[ ${i} == ${host} ]]
		then cargo build --target ${i} --release
		else cargo clean    # https://github.com/cross-rs/cross/issues/724
		cross build --target ${i} --release
	fi
	if [[ -f "${script_path}/target/${i}/release/bbscript" ]] || [[ -f "${script_path}/target/${i}/release/bbscript.exe" ]]
		then zip -j "bbscript-v${ver}-${i}.zip" "${script_path}/target/${i}/release/bbscript" "${script_path}/target/${i}/release/bbscript.exe"
		zip -r "bbscript-v${ver}-${i}.zip" "./static_db/dbfz.ron"
	fi
done

# Really should check whether the program actually built correctly or not.
# However, I've chosen not to care. If the .zip is missing, something messed up.
exit 0
