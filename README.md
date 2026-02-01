# rubygems-build-binary

## Summary

This is a RubyGems plugin. This adds `build_binary` `gem` sub command
that builds a binary gem for the current Ruby and platform from a
source (`ruby` platform) gem.

## How to use

Install `rubygems-build-binary` gem:

```bash
gem install rubygems-build-binary
```

Build a binary gem from a source gem:

```bash
gem fetch cairo
gem build_binary cairo-*.gem
```

It builds `cairo-X.Y.Z-x86_64-linux.gem` that includes built binaries
for the current Ruby and platform.

## Motivation

...

## License

MIT. See [LICENSE](LICENSE) for details.
