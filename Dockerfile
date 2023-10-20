FROM us-central1-docker.pkg.dev/voxelphile/cloud-gke-source-deploy/rust:latest

WORKDIR /usr/src/app
COPY . .

RUN mkdir -p $CARGO_HOME/git/db/ && cargo +nightly build --release --bin sol --target aarch64-unknown-linux-musl

EXPOSE 13127

CMD ["./target/release/sol"]