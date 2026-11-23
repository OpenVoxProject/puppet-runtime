# puppet-runtime

The puppet-runtime exists to build vendored components for
[OpenVox](https://github.com/OpenVoxProject) projects and distribute them as a
tarball for reuse. Runtime projects are built with
[vanagon](https://github.com/OpenVoxProject/vanagon), a packaging utility.

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

Next, if you are building on infrastructure outside of the OpenVox Project, you will need to
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
the target repository that consumes the runtime. For example, openvox-agent is
developed on multiple git branches; You should select the runtime project that
matches the target branch (for instance, you would build `agent-runtime-5.3.x`
for use with openvox-agent's 5.3.x branch).  See the
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

This is the all-in-one task, which will also commit your changes.
However, there is also `vox:update_gems_wo_commit`, which does the same except committing changes.
There's a CI workflow that runs daily + on demand.
It raises a PR / updates an existing PR if the rake task finds any changes.
The PR description lists component changes with changelog links from the selected gem versions' RubyGems metadata.
When unavailable, it uses release links from component comments, then source code or the RubyGems version page.
Set `COMPONENT_UPDATE_BODY` to a file path to generate this Markdown description locally as well.
The workflow writes it under `runner.temp` and passes it to the PR action using `body-path`.

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

A component never moves past what the components depending on it accept. When the newest release of a gem falls outside a dependent's requirement, the task holds the gem at the newest release every dependent accepts and lists the hold in its summary, which is also the commit message. A `# PINNED` version that a dependent cannot use fails the task, since the build would fail with it.

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

## Updating (GitHub) releases

We provide two rake tasks, `vox:print_outdated_components` and `vox:update_outdated_components`.
The first one inspects all non-rubygem components:

```
$ bundle exec rake vox:print_outdated_components
Checking 14 component(s) for updates...

  augeas... up to date (1.14.1)
  curl... error (Could not parse upstream version 'curl-8_20_0')
  dmidecode... skipped (No GitHub URL detected)
  libedit... skipped (No GitHub URL detected)
  libffi... up to date (3.5.2)
  libxml2... skipped (No GitHub URL detected)
  libyaml... up to date (0.2.5)
  openssl-3.0... OUTDATED: 3.0.20 -> 4.0.0
  puppet-ca-bundle... up to date (1.1.0)
  readline... skipped (No GitHub URL detected)
  ruby-3.2... skipped (No GitHub URL detected)
  ruby-augeas... up to date (0.6.0)
  ruby-shadow... up to date (2.5.1)
  virt-what... skipped (No GitHub URL detected)

=== Components with available updates ===
  openssl-3.0: 3.0.20 -> 4.0.0 (upstream tag: openssl-4.0.0)

=== Errors encountered ===
  curl: Could not parse upstream version 'curl-8_20_0'

=== Skipped (no checkable upstream) ===
  dmidecode: No GitHub URL detected
  libedit: No GitHub URL detected
  libxml2: No GitHub URL detected
  readline: No GitHub URL detected
  ruby-3.2: No GitHub URL detected
  virt-what: No GitHub URL detected
```

It will search for new releases upstream.
Right now only github.com is supported, but most of our components come from rubygems.org or github.com anyways, so this catches 85% of our components.
The second rake task checks the GitHub API for new releases and updates the json file with the version & URL.

```
$ bundle exec rake vox:update_outdated_components
Checking 14 component(s) for updates...

  augeas... up to date (1.14.1)
  curl... error (Could not parse upstream version 'curl-8_20_0')
  dmidecode... skipped (No GitHub URL detected)
  libedit... skipped (No GitHub URL detected)
  libffi... up to date (3.5.2)
  libxml2... skipped (No GitHub URL detected)
  libyaml... up to date (0.2.5)
  openssl-3.0... OUTDATED: 3.0.20 -> 4.0.0
  puppet-ca-bundle... up to date (1.1.0)
  readline... skipped (No GitHub URL detected)
  ruby-3.2... skipped (No GitHub URL detected)
  ruby-augeas... up to date (0.6.0)
  ruby-shadow... up to date (2.5.1)
  virt-what... skipped (No GitHub URL detected)

=== Components with available updates ===
  openssl-3.0: 3.0.20 -> 4.0.0 (upstream tag: openssl-4.0.0)

=== Errors encountered ===
  curl: Could not parse upstream version 'curl-8_20_0'

=== Skipped (no checkable upstream) ===
  dmidecode: No GitHub URL detected
  libedit: No GitHub URL detected
  libxml2: No GitHub URL detected
  readline: No GitHub URL detected
  ruby-3.2: No GitHub URL detected
  virt-what: No GitHub URL detected

Updated openssl-3.0 to 4.0.0
One or more components could not be checked.
$ git diff configs/components/openssl-3.0.json
diff --git a/configs/components/openssl-3.0.json b/configs/components/openssl-3.0.json
index 0f11c8a..10f1a32 100644
--- a/configs/components/openssl-3.0.json
+++ b/configs/components/openssl-3.0.json
@@ -1,5 +1,5 @@
 {
-  "version": "3.0.20",
-  "url": "https://github.com/openssl/openssl/releases/download/openssl-3.0.20/openssl-3.0.20.tar.gz",
-  "sha256sum": "c80a01dfc70ece4dc21168932c37739042d404d46ccc81a5986dd75314ecda6f"
+  "version": "4.0.0",
+  "url": "https://github.com/openssl/openssl/releases/download/openssl-4.0.0/openssl-4.0.0.tar.gz",
+  "sha256sum": "c32cf49a959c4f345f9606982dd36e7d28f7c58b19c2e25d75624d2b3d2f79ac"
 }
$
```
