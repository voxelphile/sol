FROM rust

WORKDIR /usr/src/app
COPY . .

RUN apt-get update
RUN apt-get install clang llvm -y

ENV KEY=${ARG_KEY}
ENV CRT=${ARG_CRT}

ENV CARGO_NET_GIT_FETCH_WITH_CLI=true

ENV CC_aarch64_unknown_linux_musl=clang
ENV AR_aarch64_unknown_linux_musl=llvm-ar
ENV CARGO_TARGET_AARCH64_UNKNOWN_LINUX_MUSL_RUSTFLAGS="-Clink-self-contained=yes -Clinker=rust-lld"
ENV CARGO_TARGET_AARCH64_UNKNOWN_LINUX_MUSL_RUNNER="qemu-aarch64 -L /usr/aarch64-linux-gnu"

RUN rustup default nightly && rustup target add aarch64-unknown-linux-musl && cargo +nightly build --release --bin sol --target aarch64-unknown-linux-musl

EXPOSE 0.0.0.0:13127

CMD ["./target/release/sol"]