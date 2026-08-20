# Changelog

All notable changes to this module are documented in this file.
Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## v2.0.0 - 2026-08-20

### Changed

- **azurerm provider upgraded to `~> 5.0` (pinned/tested against `5.0.1`).** `providers.tf` created for the first time
  (module previously had no `required_providers`/`required_version` block at all). Bumped **major** per this module's
  own versioning rule: introducing the first hard provider version constraint is a breaking change for any caller
  still on azurerm 4.x, independent of whether any resource argument itself changed.
- `azurerm_log_analytics_workspace.local_authentication_disabled` (bool) renamed to `local_authentication_enabled`
  (bool, inverted meaning) in azurerm v5.0.0. Both the legacy field name and the new one are accepted on the
  module's `logs_analytics_workspace` input object - the new field wins if the caller sets it explicitly, otherwise
  the legacy field is translated (inverted). No caller tfvars changes are required.
- `azurerm_log_analytics_workspace.internet_ingestion_enabled` (bool) renamed to `internet_ingestion_access_type`
  (string: `Enabled`/`Disabled`/`SecuredByPerimeter`) in azurerm v5.0.0. Same dual-compat translation as above.
- `azurerm_log_analytics_workspace.internet_query_enabled` (bool) renamed to `internet_query_access_type` (string)
  in azurerm v5.0.0. Same dual-compat translation as above.
- Bumped ESLZ module ref in `ESLZ/logs_analytics_workspace.tf` from `v1.0.0` to `v2.0.0`.
- Bumped `.github/workflows/documentation.yaml` action pins: `actions/checkout` v4.1.7 -> v7.0.1,
  `terraform-docs/gh-actions` v1.2.0 -> v1.4.1.

### Added

- `providers.tf` with `required_version = ">= 1.9"` and `azurerm ~> 5.0`.
- `.gitignore`, `.gitattributes`, `.tflint.hcl`, `ESLZ/.tflint.hcl` - none of these existed before this upgrade.
- `ESLZ/logs_analytics_workspace.tf` variables/module block updated to reflect the new module version; no new
  ESLZ-level variables were required since compat is handled entirely inside the existing `logs_analytics_workspace`
  object bag.
- Optional `name` override on `logs_analytics_workspace` (Pattern 12 - auto-generated resource name override), so an
  existing deployment whose real workspace name diverges from the generated formula can be pinned without
  destroy/recreate.
- `tests/logs_analytics_workspace.tftest.hcl` (14 runs) and `tests/upgrade_compat.tftest.hcl` (state-chaining safety
  test) - no test coverage existed before this upgrade.
- `.github/workflows/terraform-ci.yml` (fmt/init/validate/test/tflint on every PR, no Azure credentials required).
- `.github/workflows/release.yml` (creates a GitHub release on merge to main, tagged from the `ESLZ/*.tf` module ref).

### Fixed

- Invalid regex escape `[^\/]+$` -> `[^/]+$` in `locals.tf` (`\/` is not a valid Terraform/RE2 escape sequence for a
  forward slash).
- `log_analytics_workspace_object` output now marked `sensitive = true` - the underlying resource exposes
  `primary_shared_key`/`secondary_shared_key`, and the whole-object output was previously non-sensitive.

### Known blockers

- **True `>= 4.0` / v5.0.1 dual-provider-version runtime compatibility is not achievable** for
  `azurerm_log_analytics_workspace`. The three renamed/retyped arguments above have no deprecated alias in azurerm
  v5.0.0 - a resource block's argument names are validated against whichever provider major is actually installed,
  and there is no HCL-level way to conditionally emit different argument names based on the installed provider
  version. `required_providers` is therefore pinned to `~> 5.0`; this module requires azurerm 5.x to be installed.
  Caller **tfvars** remain 100% backward compatible (both old and new field names are accepted in the input object) -
  only the underlying provider constraint itself could not be loosened. Confirmed with the module owner before
  proceeding (see chat decision, 2026-08-20).
