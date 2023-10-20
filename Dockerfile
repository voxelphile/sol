FROM us-central1-docker.pkg.dev/voxelphile/cloud-gke-source-deploy/rust:latest

WORKDIR /usr/src/app
COPY . .

RUN echo $SCCACHE_REDIS
RUN rustup component add rust-src --toolchain nightly-x86_64-unknown-linux-gnu
RUN cargo +nightly build --release --bin sol --target aarch64-unknown-linux-musl

EXPOSE 13127

CMD ["./target/release/sol"]