#!/usr/bin/env run-cargo-script

fn main() {
        use std::io::{self, Read};
        fn greet_user() -> io::Result<()> {
                match name {
                Some(name) => println!("Hello there, {}!", name),
                None => println!("Hi there pwnster"),
                }
        }
}
