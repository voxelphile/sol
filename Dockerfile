FROM us-central1-docker.pkg.dev/voxelphile/cloud-gke-source-deploy/rust-arm64:latest

WORKDIR /usr/src/app
COPY . .

RUN bash -c "cargo +nightly build --release --bin sol --target aarch64-unknown-linux-gnu"

EXPOSE 13127

CMD ["./target/release/sol"]