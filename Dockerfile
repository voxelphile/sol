FROM --platform=linux/arm64 us-central1-docker.pkg.dev/voxelphile/cloud-gke-source-deploy/rust-arm64:latest

WORKDIR /usr/src/app
COPY . .

RUN cargo +nightly build --release --bin sol

EXPOSE 13127

CMD ["./target/release/sol"]
