# Changelog
All notable changes to this project will be documented in this file.

## [2025.12.05.1](https://github.com/openvoxproject/puppet-runtime/tree/2025.12.05.1) (2025-12-05)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/2025.12.03.1...2025.12.05.1)

**Fixed bugs:**

- Install augeas/facade.rb for modern ruby-augeas [\#85](https://github.com/OpenVoxProject/puppet-runtime/pull/85) ([ananace](https://github.com/ananace))

**Merged pull requests:**

- Update release automation [\#83](https://github.com/OpenVoxProject/puppet-runtime/pull/83) ([nmburgan](https://github.com/nmburgan))

## [2025.12.03.1](https://github.com/openvoxproject/puppet-runtime/tree/2025.12.03.1) (2025-12-03)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/2025.12.02.1...2025.12.03.1)

**Implemented enhancements:**

- rubygem-ruby-dbus: Add component [\#80](https://github.com/OpenVoxProject/puppet-runtime/pull/80) ([ananace](https://github.com/ananace))


**Component Changes:**
| Component | Old Version | New Version |
|-----------|-------------|-------------|
| rubygem-ruby-dbus |  | 0.25.0 |

**Project component additions:**
- rubygem-ruby-dbus: agent-runtime-main, openbolt-runtime

**Merged pull requests:**

- Specify pkgconf for el10 [\#81](https://github.com/OpenVoxProject/puppet-runtime/pull/81) ([nmburgan](https://github.com/nmburgan))
- Don't add component table when there are no changes [\#79](https://github.com/OpenVoxProject/puppet-runtime/pull/79) ([nmburgan](https://github.com/nmburgan))
- Gate win32ole gem to Windows [\#77](https://github.com/OpenVoxProject/puppet-runtime/pull/77) ([nmburgan](https://github.com/nmburgan))

## [2025.12.02.1](https://github.com/openvoxproject/puppet-runtime/tree/2025.12.02.1) (2025-12-02)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/2025.09.08.1...2025.12.02.1)


**Component Changes:**
| Component | Old Version | New Version |
|-----------|-------------|-------------|
| curl | 8.15.0 | 8.17.0 |
| libxml2 | 2.14.5 | 2.15.1 |
| openssl-3.0 | 3.0.17 | 3.0.18 |
| ruby-augeas | 0.5.0 | 0.6.0 |
| ruby-selinux | 3.8.1 | 3.9 |
| rubygem-CFPropertyList | 3.0.7 | 4.0.0 |
| rubygem-addressable |  | 2.8.8 |
| rubygem-aws-eventstream |  | 1.4.0 |
| rubygem-aws-partitions |  | 1.1188.0 |
| rubygem-aws-sdk-core |  | 3.239.2 |
| rubygem-aws-sdk-ec2 |  | 1.583.0 |
| rubygem-aws-sigv4 |  | 1.12.1 |
| rubygem-bcrypt_pbkdf |  | 1.1.1 |
| rubygem-benchmark |  | 0.5.0 |
| rubygem-bigdecimal |  | 3.3.1 |
| rubygem-bindata |  | 2.5.1 |
| rubygem-builder |  | 3.3.0 |
| rubygem-colored2 |  | 4.0.3 |
| rubygem-connection_pool |  | 2.4.1 |
| rubygem-cookiejar |  | 0.3.4 |
| rubygem-cri |  | 2.15.12 |
| rubygem-date |  | 3.5.0 |
| rubygem-ed25519 |  | 1.4.0 |
| rubygem-em-http-request |  | 1.1.7 |
| rubygem-em-socksify |  | 0.3.3 |
| rubygem-eventmachine |  | 1.2.7 |
| rubygem-excon |  | 1.3.1 |
| rubygem-faraday |  | 2.14.0 |
| rubygem-faraday-em_http |  | 2.0.1 |
| rubygem-faraday-em_synchrony |  | 1.0.1 |
| rubygem-faraday-excon |  | 2.4.0 |
| rubygem-faraday-follow_redirects |  | 0.4.0 |
| rubygem-faraday-httpclient |  | 2.0.2 |
| rubygem-faraday-multipart |  | 1.1.1 |
| rubygem-faraday-net_http |  | 3.4.2 |
| rubygem-faraday-net_http_persistent |  | 2.3.1 |
| rubygem-faraday-patron |  | 2.0.2 |
| rubygem-faraday-rack |  | 2.1.3 |
| rubygem-faraday-retry |  | 2.3.2 |
| rubygem-fiddle |  | 1.1.8 |
| rubygem-forwardable |  | 1.3.3 |
| rubygem-getoptlong |  | 0.2.1 |
| rubygem-gettext-setup |  | 1.1.0 |
| rubygem-gssapi |  | 1.3.1 |
| rubygem-gyoku |  | 1.4.0 |
| rubygem-hiera |  | 3.12.0 |
| rubygem-http_parser.rb |  | 0.8.0 |
| rubygem-httpclient |  | 2.9.0 |
| rubygem-io-console |  | 0.8.1 |
| rubygem-jmespath |  | 1.6.2 |
| rubygem-json |  | 2.16.0 |
| rubygem-jwt |  | 2.10.2 |
| rubygem-little-plugger |  | 1.1.4 |
| rubygem-log4r |  | 1.1.10 |
| rubygem-logging |  | 2.4.0 |
| rubygem-minitar | 0.12.1 | 1.1.0 |
| rubygem-molinillo |  | 0.8.0 |
| rubygem-multipart-post |  | 2.4.1 |
| rubygem-mutex_m |  | 0.3.0 |
| rubygem-net-ftp |  | 0.3.9 |
| rubygem-net-http |  | 0.8.0 |
| rubygem-net-http-persistent |  | 4.0.6 |
| rubygem-net-protocol |  | 0.2.2 |
| rubygem-net-scp |  | 4.1.0 |
| rubygem-net-ssh-krb |  | 0.5.1 |
| rubygem-nkf |  | 0.2.0 |
| rubygem-nori |  | 2.7.1 |
| rubygem-openfact |  | 5.1.0 |
| rubygem-openvox |  | 8.23.1 |
| rubygem-openvox-strings |  | 6.0.0 |
| rubygem-orchestrator_client |  | 0.7.2 |
| rubygem-ostruct |  | 0.6.3 |
| rubygem-paint |  | 2.3.0 |
| rubygem-patron |  | 0.13.4 |
| rubygem-public_suffix |  | 6.0.2 |
| rubygem-puppet-resource_api |  | 2.0.0 |
| rubygem-puppet_forge |  | 6.0.0 |
| rubygem-puppetfile-resolver |  | 0.6.3 |
| rubygem-r10k |  | 5.0.2 |
| rubygem-racc |  | 1.8.1 |
| rubygem-reline |  | 0.6.3 |
| rubygem-rexml | 3.4.2 | 3.4.4 |
| rubygem-rgen |  | 0.10.2 |
| rubygem-ruby2_keywords |  | 0.0.5 |
| rubygem-ruby_smb |  | 1.1.0 |
| rubygem-rubyntlm |  | 0.6.5 |
| rubygem-rubyzip |  | 3.2.2 |
| rubygem-singleton |  | 0.3.0 |
| rubygem-sys-filesystem | 1.5.3 | 1.5.4 |
| rubygem-terminal-table |  | 4.0.0 |
| rubygem-time |  | 0.4.1 |
| rubygem-timeout |  | 0.4.4 |
| rubygem-unicode-display_width |  | 3.2.0 |
| rubygem-unicode-emoji |  | 4.1.0 |
| rubygem-uri |  | 1.1.1 |
| rubygem-webrick |  | 1.9.2 |
| rubygem-win32ole |  | 1.9.2 |
| rubygem-windows_error |  | 0.1.5 |
| rubygem-winrm |  | 2.3.9 |
| rubygem-winrm-fs |  | 1.3.5 |
| rubygem-yard |  | 0.9.37 |

**Project component additions:**
- rubygem-addressable: openbolt-runtime
- rubygem-aws-eventstream: openbolt-runtime
- rubygem-aws-partitions: openbolt-runtime
- rubygem-aws-sdk-core: openbolt-runtime
- rubygem-aws-sdk-ec2: openbolt-runtime
- rubygem-aws-sigv4: openbolt-runtime
- rubygem-bcrypt_pbkdf: openbolt-runtime
- rubygem-benchmark: openbolt-runtime
- rubygem-bigdecimal: openbolt-runtime
- rubygem-bindata: openbolt-runtime
- rubygem-builder: openbolt-runtime
- rubygem-colored2: openbolt-runtime
- rubygem-connection_pool: openbolt-runtime
- rubygem-cookiejar: openbolt-runtime
- rubygem-cri: openbolt-runtime
- rubygem-date: agent-runtime-main, openbolt-runtime
- rubygem-ed25519: openbolt-runtime
- rubygem-em-http-request: openbolt-runtime
- rubygem-em-socksify: openbolt-runtime
- rubygem-eventmachine: openbolt-runtime
- rubygem-excon: openbolt-runtime
- rubygem-faraday: openbolt-runtime
- rubygem-faraday-em_http: openbolt-runtime
- rubygem-faraday-em_synchrony: openbolt-runtime
- rubygem-faraday-excon: openbolt-runtime
- rubygem-faraday-follow_redirects: openbolt-runtime
- rubygem-faraday-httpclient: openbolt-runtime
- rubygem-faraday-multipart: openbolt-runtime
- rubygem-faraday-net_http: openbolt-runtime
- rubygem-faraday-net_http_persistent: openbolt-runtime
- rubygem-faraday-patron: openbolt-runtime
- rubygem-faraday-rack: openbolt-runtime
- rubygem-faraday-retry: openbolt-runtime
- rubygem-fiddle: agent-runtime-main, openbolt-runtime
- rubygem-forwardable: agent-runtime-main, openbolt-runtime
- rubygem-getoptlong: openbolt-runtime
- rubygem-gettext-setup: openbolt-runtime
- rubygem-gssapi: openbolt-runtime
- rubygem-gyoku: openbolt-runtime
- rubygem-hiera: openbolt-runtime
- rubygem-http_parser.rb: openbolt-runtime
- rubygem-httpclient: openbolt-runtime
- rubygem-io-console: agent-runtime-main, openbolt-runtime
- rubygem-jmespath: openbolt-runtime
- rubygem-json: openbolt-runtime
- rubygem-jwt: openbolt-runtime
- rubygem-little-plugger: openbolt-runtime
- rubygem-log4r: openbolt-runtime
- rubygem-logging: openbolt-runtime
- rubygem-molinillo: openbolt-runtime
- rubygem-multipart-post: openbolt-runtime
- rubygem-mutex_m: openbolt-runtime
- rubygem-net-ftp: agent-runtime-main, openbolt-runtime
- rubygem-net-http: openbolt-runtime
- rubygem-net-http-persistent: openbolt-runtime
- rubygem-net-protocol: agent-runtime-main, openbolt-runtime
- rubygem-net-scp: openbolt-runtime
- rubygem-net-ssh-krb: openbolt-runtime
- rubygem-nkf: agent-runtime-main, openbolt-runtime
- rubygem-nori: openbolt-runtime
- rubygem-openfact: openbolt-runtime
- rubygem-openvox: openbolt-runtime
- rubygem-openvox-strings: openbolt-runtime
- rubygem-orchestrator_client: openbolt-runtime
- rubygem-ostruct: openbolt-runtime
- rubygem-paint: openbolt-runtime
- rubygem-patron: openbolt-runtime
- rubygem-public_suffix: openbolt-runtime
- rubygem-puppet-resource_api: openbolt-runtime
- rubygem-puppet_forge: openbolt-runtime
- rubygem-puppetfile-resolver: openbolt-runtime
- rubygem-r10k: openbolt-runtime
- rubygem-racc: agent-runtime-main, openbolt-runtime
- rubygem-reline: agent-runtime-main, openbolt-runtime
- rubygem-rgen: openbolt-runtime
- rubygem-ruby2_keywords: openbolt-runtime
- rubygem-ruby_smb: openbolt-runtime
- rubygem-rubyntlm: openbolt-runtime
- rubygem-rubyzip: openbolt-runtime
- rubygem-singleton: agent-runtime-main, openbolt-runtime
- rubygem-terminal-table: openbolt-runtime
- rubygem-time: agent-runtime-main, openbolt-runtime
- rubygem-timeout: agent-runtime-main, openbolt-runtime
- rubygem-unicode-display_width: openbolt-runtime
- rubygem-unicode-emoji: openbolt-runtime
- rubygem-uri: openbolt-runtime
- rubygem-webrick: openbolt-runtime
- rubygem-win32ole: agent-runtime-main, openbolt-runtime
- rubygem-windows_error: openbolt-runtime
- rubygem-winrm: openbolt-runtime
- rubygem-winrm-fs: openbolt-runtime
- rubygem-yard: openbolt-runtime

**Merged pull requests:**

- Show errors during shell commands in update\_component\_info [\#75](https://github.com/OpenVoxProject/puppet-runtime/pull/75) ([nmburgan](https://github.com/nmburgan))
- Add tasks for generating component info and adding to changelog [\#72](https://github.com/OpenVoxProject/puppet-runtime/pull/72) ([nmburgan](https://github.com/nmburgan))
- Update components and update\_gems script [\#70](https://github.com/OpenVoxProject/puppet-runtime/pull/70) ([nmburgan](https://github.com/nmburgan))
- Add update\_gems rake task and rename bolt -\> openbolt [\#68](https://github.com/OpenVoxProject/puppet-runtime/pull/68) ([nmburgan](https://github.com/nmburgan))
- Add switch for uploading to S3 [\#62](https://github.com/OpenVoxProject/puppet-runtime/pull/62) ([nmburgan](https://github.com/nmburgan))

## [2025.09.08.1](https://github.com/openvoxproject/puppet-runtime/tree/2025.09.08.1) (2025-09-08)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/2025-09-04-1...2025.09.08.1)

**Merged pull requests:**

- Roll back fast\_gettext to 2.4.0 [\#59](https://github.com/OpenVoxProject/puppet-runtime/pull/59) ([nmburgan](https://github.com/nmburgan))
- Change version format to use periods [\#57](https://github.com/OpenVoxProject/puppet-runtime/pull/57) ([nmburgan](https://github.com/nmburgan))

## [2025-09-04-1](https://github.com/openvoxproject/puppet-runtime/tree/2025-09-04-1) (2025-09-04)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/2025-08-23-1...2025-09-04-1)

**Merged pull requests:**

- Remove duplicated permissions block in build.yml [\#55](https://github.com/OpenVoxProject/puppet-runtime/pull/55) ([nmburgan](https://github.com/nmburgan))
- Change windows-2019-x64 -\> windows-all-x64 and fix upload task [\#54](https://github.com/OpenVoxProject/puppet-runtime/pull/54) ([nmburgan](https://github.com/nmburgan))
- Changes to enable building all MacOS types on any MacOS host [\#53](https://github.com/OpenVoxProject/puppet-runtime/pull/53) ([nmburgan](https://github.com/nmburgan))
- \[CVE-2025-2588\] patch augeas to return \_REG\_ENOSYS [\#52](https://github.com/OpenVoxProject/puppet-runtime/pull/52) ([binford2k](https://github.com/binford2k))
- Update components and remove PDK and client tools runtimes [\#35](https://github.com/OpenVoxProject/puppet-runtime/pull/35) ([nmburgan](https://github.com/nmburgan))

## [2025-08-23-1](https://github.com/openvoxproject/puppet-runtime/tree/2025-08-23-1) (2025-08-23)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/2025-08-21-1...2025-08-23-1)

**Merged pull requests:**

- Remove EOL platforms and bump puppet-ca-bundle [\#49](https://github.com/OpenVoxProject/puppet-runtime/pull/49) ([nmburgan](https://github.com/nmburgan))
- Update webrick [\#48](https://github.com/OpenVoxProject/puppet-runtime/pull/48) ([binford2k](https://github.com/binford2k))
- OSX non-root user build changes [\#44](https://github.com/OpenVoxProject/puppet-runtime/pull/44) ([shaun-rutherford](https://github.com/shaun-rutherford))

## [2025-08-21-1](https://github.com/openvoxproject/puppet-runtime/tree/2025-08-21-1) (2025-08-21)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/2025-08-10-1...2025-08-21-1)

**Merged pull requests:**

- Add Ubuntu 25.04 [\#46](https://github.com/OpenVoxProject/puppet-runtime/pull/46) ([genebean](https://github.com/genebean))
- Some notes to make it clear what OpenSSL is being used [\#45](https://github.com/OpenVoxProject/puppet-runtime/pull/45) ([nmburgan](https://github.com/nmburgan))

## [2025-08-10-1](https://github.com/openvoxproject/puppet-runtime/tree/2025-08-10-1) (2025-08-10)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202508061...2025-08-10-1)

**Fixed bugs:**

- Fix regexes [\#40](https://github.com/OpenVoxProject/puppet-runtime/pull/40) ([nmburgan](https://github.com/nmburgan))

## [202508061](https://github.com/openvoxproject/puppet-runtime/tree/202508061) (2025-08-05)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202507082...202508061)

**Implemented enhancements:**

- Bump Ruby to 3.2.9, remove Boost from agent runtimes, remove PDK runtime [\#39](https://github.com/OpenVoxProject/puppet-runtime/pull/39) ([nmburgan](https://github.com/nmburgan))
- Add component release info comments [\#34](https://github.com/OpenVoxProject/puppet-runtime/pull/34) ([nmburgan](https://github.com/nmburgan))

## [202507082](https://github.com/openvoxproject/puppet-runtime/tree/202507082) (2025-07-08)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202507081...202507082)

**Fixed bugs:**

- Readd Amazon 2023 support [\#30](https://github.com/OpenVoxProject/puppet-runtime/pull/30) ([bastelfreak](https://github.com/bastelfreak))

## [202507081](https://github.com/openvoxproject/puppet-runtime/tree/202507081) (2025-07-08)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202506191...202507081)

**Implemented enhancements:**

- Remove Puppet Enterprise leftovers [\#29](https://github.com/OpenVoxProject/puppet-runtime/pull/29) ([bastelfreak](https://github.com/bastelfreak))
- Switch from facter to openfact [\#28](https://github.com/OpenVoxProject/puppet-runtime/pull/28) ([bastelfreak](https://github.com/bastelfreak))

## [202506191](https://github.com/openvoxproject/puppet-runtime/tree/202506191) (2025-06-19)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202506181...202506191)

**Fixed bugs:**

- Fix Release Pipeline [\#26](https://github.com/OpenVoxProject/puppet-runtime/pull/26) ([bastelfreak](https://github.com/bastelfreak))

## [202506181](https://github.com/openvoxproject/puppet-runtime/tree/202506181) (2025-06-18)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202505151...202506181)

**Implemented enhancements:**

- Update curl 8.13.0-\>8.14.1 [\#25](https://github.com/OpenVoxProject/puppet-runtime/pull/25) ([cvquesty](https://github.com/cvquesty))
- Gemfile: Remove Gemfile.local support [\#23](https://github.com/OpenVoxProject/puppet-runtime/pull/23) ([bastelfreak](https://github.com/bastelfreak))
- Set SOURCE\_DATE\_EPOCH for building [\#19](https://github.com/OpenVoxProject/puppet-runtime/pull/19) ([smortex](https://github.com/smortex))

## [202505151](https://github.com/openvoxproject/puppet-runtime/tree/202505151) (2025-05-15)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202504291...202505151)

**Implemented enhancements:**

- Add Fedora 43 [\#18](https://github.com/OpenVoxProject/puppet-runtime/pull/18) ([nmburgan](https://github.com/nmburgan))

## [202504291](https://github.com/openvoxproject/puppet-runtime/tree/202504291) (2025-04-29)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202504221...202504291)

**Implemented enhancements:**

- Add Debian 13 and amazon-2-x86\_64 [\#17](https://github.com/OpenVoxProject/puppet-runtime/pull/17) ([nmburgan](https://github.com/nmburgan))

## [202504221](https://github.com/openvoxproject/puppet-runtime/tree/202504221) (2025-04-22)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202504211...202504221)

## [202504211](https://github.com/openvoxproject/puppet-runtime/tree/202504211) (2025-04-21)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202504141...202504211)

**Implemented enhancements:**

- Use cmake3 for el7 [\#16](https://github.com/OpenVoxProject/puppet-runtime/pull/16) ([nmburgan](https://github.com/nmburgan))
- Update lots of components [\#15](https://github.com/OpenVoxProject/puppet-runtime/pull/15) ([nmburgan](https://github.com/nmburgan))

## [202504141](https://github.com/openvoxproject/puppet-runtime/tree/202504141) (2025-04-14)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202503221...202504141)

**Implemented enhancements:**

- Add Fedora 42 [\#14](https://github.com/OpenVoxProject/puppet-runtime/pull/14) ([nmburgan](https://github.com/nmburgan))

## [202503221](https://github.com/openvoxproject/puppet-runtime/tree/202503221) (2025-03-22)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202503201...202503221)

**Fixed bugs:**

- Set paths back to PuppetLabs/Puppet on Windows [\#12](https://github.com/OpenVoxProject/puppet-runtime/pull/12) ([nmburgan](https://github.com/nmburgan))

## [202503201](https://github.com/openvoxproject/puppet-runtime/tree/202503201) (2025-03-20)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202502261...202503201)

**Implemented enhancements:**

- Changes for Windows OpenVox builds [\#10](https://github.com/OpenVoxProject/puppet-runtime/pull/10) ([nmburgan](https://github.com/nmburgan))

## [202502261](https://github.com/openvoxproject/puppet-runtime/tree/202502261) (2025-02-26)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202502251...202502261)

## [202502251](https://github.com/openvoxproject/puppet-runtime/tree/202502251) (2025-02-26)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202502203...202502251)

**Implemented enhancements:**

- Add Fedora 41 [\#6](https://github.com/OpenVoxProject/puppet-runtime/pull/6) ([nmburgan](https://github.com/nmburgan))

## [202502203](https://github.com/openvoxproject/puppet-runtime/tree/202502203) (2025-02-20)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202502202...202502203)

**Implemented enhancements:**

- Update ruby, curl, rexml, and semantic\_puppet [\#5](https://github.com/OpenVoxProject/puppet-runtime/pull/5) ([nmburgan](https://github.com/nmburgan))

## [202502202](https://github.com/openvoxproject/puppet-runtime/tree/202502202) (2025-02-20)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202502201...202502202)

## [202502201](https://github.com/openvoxproject/puppet-runtime/tree/202502201) (2025-02-20)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202502032...202502201)

**Fixed bugs:**

- Fix 7.x [\#3](https://github.com/OpenVoxProject/puppet-runtime/pull/3) ([nmburgan](https://github.com/nmburgan))

## [202502032](https://github.com/openvoxproject/puppet-runtime/tree/202502032) (2025-02-03)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202502031...202502032)

## [202502031](https://github.com/openvoxproject/puppet-runtime/tree/202502031) (2025-02-02)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202502011...202502031)

## [202502011](https://github.com/openvoxproject/puppet-runtime/tree/202502011) (2025-01-14)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202501082...202502011)

## [202501082](https://github.com/openvoxproject/puppet-runtime/tree/202501082) (2025-01-09)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202501081...202501082)

## [202501081](https://github.com/openvoxproject/puppet-runtime/tree/202501081) (2025-01-09)

[Full Changelog](https://github.com/openvoxproject/puppet-runtime/compare/202501080...202501081)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
