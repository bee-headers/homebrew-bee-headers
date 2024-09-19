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

2. Install the headers:

Once the tap is added, you can install the Bee Headers formula:

```sh
brew install bee-headers/bee-headers/bee-headers
```

3. Verify the installation:

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

1. Clone the project:

```sh
git clone https://github.com/bee-headers/homebrew-bee-headers.git
cd homebrew-bee-headers/
```

2. Install the Bee Headers Homebrew formulae manually using:

```sh
brew install --build-from-source bee-headers.rb
```

> *Note*
>
> If you have the formulae already installed, you can reinstalled it with:
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

## License

This project is licensed under the GPL-2.0-only license. Please see the LICENSE
file for more details.

## Contributing

Feel free to open issues or submit pull requests to contribute to the project.


