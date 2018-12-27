# docker-oss

Automatic compatibility tests, e.g. to learn which OS versions a binary can be run on.

## Usage

```bash
./run.sh <local-path-to-binary>
```

The script will copy the binary into the local directory, run a bunch of containers with the binary mounted inside as a volume, use `docker` to run the binary in each of the images listed in `images.csv` (and also print output from running `ldd` on it) and then record the exitlevel from `docker`.  At the very end, it prints a PASS/FAIL summary for all the images, where PASS means that `docker`'s exitlevel was 0.

The tests assume that running `<binary> --help` returns with exitlevel 0.  If the binary doesn't recognize `--help` or otherwise exits with non-0 exitlevel, then all tests will fail.

Output from the `docker` commands should be visible, so you can peruse that to diagnose why certain OSs are failing.

Feel free to edit `images.csv`.

## Prerequisites

It's assumed you have `docker` installed and that `sudo` is not needed to run it.  If `sudo` is needed, you can simply prepend `sudo` to the `docker` command in `run.sh`.

## Example output

```bash
./run.sh ../bamcount/bamcount
...
(lots of output from containers)
...
Final report:

alpine:3.7 FAILED
centos:7 FAILED
centos:6 FAILED
centos:5 FAILED
ubuntu:19.04 PASSED
ubuntu:18.10 PASSED
ubuntu:18.04 PASSED
ubuntu:16.04 PASSED
ubuntu:14.04 FAILED
debian:buster PASSED
debian:stretch PASSED
debian:jessie FAILED
```