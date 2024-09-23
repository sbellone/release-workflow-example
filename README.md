# Release workflow example

This repository is an example of a release workflow using GitHub Actions and branches protection.

It has 2 permanent branches:
- `main`, the default branch, protected with the following [rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets):
  - _Restrict updates_
  - _Restrict deletions_
- `develop`, the development branch against PRs are opened, protected with the following rulesets:
  - _Restrict deletions_
  - _Require a pull request before merging_

> It's important to use rulesets instead of the legacy branch protection feature.

### Release workflow

After some PRs have been merged into `develop`, a [GitHub Action](.github/workflows/release.yml) is responsible to:
- Bump the version in `package.json`
- Commit the change on `develop`
- Merge `develop` into `main`
- Draft a release, ready to be reviewed and published

## Setup
### How to setup the action to bypass branches protection

To bypass branches protection from a GitHub action:
- Create a [deploy key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys) with write permissions
- Save the private SSH key in a `DEPLOY_KEY` [secret](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions)
- Add `Deploy keys` to the Bypass list of the rulesets (Bypass list > Add bypass > Deploy keys)
- Make your action checkouts the repo [using the SSH key from the secret](.github/workflows/release.yml#24)

### Rotate the deploy key
#### Manually

- [Create a deploy key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys#set-up-deploy-keys) with write permissions.
- Update the `DEPLOY_KEY` secret with the new SSH private key
- Remove the old deploy key

#### Automatically

Prerequisites:
- Node.js
- [GitHub CLI](https://cli.github.com/)

```
./rotate-deploy-key.sh
```
