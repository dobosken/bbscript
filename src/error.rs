use thiserror::Error;

#[derive(Error, Debug)]
pub enum BBScriptError {
    #[error("File `{0}` does not exist")]
    FileDoesNotExist(String),
    #[error("Output file `{0}` already exists, specify overwrite with -o flag")]
    OutputAlreadyExists(String),
    #[error("Unknown function with ID/name `{0}`")]
    UnknownFunction(String),
    #[error("No value associated with arg `{0}` name `{1}`")]
    NoAssociatedValue(String, String),
}
