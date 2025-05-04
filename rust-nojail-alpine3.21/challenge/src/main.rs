use std::{error::Error};
use std::fs;

fn main() -> Result<(), Box<dyn Error>> {
    let flag = fs::read_to_string("/flag.txt")?;
    let flag = flag.trim();

    println!("Hello from Rust!");
    println!("{}", flag);

    Ok(())
}
