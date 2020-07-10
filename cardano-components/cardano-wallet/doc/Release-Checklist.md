# Release Checklist

## Preparing the release
- [ ] Make sure `cardano-wallet` points to correct revisions of dependent low-level libs (verify on target repositories if [stack.yaml](https://github.com/input-output-hk/cardano-wallet/blob/master/stack.yaml#L34-L42) points to appropriate revisions for `persistent`, `cardano-addresses`...). Also verify that the stack resolver corresponds to the `cardano-node` version.

- [ ] Fetch the tip of `master`:

```sh
$ git checkout master
$ git pull
```

- [ ] Create a new branch for the release:

```sh
$ git checkout -b your-name/bump-release/YYYY-MM-DD
```

- [ ] Edit the release parameters section in `./scripts/make_release.sh`. To bump from `2020.3.16` to `2020.4.1` they will look like:
```
 # Release-specific parameters (Change when you bump the version)
 GIT_TAG="v2020-04-01"
 CABAL_VERSION="2020.4.1"

 OLD_GIT_TAG="v2020-03-16"
 OLD_CABAL_VERSION="2020.3.16"

 JORM_TAG="v0.8.15"
 CARDANO_NODE_TAG="1.9.3"
```

> :warning: We use a slightly different notation between `.cabal` and git tags! Git tags follows the following format: `vYYYY-MM-DD` (notice the `v` and hyphens) whereas cabal version are written as: `YYYY.MM.DD`.

- [ ] In the from the **root** of the repository, run:

```bash
export GITHUB_API_TOKEN=<A GITHUB API TOKEN>
$ ./scripts/make_release.sh
```
This will bump the version in .cabal and .nix files and generate release notes. If you have none yet, you can create a _personal access token_ in your [Github Settings](https://github.com/settings/tokens). No scope is required for this token, only public access (as it is simply used to read publicly available data from the Github API).

- [ ] Open a pull request to submit the modified files. Get it merged.

- [ ] Trigger a release build on CI (Travis) and wait for the build artifacts to be published on github
  ```
  $ git push origin refs/tags/vYYYY-MM-DD
  ```
  Where `YYYY-MM-DD` should be replaced by the actual date of the release.

## Create the release notes

- [ ] Verify all PRs since the last release have a corresponding milestone (hint: we can filter PR by merge date on github using `merged:>yyyy-mm-dd` filter and find bare PRs with the `no:milestone` filter).

- [ ] Write release notes in the [release page](https://github.com/input-output-hk/cardano-wallet/releases) using the previously generated release notes. Fill in the empty sections.

## Verify release artifacts

- [ ] Verify that the documentations have been correctly exported on [gh-pages](https://github.com/input-output-hk/cardano-wallet/tree/gh-pages)

- [ ] Make sure CLI manuals are up to date:
  - [Command-Line Interface (Jörmungandr)](https://github.com/input-output-hk/cardano-wallet/wiki/Wallet-command-line-interface)
  - [Command-Line Interface (Byron Reboot)](https://github.com/input-output-hk/cardano-wallet/wiki/Wallet-Command-Line-Interface-(cardano-wallet-byron))


## Manual ad-hoc verifications

- [ ] Execute all [manual scenarios](https://github.com/input-output-hk/cardano-wallet/tree/master/test/manual) on the binaries to be released.

- [ ] Verify that sensitive fields listed in [Cardano/Wallet/Api/Server](https://github.com/input-output-hk/cardano-wallet/blob/master/lib/core/src/Cardano/Wallet/Api/Server.hs#L409) are still accurate and aren't missing any new ones.
  ```
  sensitive =
      [ "passphrase"
      , "old_passphrase"
      , "new_passphrase"
      , "mnemonic_sentence"
      , "mnemonic_second_factor"
      ]
  ```

- [ ] Verify latest [buildkite nightly](https://buildkite.com/input-output-hk/cardano-wallet-nightly) and make sure the results are fine. [Benchmark charts](http://cardano-wallet-benchmarks.herokuapp.com/) may be helpful in analysis.

- [ ] Manually run the disabled `LAUNCH` tests in:
  ```
  lib/jormungandr/test/integration/Test/Integration/Jormungandr/Scenario/CLI/Launcher.hs
  ```
- [ ] run all integration test for jormungandr:
  ```
  stack test cardano-wallet-jormungandr:jormungandr-integration
  ```
  This is done as part of the [buildkite nightly](https://buildkite.com/input-output-hk/cardano-wallet-nightly) pipeline. Click on the _Rebuild master branch_ step and check that it has succeeded.
  
## Publication

- [ ] Once everyone has signed off (i.e. Tech lead, QA & Release manager), publish the release draft.

- [ ] Update the "Compatibility Matrix" in the README.md (keep info about last 3 versions of `cardano-wallet`).

- [ ] Add the release to the [automated migration tests](https://github.com/input-output-hk/cardano-wallet/blob/master/nix/migration-tests.nix#L44-L61) (keep only the last 3 versions).  
