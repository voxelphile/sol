FROM us-central1-docker.pkg.dev/voxelphile/cloud-gke-source-deploy/rust:latest

WORKDIR /usr/src/app
COPY . .

ENV CC_aarch64_unknown_linux_musl=clang
ENV AR_aarch64_unknown_linux_musl=llvm-ar
ENV CARGO_TARGET_AARCH64_UNKNOWN_LINUX_MUSL_RUSTFLAGS="-Clink-self-contained=yes -Clinker=rust-lld"
ENV CARGO_TARGET_AARCH64_UNKNOWN_LINUX_MUSL_RUNNER="qemu-aarch64 -L /usr/aarch64-linux-gnu"

RUN echo $CC_aarch64_unknown_linux_musl
RUN cat ./crt
RUN rustup component add rust-src --toolchain nightly-x86_64-unknown-linux-gnu
RUN cargo +nightly build -Z build-std --release --bin sol --target aarch64-unknown-linux-musl

EXPOSE 13127

CMD ["./target/release/sol"]