FROM rust

WORKDIR /usr/src/app
COPY . .

ENV KEY=${ARG_KEY}
ENV CRT=${ARG_CRT}

RUN rustup target add aarch64-unknown-linux-gnu && cargo build --release --bin sol --target aarch64-unknown-linux-gnu

EXPOSE 0.0.0.0:13127

CMD ["./target/release/sol"]