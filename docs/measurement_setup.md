# First-launch measurements

The first launch recommends a measurement family from the platform locale's
country code only. US, Liberia (LR), and Myanmar (MM) recommend Imperial;
everywhere else, including Canada, the UK, Australia, and New Zealand,
recommends Metric. A missing country recommends Metric. This recommendation is
independent of the selected UI language and can always be overridden.

Choosing Metric sets the preferred system to `metric` and the default unit for
new cut lists to `mm`. Choosing Imperial sets `imperial` and `ftIn`. Settings
can change either later. Existing projects retain their own `displayUnit` and
exact integer lengths; project Cut Settings still permits all five units.

Schema v4 adds `measurement_system` and `onboarding_completed` to AppSettings.
Upgrades derive the system from the existing default unit and mark setup
complete, including an older database without a settings row. A genuinely
fresh settings row starts incomplete. Both fields are saved in the same row.

Stock shortcuts are exact lengths. The family follows the current project's
display unit, and the chips format in that unit. Tapping a shortcut changes
only the pending length entry, never the project unit or stored stock. Manual
entry remains unrestricted and exact.
