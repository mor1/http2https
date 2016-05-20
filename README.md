[![Build Status](https://travis-ci.org/mor1/http2https.png?branch=master)](https://travis-ci.org/mor1/http2https)

# http2https

This is a simple redirector unikernel that issues HTTP 302 responses to incoming
HTTP requests. It's useful to use as a listener on port 80 to redirect traffic
to the corresponding HTTPS port on 443.

## Installation

The image on the Hub at `docker pull mor1/mir-http2https` will listen for HTTP
on 80/TCP and redirect to HTTPS on 443/TCP.

To build given a working OCaml, OPAM and Docker installations, use the `build`
shell script to construct an image, parameterised by the listening (`FROMP`) and
forwarding (`TOP`) ports. This also outputs a `run` shell script containing the
necessary `docker` command to run the image.

## Usage

See `mirage configure --help`

```
MIRAGE-CONFIGURE(1)              Mirage Manual             MIRAGE-CONFIGURE(1)



NAME
       mirage-configure - Configure a mirage application.

SYNOPSIS
       mirage configure [OPTION]...

DESCRIPTION
       The configure command initializes a fresh mirage application.

MIRAGE PARAMETERS
       --no-ocaml-version-check
           Bypass the OCaml compiler version checks.

       -t TARGET, --target=TARGET (absent=macosx or MODE env)
           Target platform to compile the unikernel for. Valid values are:
           xen, unix, macosx.

       --unix
           Set target to unix. For OSX (Yosemite or higher) unix is equivalent
           to `--target=macosx`. Otherwise it is `--target=unix`. Will
           automatically set target.

       --warn-error=BOOL (absent=false)
           Enable -warn-error when compiling OCaml sources.

       --xen
           Set target to xen. Will automatically set target.

UNIKERNEL PARAMETERS
       --dhcp=DHCP (absent=false)
           Enable dhcp for the unikernel.

       --gateways=GATEWAYS (absent=10.0.0.1)
           The gateways of the unikernel.

       --ip=IP (absent=10.0.0.2)
           The ip address of the unikernel.

       -l LEVEL, --logs=LEVEL
           Be more or less verbose. LEVEL must be of the form *:info,foo:debug
           means that that the log threshold is set to info for every log
           sources but the foo which is set to debug.

       --net=NET (absent=direct)
           Use socket or direct group for the unikernel.

       --netmask=NETMASK (absent=255.255.255.0)
           The netmask of the unikernel.

       --network=NETWORK (absent=tap0)
           The network interface listened by the unikernel.

       -p FROM-PORT, --port=FROM-PORT (absent=80 or HTTP2HTTPS_PORT env)
           TCP port to listen on.

       -r TO-PORT, --redirect=TO-PORT (absent=443 or HTTP2HTTPS_REDIRECT env)
           TCP port to redirect to.

       -u URI, --uri=URI (absent=https://localhost/ or HTTP2HTTPS_URI env)
           Target URI to redirect requests to.

ENVIRONMENT VARIABLES
       HTTP2HTTPS_PORT
           See option --port.

       HTTP2HTTPS_REDIRECT
           See option --redirect.

       HTTP2HTTPS_URI
           See option --uri.

       MIRAGE_LOGS
           See option --logs.

       MODE
           See option --target.

COMMON OPTIONS
       These options are common to all commands.

       --color=COLOR (absent=auto)
           Colorize the output. COLOR must be one of `auto', `always' or
           `never'.

       -f CONFIG_FILE, --file=CONFIG_FILE
           Configuration file. If not specified, the current directory will be
           scanned. If one file named config.ml is found, that file will be
           used. If no files or multiple configuration files are found, this
           will result in an error unless one is explicitly specified on the
           command line.

       --help[=FMT] (default=pager)
           Show this help in format FMT (pager, plain or groff).

       --no-depext
           Skip installation of external dependencies.

       --no-opam
           Do not manage the OPAM configuration. This will result in dependent
           libraries not being automatically installed during the
           configuration phase.

       --no-opam-version-check
           Bypass the OPAM version check.

       -v, --verbose
           Be verbose

       --version
           Show version information.



Mirage 2.9.0                                               MIRAGE-CONFIGURE(1)
```
