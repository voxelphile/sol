FROM ae73976bf51c

WORKDIR /usr/src/app
COPY . .

ENV KEY=${ARG_KEY}
ENV CRT=${ARG_CRT}

RUN cargo +nightly -Z sparse-registry build --release --bin sol --target aarch64-unknown-linux-musl

EXPOSE 13127

CMD ["./target/release/sol"]