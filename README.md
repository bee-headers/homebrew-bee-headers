# Bee Headers

Bee Headers provides a set of headers including `byteswap.h`, `elf.h`, and
`endian.h` that are required to build the Linux kernel. This project allows easy
installation of these headers via Homebrew.

## Installation

To install the headers using Homebrew, follow these steps:

1. **Tap the repository:**

First, add the custom tap for Bee Headers:

```sh
brew tap bee-headers/bee-headers
```

2. **Install the headers:**

Once the tap is added, you can install the Bee Headers formula:

```sh
brew install bee-headers/bee-headers/bee-headers
```

3. **Verify the installation:**

You can use `pkg-config` to confirm the installation and retrieve the necessary
flags for building the Linux kernel:

```sh
pkg-config bee-headers --cflags
```

This should output the include path, something like:

```sh
-I/opt/homebrew/Cellar/bee-headers/0.1/include
```

## Installation (Manual)

1. **Clone the project:**

```sh
git clone https://github.com/bee-headers/homebrew-bee-headers.git
cd homebrew-bee-headers/
```

2. **Install the Bee Headers Homebrew formula manually using:**

```sh
brew install --build-from-source bee-headers.rb
```

> *Note*
>
> If you have the formula already installed, you can reinstall it with:
>
> ```sh
> brew reinstall --build-from-source bee-headers.rb
> ```

## Uninstall

To remove the installed bee-headers package, you can run:

```sh
brew uninstall bee-headers
```

This will remove the installed headers from your system.

If you no longer want the custom tap in your Homebrew environment, you can also
remove it with:

```sh
brew untap bee-headers/bee-headers
```

This will remove the tap from your Homebrew setup.

## How to use Bee Headers to Build the Linux kernel in macOS - Quick Version

```shell
diskutil apfs addVolume /dev/disk<N> "Case-sensitive APFS" linux
```

```shell
brew install coreutils findutils gnu-sed gnu-tar grep llvm make pkg-config
```

```shell
brew tap bee-headers/bee-headers
brew install bee-headers/bee-headers/bee-headers
```

Initialize the environment with `bee-init`. Repeat with every new shell:

```shell
source bee-init
```

```shell
make LLVM=1 defconfig
make LLVM=1 -j$(nproc)
```

## How to use Bee Headers to Build the Linux kernel in macOS

Building on macOS with LLVM is experimental. This section provides steps to
install dependencies via Homebrew, set up the environment, and start the build
process.

1. **Create a Case-Sensitive Volume**

For fetching and building the project, you need a case-sensitive volume. Use the
following command to create one:

```shell
diskutil apfs addVolume /dev/disk<N> "Case-sensitive APFS" linux
```

Replace `/dev/disk<N>` with the appropriate disk identifier.

2. **Install Build Dependencies**

Use Homebrew to install the required build dependencies.

- **Core Utilities**: `coreutils`, `findutils`, `gnu-sed`, `gnu-tar`, `grep`,
`llvm`, `make`, and `pkg-config`.

```shell
brew install coreutils findutils gnu-sed gnu-tar grep llvm make pkg-config
```

- **Bee Headers**: Install byteswap, elf, and endian headers using the [Bee
Headers Project](https://github.com/bee-headers/headers).

```shell
brew tap bee-headers/bee-headers
brew install bee-headers/bee-headers/bee-headers
```

4. **Configure the environment using `bee-init` helper**:

```shell
source bee-init
```

> *Note*
>
> If `$(brew --prefix)/bin` is not part of your `$PATH` environment variable, you
> may need to do instead:
>
> ```shell
> source $(brew --prefix)/bin/bee-init
>```

5. Once the environment is set up, you can start the build process using LLVM.
Run the following commands to initiate the build:

```shell
make LLVM=1 defconfig
make LLVM=1 -j$(nproc)
```

### Manual Configuration of the Environment

Use the steps below to manually set up the above step 4. This is an alternative
to the `source bee-init`.

Include all the required GNU tools and LLVM in your `$PATH`. This ensures that
the necessary tools are available during the build process.

```shell
PATH="#{HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/findutils/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/gawk/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/grep/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/make/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/llvm/bin:$PATH"
```

Define the [`HOSTCFLAGS`](https://kernel.org/doc/html/latest/kbuild/kbuild.html#hostcflags)
variable:

```shell
export HOSTCFLAGS="$(pkg-config --cflags bee-headers) -D_UUID_T -D__GETHOSTUUID_H"
```

> Note
>
> `pkg-config --cflags bee-headers` is used to locate the include directory with
> `byteswap.h`, `elf.h` and `endian.h` headers.

Now, your environment is ready to build.

You can also automate your setup using any of the options below:

* a) Using your shell `~/.profile`, `~/.bashrc`, or equivalents:

```~/.profile
PATH="#{HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/findutils/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/gawk/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/grep/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/make/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/llvm/bin:$PATH"
export HOSTCFLAGS="$(pkg-config --cflags bee-headers) -D_UUID_T -D__GETHOSTUUID_H"
```

> *Note*
>
> You can add all your gnubin folders with:
>
> ```~/.profile
> if type brew &>/dev/null; then
>        HOMEBREW_PREFIX=$(brew --prefix)
>        for dir in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do export PATH=$dir:$PATH; done
>        for dir in ${HOMEBREW_PREFIX}/opt/*/libexec/gnuman; do export MANPATH=$dir:$MANPATH; done
> fi
> ```

* b) Using `GNUmakefile` in the project tree: Define `HOSTCFLAGS` only to your
specific tree, add a `GNUmakefile` file to wrap the `Makefile` file:

```GNUmakefile
PATH="#{HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/findutils/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/gawk/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/grep/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/make/libexec/gnubin:$PATH"
PATH="#{HOMEBREW_PREFIX}/opt/llvm/bin:$PATH"
export HOSTCFLAGS="$(shell pkg-config --cflags bee-headers) -D_UUID_T -D__GETHOSTUUID_H"
include Makefile
```

## License

This project is licensed under the GPL-2.0-only license. Please see the LICENSE
file for more details.

## Contributing

Feel free to open issues or submit pull requests to contribute to the project.
