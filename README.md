# puppet-runtime

The puppet-runtime exists to build vendored components for
[Puppet](https://github.com/puppetlabs) projects and distribute them as a
tarball for reuse. Runtime projects are built with
[vanagon](https://github.com/puppetlabs/vanagon), a packaging utility.

Available components include curl, openssl, ruby, and more - see the
[configs/components directory](configs/components) for a full list. Individual
projects in the [configs/projects directory](configs/projects) include subsets
of these components. These projects may be built for platforms listed in the
[configs/platforms directory](configs/platforms).

## Build instructions

To build a puppet-runtime project:

- Ruby and [bundler](http://bundler.io/) must be installed
- You must have root ssh access to a VM to build on

First, install the gem dependencies:

```
$ bundle install
```

Next, if you are building on infrastructure outside of Puppet, you will need to
modify some package dependency names in the [configs directory](configs). Any
references to pl-gcc, pl-cmake, pl-yaml-cpp, etc. in these files will need to
be changed to refer to equivalent installable packages on your target platform.
In many cases, you can drop the `pl-` prefix and ensure that `CXX` or `CC`
environment variables are what they should be.

Next, determine which of the [runtime projects](configs/projects) in this
repository you need to build. This will depend on the target repository that
consumes your finished runtime. In some cases, there is only one runtime
project available (`runtime-pdk`, for example, is the only runtime for the
PDK). In other cases, the runtime project to build may depend on the branch of
the target repository that consumes the runtime. For example, puppet-agent is
developed on multiple git branches; You should select the runtime project that
matches the target branch (for instance, you would build `agent-runtime-5.3.x`
for use with puppet-agent's 5.3.x branch).  See the
[configs/projects](configs/projects) directory for a full list of options.

You can build the project using vanagon like this:

```
$ bundle exec build <project-name> <platform> <target-vm>
```

Where:
- `project-name` is the name of the runtime project to build (from
  [configs/projects](configs/projects))
- `platform` is the name of a platform supported by vanagon and configured in
  the [configs/platforms](configs/platforms) directory
- `target-vm` is the hostname of the VM you will build on. You must have root
  ssh access configured for this host, and it must match the target platform.

## Updating rubygem components

This repo includes a rake task that will use the RubyGems API to update all rubygem components, including adding any missing runtime dependencies.
```
$ bundle exec rake vox:update_gems
```
In each `rubygem-*.rb` file in `configs/components`, you will find a "magic" block near the top. For example:
```
### Maintained by update_gems automation ###
pkg.version '2.14.0'
pkg.sha256sum '8699cfe5d97e55268f2596f9a9d5a43736808a943714e3d9a53e6110593941cd'
pkg.build_requires 'rubygem-faraday-net_http'
pkg.build_requires 'rubygem-json'
pkg.build_requires 'rubygem-logger'
### End automated maintenance section ###
```
Everything in this block can be automatically updated by the rake task. There are some special comments that change the behavior.

`# PINNED` right before the `pkg.version` line will keep this component at the current version. Dependencies will still be checked to ensure none are missing. For example:
```
### Maintained by update_gems automation ###
# PINNED
pkg.version '2.14.0'
pkg.sha256sum '8699cfe5d97e55268f2596f9a9d5a43736808a943714e3d9a53e6110593941cd'
pkg.build_requires 'rubygem-faraday-net_http'
pkg.build_requires 'rubygem-json'
pkg.build_requires 'rubygem-logger'
### End automated maintenance section ###
```

Adding `# GEM TYPE: <type>` will allow you to specify a checksum for a precompiled version of a gem. This can be used with other logic within the magic block to specify a checksum based on platform. For example:
```
### Maintained by update_gems automation ###
pkg.version '1.17.2'
if platform.is_windows?
  # GEM TYPE: x64-mingw32
  pkg.sha256sum ''
else
  pkg.sha256sum '297235842e5947cc3036ebe64077584bff583cd7a4e94e9a02fdec399ef46da6'
end
### End automated maintenance section ###
```
The rake task will leave any lines it doesn't know about alone (in this case, the if/else/end logic) and update both checksums, with the default without the `# GEM TYPE` decorator being the `ruby` uncompiled gem. Try not to get too fancy with logic in here.
