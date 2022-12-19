# Appcircle _Flutter Test_ component

This component allows you to run [Flutter unit tests](https://flutter.dev/docs/cookbook/testing/unit/introduction#run-tests-in-a-terminal). Please note that it requires a preceding Flutter Install step to run.

## Required Inputs

- `AC_FLUTTER_PROJECT_DIR`: Flutter Project Directory. Specifies the root of your Flutter project where your pubspec.yaml file exist.

## Optional Inputs

- `AC_FLUTTER_JUNIT_REPORTS`: Create JUnit reports. If this set to YES, JUnit Report will be created at AC_TEST_RESULT_PATH
- `AC_FLUTTER_TEST_EXTRA_ARGS`: Flutter Test Additional Arguments. Specifies custom arguments. Defaults to: --machine

## Output Variables

- `AC_TEST_RESULT_PATH`: JUnit Report. Specifies the path of the JUnit Report.
