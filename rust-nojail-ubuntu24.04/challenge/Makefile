.PHONY: dist clean

challenge:
	RUSTFLAGS='-C target-feature=+crt-static' cargo build --release
	cp target/release/challenge .

clean:
	${RM} challenge target/ compile_commands.json
