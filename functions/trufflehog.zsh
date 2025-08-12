# Autoloadable function to scan git repos for secrets
trufflehog() {
  sudo docker run --rm -it -v "$PWD:/pwd" trufflesecurity/trufflehog:latest github --repo "$1"
}
