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
	"wine"
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
exempt_comparison=(
	"BBS_BRS"
	"BBS_TNN"
)
b_error="0"
for i in "${targets[@]}"
	do echo "Building for ${i}"
	cargo clean    # https://github.com/cross-rs/cross/issues/724
	if [[ ${i} == ${host} ]]
		then cargo build --target ${i} --release || b_error="1"
		else cross build --target ${i} --release || b_error="1"
	fi
	if [[ ${b_error} != "0" ]]
		then echo "Build for ${i} failed"
		echo "Skipping and resetting for next target"
		cargo clean
		b_error="0"
		continue
	fi
	for a in "bbscript" "bbscript.exe"
		do if [[ -f "${script_path}/target/${i}/release/${a}" ]]
			then bin=${a}
			if [[ -f "${script_path}/${bin}" ]]
				then rm "${script_path}/${bin}"
			fi
			ln -sf "${script_path}/target/${i}/release/${bin}" "${script_path}"
		fi
	done

	echo "Setting up tests"
	if [[ ${i} == ${host} ]]
		then test="./${bin}"
		else test="wine ${bin}"
		export WINEPREFIX="${script_path}/.wine"
		export WINEDEBUG="-all"
		if [[ ! -d "${WINEPREFIX}" ]]
			then wineboot
		fi
	fi

	echo "Running tests: "
	errors=()
	for f in tests/BBS_*
		do filename=$(basename ${f})
		echo -n "${filename} "
		${test} parse dbfz -o "./${f}" "/tmp/bbscript_test_1" || errors+=("${filename} parsing failed")
		${test} rebuild -o dbfz "/tmp/bbscript_test_1" "/tmp/bbscript_test_2" || errors+=("${filename} rebuilding failed")

		# skip binary compare for scripts that are purposefully different from their original counterparts
		if [[ "${exempt_comparison[@]}" =~ "${filename}" ]]
			then continue
		fi
		diff <(od -An -tx1 -w1 -v "/tmp/bbscript_test_2") <(od -An -tx1 -w1 -v "${f}")
		if [[ $? -eq 1 ]]
			then errors+=("${filename} did not pass binary match after parse > rebuild")
		fi
	done
	echo -ne "\n"
	if (( ${#errors[@]} != 0 ))
		then printf '%s\n' "${errors[@]}"
		exit 1
	fi

	# if [[ -d "${script_path}/.wine" ]]
	# 	then rm -r "${script_path}/.wine"
	# fi

	echo "Creating bbscript-v${ver}-${i}.zip"
	if [[ -f "bbscript-v${ver}-${i}.zip" ]]
		then rm "bbscript-v${ver}-${i}.zip"
	fi
	zip -j "bbscript-v${ver}-${i}.zip" "${script_path}/target/${i}/release/${bin}"
	zip -r "bbscript-v${ver}-${i}.zip" "./static_db/dbfz.ron"

	rm "${bin}"
	echo -e "Done making ${bin} for ${i}!\n"
done
exit 0
